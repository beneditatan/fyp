% Copyright 2014 The MathWorks, Inc.

% 
% %% Create a MATLAB Timer
% t = timer;              % Create the MATLAB Timer
% 
% t.TimerFcn = @XBeePoll; % Call this function every 5 seconds
% t.Period = 5;         % Call the |TimerFcn| every 5 seconds
% t.ExecutionMode = 'FixedRate';  % Run the timer at a fixed rate
% 
% %% Start periodic polling
% start(t);


%Timer Callback function
function [] = ftimer(~,~)
    while TimerHandle.TasksExecuted == 60
        XBeePoll();
        break;
    end
end

%Handle and execution
TimerHandle = timer('ExecutionMode','fixedrate','period',1,'tag','clockTimer','timerfcn',@ftimer);
start(TimerHandle);

