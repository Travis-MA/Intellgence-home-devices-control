% Created 2018-11-15, Updated 2018-11-15
% Author: Siqing Ma
% Get the time, channel and status

clear;
clc;
start_time = 3742243200 ;%Start timing form 2018/8/1 00:00:00

%return
TIME = [];%(vector)
ID_CH = {};%(cell)
STATUS = [];%(vector)

%Read data from xlsx file
[a, data] = xlsread('dev_data.xlsx');
origin_sec = cell2mat(data(:,1));
origin_opt = data(:,2);

total_clc = 1;

%For every single time
for i = 1 : length(origin_sec) 
    
    sub_opt = origin_opt{i}; %Operation on that time
    sec = str2double(origin_sec(i,:)) - start_time;
    
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
            
            id_ch = [id, '-', ch];
            TIME(end + 1,1) = sec;
            ID_CH{total_clc,1} = id_ch; 
            STATUS(end+1,1) = status;
            
            ch_clc = ch_clc+1;
            total_clc = total_clc+1;
        end
    end     
end



