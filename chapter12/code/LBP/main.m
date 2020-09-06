%load('F:\matlabfile\processing\chapter12\code\LBP\Mat\LBPMap.mat');
I=imread('F:\matlabfile\processing\chapter12\apples.jpg');
I=rgb2gray(I);

[hist1,I_LBP1]=getMBLBPFea(I,1);
[hist2,I_LBP2]=getMBLBPFea(I,2);
[hist3,I_LBP3]=getMBLBPFea(I,3);
figure,imshow(I_LBP1,[ ]);
figure,imshow(I_LBP2,[ ]);
figure,imshow(I_LBP3,[ ]);
figure,hist(hist1);
% figure,plot(hist2);
% figure,plot(hist3);