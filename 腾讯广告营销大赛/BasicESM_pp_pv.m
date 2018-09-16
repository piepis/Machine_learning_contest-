clc;
clear all;
tic;
f = 800; %Ƶ��
c = 344;%����
w = 2*pi*f;%��Ƶ��
k = w/c;%����
ro = 1.21; %�����ܶ�
r0 = 0.05;%������뾶
mx = 21; my = 21;%ȫϢ��ȡ�����
lx = 2; ly = 2;%ȫϢ���С
a = lx/(mx-1);%ȫϢ�����
xh = -lx/2:a:lx/2;%����ȫϢ���ľ���
yh = -ly/2:a:ly/2;%����ȫϢ���ľ���
[XH,YH] = meshgrid(xh,yh);%�������񻯵ľ���
zh = 0.35;   %ȫϢ��λ��
xr = xh;
yr = yh;
[XR,YR] = meshgrid(xr,yr);
zr = r0+0.1; %�����ؽ��沢ȷ��λ��
nx = 21; ny = 21;
sx = 2; sy = 2;
a1 = sx/(nx-1);
xs = -sx/2:a1:sx/2;
ys = -sy/2:a1:sy/2;
[XS,YS] = meshgrid(xs,ys);
zs = -0.1;%��ЧԴ�����
M = length(xh)*length(yh);%��ѹ���������
N = length(xs)*length(ys);%��ЧԴ�����

x = 0; y = 0; z = 0;%������λ��
rh = sqrt((XH-x).^2+(YH-y).^2+(zh-z)^2);%ȫϢ���ϸ����㵽������ľ���
rr = sqrt((XR-x).^2+(YR-y).^2+(zr-z)^2);%�ؽ����ϸ����㵽������ľ���
ph=-(i*2*pi*f*ro*r0^2)/(1-i*k*r0)./rh.*exp(i*k*(rh-r0));%ȫϢ����ѹ����ֵ
pr=-(i*2*pi*f*ro*r0^2)/(1-i*k*r0)./rr.*exp(i*k*(rr-r0));%�ؽ�����ѹ����ֵ
costh = zr./rr;
vr = r0^2*exp(i*k*(rr-r0)).*(i*k*rr-1)./((i*k*r0-1)*rr.^2).*costh;%�ؽ�������
%figure(1);%ȫϢ����ѹ����ֵ
%surf(abs(ph));
%title('ȫϢ��������ѹ');
%axis tight
%figure(2);%�ؽ�����ѹ����ֵ
%surf(abs(pr));
%title('�ؽ���������ѹ');
%axis tight
%figure(3);%�ؽ�����������ֵ
%surf(abs(vr));
%title('�ؽ�����������');
%axis tight
%surf ��ά��ɫ����ͼ abs ��ֵ�ķ�ֵ 

[U,S,V] = svd (ph)
ph1 = reshape(ph,M,1);%��PH�������״ΪM��1�У���������
XH = reshape(XH,1,M);
YH = reshape(YH,1,M);
XR = reshape(XR,1,M);
YR = reshape(YR,1,M);
XS = reshape(XS,1,N);
YS = reshape(YS,1,N);

for m = 1:M
    for n = 1:N
        Rsh = sqrt((XH(m)-XS(n))^2+(YH(m)-YS(n))^2+(zh-zs)^2);
        Rsr = sqrt((XR(m)-XS(n))^2+(YR(m)-YS(n))^2+(zr-zs)^2);
        costh2 =(zr-zs)/Rsr;
        Gpsh(m,n) = exp(i*k*Rsh)/(4*pi*Rsh);
        Gpsr(m,n) = exp(i*k*Rsr)/(4*pi*Rsr);
        Gvsr(m,n) = exp(i*k*Rsr)*(i*k*Rsr-1)/(4*pi*Rsr^2)*costh2;
    end
end
%����ѭ���ṹ�Ǽ����˹��������

ph2=awgn(ph1,30)%��������
Q = pinv(Gpsh)*ph2/(i*ro*c*k);%pinv��������棬��ǿ
[Q_lambda,rho,eta] = tikhonov(U,S,V,ph2,0.01,Q)
P = i*ro*c*k*Gpsr*Q;%�ؽ�����ѹ����
p = reshape(P,length(xr),length(yr));%�ؽ�����ѹ���󻻻�ԭ������״
V = Gvsr*Q;%������
v = reshape(V,length(xr),length(yr));%���ٵľ�����״�ؽ�



errp=norm(pr-p)/norm(pr);
errv=norm(vr-v)/norm(vr);%�����
toc;

figure(4);
surf(abs(p));
title('�ؽ���ѹ');
axis tight% axis tight ��������������ʾ��ΧΪ������
%grid off %�ر�����
%figure(5);
%surf(abs(v));
%title('�ؽ�����');
%axis tight
figure(6);
surf(abs(pr));
title('������ѹ');
axis tight
% grid off
%figure(7);
 %surf(abs(vr));
%title('��������');
%axis tight


