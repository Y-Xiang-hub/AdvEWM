% strength (positive plus, negative minus)
QR = 0.040;
QG = 0.010;
QB = 0.080;

imgori = 'cat.jpg';
imgwm = 'dog.jpg';

[theimgname] = WaterMark(imgori, imgwm, QR, QG, QB);
for n = 1:10
    [imgimg] = WaterMark(theimgname, imgwm, QR, QG, QB);
    theimgname = imgimg;
end

% output
subplot(1,1,1),imshow(theimgname),title('Image after embedding watermarkingñ');
