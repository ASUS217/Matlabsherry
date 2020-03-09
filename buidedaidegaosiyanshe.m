%��˹����

%---------------Բ���Ľ��Ŵ��㷨----------------
%                 ���ɸ�˹����
%             ��˹���������������
%
%
clear;
N =  512;                 %�����˹���������ά�ȴ�С
w0 = 0.1;                 %��˹���������뾶,��λΪ��cm��

L = 4*w0;                 %������ת��Ϊʵ�ʵĴ�С����λΪ��cm��
lambda = 6.71e-5;       %��������λΪ��cm��
k = 2*pi/lambda;        %��ʸ
z = 10;                 %�ռ���������͸��֮��Ĵ������룬��λΪ��cm��
z1 = 15;                %͸��֮��Ĵ�����ɢ����ľ��룬��λΪ��cm��
z2 = 5;                 %ɢ��������Ĺⳡ�������۲���ľ��룬��λΪ��cm��
dx = L/(N-1);               %�������
f =20;                  %͸�����࣬��λΪ��cm��
% T = structure_T(N^2);
phase = ones(N);


A = (-L/2:L/(N-1):L/2);
B = ones(length(A),1)*A;
C = A'*ones(1,length(A));
Gau = exp((-(B.^2+C.^2))/(w0^2)); %������˹����
Gau1 = (1/sum(sum(Gau)))*Gau;     %��˹������ǿ��һ��
Gau1 = Gau1.*exp(1i*phase);

delta_u = 1/(N*dx);
delta_v = 1/(N*dx);      


% D = (1:1:N);
% E = ones(length(D),1)*D;
% F = D'*ones(1,length(D));
% Kx = (2*pi*(F-1))/(N*dx)-((2*pi*(N))/(N*dx))/2;
% Ky = (2*pi*(E-1))/(N*dx)-((2*pi*(N))/(N*dx))/2;
% H = exp(1i/(2*k)*z*(Kx.^2+Ky.^2));                   %�ռ���������͸���Ĵ��ݺ���
% Htoujing = exp(1i/(2*k)*z1*(Kx.^2+Ky.^2));           %͸����ɢ����Ĵ��ݺ���
% Hsansheti = exp(1i/(2*k)*z2*(Kx.^2+Ky.^2));          %ɢ���嵽�۲���Ĵ��ݺ���
% 
% 
% FGau = fftshift(fft2(Gau1));
% Gauout = FGau.*H;                                %��˹��������һ�ξ���֮��Ĺⳡ


%�����Ǹ�˹��������һ�ξ���֮�󣬾���͸����ɢ������ٴ���һ�ξ��뵽CCD����Ĺ���      
cycle = zeros(N,N);        
% T = structure_T(N);      
r = 2.5*w0;                                           %͸���İ뾶 
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
   
T = ones(N,N);
% U1 = reshape(U1,1,N^2);
% Z = U1*T;
% Z = reshape(Z,N,N);
Z = U1.*T;
H1 = exp(1i*k*z2)*exp(-1i*lambda*pi*z2*(((F-N/2)*delta_u).^2+((E-N/2)*delta_v).^2));%���㴫�ݺ���
U2 = ifft2(fftshift(H1).*fft2(Z)*dx*dx)*delta_u*delta_v*N*N; 

% % Toujing = Gauout.*(cycle.*exp(-1i*k.*(C.^2+B.^2)./(2*f))); %͸���Ķ������ʣ���͸���Ĺ�ͫ��������͸����͸���ʺ���   
% % Tout = fftshift(fft2(Toujing));
% % Tout1 = Tout.*Htoujing;                                    % ͸�������Ĺⳡ
% % Tout = ifft2(fftshift(Htoujing).*fft2(Toujing)*dx*dx)*(1/(N*dx))^2*N*N;
% 
% % Tout = ifft2(fftshift(Htoujing).*fft2(Toujing));             % ��͸�������Ĺⳡ
% 
% Tout = ifft2(fftshift(fft2(Toujing)).*Htoujing);
% 
% 
% Tout1 = reshape(Tout,1,N^2);
% Z = Tout1*T;                                                 % ͸�����䵽ɢ���壬ɢ��������Ĺⳡ
% Z1 = reshape(Z,N,N);
% % Zout = ifft2(fftshift(Hsansheti).*fft2(Z));                  % ����ɢ���崫�����۲���Ĺⳡ
% Zout = ifft2(fftshift(fft2(Z1)).*Hsansheti);

% w1 = abs(Gauout)^2;
% w2 = abs(Tout)^2;
% w3 = abs(Zout)^2;

subplot(2,3,1),
I = abs(U0)^2;                                              %���յ��۲����ϵĹ�ǿ

% x = 1:1:N;
% y = 1:1:N;
% x = (x-1)*dx;
% y = (y-1)*dx;
% mesh(x,y,I) %�������չⳡ����ά����ͼ

% plot(I)
imagesc(I)
colormap('jet') %�������չⳡ�Ĳ�ͼ����ɫ��ʽΪjet
colorbar

subplot(2,3,2),
I1 = abs(U1)^2;
imagesc(I1)
colormap('jet') %�������չⳡ�Ĳ�ͼ����ɫ��ʽΪjet
colorbar


subplot(2,3,3),
I2 = abs(U2)^2;
imagesc(I2)
colormap('jet') %�������չⳡ�Ĳ�ͼ����ɫ��ʽΪjet
colorbar

% subplot(3,3,4),
% I3 = abs(Tout)^2;
% imagesc(I3)
% colormap('jet') %�������չⳡ�Ĳ�ͼ����ɫ��ʽΪjet
% colorbar

subplot(2,3,4)
mesh(I)

subplot(2,3,5)
mesh(I1)

subplot(2,3,6)
mesh(I2)

% subplot(3,3,8)
% mesh(I3)



   
        
        
        
