import os
import numpy as np
from PIL import Image
from skimage.metrics import structural_similarity as ssim
from skimage.metrics import peak_signal_noise_ratio as psnr


def evaluate_image(imageA, imageB):
    # compute the structural similarity index and the
    # peak signal-to-noise ratio for the images
    m = ssim(imageA, imageB, multichannel=True)
    n = psnr(imageA, imageB, data_range=imageA.max() - imageA.min())

    # return the ssim, psnr
    return m, n


if __name__ == "__main__":
    folder_path_ori = ''
    folder_path_wm = ''
    imgs_ori = os.listdir(folder_path_ori)
    # imgs_wm = os.listdir(folder_path_wm)
    ssim_sum = []
    psnr_sum = []
    for img in imgs_ori:
        if img.endswith('.bmp'):
            img = Image.open(img)
            img = np.asarray(img)
            img_wm = Image.open(folder_path_wm + '/' + img[:-4] + '_wm.bmp')
            img_wm = np.asarray(img_wm)
            ssim_score, psnr_score = evaluate_image(img, img_wm)
            ssim_sum.append(ssim_score)
            psnr_sum.append(psnr_score)
    ssim_score = np.mean(ssim_sum)
    psnr_score = np.mean(psnr_sum)

    print("Average SSIM: {}".format(ssim_score))
    print("Average PSNR: {}".format(psnr_score))
