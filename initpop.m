function pop = initpop(popsize,N)
%��ʼ��Ⱥ
pop = cell(1,popsize);
for i = 1 : popsize
    phase = 2*pi*rand(N);  %�����λ
    pop{1,i} = exp(1i*phase);
end
