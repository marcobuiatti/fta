function [eps,f,enp0,enp1,n]=fta_eps_np(data,w,npw,tf,plfit,chanlocs,fig,srate)
% Input:
% data = data cell; data{n} = nth epoch
% w = sliding window width in time points (must be a multiple of one cycle
% length at the tag frequency!)
% npw = half-width in time points of normalizing interval for np computation
% tf = tag frequency
% plfit = power-law fit (1: power-law fit normalization, 0: average
% normalization
% chanlocs = channel location structure (= EEG.chanlocs in EEGLAB dataset)
% fig = plotting option (1: plot figure, 0: do not plot anything)
% srate = data sampling rate (= EEG.srate in EEGLAB dataset)
%
% Output:
% eps = data evoked power spectrum (i.e. power spectrum of the
% event-related potential)
% f = frequency vector
% np0 = normalized power at frequency tf
% np1 = normalized power at frequency 2*tf
% n = number of epochs used to compute ps
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2022-.

% Compute power spectrum by FFT (square taper) on all channels of EEG data estimated by
% averaging single-window power spectrum over consecutive windows overlapping by a little more than half
% their length to cover all data points (adaptive windowing, aw)
[eps,f,n]=fta_eps(data,w,srate);

if plfit % power-law fit normalization
    enp0=fta_np_plfit(eps,f,tf,npw);
    enp1=fta_np_plfit(eps,f,2*tf,npw);
else % average normalization
    enp0=fta_np(eps,f,tf,npw);
    enp1=fta_np(eps,f,2*tf,npw);
end

if fig
    fta_topoplot_ps(eps,f,tf,chanlocs);
    fta_topoplot_np(enp0,chanlocs);
    % Uncomment the next two lines to plot ps,np of first harmonic
    % fta_topoplot_ps(ps,f,2*tf,chanlocs);
    % fta_topoplot_np(np1,chanlocs);
end
