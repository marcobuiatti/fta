function np=fta_np(ps,f,tf,width)
% np=fta_np(ps,f,tf,width)
% Computes normalized power spectrum at the selected frequency by dividing the ps at that frequency 
% by the mean of the power on a frequency interval around the selected frequency. 
% 
% Inputs:
% ps = power spectrum, channels x frequency 
% f = frequency vector
% tf = selected ("tag") frequency
% width = half-width of normalising interval, in frequency bins
% 
% Output:
% np = normalized power spectrum (channels)
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-

%% INITIALIZATION %%
np=ones(size(ps,1),1);

% FIND TAG FREQUENCY %
[~,I] = min(abs(f-tf));

%% COMPUTE NP %%
if width==0     % Non-normalised ps %
    for el=1:size(ps,1)
        np(el)=ps(el,I);
    end
else
    %% set interval around peak freq
    fitpoints=[I-width:I-1 I+1:I+width];
    %     fitpoints=[I-width-1:I-2 I+2:I+width+1]; % remove nearest neighbours too from the normalising interval
    %% compute np %%
    for el=1:size(ps,1)
        np(el)=ps(el,I)/mean(ps(el,fitpoints));
        % np(el)=ps(el,I)-mean(ps(el,fitpoints)); % baseline-substract
        % instead of ratio
    end
end
