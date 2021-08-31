% @Time		  : 1 June, 2020
% @Author   : Tiantian Li and Yuexin Xiang
% @Email	  : ltt@cug.edu.cn or yuexin.xiang@cug.edu.cn
% @Function : RGB separation

function [R,G,B] = RGBseparate(ImgName)
image = imread(ImgName);
image_r = image(:,:,1);
image_g = image(:,:,2);
image_b = image(:,:,3);
R = image_r;
G = image_g;
B = image_b;
