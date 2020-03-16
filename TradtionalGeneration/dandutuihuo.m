tic
N = 16; %����������
target = round((N/2-1)*N+N/2); %�۽���  round�����������е�ÿ��Ԫ����������Ϊ���������
temperature = 300;  %��ʼ�¶�
alpha = 0.99;       %�¶�˥��ϵ��
iter = 50;         %�ڲ����ؿ���ѭ����������
stop_t = 1;         %ֹͣ�����¶�
counter=1;
phase0 = 2*pi*rand(N);  %�����λ��Ϊ��ʼ��������λ
cost = zeros(1,1000);
phase=zeros(16,16);
  
while temperature > stop_t          %��ѭ�� ���ﵽ������¶���ֹͣѭ����   
    for n = 1:iter                  %��ѭ��  ����һ���¶��µ�ѭ��������
        Ef=exp(1i*phase0);
      
        cost0 = cal_cost(Ef,N,T,target); %��ʼ�����õ��ĳ�����cost
        phase1=phase0+0.01*rand(N);    %�Գ�ʼ��λ����һ���Ŷ�
    
        Ef= exp(1i*phase1);
        
        cost1 = cal_cost(Ef,N,T,target); %���������Ŷ���ľ۽�Ч��
       
        %ȷ���Ƿ�����½�
        delta_e = cost1 - cost0;
        phase=phase0;%��ʼ��λֵ�ȸ�ֵ��phase
        if delta_e > 0
            phase=phase1;  %�µ�λ�õõ����õĽ⣬��˽����½�
            phase0=phase1;
        else
            if exp(-delta_e/temperature) < rand  %���������ؿ��巨������ж��Ƿ�����½�
                %��һ�����ʽ��ղ��
                phase=phase1;
                phase0=phase1;
            end
        end
    end 
    phase0=phase;
    Ef=exp(1i*phase);
    cost(1,counter) = cal_cost(Ef,N,T,target);
    counter = counter + 1;
    temperature=alpha*temperature;%�����˻�
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
title('���ƺ�������ǿ')

subplot(2,2,2)
imshow(Pin,[])
colorbar
title('���ƺ��������λ')

subplot(2,2,3)
imshow(Iout,[])
colorbar
title('���ƺ������ǿ')

subplot(2,2,4)
imshow(Pout,[])
colorbar
title('���ƺ�������λ');

toc