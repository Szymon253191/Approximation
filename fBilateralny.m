clear;
close all;
tic
% wczytanie oryginalnego obrazu
in_img = imread('kitku.bmp');
in_img = double(in_img)/255;

% Ustawanie parametrów filtru bilateralnego
w = 100; % połowa szerokości filtru 
sigma_c = 2; % standardowe odchylenie filtru 
sigma_s = 0.5; % im większa wartość tym większe rozmycie

out_img = filtr_bilateralny(in_img,w,sigma_c,sigma_s);

figure(1)
imshow(in_img,[])
figure(2)
imshow(out_img,[])
title('Po filtrze Bilateralny')

imwrite(out_img, 'kitku_po.bmp')

A = imread('kitku_po.bmp');
B = imresize(imread('kitkuOrg.bmp'), [1024 1024]);

err = immse(A, B);
disp(err);

function result = filtr_bilateralny(in_img,w,sigma_c,sigma_s);

% wstępne obliczanie Gaussoweightskich wag dla odległości 
[X, Y] = meshgrid(-w : w, -w : w);
C = exp(-(X.^2 + Y.^2)/(2 * sigma_c ^ 2));

% zmiana zakresu wariancji dla max. luminancji
sigma_s = 100 * sigma_s;

% zastosowanie filtru bilateralnego
[row, column, colour] = size(in_img);
out_img   = zeros(row, column ,colour);

for i = 1 : row
   for j = 1 : column
       % wyodrębnienie lokalnego fragmentu
       I = in_img(max(i - w, 1) : min(i + w, row), max(j - w, 1):min(j + w, column), :);

       % obliczenie weightagi intesywności Gaussa
       dL = I(:, :, 1) - in_img(i, j, 1);
       da = I(:, :, 2) - in_img(i, j, 2);
       db = I(:, :, 3) - in_img(i, j, 3);
       
       S = exp(-(dL .^2 + da .^2 + db .^2)/(2 * sigma_s ^2));
       
       % obliczanie odpowiedzi filtra bilateralnego
       F = S .* C((max(i - w, 1) : min(i + w, row)) - i + w + 1,(max(j - w, 1):min(j + w, column)) - j + w + 1);  
       out_img(i, j, 1) = sum(sum(F .* I(:, :, 1))) / sum(F(:));
       out_img(i, j, 2) = sum(sum(F .* I(:, :, 2))) / sum(F(:));
       out_img(i, j, 3) = sum(sum(F .* I(:, :, 3))) / sum(F(:));
   end
end
time = toc
result = out_img;
end