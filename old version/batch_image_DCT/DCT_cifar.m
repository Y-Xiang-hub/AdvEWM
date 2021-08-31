clear
clc

% strength (positive plus, negative minus)
QR = 0.040;
QG = 0.010;
QB = 0.080;

for i = 0:9
    % the number of images in each class
    total_img = 200;
    
    wmPath = fullfile('main_folder', [num2str(i),'watermarking_folder']);
    wms = dir([wmPath, '/', '*.jpg']);
    imgNameswm = {wms.name};
    
    imgoPath = fullfile('main_folder', num2str(i));
    imgso = dir([imgoPath, '/', '*.jpg']);
    imgNameso = {imgso.name};
    
    OutputPath = 'path_result';
    
    for j = 1:total_img
        imgori_path = fullfile(imgoPath, imgNameso{1,j});
        imgwm_path = fullfile(wmPath, imgNameswm{1,j});
        
        times = 10;  % 1:1:10
        [theimgname] = WaterMark(imgori_path, imgwm_path, QR, QG, QB, OutputPath, i, j, times);
        for n = 1:times-1
            [imgimg] = WaterMark(theimgname, imgwm_path, QR, QG, QB, OutputPath, i, j, times);
            theimgname = imgimg;
        end

    end
end
