function [ImgName] = WaterMark(OriImg, WmImg, QR, QG, QB, OutputDir, i, j, times)

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

wm_img = cat(3, K1, K2, K3);


% for CIFAR-10
path = fullfile(OutputDir,['times',int2str(times)],int2str(i));
imwrite(uint8(wm_img), [path,'/','dct.',int2str(i),'_',int2str(j),'.jpg']);
ImgName = [path,'/','dct.',int2str(i),'_',int2str(j),'.jpg'];

% for Kaggle
% imwrite(uint8(wm_img), [OutputDir,'dct.','cat',int2str(i),'b',int2str(j),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'dct.','cat',int2str(i),'b',int2str(j),'.',int2str(times),'.jpg'];
% imwrite(uint8(wm_img), [OutputDir,'dct.','dog',int2str(i),'a',int2str(j),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'dct.','dog',int2str(i),'a',int2str(j),'.',int2str(times),'.jpg'];
