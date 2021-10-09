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
```
### 패키지 업으면, 필요한 것 있으면 다운


#### pretrained model download
```
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1yim_nfaYOKD6jRns3YKMPcCmUYtrVYF0" -O recog.pth && rm -rf ~/cookies.txt
```
```
wget --load-cookies ~/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies ~/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1xv1gs770_HGbWdJ6EgTxo_zngiE_voWJ" -O craft.pth && rm -rf ~/cookies.txt
```
```
# 만약 wget 다운이 안 되면, https://drive.google.com/drive/folders/1UFAEyF5gTxioO2vsp-PjWRYeA6ajkIDj에서 2개 파일 다운
```


### 실행 방법
```
python craft.py --test_folder {경로}
# 만약 gpu 없다면
python craft.py --test_folder {경로} --cuda n
```
### example
```
python craft.py --test_folder "eng/"
```
