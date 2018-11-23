% Created 2018-11-15, Updated 2018-11-15
% Author: Siqing Ma
% Get the time, channel and status

clear;
clc;
start_time = 3742243200 ;%Start timing form 2018/8/1 00:00:00

%Part1: Read data from xlsx file (make sure that the time column is sorted!)
[a, data] = xlsread('dev_data.xlsx');
origin_sec = cell2mat(data(:,1));
origin_opt = data(:,2);

time_row = zeros(length(origin_sec), 1);
devch_col_cell = {};

%Part2: build up the column
%% 
for i = 1 : length(origin_sec) 
    sub_opt = origin_opt{i}; %Operation on that time
    sec = str2double(origin_sec(i,:)) - start_time;
    time_row(i) = sec;
    
    idp = strfind(sub_opt,'DevId=');
    alp = strfind(sub_opt,'Alive=');
    stp = strfind(sub_opt,'Status=');
    chp = strfind(sub_opt,'CN=');
    cnp = strfind(sub_opt,'CHCount=');
    
    dev_num = length(idp); % Device number on that time;
    
     %For every single device
    ch_clc = 1;
    for j = 1 : dev_num 
        id = sub_opt(idp(j)+6 : alp(j)-2);%The device id
        chcount = str2double(sub_opt(cnp(j)+8));% The channel number 
        
        %For every single channel
        for k = 1 : chcount 
            ch = sub_opt(chp(ch_clc)+3); %Channel id
            id_ch =  strcat(id,ch);
            test = ismember(id_ch, devch_col_cell);
            if isempty(test) || test == 0
                devch_col_cell{end+1} = id_ch;
            end
            ch_clc = ch_clc+1;
        end
    end     
end

devch_col = zeros(length(devch_col_cell), 1);
for i = 1 : length(devch_col_cell) 
    devch_col(i) = str2double(devch_col_cell{ i });
end
devch_col = sort(devch_col);

%Part3: build up the matrix
%% 
X = zeros(length(time_row), length(devch_col));
for i = 1 : length(time_row) 
    
    sub_opt = origin_opt{i}; %Operation on that time
    idp = strfind(sub_opt,'DevId=');
    alp = strfind(sub_opt,'Alive=');
    stp = strfind(sub_opt,'Status=');
    chp = strfind(sub_opt,'CN=');
    cnp = strfind(sub_opt,'CHCount=');
    
    dev_num = length(idp); % Device number on that time;
    
    ch_clc = 1;
    %For every single device
    for j = 1 : dev_num 
        id = sub_opt(idp(j)+6 : alp(j)-2); %The device id
        chcount = str2double(sub_opt(cnp(j)+8));% The channel number 
        
        %For every single channel
        for k = 1 : chcount 
            ch = sub_opt(chp(ch_clc)+3); %Channel id
            status = str2double(sub_opt(stp(ch_clc)+7)); %Status
            id_ch =  str2double(strcat(id,ch));
            pos = find(devch_col==id_ch)
            
            if status == 1
                X(i, pos) = 1;
            else
                X(i, pos) = -1;
                %X(i, pos) = -1;
            end
            
            ch_clc = ch_clc+1;
        end
    end     
end

T = repmat(time_row, 1, 85);
T = T.*X;
T = abs(T);

RHO = corr(X);