function [np,pstf,psbl]=fta_np_plfit(ps,f,tf,width)
% [np,pstf,psbl]=fta_np_plfit(ps,f,tf,width)
% Computes normalized power spectrum at the selected frequency by dividing the ps at that frequency 
% by the power-law fit of the power computed on a frequency interval around the selected frequency. 
% 
% Inputs:
% ps = power spectrum, channels x frequency 
% f = frequency vector
% tf = selected ("tag") frequency
% width = half-width of normalising interval, in frequency bins
% 
% Output:
% np = normalized power spectrum (channels)
% pstf = power at tf
% psbl = "baseline" ps computed from power-law fit
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2017.

%% INITIALIZATION %%
np=ones(size(ps,1),1);

% FIND TAG FREQUENCY %
[~,I] = min(abs(f-tf));

%% COMPUTE NP %%
%% set interval around peak freq
fitpoints=[I-width:I-1 I+1:I+width];
% fitpoints=[I+1:I+width]; % upper interval only
% fitpoints=[I-width-1:I-2 I+2:I+width+1]; % remove nearest neighbours too from the normalising interval
%% compute np %%
fitorder=1;
for el=1:size(ps,1)
    pstf(el,1)=ps(el,I);
    [Psp,~] = polyfit(log(f(fitpoints)),log(ps(el,fitpoints)),fitorder);
    fitpeak=exp(polyval(Psp,log(f(I))));
    psbl(el,1)=fitpeak;
    np(el,1)=ps(el,I)/fitpeak;
end
