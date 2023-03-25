function [ImgName] = DWT_WaterMark(OriImg, WmImg, QR, QG, QB, class_ori, class_wm, times, OutputDir)

% RGB separation of the original image
IRGB = imread(OriImg);
% IRGB = double(IRGB);
%IRGB = imresize(IRGB, [256,256]);
IR = IRGB(:, :, 1);
IG = IRGB(:, :, 2);
IB = IRGB(:, :, 3);

% original image R component single-level DWT transformation

[cA1r, cH1r, cV1r, cD1r] = dwt2(IR, 'haar');
[cA1g, cH1g, cV1g, cD1g] = dwt2(IG, 'haar');
[cA1b, cH1b, cV1b, cD1b] = dwt2(IB, 'haar');

% RGB separation of the watermarking image
WIRGB = imread(WmImg);
% WIRGB = double(WIRGB);
%WIRGB = imresize(WIRGB, [256,256]);
WIR = WIRGB(:, :, 1);
WIG = WIRGB(:, :, 2);
WIB = WIRGB(:, :, 3);

% watermarking image R component single-level DWT transformation

[cA1wr, cH1wr, cV1wr, cD1wr] = dwt2(WIR, 'haar');
[cA1wg, cH1wg, cV1wg, cD1wg] = dwt2(WIG, 'haar');
[cA1wb, cH1wb, cV1wb, cD1wb] = dwt2(WIB, 'haar');

% the watermarking embeds in the low-frequency, mid-frequency, 
% and high-frequency components of the R component of the original 
% image in single level
cA1r = cA1r + QR * cA1wr;
cH1r = cH1r - QR * cA1wr;
cV1r = cV1r - QR * cA1wr;
cD1r = cD1r - QR * cA1wr;
% inverse DWT transformation of the R component
% Single-level inverse discrete 2-D wavelet transform
wm_R = idwt2(cA1r, cH1r, cV1r, cD1r, 'haar');

% the watermarking embeds in the low-frequency, mid-frequency, 
% and high-frequency components of the G component of the original 
% image in the single level
cA1g = cA1g - QG * cA1wg;
cH1g = cH1g + QG * cA1wg;
cV1g = cV1g + QG * cA1wg;
cD1g = cD1g + QG * cA1wg;

wm_G = idwt2(cA1g, cH1g, cV1g, cD1g, 'haar');

% the watermarking embeds in the low-frequency, mid-frequency, 
% and high-frequency components of the B component of the original 
% image in the single level
cA1b = cA1b + QB * cA1wb;
cH1b = cH1b - QB * cA1wb;
cV1b = cV1b - QB * cA1wb;
cD1b = cD1b - QB * cA1wb;

wm_B = idwt2(cA1b, cH1b, cV1b, cD1b, 'haar');

% output
wm_img = cat(3, wm_R, wm_G, wm_B);
%wm_img = imresize(wm_img, [32,32]);

% for CIFAR-10
% path = fullfile(OutputDir,['times',int2str(times)],int2str(i));
% imwrite(uint8(wm_img), [path,'/','dwt.',int2str(i),'_',int2str(j),'.jpg']);
% ImgName = [path,'/','dwt.',int2str(i),'_',int2str(j),'.jpg'];


if times == 1
    [~, nameo, ~] = fileparts(OriImg);
	[~, namew, ~] = fileparts(WmImg);
	ImgName = [OutputDir,'/','dwt.',nameo,'.',namew,'.',int2str(times),'.jpg'];
	imwrite(uint8(wm_img), ImgName);
	% imwrite(uint8(wm_img), [OutputDir,'/','dwt-',int2str(class_ori),'-',int2str(class_wm),'-',int2str(times),'.jpg']);
else
    [~, nameo, ~] = fileparts(OriImg);
    nameo_parts = split(nameo, ".");
    ImgName = [OutputDir,'/','dwt.',nameo_parts{2},'.',nameo_parts{3},'.',int2str(times),'.jpg'];
    imwrite(uint8(wm_img), ImgName);
    % imwrite(uint8(wm_img), [OutputDir,'/','dwt-',nameo_parts(2),'-',nameo_parts(3),'-',int2str(times),'.jpg']);
    % ImgName = [OutputDir,'/','dwt-',nameo_parts(2),'-',nameo_parts(3),'-',int2str(times),'.jpg'];
end


% for Kaggle
% imwrite(uint8(wm_img), [OutputDir,'/','dwt.','cat',int2str(i),'b',int2str(j),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'/','dwt.','cat',int2str(i),'b',int2str(j),'.',int2str(times),'.jpg'];
% imwrite(uint8(wm_img), [OutputDir,'/','dwt.','dog',int2str(class_ori),'a',int2str(class_wm),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'/','dwt.','dog',int2str(class_ori),'a',int2str(class_wm),'.',int2str(times),'.jpg'];
