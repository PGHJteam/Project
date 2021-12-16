import argparse,sys
import numpy as np
import cv2
from detection import imgproc, craft_utils
from detection.craft import CRAFT
from torch.autograd import Variable
from collections import OrderedDict
from image_crop import cropped_image
from torch.utils.data import Dataset
from trocr_inference import init as tr_init
from trocr_inference import get_text as tr_recog
import string
import torch
import torch.backends.cudnn as cudnn
import torch.utils.data
import torch.nn.functional as F
import os
import json
from PIL import Image
from recognition.utils import CTCLabelConverter, AttnLabelConverter
from recognition.dataset import AlignCollate
from recognition.model import Model
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
os.environ['KMP_DUPLICATE_LIB_OK'] = 'True'




def list_files(in_path):
    img_files = []
    mask_files = []
    gt_files = []
    for (dirpath, dirnames, filenames) in os.walk(in_path):
        for file in filenames:
            filename, ext = os.path.splitext(file)
            ext = str.lower(ext)
            if ext == '.jpg' or ext == '.jpeg' or ext == '.gif' or ext == '.png' or ext == '.pgm':
                img_files.append(os.path.join(dirpath, file))
            elif ext == '.bmp':
                mask_files.append(os.path.join(dirpath, file))
            elif ext == '.xml' or ext == '.gt' or ext == '.txt':
                gt_files.append(os.path.join(dirpath, file))
            elif ext == '.zip':
                continue
    # img_files.sort()
    # mask_files.sort()
    # gt_files.sort()
    return img_files, mask_files, gt_files

def get_files(img_dir):
    imgs, masks, xmls = list_files(img_dir)
    return imgs, masks, xmls
def str2bool(v):
    return v.lower() in ("yes", "y", "true", "t", "1")
def copyStateDict(state_dict):
    if list(state_dict.keys())[0].startswith("module"):
        start_idx = 1
    else:
        start_idx = 0
    new_state_dict = OrderedDict()
    for k, v in state_dict.items():
        name = ".".join(k.split(".")[start_idx:])
        new_state_dict[name] = v
    return new_state_dict
def command():
    parser = argparse.ArgumentParser(description='CRAFT Text Detection')
    # detection
   
    parser.add_argument('--detect_model', default='downloads/premodels/craft.pth', type=str, help='pretrained model')
    parser.add_argument('--text_threshold', default=0.7, type=float, help='text confidence threshold')
    parser.add_argument('--low_text', default=0.4, type=float, help='text low-bound score')
    parser.add_argument('--link_threshold', default=0.4, type=float, help='link confidence threshold')
    parser.add_argument('--cuda', default=True, type=str2bool, help='Use cuda for inference')
    parser.add_argument('--canvas_size', default=1280, type=int, help='image size for inference')
    parser.add_argument('--mag_ratio', default=1.5, type=float, help='image magnification ratio')
    parser.add_argument('--poly', default=False, action='store_true', help='enable polygon type')
    parser.add_argument('--show_time', default=False, action='store_true', help='show processing time')
    parser.add_argument('--test_folder', default='/data/', type=str, help='folder path to input images')
    parser.add_argument('--refine', default=False, action='store_true', help='enable link refiner')
    parser.add_argument('--refiner_model', default='weights/craft_refiner_CTW1500.pth', type=str, help='pretrained refiner model')



    # recogntion
    parser.add_argument('--workers', type=int, help='number of data loading workers', default=4)
    parser.add_argument('--batch_size', type=int, default=192, help='input batch size')
    parser.add_argument('--recog_model', default="downloads/premodels/recog.pth", help="path to saved_model to evaluation")
    parser.add_argument('--recog_name',default='trocr',help="choose trocr or naver")

    """ Data processing """
    parser.add_argument('--batch_max_length', type=int, default=25, help='maximum-label-length')
    parser.add_argument('--imgH', type=int, default=32, help='the height of the input image')
    parser.add_argument('--imgW', type=int, default=100, help='the width of the input image')
    parser.add_argument('--rgb', default=False, help='use rgb input')
    parser.add_argument('--character', type=str, default='0123456789abcdefghijklmnopqrstuvwxyz', help='character label')
    parser.add_argument('--sensitive', action='store_true', help='for sensitive character mode')
    parser.add_argument('--PAD', action='store_true', help='whether to keep ratio then pad for image resize')
    """ Model Architecture """
    parser.add_argument('--Transformation', type=str, default='TPS', help='Transformation stage. None|TPS')
    parser.add_argument('--FeatureExtraction', type=str, default='ResNet', help='FeatureExtraction stage. VGG|RCNN|ResNet')
    parser.add_argument('--SequenceModeling', type=str, default='BiLSTM', help='SequenceModeling stage. None|BiLSTM')
    parser.add_argument('--Prediction', type=str, default='Attn', help='Prediction stage. CTC|Attn')
    parser.add_argument('--num_fiducial', type=int, default=20, help='number of fiducial points of TPS-STN')
    parser.add_argument('--input_channel', type=int, default=1, help='the number of input channel of Feature extractor')
    parser.add_argument('--output_channel', type=int, default=512,
                        help='the number of output channel of Feature extractor')
    parser.add_argument('--hidden_size', type=int, default=256, help='the size of the LSTM hidden state')


    args = parser.parse_args()
    if args.sensitive:
        args.character = string.printable[:-6]  # same with ASTER setting (use 94 char).

    cudnn.benchmark = True
    cudnn.deterministic = True
    args.num_gpu = torch.cuda.device_count()
    return args


def detect(args,net,image, text_threshold, link_threshold, low_text, cuda, poly, refine_net=None):
    img_resized, target_ratio, size_heatmap = imgproc.resize_aspect_ratio(image, args.canvas_size, interpolation=cv2.INTER_LINEAR, mag_ratio=args.mag_ratio)
    ratio_h = ratio_w = 1 / target_ratio

    # preprocessing
    x = imgproc.normalizeMeanVariance(img_resized)
    x = torch.from_numpy(x).permute(2, 0, 1)    # [h, w, c] to [c, h, w]
    x = Variable(x.unsqueeze(0))                # [c, h, w] to [b, c, h, w]
    if cuda:
        x = x.cuda()

    # forward pass
    with torch.no_grad():
        y, feature = net(x)

    # make score and link map
    score_text = y[0,:,:,0].cpu().data.numpy()
    score_link = y[0,:,:,1].cpu().data.numpy()

    # refine link
    if refine_net is not None:
        with torch.no_grad():
            y_refiner = refine_net(y, feature)
        score_link = y_refiner[0,:,:,0].cpu().data.numpy()


    # Post-processing
    boxes, polys = craft_utils.getDetBoxes(score_text, score_link, text_threshold, link_threshold, low_text, poly)

    # coordinate adjustment
    boxes = craft_utils.adjustResultCoordinates(boxes, ratio_w, ratio_h)
    polys = craft_utils.adjustResultCoordinates(polys, ratio_w, ratio_h)
    for k in range(len(polys)):
        if polys[k] is None: polys[k] = boxes[k]
    return polys

args = command()
def init_detect_model(args):
    net = CRAFT()  # initialize

    # print('Loading weights from checkpoint (' + args.detect_model + ')')
    if args.cuda:
        net.load_state_dict(copyStateDict(torch.load(args.detect_model)))
    else:
#         import pickle
#         import chardet string = "솜씨좋은장씨"
#         print(chardet.detect(string.encode()))
#         pickle.load = partial(pickle.load, encoding="utf-8")
#         pickle.Unpickler = partial(pickle.Unpickler, encoding="latin1")
#         model = torch.load(model_file, map_location=lambda storage, loc: storage, pickle_module=pickle)
        net.load_state_dict(copyStateDict(torch.load(args.detect_model, map_location='cpu')))
    if args.cuda:
        net = net.cuda()
        net = torch.nn.DataParallel(net)
        cudnn.benchmark = False
    net.eval()
    refine_net = None
    if args.refine:
        from detection.refinenet import RefineNet
        refine_net = RefineNet()
        # print('Loading weights of refiner from checkpoint (' + args.refiner_model + ')')
        if args.cuda:
            refine_net.load_state_dict(copyStateDict(torch.load(args.refiner_model)))
            refine_net = refine_net.cuda()
            refine_net = torch.nn.DataParallel(refine_net)
        else:
            refine_net.load_state_dict(copyStateDict(torch.load(args.refiner_model, map_location='cpu')))

        refine_net.eval()
        args.poly = True

    return net, refine_net, args
def init_recog_model(args):
    if 'CTC' in args.Prediction:
        converter = CTCLabelConverter(args.character)
    else:
        converter = AttnLabelConverter(args.character)
    args.num_class = len(converter.character)

    if args.rgb:
        args.input_channel = 3
    model = Model(args)
    # print('model input parameters', args.imgH, args.imgW, args.num_fiducial, args.input_channel, args.output_channel,
    #       args.hidden_size, args.num_class, args.batch_max_length, args.Transformation, args.FeatureExtraction,
    #       args.SequenceModeling, args.Prediction)
    model = torch.nn.DataParallel(model).to(device)

    # load model
    # print('loading pretrained model from %s' % args.recog_model)
    model.load_state_dict(torch.load(args.recog_model, map_location=device))
    return model,args,converter

# def init_model(args):
#     image_list, _, _ = get_files(args.test_folder)
#     net, refine_net, args = init_detect_model(args)
#     recog_net,args,converter = init_recog_model(args)
#     return image_list,net, recog_net, refine_net, args,converter

class CropDataset(Dataset):

    def __init__(self, polys, image,trocr=False,naver=False,img_transform=None):
        self.image = image
        self.polys = polys
        self.trocr = trocr
        self.naver = naver
        if trocr:
            self.img_transform = img_transform

    def __len__(self):
        return len(self.polys)

    def __getitem__(self, index):
        res = self.polys[index]

        res = np.array(res).astype(np.int32).reshape((-1))
        croped,rect = cropped_image(self.image, res)
        if self.naver:
            croped = Image.fromarray(croped).convert('L')
        elif self.trocr:
            croped = Image.fromarray(croped).convert('RGB').resize((384, 384))
            cropped = self.img_transform(croped).unsqueeze(0).to(device).float()
            croped = {'net_input': {"imgs": cropped},}
        return croped, rect

def naver_recog(args,data,model,converter,img_size):
    AlignCollate_demo = AlignCollate(imgH=args.imgH, imgW=args.imgW, keep_ratio_with_pad=args.PAD)

    data_loader = torch.utils.data.DataLoader(
        data, batch_size=args.batch_size,
        shuffle=False,
        num_workers=int(args.workers),
        collate_fn=AlignCollate_demo, pin_memory=True)

    # predict
    model.eval()
    with torch.no_grad():
        for image_tensors, rects in data_loader:
            batch_size = image_tensors.size(0)
            image = image_tensors.to(device)
            # For max length prediction
            length_for_pred = torch.IntTensor([args.batch_max_length] * batch_size).to(device)
            text_for_pred = torch.LongTensor(batch_size, args.batch_max_length + 1).fill_(0).to(device)

            if 'CTC' in args.Prediction:
                preds = model(image, text_for_pred)

                # Select max probabilty (greedy decoding) then decode index to character
                preds_size = torch.IntTensor([preds.size(1)] * batch_size)
                _, preds_index = preds.max(2)
                # preds_index = preds_index.view(-1)
                preds_str = converter.decode(preds_index, preds_size)

            else:
                preds = model(image, text_for_pred, is_train=False)

                # select max probabilty (greedy decoding) then decode index to character
                _, preds_index = preds.max(2)
                preds_str = converter.decode(preds_index, length_for_pred)

            # log = open(f'./log_demo_result.txt', 'a')
            dashed_line = '-' * 80
            head = f'{"image_path":25s}\t{"predicted_labels":25s}\tconfidence score'

            # print(f'{dashed_line}\n{head}\n{dashed_line}')
            # log.write(f'{dashed_line}\n{head}\n{dashed_line}\n')

            preds_prob = F.softmax(preds, dim=2)
            preds_max_prob, _ = preds_prob.max(dim=2)

            one_image_res = []

            for idx, (pred, pred_max_prob,rect) in enumerate(zip(preds_str, preds_max_prob,rects)):
                if 'Attn' in args.Prediction:
                    pred_EOS = pred.find('[s]')
                    pred = pred[:pred_EOS]  # prune after "end of sentence" token ([s])
                    pred_max_prob = pred_max_prob[:pred_EOS]

                # calculate confidence score (= multiply of pred_max_prob)
                confidence_score = pred_max_prob.cumprod(dim=0)[-1]
                total_x = img_size[1]
                total_y = img_size[0]
                x, y, w, h = rect
                width = w / total_x
                height = h / total_y
                left = x / total_x
                top = y / total_y
                res_dict = dict()
                res_dict['text'] = pred
                res_dict['coordinate'] = {"left":left,"top":top}
                res_dict['size'] = {"width":width,"height":height}

                
                res_dict['accuracy'] = confidence_score.to('cpu').item()

                one_image_res.append(res_dict)
                # print(f'{idx:25d}_cropped\t{pred:25s}\t{confidence_score:0.4f}\t{poly}')
                # log.write(f'{idx:25s}\t{pred:25s}\t{confidence_score:0.4f}\n')
    return one_image_res


def trocr_recog(dataset,recog_net,img_size,tr_task):
    one_image_res = []
    for tr_sample,rect in dataset:
        text = tr_recog(tr_cfg, tr_generator, recog_net, tr_sample, tr_bpe,tr_task)
        total_x = img_size[1]
        total_y = img_size[0]
        x, y, w, h = rect
        width = w / total_x
        height = h / total_y
        left = x / total_x
        top = y / total_y
        res_dict = dict()
        res_dict['text'] = text
        res_dict['coordinate'] = {"left":left,"top":top}
        res_dict['size'] = {"width":width,"height":height}

        
        res_dict['accuracy'] = 1.0
        one_image_res.append(res_dict)
    return one_image_res


if __name__ =="__main__":
    args = command()
    image_list, _, _ = get_files(args.test_folder)
    if os.path.isfile('./craft.pkl'):
            with open('craft.pkl','rb') as f:
                detect_net = pickle.load(f)
            with open('trhtr.pkl','rb') as f2:
                recog_net, tr_cfg, tr_task, tr_generator, tr_bpe, tr_img_transform = pickle.load(f2)
    else:
        detect_net, refine_net, args = init_detect_model(args)
        if args.recog_name == 'trocr':   
            recog_net, tr_cfg, tr_task, tr_generator, tr_bpe, tr_img_transform, _ = tr_init(args.recog_model, 5)
        elif args.recog_name == 'naver':
            recog_net,args,converter = init_recog_model(args)
        with open('./craft.pkl','wb') as f:
            pickle.dump(detect_net,f)
        with open('./trhtr.pkl','wb') as f2:
             pickle.dump([recog_net, tr_cfg, tr_task, tr_generator, tr_bpe, tr_img_transform],f2)
    total_image_res = {}
    for k, image_path in enumerate(image_list):
        print("Test image {:d}/{:d}: {:s}".format(k+1, len(image_list), image_path))
        name = os.path.split(image_path)[-1]
        image = imgproc.loadImage(image_path)
        img_size = image.shape

        polys = detect(args, detect_net, image, args.text_threshold, args.link_threshold, args.low_text, args.cuda, args.poly, refine_net)


        if args.recog_name == 'trocr':
            dataset = CropDataset(polys,image,trocr=True,img_transform=tr_img_transform)
            one_image_res = trocr_recog(dataset,recog_net,img_size,tr_task)
        elif args.recog_name == 'naver':
            dataset = CropDataset(polys,image,naver=True)
            one_image_res = naver_recog(args,dataset,recog_net,converter,img_size)

                

        total_image_res[name] = one_image_res
    sys.stdout.write(json.dumps(total_image_res))
