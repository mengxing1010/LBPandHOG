%读取训练数据
clear
clc
%f1 f2 f3 f4是四个特征值
[f1,f2,class] = textread('trainData.txt' , '%f%f%f');
%特征值归一化
[input,minI,maxI] = premnmx( [f1 , f2 ]')  ;
%构造输出矩阵
s = length( class) ;
output = zeros( s , 2  ) ;
for i = 1 : s 
   output( i , class( i )  ) = 1 ;
end
output
%创建神经网络
net = newff( minmax(input) , [10 2] , { 'logsig' 'purelin' } , 'traingdx' ) ; 
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
[t1 t2 c] = textread('testData.txt' , '%f%f%f');

%测试数据归一化
testInput = tramnmx ( [t1,t2]' , minI, maxI ) ;
%[testInput,minI,maxI] = premnmx( [t1 , t2]')  ;
%仿真
%其中net为训练后得到的网络，返回的Y为
Y = sim( net , testInput ) 
%{
Y返回预测值，输出有两个记为A、B，理想情况下输出为上述的output，输出结果只有1和0两种
即：output =
     0     1
     0     1
     0     1
     0     1
     1     0
     1     0
     1     0
     1     0
     1     0
     1     0
---------------------------------------------------------------------------------
例：Y =
    0.1432    0.4841    1.0754    1.2807    0.8405
    0.6034    0.5329    0.1427   -0.4194    0.0947
则说明：
    对于第一个测试数据，输出结果A=0.1432，输出结果B=0.6034
    对于第一个测试数据，输出结果A=0.4841，输出结果B=0.5329
因此，对于本例：若结果A更接近于1（左接近或右接近），那么说明该测试数据属于第一个分类；
               若结果B更接近于1（左接近或右接近），那么说明该测试数据属于第二个分类。
因此，ANN除了应用于分类问题，也可应用于对具体数值的预测问题。
---------------------------------------------------------------------------------
_______________________________________________________________2018.02.06 by_LeoHao
%}
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