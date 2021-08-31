% @Time     : 1 June, 2020
% @Author   : Tiantian Li and Yuexin Xiang
% @Email    : ltt@cug.edu.cn or yuexin.xiang@cug.edu.cn


% input
function [ImgName] = WaterMark(OriImg,WmImg,AlphaR,AlphaG,AlphaB, OutputDir, i, j, times)

% RGB separation of the original image
[IR,IG,IB] = RGBseparate(OriImg);
% original image R component three-level DWT transformation
XR = imresize(IR,[512,512]);
[cA1r,cH1r,cV1r,cD1r,cA2r,cH2r,cV2r,cD2r,cA3r,cH3r,cV3r,cD3r] = nDWT(XR,3);
% original image G component three-level DWT transformation
XG = imresize(IG,[512,512]);
[cA1g,cH1g,cV1g,cD1g,cA2g,cH2g,cV2g,cD2g,cA3g,cH3g,cV3g,cD3g] = nDWT(XG,3);
% original image B component three-level DWT transformation
XB = imresize(IB,[512,512]);         
[cA1b,cH1b,cV1b,cD1b,cA2b,cH2b,cV2b,cD2b,cA3b,cH3b,cV3b,cD3b] = nDWT(XB,3);

% RGB separation of the watermarking image
[WIR,WIG,WIB] = RGBseparate(WmImg);
% watermarking image R component three-level DWT transformation
WXR = imresize(WIR,[128,128]);
[WcAr,WcHr,WcVr,WcDr] = nDWT(WXR,1);
% watermarking image G component three-level DWT transformation
WXG = imresize(WIG,[128,128]);
[WcAg,WcHg,WcVg,WcDg] = nDWT(WXG,1);
% watermarking image B component three-level DWT transformation
WXB = imresize(WIB,[128,128]);
[WcAb,WcHb,WcVb,WcDb] = nDWT(WXB,1);

% the watermarking embeds in the low-frequency, mid-frequency, 
% and high-frequency components of the R component of the original 
% image in the third level
cA3r = cA3r+AlphaR*WcAr;
cH3r = cH3r-AlphaR*WcAr;
cV3r = cV3r-AlphaR*WcAr;
cD3r = cD3r-AlphaR*WcAr;
% inverse DWT transformation of the R component in three levels
YRca2 = idwt2(cA3r,cH3r,cV3r,cD3r,'haar');
YRca1 = idwt2(YRca2,cH2r,cV2r,cD2r,'haar');
YR = idwt2(YRca1,cH1r,cV1r,cD1r,'haar');

% the watermarking embeds in the low-frequency, mid-frequency, 
% and high-frequency components of the G component of the original 
% image in the third level
cA3g = cA3g-AlphaG*WcAg;
cH3g = cH3g+AlphaG*WcAg;
cV3g = cV3g+AlphaG*WcAg;
cD3g = cD3g+AlphaG*WcAg;
% inverse DWT transformation of the G component in three levels
YGca2 = idwt2(cA3g,cH3g,cV3g,cD3g,'haar');
YGca1 = idwt2(YGca2,cH2g,cV2g,cD2g,'haar');
YG = idwt2(YGca1,cH1g,cV1g,cD1g,'haar');

% the watermarking embeds in the low-frequency, mid-frequency, 
% and high-frequency components of the B component of the original 
% image in the third level
cA3b = cA3b+AlphaB*WcAb;
cH3b = cH3b-AlphaB*WcAb;
cV3b = cV3b-AlphaB*WcAb;
cD3b = cD3b-AlphaB*WcAb;
% inverse DWT transformation of the B component in three levels
YBca2 = idwt2(cA3b,cH3b,cV3b,cD3b,'haar');
YBca1 = idwt2(YBca2,cH2b,cV2b,cD2b,'haar');
YB = idwt2(YBca1,cH1b,cV1b,cD1b,'haar');

% output
wm_img = cat(3,YR,YG,YB);

% for CIFAR-10
% path = fullfile(OutputDir,['times',int2str(times)],int2str(i));
% imwrite(uint8(wm_img), [path,'/','dwt.',int2str(i),'_',int2str(j),'.jpg']);
% ImgName = [path,'/','dwt.',int2str(i),'_',int2str(j),'.jpg'];

% for Kaggle
% imwrite(uint8(wm_img), [OutputDir,'/','dwt.','cat',int2str(i),'b',int2str(j),'.',int2str(times),'.jpg']);
% ImgName = [OutputDir,'/','dwt.','cat',int2str(i),'b',int2str(j),'.',int2str(times),'.jpg'];
imwrite(uint8(wm_img), [OutputDir,'/','dwt.','dog',int2str(i),'a',int2str(j),'.',int2str(times),'.jpg']);
ImgName = [OutputDir,'/','dwt.','dog',int2str(i),'a',int2str(j),'.',int2str(times),'.jpg'];
