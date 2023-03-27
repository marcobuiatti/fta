function fta_topoplot_itc(itc,f,tf,chanlocs)
% function fta_topoplot_itc(itc,f,tf,chanlocs)
% Plots the topography of inter-trial coherence
% Uses EEGLAB function topoplot.
% 
% Inputs:
% itc = inter-trial coherence 
% f = frequency vector
% tf = selected ("tag") frequency
% chanlocs = channel position, EEG.chanlocs in EEGLAB dataset
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-

% COMPUTING TAG FREQUENCY %
[~,I] = min(abs(f-tf));
itc_lim=0.6;
figure; 
topoplot(itc(:,I),chanlocs,'maplimits',[0 itc_lim],'electrodes','off','conv','on'); 
cbar;
colormap('parula');
set(gca,'Fontsize',14);