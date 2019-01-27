% The core part was coded by the original data collector Tong Xu
function [ daan ] =chuli(x,y,z)
px=mean(x);%gas
py=mean(y);%temperature
pz=mean(z);%pressure
la=length(x);
for n=1:la;
    bfz(n)=(x(n)-px)^0.5*(y(n)-py)^0.5*(z(n)-pz)^0.5;
    fmx(n)=(x(n)-px)^1.5;
    fmy(n)=(y(n)-py)^1.5;
    fmz(n)=(z(n)-pz)^1.5;
end
    daan=sum(bfz)^2/(sum(fmx).*sum(fmy).*sum(fmz))^(2/3);
end