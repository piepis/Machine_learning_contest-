clc;
clear all;
tic;
f = 800; %频率
c = 344;%光速
w = 2*pi*f;%角频率
k = w/c;%波数
ro = 1.21; %介质密度
r0 = 0.05;%脉动球半径
mx = 21; my = 21;%全息面取点个数
lx = 2; ly = 2;%全息面大小
a = lx/(mx-1);%全息面点间距
xh = -lx/2:a:lx/2;%生成全息面点的矩阵
yh = -ly/2:a:ly/2;%生成全息面点的矩阵
[XH,YH] = meshgrid(xh,yh);%生成网格化的矩阵
zh = 0.35;   %全息面位置
xr = xh;
yr = yh;
[XR,YR] = meshgrid(xr,yr);
zr = r0+0.1; %生成重建面并确定位置
nx = 21; ny = 21;
sx = 2; sy = 2;
a1 = sx/(nx-1);
xs = -sx/2:a1:sx/2;
ys = -sy/2:a1:sy/2;
[XS,YS] = meshgrid(xs,ys);
zs = -0.1;%等效源点矩阵
M = length(xh)*length(yh);%声压测量点个数
N = length(xs)*length(ys);%等效源点个数

x = 0; y = 0; z = 0;%脉动球位置
rh = sqrt((XH-x).^2+(YH-y).^2+(zh-z)^2);%全息面上各个点到脉动球的距离
rr = sqrt((XR-x).^2+(YR-y).^2+(zr-z)^2);%重建面上各个点到脉动球的距离
ph=-(i*2*pi*f*ro*r0^2)/(1-i*k*r0)./rh.*exp(i*k*(rh-r0));%全息面声压理论值
pr=-(i*2*pi*f*ro*r0^2)/(1-i*k*r0)./rr.*exp(i*k*(rr-r0));%重建面声压理论值
costh = zr./rr;
vr = r0^2*exp(i*k*(rr-r0)).*(i*k*rr-1)./((i*k*r0-1)*rr.^2).*costh;%重建面振速
%figure(1);%全息面声压理论值
%surf(abs(ph));
%title('全息面理论声压');
%axis tight
%figure(2);%重建面声压理论值
%surf(abs(pr));
%title('重建面理论声压');
%axis tight
%figure(3);%重建面振速理论值
%surf(abs(vr));
%title('重建面理论振速');
%axis tight
%surf 三维有色曲面图 abs 数值的幅值 

[U,S,V] = svd (ph)
ph1 = reshape(ph,M,1);%把PH矩阵改形状为M行1列，即列向量
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
%上述循环结构是计算高斯函数矩阵

ph2=awgn(ph1,30)%噪声控制
Q = pinv(Gpsh)*ph2/(i*ro*c*k);%pinv是求广义逆，求场强
[Q_lambda,rho,eta] = tikhonov(U,S,V,ph2,0.01,Q)
P = i*ro*c*k*Gpsr*Q;%重建面声压计算
p = reshape(P,length(xr),length(yr));%重建面声压矩阵换回原来的形状
V = Gvsr*Q;%求振速
v = reshape(V,length(xr),length(yr));%振速的矩阵形状重建



errp=norm(pr-p)/norm(pr);
errv=norm(vr-v)/norm(vr);%求误差
toc;

figure(4);
surf(abs(p));
title('重建声压');
axis tight% axis tight 是设置坐标轴显示范围为紧凑型
%grid off %关闭网格
%figure(5);
%surf(abs(v));
%title('重建振速');
%axis tight
figure(6);
surf(abs(pr));
title('理论声压');
axis tight
% grid off
%figure(7);
 %surf(abs(vr));
%title('理论振速');
%axis tight


