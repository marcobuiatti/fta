function [itc,ppc,an,f,N] = fta_itc_ppc(data,wl,srate)
% [itc,ppc,an,f,N] = fta_itc_ppc(data,wl,srate)
% Computes Inter-Trial Coherence and Pairwise Phase Consistency on all channels of EEG data over
% consecutive non-overlapping windows (trials)
% 
% Inputs:
% data = cell structure with data{n}=EEG.data from EEGLAB dataset relative to epoch n
% wl = length of the sliding window for power spectrum computation (in time points)
% srate = data sampling rate
%
% Outputs:
% itc = inter-trial coherence (channels x frequency x epochs)
% ppcc = pairwise phase consistency (channels x frequency x epochs)
% an{ep} = phase (angle in radians) for each trial and frequency within each epoch ep (channels x frequency x trials) 
% f = frequency vector
% N = number of windows used for itc/ppc computation
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-
nep=length(data);
for el=1:size(data{1},1)
    N=0; % trial counter
    for ep=1:nep
        if size(data{ep},2) >= wl
            n_loc=floor(size(data{ep},2)/wl);
            for tr=1:n_loc
                an_loc=angle(fft(data{ep}(el,(1+(tr-1)*wl:tr*wl))));
                if floor(wl/2)==wl/2
                    an(el,:,N+tr)=an_loc(1,1:wl/2+1);
                else
                    an(el,:,N+tr)=an_loc(1,1:(wl-1)/2+1);
                end
            end
            N=N+n_loc;
        end
    end
    itc(el,:)=abs(mean(exp(1i*an(el,:,:)),3));
    ppc(el,:)=((abs(mean(exp(1i*an(el,:,:)),3)).^2)*N - 1)/(N-1);
end

disp(['Number of windows used = ' num2str(N)]);

if floor(wl/2)==wl/2
    interval=0:1:(wl/2);
else
    interval=0:1:((wl-1)/2);
end
f=interval*srate/wl;
