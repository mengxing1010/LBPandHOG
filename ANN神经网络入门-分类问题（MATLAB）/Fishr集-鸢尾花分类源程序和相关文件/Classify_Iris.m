%��ȡѵ������
clear
clc
load iris.dat;
%f1 f2 f3 f4���ĸ�����ֵ
[f1,f2,f3,f4,class] = textread('trainData.txt' , '%f%f%f%f%f',150);
%����ֵ��һ��
[input,minI,maxI] = premnmx( [f1 , f2 , f3 , f4 ]')  ;
%�����������
s = length( class) ;
output = zeros( s , 3  ) ;
for i = 1 : s 
   output( i , class( i )  ) = 1 ;
end

%����������
net = newff( minmax(input) , [10 3] , { 'logsig' 'purelin' } , 'traingdx' ) ; 
%{
    minmax(input)����ȡ4�������źţ��洢��f1 f2 f3 f4�У������ֵ����Сֵ��
    [10,3]����ʾʹ��2�����磬��һ������ڵ���Ϊ10���ڶ�������ڵ���Ϊ3��
    { 'logsig' 'purelin' }��
        ��ʾÿһ����Ӧ��Ԫ�ļ������
        ������һ����Ԫ�ļ����Ϊlogsig�����Ժ��������ڶ���Ϊpurelin������S��ת�ƺ�����
    'traingdx'����ʾѧϰ������õ�ѧϰ����Ϊtraingdx���ݶ��½�����Ӧѧϰ��ѵ��������
%}
%����ѵ������
net.trainparam.show = 50 ;% ��ʾ�м���������
net.trainparam.epochs = 1000 ;%������������ѧϰ������
net.trainparam.goal = 0.001 ;%������ѵ����Ŀ�����
net.trainParam.lr = 0.01 ;%ѧϰ���ʣ�Learning rate��

%��ʼѵ��
%����inputΪѵ�����������źţ���ӦoutputΪѵ������������
net = train( net, input , output' ) ;
%================================ѵ�����====================================%
%=============================���������в���=================================%

%��ȡ��������
[t1 t2 t3 t4 c] = textread('testData.txt' , '%f%f%f%f%f',150);

%�y�����ݹ�һ��
testInput = tramnmx ( [t1,t2,t3,t4]' , minI, maxI ) ;
%[testInput,minI,maxI] = premnmx( [t1 , t2 , t3 , t4 ]')  ;
%����
%����netΪѵ����õ������磬���ص�YΪ
Y = sim( net , testInput ) 

%ͳ��ʶ����ȷ��
[s1 , s2] = size( Y ) ;
hitNum = 0 ;
for i = 1 : s2
    [m , Index] = max( Y( : ,  i ) ) ;
    if( Index  == c(i)   ) 
        hitNum = hitNum + 1 ; 
    end
end
sprintf('ʶ������ %3.3f%%',100 * hitNum / s2 )