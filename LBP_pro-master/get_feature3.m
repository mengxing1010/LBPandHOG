function CLBPfeature = get_feature3(img)


if length(size(img))==3
    [m, n, z]=size(img);
else
    [m, n] = size(img);
end

imgS=zeros(m,n);
imgM=zeros(m,n);
imgC=zeros(m,n);

CI = mean(img(:));

check = 0;
count = 0;
for i=2:m-1
   for j=2:n-2 
        if img(i,j) > CI
                    
             imgC(i,j) = 1;
                   
        end
                
       pow=0;
        for p=i-1:i+1
            for q =j-1:j+1
                %np = abs(img(p,q)-img(i,j));
                check = check + abs(double(img(p,q))-double(img(i,j)));
                count = count+1;
                
                if img(p,q) >= img(i,j)
                    if p~=i && q~=j         %�е�����������3*3��˳ʱ����룬�ҾͰ�����˳������ˡ�
                                            %����������������ɶ�ģ�ֻҪ����ͬ��������ˡ�
                      imgS(i,j)=imgS(i,j)+2^pow;
                      pow=pow+1;
                                           
                    end
                end
                
                
            end
        end
            
   end
end

MeanC = check/count;

for i=2:m-1
   for j=2:n-2 
        
       pow=0;
        for p=i-1:i+1
            for q =j-1:j+1
                np = abs(double(img(p,q))-double(img(i,j)));
                
                if np >= MeanC
                    if p~=i || q~=j         %�е�����������3*3��˳ʱ����룬�ҾͰ�����˳������ˡ�
                                            %����������������ɶ�ģ�ֻҪ����ͬ��������ˡ�
                      imgM(i,j)=imgM(i,j)+2^pow;
                      pow=pow+1;
                    end
                end
            end
        end
            
   end
end


Sfeature = imhist(imgS);
Mfeature = imhist(imgM);
Cfeature = imhist(imgC);

CLBPfeature = [Sfeature;Mfeature;Cfeature];