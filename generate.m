function Offspring = generate(pop,cost,N,R) %������� R�Ǳ������
p_cost = cost/sum(cost);
p_cost = cumsum(p_cost); %�����������
fitin = 1;
newin = 1;
ma_cost = rand;
pa_cost = rand;
ma = zeros(N);
pa = zeros(N);
while newin == 1 %ѡ��ĸ
    if ma_cost <= p_cost(fitin)
        ma = pop{1,fitin};
        newin = newin + 1;
    else
        fitin = fitin + 1;
    end
end

newin = 1;
fitin = 1;
% pain = 1;
% 
% while pain ==1
    while newin == 1
        if pa_cost <= p_cost(fitin) 
            pa = pop{1,fitin};
            newin = newin + 1;
        else
            fitin = fitin + 1;
        end
    end
%     if pa == ma
%         pain = 1;
%         newin = 1;
%         fitin = 1;
%         pa_cost = rand;
%     else
%         pain = 0;
%     end
% end


%���ɺ��
T0 = rand(N,N);
T0(T0>=0.5) = 1;
T0(T0<0.5) = 0; %����0,1�������
Offspring = ma.*T0 + pa.*(1-T0);

for i = 1:N   %�������
    for j = 1:N
        if rand < R
            Offspring(i,j) = exp(1i*(-pi+pi*rand));
        end
    end
end



