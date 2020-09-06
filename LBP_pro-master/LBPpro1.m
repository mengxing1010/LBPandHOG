%This procedure works for LBP

clear all;
close all;
clc;

img=imread('36.png');

figure(1);
imshow(img);

if length(size(img))==3
    [m, n, z]=size(img);
else
    [m, n] = size(img);
end

imgn=zeros(m,n);
for i=2:m-1
   for j=2:n-2 
        
       pow=0;
        for p=i-1:i+1
            for q =j-1:j+1
                if img(p,q) > img(i,j)
                    if p~=i || q~=j         %�е�����������3*3��˳ʱ����룬�ҾͰ�����˳������ˡ�
                                            %����������������ɶ�ģ�ֻҪ����ͬ��������ˡ�
                      imgn(i,j)=imgn(i,j)+2^pow;
                      pow=pow+1;
                    end
                end
            end
        end
            
   end
end
figure(2);
imshow(imgn,[]);

hist=cell(1,100);     %�����ĸ�������ֱ��ͼ��10*10��̫���ˣ������򵥵�
hist{1}=imhist(img(1:floor(m/2),1:floor(n/2)));
hist{2}=imhist(img(1:floor(m/2),floor(n/2)+1:n));
hist{3}=imhist(img(floor(m/2)+1:m,1:floor(n/2)));
hist{4}=imhist(img(floor(m/2)+1:m,floor(n/2)+1:n));
for i=1:4
   figure;
   plot(hist{i});
end
flag1=0;flag2=0;
for i=1:10
    flag2=0;
    for j=1:10
    hist{(i-1)*10+j}=imhist(img(flag1+1:floor(m/10)+flag1,flag2+1:floor(n/10)+flag2));
    
    flag2=flag2+floor(n/10);
    end
    flag1=flag1+floor(m/10);
end

LBPfeature=hist{1};
for i=2:100
    LBPfeature=[LBPfeature,hist{i}];
end

%������άPCA

[COEFF,SCORE,latent]=princomp(LBPfeature');

ratio=cumsum(latent)./sum(latent);