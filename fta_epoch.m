function [data,pointrange]=fta_epoch(EEG,type)
% function [data,pointrange]=ft_epoch(EEG,type)
% epochs EEG into epochs containing consecutive "type" events, unless any other event is met
% assumes that after the first "type" event, no other event types are found apart from possible boundaries
%
% Example: type={'DIN1'}; type={'DIN1','DIN2'};
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2017-

ev=1; % event counter
epoch=1;
while ev <= length(EEG.event)
    %     while strcmp(EEG.event(ev).type,'boundary') % if event(ev) is 'boundary', we test whether it is the beginning of the 'type' segment
    %         disp('boundary');
    if any(strcmp(EEG.event(ev).type,type)) % if event(ev+1) is 'type', ev=first time point
        % if ev is first event, there is no initial boundary, therefore the
        % epoch starts at time 0
        if ev==1 pointrange{epoch}(1)=1000/EEG.srate;
        else
            pointrange{epoch}(1)=EEG.event(ev-1).latency;
        end
        ev=ev+1;
        a=1;
        while a
            if ev == length(EEG.event) % if ev=last event
                pointrange{epoch}(2)=EEG.pnts; % ev=last time point of the dataset
                a=0;
            elseif ev == length(EEG.event)+1 % if ev=last event
                pointrange{epoch}(2)=EEG.pnts; % ev=last time point of the dataset
                a=0;
            elseif ~strcmp(EEG.event(ev).type,'boundary') % if event(ev) is not 'boundary', proceed to next ev
                ev=ev+1;
            else % if event(ev) is 'boundary'
                pointrange{epoch}(2)=EEG.event(ev).latency; % event(ev)=last time point
                a=0;
            end
        end
        % select data
        EEGsel = pop_select( EEG,'point',pointrange{epoch});
        data{epoch}=EEGsel.data;
        epoch=epoch+1;
    end
    ev=ev+1;
end

