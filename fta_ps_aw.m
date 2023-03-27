function [ps,f,n]=fta_ps_aw(data,wl,srate)
% [ps,f,n]=fta_ps_fit(data,wl,srate)
% Computes power spectrum by FFT (square taper) on all channels of EEG data estimated by
% averaging single-window power spectrum over consecutive windows overlapping by a little more than half
% their length to cover all data points (adaptive windowing, aw)
% 
% Inputs:
% data = cell structure with data{n}=EEG.data from EEGLAB dataset relative to epoch n
% w = length of the sliding window for power spectrum computation (in time points)
% srate = data sampling rate
%
% Outputs:
% ps = power spectrum (channels x frequency)
% f = frequency bins
% n = number of epochs used to compute ps
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-.

for ep=1:length(data)
    loc(ep)=length(data{ep}(1,:))/wl;
end
data(loc<1)=[];

if isempty(data)
        error('Window longer than data!');
end

% Taper option (default taper is square, ideal for frequency-tagging) 
option='s';
if  strcmp(option, 's')
   w=ones(wl,1)/wl;
elseif  strcmp(option, 'w')
    w=welch(wl);
elseif  strcmp(option, 'p')
   w=parzen(wl);
elseif  strcmp(option, 'h')
   w=hamming(wl);
end
w=w';

wss=wl*(sum(w.^2));	%window squared and summed
% wss = 1 for square window
for el=1:size(data{1},1)
    ap=0;
    for ep=1:length(data)
        l=size(data{ep}(el,:),2);
%         if l-wl<20  % use one window only if epoch is longer only a few points more than wl
        if l-wl<floor(wl/4)  % use one window only if residual segment is shorter than wl/4
            l=wl;
            N=ceil(2*l/wl); % max number of consecutive HALF windows (non-overlapping if l is multiple of wl/2)
            dwl=0;
        else
            N=ceil(2*l/wl); % max number of consecutive HALF windows (non-overlapping if l is multiple of wl/2)
            dwl=floor((l-wl)/(N-2)); % step
        end
        n_loc(ep)=N-1; % number of consecutive full windows
        
        ap_loc=0;						%average power
        for i=1:n_loc(ep)
            wd=w.*data{ep}(el,(i-1)*dwl+1:(i-1)*dwl+wl);
            ap_loc=ap_loc + abs(fft(wd)).^2;
        end
        ap=ap+ap_loc;
    end
    n=sum(n_loc);
    ps(el,1)=ap(1)/(wss*n);
    ps(el,2:wl/2)=(ap(2:wl/2)+ap(wl:-1:wl/2 +2))/(wss*n);
    ps(el,wl/2 +1)=ap(wl/2 +1)/(wss*n);
    interval=0:1:(wl/2);
end
f=interval*srate/wl;

for ep=1:length(n_loc)
            disp(['Number of windows used for epoch ' num2str(ep) ' = ' num2str(n_loc(ep))]);
end









