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
    folder_path_ori = r'C:\Users\dell\Desktop\General Watermark Dataset'
    folder_path_wm = r'C:\Users\dell\Desktop\AI\AI_AEs_Code_Pytorch\Dataset\CIFAR-10\DWT_AEs\EfficientNet'
    categories = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']
    for c in categories:
        folder_path_ori_c = folder_path_ori + '/' + c
        folder_path_wm_c = folder_path_wm + '/' + c
        imgs_ori = os.listdir(folder_path_ori_c)
        imgs_wm = os.listdir(folder_path_wm_c)
        ssim_sum = []
        psnr_sum = []
        for img_wm in imgs_wm:
            if img_wm.endswith('.jpg'):
                name_parts = img_wm.split('.')
                img_ori = name_parts[1] + '.' + name_parts[4]
                img_ori = folder_path_ori_c + '/' + img_ori
                try:
                    img_ori = Image.open(img_ori)
                    img_ori = np.asarray(img_ori)
                    img_wm = folder_path_wm_c + '/' + img_wm
                    img_wm = Image.open(img_wm)
                    img_wm = np.asarray(img_wm)
                    ssim_score, psnr_score = evaluate_image(img_ori, img_wm)
                    ssim_sum.append(ssim_score)
                    psnr_sum.append(psnr_score)
                except:
                    pass

        ssim_score = np.mean(ssim_sum)
        psnr_score = np.mean(psnr_sum)

        print("############################################################\n")
        print("Category {}".format(c))
        print("Average SSIM: {}".format(ssim_score))
        print("Average PSNR: {}".format(psnr_score))
        print("\n")

