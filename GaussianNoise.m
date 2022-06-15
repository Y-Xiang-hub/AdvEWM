I = imread('a.jpg');

subplot(1,3,1);
imshow(I);
title('Original Image');

IR = I(:, :, 1);
IG = I(:, :, 2);
IB = I(:, :, 3);
NR = imnoise(IR, 'gaussian', 0, 0.02);
NG = imnoise(IG, 'gaussian', 0, 0.02);
NB = imnoise(IB, 'gaussian', 0, 0.02);
N = cat(3,NR,NG,NB);
subplot(1,3,2);
imshow(N);
title('Noised Image');

imwrite(N,'a1.jpg');