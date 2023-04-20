
I = imread('name.png');


I = im2gray(I);

figure;
imshow(I)
results = ocr(I);

results.Text


