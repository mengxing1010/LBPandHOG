
function L=hsvquan(hsv) 
%对HSV进行量化,把3个颜色分量合成为一维特征矢量: 
I=imread('apples.jpg');
I=im2double(I);
hsv=rgb2gray(I);
h=hsv(:,:,1); 
s=hsv(:,:,2); 
v=hsv(:,:,3); 
 
% 如果对HSV 空间进行适当的量化后再计算直方图, 则计算量要少得多. 我们将H , S ,V 3个分量按照人的颜色感知进行非等间隔的量化, 从对颜色模型的大量分析, 我们把 
% 色调H 空间分成8份, 饱和度S 和亮度V 空间分别分成3份, 并根据色彩的不同范围进行量化, 量化后的色 
% 调、饱和度和亮度值分别为H , S ,V. 
h=h*360; 
H=zeros(size(hsv,1),size(hsv,2)); 
H(h>=316|h<=20)=0; 
H(h>=21&h<=40)=1; 
H(h>=41&h<=75)=2; 
H(h>=76&h<=155)=3; 
H(h>=156&h<=190)=4; 
H(h>=191&h<=270)=5; 
H(h>=271&h<=295)=6; 
H(h>=296&h<=351)=7; 
 
 
 
S=zeros(size(hsv,1),size(hsv,2)); 
S(s>=0&s<=0.2)=0; 
S(s>0.2&s<=0.7)=1; 
S(s>0.7&s<=1)=2; 
 
 
V=zeros(size(v)); 
V(v>=0&v<=0.2)=0; 
V(v>0.2&v<=0.7)=1; 
V(v>0.7&v<=1)=2; 
 
 l=9*H+3*S+V; 
 
% L=mat2gray(l); 
% histL=imhist(L,72); 
for i=0:71 
    L(i+1)=numel(l(l==i)); 
end 