function fta_topoplot_np(np,chanlocs)
% fta_topoplot_np(np,chanlocs)
% Plots the topography of normalized power spectrum np
% Uses EEGLAB function topoplot.
% 
% Inputs:
% np = normalized power spectrum
% chanlocs = channel position, EEG.chanlocs in EEGLAB dataset
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-

figure; 
maxnp=max(np);
% Plot np
topoplot(np,chanlocs,'electrodes','off','maplimits',[0 maxnp/1.1],'conv','on'); 
% Otherwise, plot log(np)
% topoplot(log(np),chanlocs,'maplimits',[-1.5 1.5],'electrodes','numbers'); 
cbar('vert',0,[0 maxnp/1.1],3);
colormap('parula');
set(gca,'Fontsize',14);
