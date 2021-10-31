# 필기해줘 AI engine
1. 필요한 python package 다운
2. wget으로 pretrained model down
3. python craft --test_folder로 실행


```
pip install torch==0.4.1.post2 torchvision==0.2.1 opencv-python==3.4.2.17 scikit-image==0.14.2 scipy==1.1.0 pillow imutils
```

```
# 서버가 아니라면
sudo apt-get install cmake
pip install scikit-build torch torchvision opencv-python scikit-image scipy pillow imutils tqdm lmdb natsort numpy pandas
pip install pybind11
pip timm==0.4.5 tensorboard nltk h5py fastwer
git+https://github.com/liminghao1630/fairseq.git
pip install -v --no-cache-dir --global-option="--cpp_ext" --global-option="--cuda_ext" 'git+https://github.com/NVIDIA/apex.git'
```
### 패키지 업으면, 필요한 것 있으면 다운

## pretrained model download
#### craft pretrained model download
```
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ" -O craft.pth && rm -rf ~/cookies.txt
```
```
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0" -O recog.pth && rm -rf ~/cookies.txt
```


#### trocr pretrained model donwload
###### doc
```
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1-3CrKW5v-40fDh0XXJipZw2D6YGntgdN' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1-3CrKW5v-40fDh0XXJipZw2D6YGntgdN" -O trocr.pt && rm -rf ~/cookies.txt
```
###### htr
```
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1YhPvf463vzhHfX2QWqjmKQRNzUlOUwVA' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1YhPvf463vzhHfX2QWqjmKQRNzUlOUwVA" -O trhtr.pt && rm -rf ~/cookies.txt
```

### 실행 방법
```
python craft.py --test_folder {경로} --recog_name trocr 또는 naver 선택 --recog_model {경로}
```
### 만약 gpu 없다면
```
python craft.py --test_folder {경로} --cuda n --recog_name trocr 또는 naver 선택 --recog_model {경로}
```
### example
```
python craft.py --test_folder "eng/" --recog_name trocr --recog_model downloads/premodels/trhtr.pt
```
### 서버용
```
sudo apt-get install build-essential
sudo apt-get install python3.8-dev
cd models/trocr
pip3 install pybind11
pip3 install -r requirements.txt
cd ..
cd ..

img_path, '--cuda','n','--recog_name','trocr','--recog_model','./models/trhtr.pt','--detect_model','./models/craft.pth

```

