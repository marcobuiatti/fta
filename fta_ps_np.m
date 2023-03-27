function [ps,f,np0,np1,n]=fta_ps_np(data,w,npw,tf,plfit,chanlocs,fig,srate)
% Input:
% data = data cell; data{n} = nth epoch
% w = sliding window width in time points
% npw = half-width in time points of normalizing interval for np computation
% tf = tag frequency
% plfit = power-law fit (1: power-law fit normalization, 0: average
% normalization
% chanlocs = channel location structure (= EEG.chanlocs in EEGLAB dataset)
% fig = plotting option (1: plot figure, 0: do not plot anything)
% srate = data sampling rate (= EEG.srate in EEGLAB dataset)
%
% Output:
% ps = data power spectrum
% f = frequency vector
% np0 = normalized power at frequency tf
% np1 = normalized power at frequency 2*tf
% n = number of epochs used to compute ps
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-.

% Compute power spectrum by FFT (square taper) on all channels of EEG data estimated by
% averaging single-window power spectrum over consecutive windows overlapping by a little more than half
% their length to cover all data points (adaptive windowing, aw)
[ps,f,n]=fta_ps_aw(data,w,srate);

if plfit % power-law fit normalization
    np0=fta_np_plfit(ps,f,tf,npw);
    np1=fta_np_plfit(ps,f,2*tf,npw);
else % average normalization
    np0=fta_np(ps,f,tf,npw);
    np1=fta_np(ps,f,2*tf,npw);
end

if fig
    fta_topoplot_ps(ps,f,tf,chanlocs);
    fta_topoplot_np(np0,chanlocs);
    % Uncomment the next two lines to plot ps,np of first harmonic
    % fta_topoplot_ps(ps,f,2*tf,chanlocs);
    % fta_topoplot_np(np1,chanlocs);
end
