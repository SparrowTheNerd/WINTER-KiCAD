%s = serialport('COM5',9600);
%data = str2double(readline(s));

clear
clc

%User Defined Properties 
serialPort = 'COM5';            % define COM port #
plotTitle = 'Serial Data Log';  % plot title
xLabel = 'Elapsed Time (s)';    % x-axis label
yLabel = 'Acceleration';                % y-axis label
plotGrid = 'on';                % 'off' to turn off grid
min = -30;                     % set y-min
max = 30;                      % set y-max
scrollWidth = 10;               % display period in plot, plot entire data log if <= 0
delay = .0000001;                    % make sure sample faster than resolution

%Define Function Variables
time = 0;
data = zeros(3,1);
count = 0;

%Set up Plot
plotGraph = plot(time,data(1,:),'-r',...
            'LineWidth',2,...
            'MarkerFaceColor','w',...
            'MarkerSize',2);

title(plotTitle,'FontSize',25);
xlabel(xLabel,'FontSize',15);
ylabel(yLabel,'FontSize',15);
axis([-30 30 min max]);
grid(plotGrid);

%Open Serial COM Port
s = serialport(serialPort, 9600);
tic

while ishandle(plotGraph)  %Loop when Plot is Active

dat = readline(s) %Read Data from Serial as Float

if(~isempty(dat) && isfloat(dat)) %Make sure Data Type is Correct        
    count = count + 1;    
    time(count) = toc;    %Extract Elapsed Time in seconds      

    %Set Axis according to Scroll Width
    if(scrollWidth > 0)
    set(plotGraph,'XData',time(time > time(count)-scrollWidth),...
        'YData', dat(time > time(count)-scrollWidth));

    axis([time(count)-scrollWidth time(count) min max]);
    else
    set(plotGraph,'XData',time,'YData',dat);

    axis([0 time(count) min max]);
    end

    %Allow MATLAB to Update Plot
    pause(delay);
end
end

%Close Serial COM Port and Delete useless Variables
clear s

clear count dat delay max min plotGraph plotGraph1 plotGraph2 plotGrid...
    plotTitle s scrollWidth serialPort xLabel yLabel;

disp('Session Terminated');

clear str prompt;