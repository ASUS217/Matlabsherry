function cost = cal_cost(member,N,T,target)
%������Ӧ��
Ein = reshape(member,N^2,1);
Eout = T*Ein;
cost = abs(Eout(target))^2;