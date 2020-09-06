% main 
% The main function just using to obtain the MBLBP image
% Hunan University
% Edit 25.01.2013
% if you find anything wrong,just not hesitate to email me
% hudalikm@163.com
% look for the paper:"Learning Multi-scale Block Local Binary Patterns for
% Face Recognition" for details.
img=imread('apples.jpg');
scales=5;
MBLBPimg=MBLBP(img,scales);
imshow(MBLBPimg,[])