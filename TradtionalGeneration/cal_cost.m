function cost = cal_cost(member1,b,NN,xx,yy,w,wRect,cam)
%������Ӧ��
%����������ռ�������    
for j = 1:xx %��32*18�ľ�����չ��1920*1080
    for p = 1:yy
        member(NN*(j-1)+1:NN*j,NN*(p-1)+1:NN*p) = member1(j,p)*ones(NN);
    end
end

GratingIndex=Screen('MakeTexture',w,member);
GRect=Screen('Rect',GratingIndex);
cGRect=CenterRect(GRect,wRect);
Screen('DrawTexture',w,GratingIndex,cGRect,wRect);
Screen(w,'Flip');   
pause(0.15);
Eout1 = rgb2gray(LucamCaptureFrame(cam)); %�ɼ�ccdһ֡ͼ��
Eout1 = double(Eout1);
% cost = sum(sum(Eout1((1040/2-b):(1040/2+b),(1392/2-b):(1392/2+b))))/(2*b+1)^2;
x0 = 628;%yuan628
y0 = 484;%yuan484
r0 = b;
[x,y]=meshgrid(1:1390,1:1040);
r = sqrt((x-x0).^2+(y-y0).^2) <= r0;%��������С 10�����ǰ뾶
focus = Eout1(r);
int = sum(sum(focus));
pingjun = int/length(focus);%�۽������ƽ��ǿ��
cost = pingjun;

% focus = Eout1(662:692,445:475);
% cost = sum(sum(focus))/numel(focus);
