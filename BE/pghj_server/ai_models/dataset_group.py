import numpy as np
from image_crop import cropped_image
from PIL import Image
from torch.utils.data import Dataset

class NaverDataset(Dataset):

    def __init__(self, polys, image):
        self.image = image
        self.polys = polys

    def __len__(self):
        return len(self.polys)

    def __getitem__(self, index):
        res = self.polys[index]
        res = np.array(res).astype(np.int32).reshape((-1))
        croped,rect = cropped_image(self.image, res)
        croped = Image.fromarray(croped).convert('L')

        return croped, rect


class TrocrDataset(Dataset):
    def __init__(self, polys, image,processor, max_target_length=256):
        self.image = image
        self.polys = polys
        self.processor = processor
        self.max_target_length = max_target_length

    def __len__(self):
        return len(self.polys)

    def __getitem__(self, idx):
        res = self.polys[idx]
        res = np.array(res).astype(np.int32).reshape((-1))
        croped,rect = cropped_image(self.image, res)
        croped = self.processor(croped, return_tensors="pt").pixel_values.squeeze()

        return croped, rect
