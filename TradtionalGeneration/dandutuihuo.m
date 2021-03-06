tic
N = 16; %矩阵行列数
target = round((N/2-1)*N+N/2); %聚焦点  round函数将参数中的每个元素四舍五入为最近的整数
temperature = 300;  %初始温度
alpha = 0.99;       %温度衰减系数
iter = 50;         %内部蒙特卡罗循环迭代次数
stop_t = 1;         %停止迭代温度
counter=1;
phase0 = 2*pi*rand(N);  %随机相位作为初始入射光的相位
cost = zeros(1,1000);
phase=zeros(16,16);
  
while temperature > stop_t          %外循环 （达到了最低温度则停止循环）   
    for n = 1:iter                  %内循环  （在一个温度下的循环次数）
        Ef=exp(1i*phase0);
      
        cost0 = cal_cost(Ef,N,T,target); %初始入射光得到的出射光的cost
        phase1=phase0+0.01*rand(N);    %对初始相位添加一个扰动
    
        Ef= exp(1i*phase1);
        
        cost1 = cal_cost(Ef,N,T,target); %计算添加扰动后的聚焦效果
       
        %确定是否接收新解
        delta_e = cost1 - cost0;
        phase=phase0;%初始相位值先赋值给phase
        if delta_e > 0
            phase=phase1;  %新的位置得到更好的解，因此接受新解
            phase0=phase1;
        else
            if exp(-delta_e/temperature) < rand  %否则以蒙特卡洛法则进行判断是否接受新解
                %以一定概率接收差解
                phase=phase1;
                phase0=phase1;
            end
        end
    end 
    phase0=phase;
    Ef=exp(1i*phase);
    cost(1,counter) = cal_cost(Ef,N,T,target);
    counter = counter + 1;
    temperature=alpha*temperature;%降温退火
end
cost

 figure(1);
 plot(cost);
 
Ef = reshape(Ef,N^2,1);
Eout = T*Ef;
Eout = reshape(Eout,N,N);
Eout = Eout';
Ef = reshape(Ef,N,N);
Ef = Ef';
Iin = abs(Ef).^2;
Pin = angle(Ef);
Iout = abs(Eout).^2;
Pout = angle(Eout);
AT = abs(T);
PT = angle(T);


figure(2)
subplot(2,2,1)
imshow(Iin,[])
colorbar
title('调制后入射光光强')

subplot(2,2,2)
imshow(Pin,[])
colorbar
title('调制后入射光相位')

subplot(2,2,3)
imshow(Iout,[])
colorbar
title('调制后出射光光强')

subplot(2,2,4)
imshow(Pout,[])
colorbar
title('调制后出射光相位');

toc
