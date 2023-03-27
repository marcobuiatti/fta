%% Frequency-Tagging Analysis Workflow %%
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-

%% preprocessing %%

% Suggested pre-processing pipeline:
%
% Load data in EEGLAB gui
%
% Band-pass filter in two steps (one is not efficient). 
% Low-pass cut-off at 40 Hz
lpc=40;
EEG = pop_eegfiltnew(EEG, 'hicutoff', lpc);
% High-pass cut-off at 0.2 Hz
hpc=0.2;
EEG=clean_drifts(EEG, hpc, []); 
% or
EEG = pop_eegfiltnew(EEG, 'locutoff', hpc);

% Save filtered dataset on EEGLAB gui

% Segment EEG based on fixation times fixt
EEG = pop_select( EEG,'time',fixt);
eeglab redraw

% ARTIFACT REMOVAL: NEAR, ending with clean data and interpolated channels.

% Compute average reference and recover reference channel

% Save clean, average-referenced data on EEGLAB gui

%% Spectral analysis, single subject level %%
% Extract data epochs for each condition
% NOTE: fta_epoch is designed for continuous data where the beginning of
% each stimulus cycle is marked by an event. Epochs are continuous data
% segments of stimulation. They end whenever a boundary event occurs. 
% Please adapt to your design and carefully check that it correctly epochs the data as you expect.
%
% Input:
% EEG = EEGLAB dataset
% type = event type (may be more than one, separated by commas)
%
% Output: 
% data = data cell; data{n} = nth epoch
cond1='DIN1';
cond2='DIN2';
data1=fta_epoch(EEG,cond1); % condition 1
data2=fta_epoch(EEG,cond2); % condition 2

%% Compute power spectrum and normalized power
% function [ps,f,np0,np1,n]=fta_ps_np(data,w,npw,tf,plfit,chanlocs,fig,srate)
% Input:
% data = data cell; data{n} = nth epoch
% w = sliding window width in time points (must be a multiple of one cycle
% length at the tag frequency!)
% npw = half-width in time points of normalizing interval for np
% computation (=FTR as defined in Buiatti et al., 2019)
% tf = tag frequency
% plfit = power-law fit (1: power-law fit normalization, 0: average
% normalization
% chanlocs = channel location structure (= EEG.chanlocs in EEGLAB dataset)
% fig = plotting option (1: plot figure, 0: do not plot anything). 
% First figure: topography of power spectrum at tag frequency; 
% Second figure: topography of np at tag frequency
% srate = data sampling rate (= EEG.srate in EEGLAB dataset)
%
% Output:
% ps = data power spectrum
% f = frequency vector
% np0 = normalized power at frequency tf
% np1 = normalized power at frequency 2*tf
% n = number of epochs used to compute ps

% Set parameters: 
w=2500; 
npw=3;
tf=0.8;
plfit=1;
chanlocs=EEG.chanlocs;
srate=EEG.srate;
fig=1;
% run fta_ps_np
[ps1,f,np1]=fta_ps_np(data1,w,npw,tf,plfit,chanlocs,fig,srate);
[ps2,f,np2]=fta_ps_np(data2,w,npw,tf,plfit,chanlocs,fig,srate);

% compute evoked power spectrum (i.e. 
[eps1,f,enp1]=fta_eps_np(data1,w,npw,tf,plfit,chanlocs,fig,srate);
[eps2,f,enp2]=fta_eps_np(data2,w,npw,tf,plfit,chanlocs,fig,srate);


% Plot power spectrum on cluster of selected channels
% Frequency range (in frequency bins) used for the plot.
frange=3:12;
% Selected channels. When exploring the effects on a single subject: select those channels that show 
% a higher FTR in the topography plots above.
selch=[73 74];
fta_plot_ps(frange,selch,f,ps1,ps2);

% plot power spectrum in all channels in topographic view
ps(:,:,1)=ps1;
ps(:,:,2)=ps2;
ylim=20;
figure; 
plottopo(ps(:,frange,:), 'chanlocs', chanlocs,'ydir',1,'limits',[f(frange(1)) f(frange(end)) 0 ylim]);

%% Inter-Trial Coherence analysis (ITC)
% epoch data starting from first event (so that all epochs are time-locked)
data1_tl=fta_epoch_tl(EEG,cond1);
data2_tl=fta_epoch_tl(EEG,cond2);

% Compute Inter-Trial Coherence and Pairwise Phase Consistency
wl_tl=1250;

[itc1,ppc1,an1,f_tl] = fta_itc_ppc(data1_tl,wl_tl,srate);
[itc2,ppc2,an2,f_tl] = fta_itc_ppc(data2_tl,wl_tl,srate);

% Plot topography of ITC (works with PPC too)
fta_topoplot_itc(itc1,f_tl,tf,chanlocs);
fta_topoplot_itc(itc2,f_tl,tf,chanlocs);

% Plot ITC on cluster of selected channels (works with PPC too)
% Frequency range (in frequency bins) used for the plot.
frange_itc=3:11;
% Selected channels. When exploring the effects on a single subject: select those channels that show 
% a higher FTR in the topography plots above.
selch=[73 74];
fta_plot_ps(frange_itc,selch,f_itc,itc1,itc2);

