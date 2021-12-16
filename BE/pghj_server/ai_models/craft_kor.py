import argparse,sys
import pickle
import cv2
from detection import imgproc, craft_utils
from detection.craft import CRAFT
from torch.autograd import Variable
from collections import OrderedDict
from dataset_group import NaverDataset, TrocrDataset

import re
import string
import torch
import torch.backends.cudnn as cudnn
import torch.utils.data
import torch.nn.functional as F
import os
import json

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

    # naver detection
    parser.add_argument('--detect_model', default='downloads/premodels/craft.pth', type=str, help='pretrained model')
    parser.add_argument('--text_threshold', default=0.7, type=float, help='text confidence threshold')
    parser.add_argument('--low_text', default=0.4, type=float, help='text low-bound score')
    parser.add_argument('--link_threshold', default=0.4, type=float, help='link confidence threshold')
    parser.add_argument('--cuda', default=True, type=str2bool, help='Use cuda for inference')
    parser.add_argument('--canvas_size', default=1280, type=int, help='image size for inference')
    parser.add_argument('--mag_ratio', default=1.5, type=float, help='image magnification ratio')
    parser.add_argument('--poly', default=False, action='store_true', help='enable polygon type')
    parser.add_argument('--show_time', default=False, action='store_true', help='show processing time')
    parser.add_argument('--refine', default=False, action='store_true', help='enable link refiner')
    parser.add_argument('--refiner_model', default='weights/craft_refiner_CTW1500.pth', type=str, help='pretrained refiner model')

    # naver recogntion
    parser.add_argument('--test_folder', required=True, help='path to image_folder which contains text images')
    parser.add_argument('--workers', type=int, help='number of data loading workers', default=4)
    parser.add_argument('--batch_size', type=int, default=192, help='input batch size')
    parser.add_argument('--saved_model', default='downloads/premodels/pretrained_ocr.pth', help="path to saved_model to evaluation")
    """ Data processing """
    parser.add_argument('--batch_max_length', type=int, default=25, help='maximum-label-length')
    parser.add_argument('--imgH', type=int, default=32, help='the height of the input image')
    parser.add_argument('--imgW', type=int, default=100, help='the width of the input image')
    parser.add_argument('--rgb', action='store_true', help='use rgb input')
    parser.add_argument('--character', type=str,
                        default='0123456789abcdefghijklmnopqrstuvwxyz가각간갇갈감갑값갓강갖같갚갛개객걀걔거걱건걷걸검겁것겉게겨격겪견결겹경곁계고곡곤곧골곰곱곳공과관광괜괴굉교구국군굳굴굵굶굽궁권귀귓규균귤그극근글긁금급긋긍기긴길김깅깊까깍깎깐깔깜깝깡깥깨꺼꺾껌껍껏껑께껴꼬꼭꼴꼼꼽꽂꽃꽉꽤꾸꾼꿀꿈뀌끄끈끊끌끓끔끗끝끼낌나낙낚난날낡남납낫낭낮낯낱낳내냄냇냉냐냥너넉넌널넓넘넣네넥넷녀녁년념녕노녹논놀놈농높놓놔뇌뇨누눈눕뉘뉴늄느늑는늘늙능늦늬니닐님다닥닦단닫달닭닮담답닷당닿대댁댐댓더덕던덜덟덤덥덧덩덮데델도독돈돌돕돗동돼되된두둑둘둠둡둥뒤뒷드득든듣들듬듭듯등디딩딪따딱딴딸땀땅때땜떠떡떤떨떻떼또똑뚜뚫뚱뛰뜨뜩뜯뜰뜻띄라락란람랍랑랗래랜램랫략량러럭런럴럼럽럿렁렇레렉렌려력련렬렵령례로록론롬롭롯료루룩룹룻뤄류륙률륭르른름릇릎리릭린림립릿링마막만많말맑맘맙맛망맞맡맣매맥맨맵맺머먹먼멀멈멋멍멎메멘멩며면멸명몇모목몬몰몸몹못몽묘무묵묶문묻물뭄뭇뭐뭘뭣므미민믿밀밉밌및밑바박밖반받발밝밟밤밥방밭배백뱀뱃뱉버번벌범법벗베벤벨벼벽변별볍병볕보복볶본볼봄봇봉뵈뵙부북분불붉붐붓붕붙뷰브븐블비빌빔빗빚빛빠빡빨빵빼뺏뺨뻐뻔뻗뼈뼉뽑뿌뿐쁘쁨사삭산살삶삼삿상새색샌생샤서석섞선설섬섭섯성세섹센셈셋셔션소속손솔솜솟송솥쇄쇠쇼수숙순숟술숨숫숭숲쉬쉰쉽슈스슨슬슴습슷승시식신싣실싫심십싯싱싶싸싹싼쌀쌍쌓써썩썰썹쎄쏘쏟쑤쓰쓴쓸씀씌씨씩씬씹씻아악안앉않알앓암압앗앙앞애액앨야약얀얄얇양얕얗얘어억언얹얻얼엄업없엇엉엊엌엎에엔엘여역연열엷염엽엿영옆예옛오옥온올옮옳옷옹와완왕왜왠외왼요욕용우욱운울움웃웅워원월웨웬위윗유육율으윽은을음응의이익인일읽잃임입잇있잊잎자작잔잖잘잠잡잣장잦재쟁쟤저적전절젊점접젓정젖제젠젯져조족존졸좀좁종좋좌죄주죽준줄줌줍중쥐즈즉즌즐즘증지직진질짐집짓징짙짚짜짝짧째쨌쩌쩍쩐쩔쩜쪽쫓쭈쭉찌찍찢차착찬찮찰참찻창찾채책챔챙처척천철첩첫청체쳐초촉촌촛총촬최추축춘출춤춥춧충취츠측츰층치칙친칠침칫칭카칸칼캄캐캠커컨컬컴컵컷케켓켜코콘콜콤콩쾌쿄쿠퀴크큰클큼키킬타탁탄탈탑탓탕태택탤터턱턴털텅테텍텔템토톤톨톱통퇴투툴툼퉁튀튜트특튼튿틀틈티틱팀팅파팎판팔팝패팩팬퍼퍽페펜펴편펼평폐포폭폰표푸푹풀품풍퓨프플픔피픽필핏핑하학한할함합항해핵핸햄햇행향허헌험헤헬혀현혈협형혜호혹혼홀홈홉홍화확환활황회획횟횡효후훈훌훔훨휘휴흉흐흑흔흘흙흡흥흩희흰히힘?!.,',
                        help='character label')
    parser.add_argument('--sensitive', action='store_true', help='for sensitive character mode')
    parser.add_argument('--PAD', action='store_true', help='whether to keep ratio then pad for image resize')
    """ Model Architecture """
    parser.add_argument('--Transformation', type=str, default='TPS', help='Transformation stage. None|TPS')
    parser.add_argument('--FeatureExtraction', type=str, default='ResNet', help='FeatureExtraction stage. VGG|RCNN|ResNet')
    parser.add_argument('--SequenceModeling', type=str, default='BiLSTM', help='SequenceModeling stage. None|BiLSTM')
    parser.add_argument('--Prediction', type=str, default='CTC', help='Prediction stage. CTC|Attn')
    parser.add_argument('--num_fiducial', type=int, default=20, help='number of fiducial points of TPS-STN')
    parser.add_argument('--input_channel', type=int, default=1, help='the number of input channel of Feature extractor')
    parser.add_argument('--output_channel', type=int, default=512,
                        help='the number of output channel of Feature extractor')
    parser.add_argument('--hidden_size', type=int, default=256, help='the size of the LSTM hidden state')
    parser.add_argument('--detect_text',required=True, help='htr or ocr')
    parser.add_argument('--recog_name', default='naver', help='naver or trocr')
    parser.add_argument('--recog_model', default='./ai_models/downloads/premodels/kocrnn.pth', help='naver path')

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
    net = CRAFT()
    if args.cuda:
        net.load_state_dict(copyStateDict(torch.load(args.detect_model)))
    else:
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
    model = torch.nn.DataParallel(model).to(device)
    model.load_state_dict(torch.load(args.recog_model, map_location=device))
    return model,args,converter




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
    return one_image_res


def trocr_recog(dataset,recog_net,img_size,tr_task):
    one_image_res = []
    total_x = img_size[1]
    total_y = img_size[0]
    start_tok = '[CLS]'
    end_tok = '[SEP]'
    data_loader = torch.utils.data.DataLoader(
        dataset, batch_size=args.batch_size,
        shuffle=False,
        num_workers=int(args.workers), pin_memory=True)
    recog_net.eval()
    with torch.no_grad():
#         for tr_sample,rect in dataset:
#             generated_ids = recog_net.generate(tr_sample)
#             text = dataset.processor.decode(generated_ids, skip_special_tokens=True)
#             total_x = img_size[1]
#             total_y = img_size[0]
#             x, y, w, h = rect
#             width = w / total_x
#             height = h / total_y
#             left = x / total_x
#             top = y / total_y
#             res_dict = dict()
#             res_dict['text'] = text
#             res_dict['coordinate'] = {"left":left,"top":top}
#             res_dict['size'] = {"width":width,"height":height}


#             res_dict['accuracy'] = 1.0
#             one_image_res.append(res_dict)
        for tr_sample,rect in data_loader:
            generated_ids = recog_net.generate(tr_sample,max_length=5)
            text = dataset.processor.batch_decode(generated_ids)
            for t in text:
                temp = re.sub(start_tok,"",t)
                if len(temp) == 0:
                    t = ''
                else:
                    if temp.startswith('[SEP]'):
                        end_idx = temp[len(start_tok):].find(end_tok)
                        if end_idx == 0:
                            t = ''
                        else:
                            t = temp[len(start_tok):end_idx]
                x, y, w, h = rect
                width = w / total_x
                height = h / total_y
                left = x / total_x
                top = y / total_y
                res_dict = dict()
                res_dict['text'] = t
                res_dict['coordinate'] = {"left":left,"top":top}
                res_dict['size'] = {"width":width,"height":height}


                res_dict['accuracy'] = 1.0
            one_image_res.append(res_dict)
    return one_image_res


if __name__ =="__main__":
    args = command()
    image_list, _, _ = get_files(args.test_folder)
    detect_net, refine_net, args = init_detect_model(args)
    if args.recog_name == 'trocr':
        with open('./kor_processor.pkl','rb') as f:
          kor_processor = pickle.load(f)
        with open('./kor_htr_model.pkl','rb') as f:
          kor_model = pickle.load(f)
    elif args.recog_name == 'naver':
        recog_net,args,converter = init_recog_model(args)
    
    total_image_res = {}
    for k, image_path in enumerate(image_list):
        print("Test image {:d}/{:d}: {:s}".format(k+1, len(image_list), image_path))
        name = os.path.split(image_path)[-1]
        image = imgproc.loadImage(image_path)
        img_size = image.shape

        polys = detect(args, detect_net, image, args.text_threshold, args.link_threshold, args.low_text, args.cuda, args.poly, refine_net)

        if args.recog_name == 'trocr':
            dataset = TrocrDataset(polys,image,kor_processor)
            one_image_res = trocr_recog(dataset,kor_model,img_size)
        elif args.recog_name == 'naver':
            dataset = NaverDataset(polys,image)
            one_image_res = naver_recog(args,dataset,recog_net,converter,img_size)

        total_image_res[name] = one_image_res
    sys.stdout.write(json.dumps(total_image_res))
