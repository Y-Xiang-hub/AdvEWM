import os
import shutil
import random
import time
import cv2
import numpy as np
from PIL import Image
import math
import matlab.engine
import string

import Tdensenet
# import Tgooglenet
# import Tresnet
# import Tdensenet
# import Tvgg
# import Tdensenet
# import Tmobilenet
# import Tefficientnet
# import Tvit

import torch
# import torch.nn as nn
# import torch.optim as optim
import torch.nn.functional as F
# from torch.autograd import Variable
# import torchvision
import torchvision.transforms as transforms
from collections import OrderedDict

MAX_TIMES = 1  # 2 times for dwt-dct (0 represent 1, 1 represent 2)
MAX_FAULT_COUNT = 10  # fault count
TOTAL_SUCCESS = 0  # to count the total successful result number
TOTAL_NUM = 0  # to count the total number

# embedding strength
R = 0.02
G = 0.04
B = 0.01

my_device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')


def img_loader(PATH):
    img = Image.open(PATH)
    trans = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.4914, 0.4822, 0.4465), (0.2023, 0.1994, 0.2010)),
    ])
    img = trans(img)
    img = img.to(my_device)
    img = img.unsqueeze(0)  # after extension is [1，1，28，28]
    return img


def img_prediction(LOADER, class_name):
    outputs = model(LOADER)
    prob = F.softmax(outputs, dim=1)  # prob is the probabilities of then classes
    confidence_LOADER = float(torch.max(prob))
    value, predicted_LOADER = torch.max(outputs.data, 1)
    predicted_LOADER.item()
    pred_class = class_name[predicted_LOADER.item()]
    return confidence_LOADER, predicted_LOADER.item()


# Add dwt-dct watermark
def add_dwt_dct_wm(img_ori_PATH, img_wm_PATH,
               strength_R, strength_G, strength_B,
               ori_CLASS, wm_CLASS, TIMES, img_output_PATH, eng):
    img_name = eng.DWT_WaterMark(img_ori_PATH, img_wm_PATH,
                                 strength_R, strength_G, strength_B,
                                 ori_CLASS, wm_CLASS, TIMES, img_output_PATH)
    img_name = eng.DCT_WaterMark(img_name, img_wm_PATH,
                                 strength_R, strength_G, strength_B,
                                 ori_CLASS, wm_CLASS, TIMES, img_output_PATH)
    return img_name


def use_dwt_dct(img_ori_PATH, img_wm_PATH,
            strength_R, strength_G, strength_B,
            ori_CLASS, wm_CLASS, TIMES, img_output_PATH, eng, class_name):
    img_transfer = add_dwt_dct_wm(img_ori_PATH, img_wm_PATH,
                              strength_R, strength_G, strength_B,
                              ori_CLASS, wm_CLASS, TIMES, img_output_PATH, eng)
    img_embedding = img_loader(img_transfer)
    confidence_wmed, class_wmed = img_prediction(img_embedding, class_name)
    print("Being Watermarked With Times: " + str(TIMES))
    print("Belongs To Class: " + str(class_wmed))
    print("With Confidence: " + str(confidence_wmed))
    print("\n")
    NEW_TIMES = TIMES + 1
    time_flag = False

    success_flag = False
    if class_wmed == ori_CLASS:
        for i in range(0, MAX_TIMES):
            if i <= MAX_TIMES:
                img_transfer = add_dwt_dct_wm(img_transfer, img_wm_PATH,
                                          strength_R, strength_G, strength_B,
                                          ori_CLASS, wm_CLASS, NEW_TIMES, img_output_PATH, eng)
                img_embedding = img_loader(img_transfer)
                confidence_wmed, class_wmed = img_prediction(img_embedding, class_name)
                print("Being Watermarked With Times: " + str(NEW_TIMES))
                print("Belongs To Class: " + str(class_wmed))
                print("With Confidence: " + str(confidence_wmed))
                if class_wmed == ori_CLASS:
                    NEW_TIMES += 1
                    i += 1
                    continue
                else:
                    success_flag = True
                    break
            else:
                break
    else:
        success_flag = True
        time_flag = True

    if (success_flag is True) & (time_flag is True):
        return TIMES
    elif (success_flag is True) & (time_flag is False):
        return NEW_TIMES
    else:
        print("This Watermark Image Failed in Generating AEs")
        return "FAIL"


def result_process(path, result):
    path_list = os.listdir(path)
    img_num = len(path_list) - 1
    path_list.sort(key=lambda f: int(f.split('.')[3]))
    if result == "FAIL":
        midresult_delete(path)
        return False
    else:
        del path_list[0:img_num]
        return path_list[0]


def copy_result(filename, ori_address, new_address):
    shutil.move(ori_address + '/' + filename, new_address + '/' + filename)
    print("Result Has Been Moved To Target Folder!")


def midresult_delete(path):
    shutil.rmtree(path)
    os.mkdir(path)


if __name__ == "__main__":

    # DWT
    model_path = 'path-1 + .pth'
    ori_list_path = 'path-2'
    buff_img_path = 'path-3'
    wm_path = 'path-4'
    final_img_path = 'path-5'
    save_record_path = 'path-6 + .txt'

    # TIME COUNT - 1
    time_start = time.time()

    # classification
    class_name = ('plane', 'car', 'bird', 'cat', 'deer', 'dog', 'frog', 'horse', 'ship', 'truck')

    # choose device
    # my_device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')

    # load CIFAR-10 model
    model = Tdensenet.DenseNet121()
    checkpoint = torch.load(model_path)
    state_dict = checkpoint['net']
    epoch = checkpoint['epoch']
    accuracy = checkpoint['acc']
    new_state_dict = OrderedDict()
    for k, v in state_dict.items():
        name = k[7:]  # remove 'module.'
        # name = name.replace('module.', '')
        new_state_dict[name] = v
    model.load_state_dict(new_state_dict)
    model.to(my_device)
    model.eval()

    matlab_eng = matlab.engine.start_matlab()

    # single-folder
    folder_ori_list = [ori_list_path]

    # get and save the name of watermark (test) image folder
    folder_wm = os.walk(wm_path)
    folder_wm_list = []
    delete_flag_wm = 0
    for folder_wm_path, dir_list, folder_list in folder_wm:
        if delete_flag_wm == 0:
            delete_flag_wm += 1
        else:
            folder_wm_list.append(folder_wm_path)
            delete_flag_wm += 1
    print(folder_wm_list)
    # embed watermark image into original image

    for folder_ori_img in folder_ori_list:
        files_ori = os.listdir(folder_ori_img)
        for i_ori in files_ori:
            current_ori_path = folder_ori_img + '/' + i_ori
            img_ori = img_loader(current_ori_path)
            confidence_ori, class_ori = img_prediction(img_ori, class_name)
            TOTAL_NUM += 1

            # random the order-1
            random.shuffle(folder_wm_list)

            for folder_wm_img in folder_wm_list:
                files_wm = os.listdir(folder_wm_img)
                wm_round_flag = False
                ori_round_flag = False
                WM_FAULT_COUNT = 0

                # random the order-2
                random.shuffle(files_wm)

                for i_wm in files_wm:
                    current_wm_path = folder_wm_img + '/' + i_wm
                    img_wm = img_loader(current_wm_path)
                    confidence_wm, class_wm = img_prediction(img_wm, class_name)
                    time_check = 1
                    round_result = use_dwt_dct(current_ori_path, current_wm_path, R, G, B, class_ori, class_wm, time_check,
                                           buff_img_path, matlab_eng, class_name)
                    result_img_name = result_process(buff_img_path, round_result)
                    if (result_img_name is False) & (WM_FAULT_COUNT < MAX_FAULT_COUNT):
                        WM_FAULT_COUNT += 1
                        # TEST
                        print("TEST FAULT_COUNT: ", WM_FAULT_COUNT)
                        continue
                    else:
                        if WM_FAULT_COUNT < MAX_FAULT_COUNT:
                            copy_result(result_img_name, buff_img_path, final_img_path)
                            midresult_delete(buff_img_path)
                            TOTAL_SUCCESS += 1
                            wm_round_flag = True
                            break
                        else:
                            break
                if wm_round_flag is True:
                    ori_round_flag = True
                    result_record = open(save_record_path, 'a')
                    print("Current Process = " + str(TOTAL_NUM) + "/" + str(1000) + " Success")
                    print("Current Process = " + str(TOTAL_NUM) + "/" + str(1000) + " Success",
                          file=result_record)
                    result_record.close()
                    print("\n")
                    break
                result_record = open(save_record_path, 'a')
                print("Current Process = " + str(TOTAL_NUM) + "/" + str(1000) + " Failure")
                print("Current Process = " + str(TOTAL_NUM) + "/" + str(1000) + " Failure",
                      file=result_record)
                result_record.close()
                print("\n")
                if ori_round_flag is True:
                    break
                else:
                    continue

    # TIME COUNT - 2
    time_end = time.time()
    print("###############################################")
    print("Time Cost: ", time_end - time_start, "s")
    print("Success Rate: ", TOTAL_SUCCESS, "/", TOTAL_NUM)
    print("###############################################")

    matlab_eng.quit()
