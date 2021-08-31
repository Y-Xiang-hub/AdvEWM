% RGB separation
function [R,G,B] = RGBseparate(ImgName)
image = imread(ImgName);
image_r = image(:,:,1);
image_g = image(:,:,2);
image_b = image(:,:,3);
R = image_r;
G = image_g;
B = image_b;
