%1��ȡԭͼ��������ɶ�ֵͼ��
I=imread('ˮ������ʵ��ͼ��.jpg');


I2=rgb2gray(I);
BW=im2bw(I2,0.9);
total=bwarea(~BW)
figure,subplot(1,3,1),imshow(I),title('ԭʼͼ��');
 subplot(1,3,2),imshow(I2),title('�Ҷ�ͼ��');
subplot(1,3,3),imshow(BW),title('��ֵͼ��');

%2���б�Ե��� �õ��˲�������ͼ�α߽�(����sobel���ӻ���������)

%3�õ�����ͼ�ε������߽�

SE=strel('rectangle',[40 30]);  % �ṹ����
J2=imopen(BW,SE);            % ��������
figure,imshow(J2),title('�Զ�ֵͼ����п������Ľ��ͼ��');

SE=strel('square',5); % ����3��3��ʴ�ṹԪ��
J=imerode(~J2,SE);
BW2=(~J2)-J;        % ����Ե
figure,imshow(BW2),title('3*3��ʴ������ͼ��߽�����');

%��������еļ���������״�߽�
B = imfill(BW2,'holes');
B = bwmorph(B,'remove');
figure,imshow(B),title('��ȡ���ı߽�ͼ��');

%3-2����ͬ��ͼ�ν��зֱ��ǣ�num��ʾ���ӵ�ͼ�ζ���ĸ���
[Label,num] = bwlabel(B,8);

%�õ�����ͼ��ı߽����ص�����




%4�������ͼ�ε�Ԫ���ܳ�   ���������ص�����߽����ص�����ķ���   numPoints�����ʾ����ͼ�α߽�����ظ��������ø�������ʾ�ܳ���
 %num = max(max(Label));

    for i = 1 : num
        Premeter(i) = 0;
    end

    [row,col] = size(Label);
    for i = 1 : row
        for j = 1 : col
            if(Label(i,j) > 0)
                Premeter(Label(i,j)) = Premeter(Label(i,j)) + 1;    %�����Ǻ�ĸ���ͼ�α߽������صĸ���������
            end
        end
    end

%5�������ͼ�ε�Ԫ�����
FilledLabel = imfill(Label,'holes');  %�������ǵı߽����м�Χ�ɵ�ͼ������
figure,imshow(FilledLabel),title('�����Ǻ��ѱ����Ľ��ͼ��');
for i = 1 : num
    Area(i) = 0;
end

[row,col] = size(FilledLabel);
for i = 1 : row
    for j = 1 : col
        if(FilledLabel(i,j) > 0)
            Area(FilledLabel(i,j)) = Area(FilledLabel(i,j)) + 1;   %ͨ��ͳ�����ص�����ķ�ʽ�������״�����
        end
    end
end

%6�������ͼ�ε�Ԫ��Բ��
for i = 1 : num     
    Ecllipseratio(i) = 4*pi*Area(i)/Premeter(i)^2;
end

%7�������ͼ�����ɫ��ɫ�ȣ�

HSV = rgb2hsv(I);   %ת��ΪHSV��Ϊ�������ɫԪ�ص���ȡ��׼��

[row,col] = size(FilledLabel);   %ͳ�������ͼ���и���ͼ���������صĸ����Ķ���
MeanHue = zeros(1,num);
    for i = 1 : num
        Hue = zeros(Area(i),1);
        nPoint = 0;
        for j = 1 : row
            for k = 1 : col
                if(FilledLabel(j,k) == i)
                    nPoint = nPoint + 1;
                    Hue(nPoint,1) = HSV(j,k,1);
                end
            end
        end
        
        Hue(:,i) = sort(Hue(:,1));
        for j = floor(nPoint*0.1) : floor(nPoint*0.9)
            MeanHue(i) = MeanHue(i) + Hue(j,1);
        end
        MeanHue(i) = MeanHue(i) / (0.8*nPoint);  %�����ƽ����ɫ��ֵ
    end


%8ʶ����

%8-1�����ҵķ��������ڶ�ά�����ռ�Ը���ͼ������������
pitch=0;
for i=1:num
    if(MeanHue(i)>0.5)    %������ʶ���ҵ�׼���жϸ���ͼ����ƽ��ɫ��ֵ����0.5��Ϊ��
        pitch=i;
    end
end
%8-2�Էֳ��������ֱ𹹽���Ӧ��ͼ����Ĥ�����ö�ԭͼ������ͼ�������Ĥ����
pitchHSV=HSV;
[row,col] = size(FilledLabel);   %ͳ�������ͼ���и���ͼ���������صĸ����Ķ���
%MeanHue = zeros(1,num);
        for j = 1 : row
            for k = 1 : col
                if(FilledLabel(j,k) ~=pitch)
                       %pitchHSV(j,k,2)=0;
                       pitchHSV(j,k,3)=0;
                end
            end
        end
%8-3�任�������յĽ��ͼ��ͼ������ʾ�Ľ������Ӧ��������ָ�������
pitchmatrix = hsv2rgb(pitchHSV);   %ת��ΪRGB��ͼ����ͼ���Ѿ���ȥ������ˮ����ֻʣ����
figure,imshow(pitchmatrix),title('ˮ�����һ������');

%9ʶ����

%9-1�������ܵķ��������ڶ�ά�����ռ�Ը���ͼ������������
pineapple=1;
mazarea=Area(1);
for i=1:num
    if(mazarea<Area(i))    %������ʶ���ҵ�׼���жϸ���ͼ�����������Ϊ����
        mazarea=Area(i);
        pineapple=i;
    end
end
%9-2�Էֳ��������ֱ𹹽���Ӧ��ͼ����Ĥ�����ö�ԭͼ������ͼ�������Ĥ����
pineappleHSV=HSV;
        for j = 1 : row
            for k = 1 : col
                if(FilledLabel(j,k) ~=pineapple)
                       %pitchHSV(j,k,2)=0;
                       pineappleHSV(j,k,3)=0;
                end
            end
        end
%9-3�任�������յĽ��ͼ��ͼ������ʾ�Ľ������Ӧ��������ָ�������
pineapplematrix = hsv2rgb(pineappleHSV);   %ת��ΪRGB��ͼ����ͼ���Ѿ���ȥ������ˮ����ֻʣ�²���
figure,imshow(pineapplematrix),title('ˮ������������');


%10ʶ���㽶

%101�����㽶�ķ��������ڶ�ά�����ռ�Ը���ͼ������������
banana=0;
for i=1:num
    if((Ecllipseratio(i)<0.5))    %������ʶ���ҵ�׼���жϸ���ͼ����ƽ��Բ��ֵС��0.5��Ϊ�㽶
        banana=i;
    end
end
%102�Էֳ��������ֱ𹹽���Ӧ��ͼ����Ĥ�����ö�ԭͼ������ͼ�������Ĥ����
bananaHSV=HSV;
        for j = 1 : row
            for k = 1 : col
                if(FilledLabel(j,k) ~=banana)
                       %pitchHSV(j,k,2)=0;
                       bananaHSV(j,k,3)=0;
                end
            end
        end
%103�任�������յĽ��ͼ��ͼ������ʾ�Ľ������Ӧ��������ָ�������
bananamatrix = hsv2rgb(bananaHSV);   %ת��ΪRGB��ͼ����ͼ���Ѿ���ȥ������ˮ����ֻʣ���㽶
figure,imshow(bananamatrix),title('ˮ����������㽶');


%11ʶ����

%11-1������ķ��������ڶ�ά�����ռ�Ը���ͼ������������
pear=0;
for i=1:num
    if(MeanHue(i)<0.125)    %������ʶ���ҵ�׼���жϸ���ͼ����ƽ��ɫ��ֵС��0.125��Ϊ��
        pear=i;
    end
end
%11-2�Էֳ��������ֱ𹹽���Ӧ��ͼ����Ĥ�����ö�ԭͼ������ͼ�������Ĥ����
pearHSV=HSV;
        for j = 1 : row
            for k = 1 : col
                if(FilledLabel(j,k) ~=pear)
                       %pitchHSV(j,k,2)=0;
                       pearHSV(j,k,3)=0;
                end
            end
        end
%11-3�任�������յĽ��ͼ��ͼ������ʾ�Ľ������Ӧ��������ָ�������
pearmatrix = hsv2rgb(pearHSV);   %ת��ΪRGB��ͼ����ͼ���Ѿ���ȥ������ˮ����ֻʣ����
figure,imshow(pearmatrix),title('ˮ������ģ���');

%12ʶ��ƻ��

%12-1����ƻ���ķ��������ڶ�ά�����ռ�Ը���ͼ������������
apple=0;
for i=1:num
    if((Ecllipseratio(i)<1.25)&(Ecllipseratio(i)>1.0))    %������ʶ���ҵ�׼���жϸ���ͼ����Բ�Ⱦ���1.0��1.25֮��ĵ�Ϊƻ��
        apple=i;
    end
end
%12-2�Էֳ��������ֱ𹹽���Ӧ��ͼ����Ĥ�����ö�ԭͼ������ͼ�������Ĥ����
appleHSV=HSV;
        for j = 1 : row
            for k = 1 : col
                if(FilledLabel(j,k) ~=apple)
                       %pitchHSV(j,k,2)=0;
                       appleHSV(j,k,3)=0;
                end
            end
        end
%12-3�任�������յĽ��ͼ��ͼ������ʾ�Ľ������Ӧ��������ָ�������
applematrix = hsv2rgb(appleHSV);   %ת��ΪRGB��ͼ����ͼ���Ѿ���ȥ������ˮ����ֻʣ��ƻ��
figure,imshow(applematrix),title('ˮ������壺ƻ��');










