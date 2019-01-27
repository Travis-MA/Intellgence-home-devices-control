% Created 2018-11-15, Updated 2018-11-20
% Author: Jun Steed Huang, Siqing Ma
% Analysis the smart home IoT data time, device and event
% The event +1 is switch on, -1 is switch off

clear;
clc;
start_time = 3742243200 ; %Start timing from 2018/8/1 00:00:00

% Part1: Read data from files 
load ('time_row.mat');
load ('event_matrix');
load ('T.mat');

%Part2: Analyze the data
% Look at time interval
int_arrival = diff(time_row)
min_gap = min(int_arrival)
max_gap = max(int_arrival)
avg_gap = mean(int_arrival)
std_gap = std(int_arrival)
% Estimate granularity for histogram
gap_ratio = round((max_gap+min_gap)/sqrt(avg_gap*std_gap))

% Look at daily behavior
Sz1 = size(time_row);
day = 24*3600;
S1 = Sz1(1,1);

% Find out Number of Daily event
for j=1:7 %7 days a week
for i=1:S1
    if time_row(i)-time_row(1)>day*j
       V(j)=i;
       break
    end
end
end

% Daily events
D = diff(V);
N = round(mean(D));

% Check at event
RHO1 = corr(X);
% Remove device self correlation 
RHO2 = RHO1-diag(diag(RHO1));
% Find out strong correlation pair
[x,y] = find(RHO2==max(max(RHO2)));

% Look deep at device
Sz2 = size(X);
S2 = Sz2(1,2);
Sz3 = size(x);
S3 = Sz3(1,1);
% Calculate yellow correlation
for l=1:S2
for k=1:S3
    if (l~=x(k)&&l~=y(k))
    RHO3(k,l)=chuli(X(:,x(k)),X(:,y(k)),X(:,l));
    end
end
end

% Find out yellow correlation triple
[u,v] = find(RHO3==max(max(RHO3)));

% Final Pearson-Huang group
Sz4 = size(u);
S4 = Sz4(1,1);
for m=1:S4
    w(:,m)=[x(u(m)),y(u(m)),v(m)];
end
% Display the group
display('These three devices are strongly related:')
display(w);

%Part3: Sample prediction
% Pick a device
hot = round(mean(x+y)/2);
dev = x(hot);
day1 = T(1:V(1),dev);
day2 = T(V(1):V(2),dev);
day3 = T(V(2):V(3),dev);
day4 = T(V(3):V(4),dev);
day5 = T(V(4):V(5),dev);
day6 = T(V(5):S1,dev);
% Predict day 7
day7 = ifft((fft(day1,N)+fft(day2,N)+fft(day3,N)+fft(day4,N)+fft(day5,N)+fft(day6,N))/6,N);

%Part4: Show the results
figure (1);
hist(int_arrival,gap_ratio);
grid;
xlabel('Local universal time seconds');
ylabel('Histogram');
title('Event interarrival times');

figure (2);
hist(log(int_arrival),gap_ratio);
grid;
xlabel('Local universal time seconds');
ylabel('Histogram');
title('Event interarrival times log scale');

figure (3);
plot(mod(time_row,day),sum(X,2),'^');
grid;
xlabel('Daily universal time seconds');
ylabel('Events');
title('Daily event arrival times');

figure (4);
plot(fft(diff(mod(time_row,day))/(day/N),N),'*');
grid;
xlabel('Normalized interarrivals');
ylabel('Normalized events');
title('Daily interarrivals FFT');

figure (5);
surfc(X);
xlabel('device id');
ylabel('sequence number');
zlabel('Event value');
title('All events for devices');

figure (6);
plot(sum(abs(X)),'+');
grid;
xlabel('Device id');
ylabel('Total events');
title('Devices activities');
 
figure (7);
surfc(RHO2);
xlabel('device id2');
ylabel('device id1');
zlabel('Pearson value');
title('Pearson linear correlation coefficient');

figure (8);
plot(x,y);
grid;
xlabel('device id2');
ylabel('device id1');
title('Strong Pearson correlated device pair');

figure (9);
surfc(abs(RHO3));
xlabel('device id3');
ylabel('device id1&2');
zlabel('Yellow module value');
title('Huang nonlinear correlation coefficient');

figure (10);
surfc(angle(RHO3));
xlabel('device id3');
ylabel('device id1&2');
zlabel('Yellow phase value');
title('Huang nonlinear correlation coefficient');

figure (11);
surfc(real(RHO3));
xlabel('device id3');
ylabel('device id1&2');
zlabel('Yellow real value');
title('Huang nonlinear correlation coefficient');

figure (12);
surfc(imag(RHO3));
xlabel('device id3');
ylabel('device id1&2');
zlabel('Yellow imaginary value');
title('Huang nonlinear correlation coefficient');

figure (13);
surfc(mod(T,day));
xlabel('device id');
ylabel('sequence number');
zlabel('Time interval');
title('Events times for devices');

figure (14);
plot(day1);
hold on;
plot(day2);
plot(day3);
plot(day4);
plot(day5);
plot(day6);
plot(day7);
hold off;
xlabel('event');
ylabel('time interval');
legend('day1','day2','day3','day4','day5','day6','day7');
title('Predicted day 7 time for hot device');