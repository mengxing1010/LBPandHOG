%读取训练数据
clear
clc
load iris.dat;
%f1 f2 f3 f4是四个特征值
[f1,f2,f3,f4,class] = textread('trainData.txt' , '%f%f%f%f%f',150);
%特征值归一化
[input,minI,maxI] = premnmx( [f1 , f2 , f3 , f4 ]')  ;
%构造输出矩阵
s = length( class) ;
output = zeros( s , 3  ) ;
for i = 1 : s 
   output( i , class( i )  ) = 1 ;
end

%创建神经网络
net = newff( minmax(input) , [10 3] , { 'logsig' 'purelin' } , 'traingdx' ) ; 
%{
    minmax(input)：获取4个输入信号（存储在f1 f2 f3 f4中）的最大值和最小值；
    [10,3]：表示使用2层网络，第一层网络节点数为10，第二层网络节点数为3；
    { 'logsig' 'purelin' }：
        表示每一层相应神经元的激活函数；
        即：第一层神经元的激活函数为logsig（线性函数），第二层为purelin（对数S形转移函数）
    'traingdx'：表示学习规则采用的学习方法为traingdx（梯度下降自适应学习率训练函数）
%}
%设置训练參数
net.trainparam.show = 50 ;% 显示中间结果的周期
net.trainparam.epochs = 1000 ;%最大迭代次数（学习次数）
net.trainparam.goal = 0.001 ;%神经网络训练的目标误差
net.trainParam.lr = 0.01 ;%学习速率（Learning rate）

%开始训练
%其中input为训练集的输入信号，对应output为训练集的输出结果
net = train( net, input , output' ) ;
%================================训练完成====================================%
%=============================接下来进行测试=================================%

%读取测试数据
[t1 t2 t3 t4 c] = textread('testData.txt' , '%f%f%f%f%f',150);

%測试数据归一化
testInput = tramnmx ( [t1,t2,t3,t4]' , minI, maxI ) ;
%[testInput,minI,maxI] = premnmx( [t1 , t2 , t3 , t4 ]')  ;
%仿真
%其中net为训练后得到的网络，返回的Y为
Y = sim( net , testInput ) 

%统计识别正确率
[s1 , s2] = size( Y ) ;
hitNum = 0 ;
for i = 1 : s2
    [m , Index] = max( Y( : ,  i ) ) ;
    if( Index  == c(i)   ) 
        hitNum = hitNum + 1 ; 
    end
end
sprintf('识别率是 %3.3f%%',100 * hitNum / s2 )