function [ImgName] = WaterMark(OriImg, WmImg, QR, QG, QB)

RGB_o = imread(OriImg);
RGB = zeros(300, 300, 3);
RGBr = RGB_o(:, :, 1);
RGBg = RGB_o(:, :, 2);
RGBb = RGB_o(:, :, 3);
RGBr = imresize(RGBr, [300,300]);
RGBg = imresize(RGBg, [300,300]);
RGBb = imresize(RGBb, [300,300]);
RGB(:, :, 1) = RGBr;
RGB(:, :, 2) = RGBg;
RGB(:, :, 3) = RGBb;

WM_o = imread(WmImg);
WM = zeros(300, 300, 3);
WMr = WM_o(:, :, 1);
WMg = WM_o(:, :, 2);
WMb = WM_o(:, :, 3);
WMr = imresize(WMr, [300,300]);
WMg = imresize(WMg, [300,300]);
WMb = imresize(WMb, [300,300]);
WM(:, :, 1) = WMr;
WM(:, :, 2) = WMg;
WM(:, :, 3) = WMb;

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
imwrite(uint8(wm_img), 'catdog.jpg','jpg');
ImgName = 'catdog.jpg';
