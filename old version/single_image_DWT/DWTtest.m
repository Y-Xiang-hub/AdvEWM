% @Time		: 1 June, 2020
% @Author	: Tiantian Li and Yuexin Xiang
% @Email	: ltt@cug.edu.cn or yuexin.xiang@cug.edu.cn
% @Function : the watermark image is embedded into the original image by the DWT-based patchwork watermarking algorithm for several times

clc
clear

% original image
imgori = 'cat.jpg';

% watermarking image
imgwm = 'dog.jpg';

% strength of embedding
alphaR = 0.04;
alphaG = 0.03;
alphaB = 0.08;
% embed watermarking into original image
[theimgname] = WaterMark(imgori,imgwm,alphaR,alphaG,alphaB);
for n = 1:50
    [imgimg] = WaterMark(theimgname,imgwm,alphaR,alphaG,alphaB);
    theimgname = imgimg;
end

% output
subplot(3,3,1),imshow(theimgname),title('Image after embedding watermarking');
