function Offspring = generate(pop,cost,R,xx,yy) %������� R�Ǳ������
p_cost = cost/sum(cost);
p_cost = cumsum(p_cost); %�����������
fitin = 1;
newin = 1;
ma_cost = rand;
pa_cost = rand;
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
pain = 1;

while pain ==1
    while newin == 1
        if pa_cost <= p_cost(fitin) 
            pa = pop{1,fitin};
            newin = newin + 1;
        else
            fitin = fitin + 1;
        end
    end
    if pa == ma
        pain = 1;
        newin = 1;
        fitin = 1;
        pa_cost = rand;
    else
        pain = 0;
    end
end


%���ɺ��
T0 = rand(xx,yy);
T0(T0>=0.5) = 1;
T0(T0<0.5) = 0; %����0,1�������
Offspring = ma.*T0 + pa.*(1-T0);

% % x0 = xx/2+10;
% % y0 = yy/2-12;
% % r0 = 8;
% % [x,y]=meshgrid(1:yy,1:xx);
% % rnei = sqrt((x-x0).^2+(y-y0).^2) <= r0;
% r1 = w0;                                          %����Բ���ĵİ뾶��ռ86.5%������ 
% x1=linspace(-2*r1,2*r1,N);             
% y1=linspace(-2*r1,2*r1,N); 
% [m1,n1] = meshgrid(x1,y1);
% D = (m1.^2+n1.^2).^(1/2);                        %Բ������ϵʽ����0��0����Բ������
% q1 = find(D<=r1);                                  %ȷ��͸��Բ������
% % neihuan = double(rnei);  

% % %ѡ����ȦԲ��
% % r2 = 20;
% % rwai = sqrt((x-x0).^2+(y-y0).^2) <= r2;
% % waihuan = double(rwai);
% % yuanhuan = waihuan-neihuan;

% A = zeros(xx,yy);
% % A(1:xx/2,1:yy/2) = 1;
% for i = 1:xx
%     for j =1:yy
%         if mod(i,2)==0 && mod(j,2)==0
%             A(i,j) = 1;
%         end
%     end
% end

for i = 1:xx   %�������
    for j = 1:yy
        if rand < R
            Offspring(i,j) = 255*rand;
        end
    end
end
% Offspring = yuanhuan.*Offspring;
% Offspring = A.*Offspring;


