% clear 
% clc 
tic
% load ('C:\Users\xjtu\Desktop\waihuanxiangwei','waihuanxianwgei')

% NN = 30;          %��30�����غϲ�����
% xx = 1200/NN;
% yy = 1920/NN;

%���⻷��ϸ�̶Ȳ�һ��

xx = 1;
yy = 2628;
Ein0 = zeros(xx,yy);


k = 1000;%ѭ������
ScreenNum = 2; %�ռ���������Ļ���
cam = 1; %ccd���
Screen('Preference', 'SkipSyncTests', 1);
b = 4;
popsize = 32;   %��Ⱥ��С
G = popsize/2;  %ÿ��ѭ�����ɵ��Ӵ���
result = zeros(1,k);
time = zeros(1,k);
% Ein0 = zeros(xx,yy);%�ϲ������λ���ƴ�С
% Ein = zeros(1200,1920);
% Ein = zeros(1200,1200);
% bg = zeros(1,100);
% bg0 = zeros(1,100);
cost = zeros(1,popsize+G);
[w,wRect] = Screen('OpenWindow',ScreenNum); %����Ļ

LucamCameraOpen(cam);%��ccd
LucamShowPreview(cam);
LucamSetExposure(20,cam);
LucamSetGain(1,cam);

% GratingIndex=Screen('MakeTexture',w,Ein0);
% GRect=Screen('Rect',GratingIndex);
% cGRect=CenterRect(GRect,wRect);
% Screen('DrawTexture',w,GratingIndex,cGRect,wRect);
% Screen(w,'Flip');   
% pause(0.3);

bg0 = zeros(1,100);
for i = 1:100
    Eout00 = rgb2gray(LucamCaptureFrame(cam)); %�ɼ�ccdһ֡ͼ��
    Eout00 = Eout00(1:1040,101:1355);
    bg0(1,i) = sum(sum(Eout00))/(1040*1355);
    bg0(1,i)
    i
end
i00 = sum(bg0)/100;


% Ein = zeros(1200,1920);
% x0 = 960;
% y0 = 600;
% [x,y]=meshgrid(1:1920,1:1200);
% r0 = 600;
% j = 1;
% for i = 250:600
%      ri = sqrt((x-x0).^2+(y-y0).^2) <= r0; %��������С 10�����ǰ뾶
%      Ein(ri)= j;
%      r0 = r0-10;
%      j = j+1;
%      if r0 == 250
%          break;
%      end
% end 

% % Eout0 = rgb2gray(LucamCaptureFrame(cam)); %�ɼ�ccdһ֡ͼ��
% ita0 = cal_cost(Ein0,b,w,wRect,cam);
% % ita02 = sum(sum(Eout0((1040/2+200-b):(1040/2+200+b),(1392/2-300-b):(1392/2-300+b))))/(2*b+1)^2;
% % ita0 = ita01*ita02;
% result(1,1) = ita0;
% ita0
% % i0
% pause(0.3);

pop = initpop(popsize,xx,yy); %��ʼ��Ⱥ
for i = 1:popsize %������Ӧ��
    cost(1,i) = cal_cost(pop{1,i},b,w,wRect,cam);
end

while all(~(diff(cost)))
    pop = initpop(popsize,xx,yy);
    for i = 1:popsize %������Ӧ��
        cost(1,i) = cal_cost(pop{1,i},b,w,wRect,cam);
    end
    fprintf('error');
end

[pop,cost] = paixu(pop,cost,popsize); %������Ӧ������

%���죬R0�ǳ�ʼ������ʣ�Rend�����ձ�����ʣ�lamda��˥������
R0 = 0.03;
Rend = 0.0025;
lamda = 200;
m = 1;   %ѭ������
R = R0;

while m < k
    t = cputime;
    m
    if mod(m,300)==0
        Screen('CloseAll');
        [w,wRect] = Screen('OpenWindow',ScreenNum);
        for i = 1:popsize %������Ӧ��
            cost(1,i) = cal_cost(pop{1,i},b,w,wRect,cam);
        end
    end
    
    
    if m > 100
        if all(~(diff(result(1,m-100:m))))
            pop(popsize/2+1:popsize) = initpop(popsize/2,xx,yy);
            for i = 1:popsize/2
                cost(1,popsize/2+i) = cal_cost(pop{1,popsize/2+i},b,w,wRect,cam);
            end
            [pop,cost] = paixu(pop,cost,popsize);
        end
    end
    
    if all(~(diff(cost)))
        pop(popsize/2+1:popsize) = initpop(popsize/2,xx,yy);
        for i = 1:popsize/2
            cost(1,popsize/2+i) = cal_cost(pop{1,popsize/2+i},b,w,wRect,cam);
        end
        [pop,cost] = paixu(pop,cost,popsize);
    end 
    
    
    
    for i = 1:G
        Offspring = generate(pop,cost,R,xx,yy); %�������
        cost_Offspring = cal_cost(Offspring,b,w,wRect,cam); %��������Ӧ��
        [pop,cost] = Add_Offspring(pop,cost,Offspring,cost_Offspring,popsize+i); %�����������Ⱥ
    end
    
    [pop,cost] = paixu(pop,cost,popsize+G);
    pop = pop(1,1:popsize);
    cost = cost(1,1:popsize);
    R = (R0-Rend)*exp(-m/lamda)+Rend;
    result(1,m) = cost(1,1);
    m = m + 1;
    figure(1)
    plot(result/i00);
    cost(1,1)
    time(1,m) = cputime - t;
    figure(2)
    plot(time)
    
end

% for j = 1:xx %��32*18�ľ�����չ��1920*1080
%     for p = 1:yy
%         Ein(NN*(j-1)+1:NN*j,NN*(p-1)+1:NN*p) = pop{1,1}(j,p)*ones(NN);
%     end
% end

Ein = cal_final(pop{1,1});


GratingIndex=Screen('MakeTexture',w,Ein);
GRect=Screen('Rect',GratingIndex);
cGRect=CenterRect(GRect,wRect);
Screen('DrawTexture',w,GratingIndex,cGRect,wRect);
Screen(w,'Flip');   
pause(0.3);
Eout = rgb2gray(LucamCaptureFrame(cam)); %�ɼ�ccdһ֡ͼ��


GratingIndex=Screen('MakeTexture',w,Ein0);
GRect=Screen('Rect',GratingIndex);
cGRect=CenterRect(GRect,wRect);
Screen('DrawTexture',w,GratingIndex,cGRect,wRect);
Screen(w,'Flip');   
pause(0.3);

% for i = 1:100
%     Eout00 = rgb2gray(LucamCaptureFrame(cam)); %�ɼ�ccdһ֡ͼ��
%     Eout00 = Eout00(1:1040,101:1392);
%     bg0(1,i) = sum(sum(Eout00))/(1040*1292);
%     i
%     bg0(1,i)
%     pause(1);
% end
% i00 = sum(bg0)/100;


% GratingIndex=Screen('MakeTexture',w,Ein);
% GRect=Screen('Rect',GratingIndex);
% cGRect=CenterRect(GRect,wRect);
% Screen('DrawTexture',w,GratingIndex,cGRect,wRect);
% Screen(w,'Flip');   
% pause(0.3);
% Eout = rgb2gray(LucamCaptureFrame(cam)); %�ɼ�ccdһ֡ͼ��
% final = sum(sum(Eout((1040/2-b):(1040/2+b),(1392/2-b):(1392/2+b))))/(2*b+1)^2;
% final2 = sum(sum(Eout((1040/2+100-b):(1040/2+100+b),(1392/2-200-b):(1392/2-200+b))))/(2*b+1)^2;
% final = final1*final2;
% % enhencement = result/i00;
% % enhencement = enhencement';
figure(3)
% plot(enhencement);

imagesc(Eout)
colormap('jet')
colorbar
% final
cost
toc












