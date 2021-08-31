clear
clc

% strength (positive plus, negative minus)
alphaR = 0.04;
alphaG = 0.03;
alphaB = 0.08;


% the number of images in each class 
total_img = 50;

imgoPath = 'path_hostimage';
imgso = dir([imgoPath, '*.jpg']);
imgNameso = {imgso.name};

wmPath = 'path_watermarking';
wms = dir([wmPath, '*.jpg']);
imgNameswm = {wms.name};


for i = 1:total_img
    imgori_path = fullfile(imgoPath, imgNameso{1,i});
    
    for j = 1:10
        imgwm_path = fullfile(wmPath, imgNameswm{1,j});
        
        times = 5;  % 5:5:50

        OutputPath = fullfile('path_result', ['class', num2str(j-1)], ['times', num2str(times)]);

        [theimgname] = WaterMark(imgori_path, imgwm_path, alphaR,alphaG,alphaB, OutputPath, i-1, j-1, times);
        for n = 1:times-1
            [imgimg] = WaterMark(theimgname, imgwm_path, alphaR,alphaG,alphaB, OutputPath, i-1, j-1, times);
            theimgname = imgimg;
        end

    end
end
