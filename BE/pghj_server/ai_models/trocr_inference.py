
from trocr import task,deit,deit_models 
import torch
import os

import fairseq as fairseq
from fairseq import utils
from fairseq_cli import generate
from PIL import Image
import torchvision.transforms as transforms


def init(model_path, beam=5):
    
    
    model, cfg, task = fairseq.checkpoint_utils.load_model_ensemble_and_task(
        [model_path],
        arg_overrides={"beam": beam, "task": "text_recognition", "data": "", "fp16": False},
        )
    
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model[0].to(device)

    img_transform = transforms.Compose([
        transforms.Resize((384, 384), interpolation=3),
        transforms.ToTensor(),
        transforms.Normalize(0.5, 0.5)
    ])

    generator = task.build_generator(
        model, cfg.generation, extra_gen_cls_kwargs={'lm_model': None, 'lm_weight': None}
    )
    
    bpe = task.build_bpe(cfg.bpe)
    
    return model, cfg, task, generator, bpe, img_transform, device


def preprocess(img_path, img_transform):
    im = Image.open(img_path).convert('RGB').resize((384, 384))
    im = img_transform(im).unsqueeze(0).to(device).float()

    sample = {
        'net_input': {"imgs": im},
    }

    return sample


def get_text(cfg, generator, model, sample, bpe,tr_task=None):
    if tr_task != None:
        decoder_output = tr_task.inference_step(generator, model, sample, prefix_tokens=None, constraints=None)
    else:
        decoder_output = task.inference_step(generator, model, sample, prefix_tokens=None, constraints=None)
    
    decoder_output = decoder_output[0][0]       #top1

    hypo_tokens, hypo_str, alignment = utils.post_process_prediction(
        hypo_tokens=decoder_output["tokens"].int().cpu(),
        src_str="",
        alignment=decoder_output["alignment"],
        align_dict=None,
        tgt_dict=model[0].decoder.dictionary,
        remove_bpe=cfg.common_eval.post_process,
        extra_symbols_to_ignore=generate.get_symbols_to_strip_from_output(generator),
    )

    detok_hypo_str = bpe.decode(hypo_str)[:-2]
    
    return detok_hypo_str

# roots = os.getcwd()
# model_path = os.path.join(roots,'downloads/premodels/trocr-large-handwritten.pt')
# jpg_path = os.path.join(roots,"downloads/naver_crop")
# entries = os.scandir(jpg_path)
# imgs = []
# for entry in entries:
#     if entry.name[-4:] == '.png' or entry.name[-4:] == '.jpg':
#         imgs.append(entry.name)
# beam = 5

# model, cfg, task, generator, bpe, img_transform, device = init(model_path, beam)

# results = []
# for filename in tqdm.tqdm(imgs):
#     img = os.path.join(jpg_path,filename)
#     sample = preprocess(img, img_transform)
#     text = get_text(cfg, generator, model, sample, bpe)
#     results.append(text)
#     break
# os.system('cls' if os.name == 'nt' else 'clear')
# print(results)
# print('done')
if __name__ == '__main__':
    
    roots = os.getcwd()
    model_path = os.path.join(roots,'downloads/premodels/trhtr.pt')
    jpg_path = os.path.join(roots,"downloads/naver_crop")
    entries = os.scandir(jpg_path)
    imgs = []
    for entry in entries:
        if entry.name[-4:] == '.png' or entry.name[-4:] == '.jpg':
            imgs.append(entry.name)
    beam = 5

    model, cfg, task, generator, bpe, img_transform, device = init(model_path, beam)

    results = []
    # for filename in tqdm.tqdm(imgs):
    for filename in imgs:
        img = os.path.join(jpg_path,filename)
        sample = preprocess(img, img_transform)
        text = get_text(cfg, generator, model, sample, bpe,task)
        results.append(text)
        break
    # os.system('cls' if os.name == 'nt' else 'clear')
    # time.sleep(0.1)
    # os.system('clear')
    
    print(results,end='')
#     model_path = '../../premodels/trocr-large-handwritten.pt'
#     jpg_path = "../../naver_crop/croped_.png0.jpg"
#     beam = 5

#     model, cfg, task, generator, bpe, img_transform, device = init(model_path, beam)

#     sample = preprocess(jpg_path, img_transform)

#     text = get_text(cfg, generator, model, sample, bpe)
 
#     print(text)

#     print('done')