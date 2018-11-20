% Created 2018-11-15, Updated 2018-11-20
% Author: Jun Steed Huang, Siqing Ma
% Analysis the smart home IoT data time, channel and status

clear;
clc;
start_time = 3742243200 ; %Start timing from 2018/8/1 00:00:00

% Part1: Read data from files 
load ('time_row.mat');
load ('event_matrix.mat');

%Part2: Analyze the data
% Look at time
int_arrival = diff(time_row);
min_gap = min(int_arrival)
max_gap = max(int_arrival)
avg_gap = mean(int_arrival)
std_gap = std(int_arrival)
gap_ratio = round(max_gap/std_gap)
% Check at event
RHO1 = corr(X);
RHO2 = RHO1-diag(diag(RHO1));
[x y]=find(RHO2==max(max(RHO2)))

%Part3: Show the results
figure (1);
hist(time_row,gap_ratio);
xlabel('Local universal time second');
ylabel('Histogram');
title('Event interarrival times');

figure (2);
surfc(RHO2);
xlabel('device id');
ylabel('device id');
zlabel('Pearson value');
title('Pearson linear correlation coefficient');

figure (3);
plot(x,y);
grid;
xlabel('device id');
ylabel('device id');
title('Strong Pearson correlated device pair');
