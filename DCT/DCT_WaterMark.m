function [ImgName] = DCT_WaterMark(OriImg, WmImg, QR, QG, QB, class_ori, class_wm, times, OutputDir)

RGB = imread(OriImg);
WM = imread(WmImg);

N1 = dct2(RGB(:, :, 1));
I1 = WM(:, :, 1);
M1 = dct2(I1);
J1 = M1;
N1 = N1 + QR * J1;
K1 = idct2(N1);

N2 = dct2(RGB(:, :, 2));
I2 = WM(:, :, 2);
M2 = dct2(I2);
J2 = M2;
N2 = N2 + QG * J2;
K2 = idct2(N2);

N3 = dct2(RGB(:, :, 3));
I3 = WM(:, :, 3);
M3 = dct2(I3);
J3 = M3;
N3 = N3 + QB * J3;
K3 = idct2(N3);

% output
wm_img = cat(3, K1, K2, K3);


% for CIFAR-10
if times == 1
    [~, nameo, ~] = fileparts(OriImg);
	[~, namew, ~] = fileparts(WmImg);
	ImgName = [OutputDir,'/','dct.',nameo,'.',namew,'.',num2str(times),'.jpg'];
	imwrite(uint8(wm_img), ImgName);
	% imwrite(uint8(wm_img), [OutputDir,'/','dwt-',int2str(class_ori),'-',int2str(class_wm),'-',int2str(times),'.jpg']);
else
    [~, nameo, ~] = fileparts(OriImg);
    nameo_parts = split(nameo, ".");
	ImgName = [OutputDir,'/','dct.',nameo_parts{2},'.',nameo_parts{3},'.',num2str(times),'.jpg'];
    imwrite(uint8(wm_img), ImgName);
    % imwrite(uint8(wm_img), [OutputDir,'/','dwt-',nameo_parts(2),'-',nameo_parts(3),'-',int2str(times),'.jpg']);
    % ImgName = [OutputDir,'/','dwt-',nameo_parts(2),'-',nameo_parts(3),'-',int2str(times),'.jpg'];
end


% for Kaggle
% imwrite(uint8(wm_img), [OutputDir,'dct.','cat',int2str(class_ori),'b',int2str(class_wm),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'dct.','cat',int2str(class_ori),'b',int2str(class_wm),'.',int2str(times),'.jpg'];
% imwrite(uint8(wm_img), [OutputDir,'dct.','dog',int2str(class_ori),'a',int2str(class_wm),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'dct.','dog',int2str(class_ori),'a',int2str(class_wm),'.',int2str(times),'.jpg'];
