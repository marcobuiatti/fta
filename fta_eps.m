function [eps,f,n]=fta_eps(data,wl,srate)
% [eps,f,n]=fta_eps(data,wl,srate)
% Computes evoked power spectrum by FFT (square taper) on all channels of EEG data estimated by
% averaging data over consecutive non-overlapping windows and computing power spectrum of the resulting evokesd response
% 
% Inputs:
% data = cell structure with data{n}=EEG.data from EEGLAB dataset relative to epoch n
% w = length of the sliding window for power spectrum computation (in time points)
% srate = data sampling rate
%
% Outputs:
% eps = evoked power spectrum (channels x frequency)
% f = frequency bins
% n = number of epochs used to compute ps
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2022-.

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
        n_loc(ep)=floor(l/wl); % max number of consecutive non-overlapping windows
        ap_loc=0;
        for i=1:n_loc(ep)
            wd=w.*data{ep}(el,(i-1)*wl+1:i*wl);
            ap_loc=ap_loc + wd;
        end
        ap=ap+ap_loc;
    end
    aps=abs(fft(ap)).^2;
    n=sum(n_loc);
    eps(el,1)=aps(1)/(wss*n);
    eps(el,2:wl/2)=(aps(2:wl/2)+aps(wl:-1:wl/2 +2))/(wss*n);
    eps(el,wl/2 +1)=aps(wl/2 +1)/(wss*n);
    interval=0:1:(wl/2);
end
f=interval*srate/wl;

for ep=1:length(n_loc)
            disp(['Number of windows used for epoch ' num2str(ep) ' = ' num2str(n_loc(ep))]);
end
        
   

