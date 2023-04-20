clc;clear all;close all;
bwImg=rgb2gray(imread("edge.jpg"));
I=double(bwImg);In=I;
mask1=[1, 0, -1;1, 0, -1;1, 0, -1];
mask2=[1, 1, 1;0, 0, 0;-1, -1, -1];
mask3=[0, -1, -1;1, 0, -1;1, 1, 0];
mask4=[1, 1, 0;1, 0, -1;0, -1, -1];
mask1=flipud(mask1);
mask1=fliplr(mask1);
mask2=flipud(mask2);
mask2=fliplr(mask2);
mask3=flipud(mask3);
mask3=fliplr(mask3);
mask4=flipud(mask4);
mask4=fliplr(mask4);
for i=2:size(I, 1)-1
    for j=2:size(I, 2)-1
        neighbour_matrix1=mask1.*In(i-1:i+1, j-1:j+1);
        avg_value1=sum(neighbour_matrix1(:));
  
        neighbour_matrix2=mask2.*In(i-1:i+1, j-1:j+1);
        avg_value2=sum(neighbour_matrix2(:));
  
        neighbour_matrix3=mask3.*In(i-1:i+1, j-1:j+1);
        avg_value3=sum(neighbour_matrix3(:));
  
        neighbour_matrix4=mask4.*In(i-1:i+1, j-1:j+1);
        avg_value4=sum(neighbour_matrix4(:));

        I(i, j)=max([avg_value1, avg_value2, avg_value3, avg_value4]);
  
    end
end
figure, imshow(uint8(I));
