from tqdm import tqdm
import os
import numpy as np
import cv2
import imutils
import matplotlib.pyplot as plt

gwamok = 'eng'  ##################정하기
root_dir = os.getcwd()


def get_image(base_dir):
    for entry in os.scandir(base_dir):
        if entry.is_file() and (entry.name.endswith(".jpg") or entry.name.endswith(".png")):
            yield entry.name
        elif entry.is_dir():
            yield from get_image(entry.path)
        else:
            continue


def get_loc(base_dir):
    for entry in os.scandir(base_dir):
        if entry.is_file() and (entry.name.endswith(".txt")):
            yield entry.name
        elif entry.is_dir():
            yield from get_image(entry.path)
        else:
            continue


image_dir = os.path.join(root_dir, gwamok)

def cropped_image(img,poly):

    temp = poly
    x = temp[::2]
    y = temp[1::2]
    pts = np.array([[int(x), int(y)] for x, y in zip(x, y)])

    rect = cv2.boundingRect(pts)
    x, y, w, h = rect
    croped = img[y:y + h, x:x + w].copy()
    # cv2.imwrite(f"temps/croped_{i}.jpg", croped)

    return croped, rect

