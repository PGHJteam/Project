import subprocess
import sys
import os

def detection_recognition(img_path, img_tag):
    basic_path = os.getcwd() + '/ai_models'
    #print(basic_path)
    detect_model = f'{basic_path}/downloads/premodels/craft.pth'
    if img_tag == 'eng-htr':
        py_path = f'{basic_path}/craft_eng.py'
        recog_name = 'trocr'
        detect_text = 'htr'
    elif img_tag == 'eng-ocr':
        py_path = f'{basic_path}/craft_eng.py'
        recog_name = 'trocr'
        detect_text = 'ocr'
    elif img_tag == 'kor-htr' or img_tag == 'kor-ocr':
        py_path = f'{basic_path}/craft_kor.py'
        recog_name = 'naver'
        detect_text = 'none'

    p1 = subprocess.run(args=[sys.executable, py_path, '--test_folder', img_path, '--cuda','n','--recog_name', recog_name,'--detect_text', detect_text, '--detect_model', detect_model], capture_output=True)

   # print("error msg: ", p1.stderr) # compile
   # print("stdout:", p1.stdout) # compile

    result = p1.stdout.strip()
    return result
