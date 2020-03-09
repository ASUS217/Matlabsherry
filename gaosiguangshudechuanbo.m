
%---------------Բ���Ľ��Ŵ��㷨----------------
%                 ���ɸ�˹����
%             ��˹���������������
%
function  yanshetu = gaosiguangshudechuanbo(member,N,T,w0)
L = 4*w0;               %������ת��Ϊʵ�ʵĴ�С����λΪ��cm��
lambda = 6.71e-5;       %��������λΪ��cm��
k = 2*pi/lambda;        %��ʸ
z = 10;                 %�ռ���������͸��֮��Ĵ������룬��λΪ��cm��
z1 = 15;                %͸��֮��Ĵ�����ɢ����ľ��룬��λΪ��cm��
z2 = 5;                 %ɢ��������Ĺⳡ�������۲���ľ��룬��λΪ��cm��
dx = L/(N-1);               %�������
f =20;                  %͸�����࣬��λΪ��cm��

A = (-L/2:L/(N-1):L/2);
B = ones(length(A),1)*A;
C = A'*ones(1,length(A));
Gau = exp((-(B.^2+C.^2))/(w0^2)); %������˹����
Gau0 = (1/sum(sum(Gau)))*Gau;     %��˹������ǿ��һ��
Gau1 = Gau0.*member;              %�����λ֮��ĸ�˹����

delta_u = 1/(N*dx);
delta_v = 1/(N*dx);      

%�����Ǹ�˹��������һ�ξ���֮�󣬾���͸����ɢ������ٴ���һ�ξ��뵽CCD����Ĺ���      
cycle = zeros(N,N);              
r = 2*w0;                                           %͸���İ뾶 
x1=linspace(-r,r,N);             
y1=linspace(-r,r,N); 
[m1,n1] = meshgrid(x1,y1);
D = (m1.^2+n1.^2).^(1/2);                        %Բ������ϵʽ����0��0����Բ������
q = find(D<=r);                                  %ȷ��͸��Բ������
cycle(q) = 1;     

toujing = cycle.*exp(-1i*k.*(C.^2+B.^2)./(2*f));%����͸���Ķ�������


D = [1:1:N];
E = ones(length(D),1)*D;
F = D'*ones(1,length(D));
H = exp(1i*k*z)*exp(-1i*lambda*pi*z*(((F-N/2)*delta_u).^2+((E-N/2)*delta_v).^2));%��˹��������Ĵ��ݺ���

H0 = exp(1i*k*z1)*exp(-1i*lambda*pi*z1*(((F-N/2)*delta_u).^2+((E-N/2)*delta_v).^2));  %�����SLM��͸���Ĵ��ݺ���
U0 = ifft2(fftshift(H).*fft2(Gau1)*dx*dx)*delta_u*delta_v*N*N;            %����͸��ǰ����Ĺⳡ

U0 = U0.*toujing;%͸�������Ĺⳡ
U1 = ifft2(fftshift(H0).*fft2(U0)*dx*dx)*delta_u*delta_v*N*N;%͸�������Ĺⳡ����15cm
   

U1 = reshape(U1,1,N^2);
Z = U1*T;
Z = reshape(Z,N,N);
H1 = exp(1i*k*z2)*exp(-1i*lambda*pi*z2*(((F-N/2)*delta_u).^2+((E-N/2)*delta_v).^2));%���㴫�ݺ���
U2 = ifft2(fftshift(H1).*fft2(Z)*dx*dx)*delta_u*delta_v*N*N; 


yanshetu = abs(power(U2,2));
