function T = structure_T(m)
% 1.����˹��������������
    p = normrnd(0,0.02,m,m); %ʵ�� ���ɾ�ֵΪ0������Ϊ0.02����̬�ֲ�������������Ϊm.
    q = normrnd(0,0.02,m,m); %�鲿
    T = p+1i*q;
    T = orth(T); %������
% 2.����ֵ�ֽ�
    [U,S,V] = svd(T);
    T = T/max(max(S));
