clc;clear all;close all;Img=imread("edge.jpg");
figure;imshow(Img);
grImg=rgb2gray(Img);
figure;imshow(grImg);
dImg=double(grImg);
filtered_image = zeros(size(dImg));
% Sobel Operator Mask
Mx = [-1 0 1; -2 0 2; -1 0 1];
My = [-1 -2 -1; 0 0 0; 1 2 1];
for i = 1:size(dImg, 1) - 2
    for j = 1:size(dImg, 2) - 2
  
        % Gradient approximations
        Gx = sum(sum(Mx.*dImg(i:i+2, j:j+2)));
        Gy = sum(sum(My.*dImg(i:i+2, j:j+2)));
                 
        % Calculate magnitude of vector
        filtered_image(i+1, j+1) = sqrt(Gx.^2 + Gy.^2);
         
    end
end
filtered_image = uint8(filtered_image);
subplot(2,2,1);imshow(filtered_image); title('Filtered Image');
thresholdValue = 100; 
output_image = max(filtered_image, thresholdValue);
output_image(output_image == round(thresholdValue)) = 0;
% Displaying Output Image
output_image = im2bw(output_image);
subplot(2,2,2) ;imshow(output_image); title('Edge Detected Image using Sobel method');
%edge detection:
edge1 = edge(dImg,'Canny');
subplot(2,2,3);imshow(edge1);title("Canny method for edge detection");
edge2 = edge(dImg,'prewitt');
subplot(2,2,4);imshow(edge2);title("Prewitt method for edge detection");