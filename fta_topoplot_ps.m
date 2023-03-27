function fta_topoplot_ps(ps,f,tf,chanlocs)
% fta_topoplot_ps(ps,f,tf,chanlocs)
% Plots the topography of power spectrum ps
% Uses EEGLAB function topoplot.
% 
% Inputs:
% ps = power spectrum (channels x frequency)
% f = frequency vector
% tf = selected ("tag") frequency
% chanlocs = channel position, EEG.chanlocs in EEGLAB dataset
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-

[~,ft_ind]=min(abs(f-tf));
ps_loc=ps(:,ft_ind); maxps=2*median(ps_loc(:));
figure; 
topoplot(ps(:,ft_ind),chanlocs,'maplimits',[0 maxps],'electrodes','numbers','conv','on'); 
cbar;
