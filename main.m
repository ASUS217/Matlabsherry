
tic
popsize = 32; %��Ⱥ��С
N = 16; %����������
G = popsize/2; %ÿ��ѭ�����ɵ��Ӵ���
pop = initpop(popsize,N); %��ʼ��Ⱥ
cost = zeros(1,popsize+G);
T = structure_T(N^2); %ɢ���崫�����
Target = round((N/2-1)*N+N/2); %�۽���  round�����������е�ÿ��Ԫ����������Ϊ���������
result = zeros(1,3000);
for i = 1:popsize %������Ӧ��
    member = pop{1,i};
    cost(1,i) = cal_cost(member,N,T,Target);
end

[pop,cost] = paixu(pop,cost,popsize); %������Ӧ������

%���죬R0�ǳ�ʼ������ʣ�Rend�����ձ�����ʣ�lamda��˥������
R0 = 0.03;
Rend = 0.0025;
lamda = 200;
m = 1;   %ѭ������
R = R0;
while m < 3000
    m
    for i = 1:G
        Offspring = generate(pop,cost,N,R); %�������
        cost_Offspring = cal_cost(Offspring,N,T,Target); %��������Ӧ��
        [pop,cost] = Add_Offspring(pop,cost,Offspring,cost_Offspring,popsize+i); %�����������Ⱥ
    end
    [pop,cost] = paixu(pop,cost,popsize+G);
    pop = pop(1,1:popsize);
    cost = cost(1,1:popsize);
    R = (R0-Rend)*exp(-m/lamda)+Rend;
    result(1,m) = cost(1,1);
    m = m + 1;
    if all(~(diff(cost)))
        pop(popsize/2+1:popsize) = initpop(popsize/2,N);
        for i = 1:popsize/2
            member = pop{1,popsize/2+i};
            cost(1,popsize/2+i) = cal_cost(member,N,T,Target);
        end
        [pop,cost] = paixu(pop,cost,popsize);
    end
end
toc

cost
Ein = reshape(pop{1,1},N^2,1);
Eout = T*Ein;
Eout = reshape(Eout,N,N);
Eout = Eout';
Ein = reshape(Ein,N,N);
Ein = Ein';
Iin = abs(Ein).^2;
Pin = angle(Ein);
Iout = abs(Eout).^2;
Pout = angle(Eout);
AT = abs(T);
PT = angle(T);


figure(1)
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

figure(2)
plot(result);