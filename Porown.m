A = imread('kitku.bmp');
B = imread('kitkuOrg.bmp');

MSE = immse(A, B)
disp(MSE);