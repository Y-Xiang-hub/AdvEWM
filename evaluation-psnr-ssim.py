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
    img1 = Image.open('img1.bmp')
    img2 = Image.open('img2.bmp')
    img1_arr = np.asarray(img1)
    img2_arr = np.asarray(img2)
    ssim_score, psnr_score = evaluate_image(img1_arr, img2_arr)

    print("SSIM: {}".format(ssim_score))
    print("PSNR: {}".format(psnr_score))
