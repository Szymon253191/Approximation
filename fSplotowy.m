
clear;
tic
% wczytanie oryginalnego obrazu
Y = imread('kitku.bmp');

% pobranie wymiarów obrazu
[W, H, O] = size(Y);

% kształty filtrów
totem = @(x) (abs(x) < 1/2);
tipi  = @(x) (abs(x) < 1) .* (1 - abs(x));

FXY = totem(linspace(-1, 1, 5)' * linspace(-1, 1, 5));
% FXY = tipi(linspace(-1, 1, 5)' * linspace(-1, 1, 5));

FXX = FXY/sum(FXY(:));
A = sum(FXY(:));
Z = imfilter(Y, FXX,'replicate');
time = toc
figure(1)
imshow(Y);
title('Obraz zaszumiony')
figure(2)
imshow(Z);
title('Po filtrze splotowym trójkątna funkcja jądra')

imwrite(Z, 'kitku_po.bmp')

A = imread('kitku_po.bmp');
B = imread('kitkuOrg.bmp');

err = immse(A, B);
disp(err);