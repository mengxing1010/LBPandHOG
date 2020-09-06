function LBPfeature = easy_get_feature(img)

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
%figure(1);
%imshow(imgn,[]);

%hist=cell(1,100);     %�����ĸ�������ֱ��ͼ��10*10��̫���ˣ������򵥵�
% hist{1}=imhist(img(1:floor(m/2),1:floor(n/2)));
% hist{2}=imhist(img(1:floor(m/2),floor(n/2)+1:n));
% hist{3}=imhist(img(floor(m/2)+1:m,1:floor(n/2)));
% hist{4}=imhist(img(floor(m/2)+1:m,floor(n/2)+1:n));
% for i=1:4
%    figure;
%    plot(hist{i});
% end

LBPfeature = imhist(imgn);

