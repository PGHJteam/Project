# 필기해줘 AI engine
1. 필요한 python package 다운
2. wget으로 pretrained model down
3. python craft --test_folder로 실행



pip install torch==0.4.1.post2 torchvision==0.2.1 opencv-python==3.4.2.17 scikit-image==0.14.2 scipy==1.1.0 pillow imutils opencv-python
### 패키지 업으면, 필요한 것 있으면 다운


#### pretrained model download
```
wget https://drive.google.com/drive/folders/1UFAEyF5gTxioO2vsp-PjWRYeA6ajkIDj/craft_mlt_25k.pth
```
```
wget https://drive.google.com/drive/folders/1UFAEyF5gTxioO2vsp-PjWRYeA6ajkIDj/TPS-ResNet-BiLSTM-Attn.pth
```

### 실행 방법
```
python craft --test_folder {경로}
```
### example
```
python craft --test_folder "eng/"
```
