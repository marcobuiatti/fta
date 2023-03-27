function fta_plot_ps(frange,selch,f,varargin)
% function fta_plot_ps(frange,ch,f,varargin)
% plots power spectrum on selected frequency range averaged on selected channels
%
% Input:
% frange = frequency range, in frequency bins
% selch = channel selection, in channel numbers
% f = frequency vector associated to power spectra
% varargin = power spectrum data (any number)
%
% Example:
% fta_plot_ps(frange,ch,f,ps1,ps2,ps3)
%
% Author: Marco Buiatti, CIMeC (University of Trento, Italy), 2016-

figure;
for i=1:length(varargin)
    plot(f(frange),mean(varargin{i}(selch,frange),1),'-*','linewidth',2);
    % loglog(f(frange),mean(varargin{i}(ch,frange),1),'-*','linewidth',2);
    hold on;
    label{i}=['ps' num2str(i)];
end
axis tight
set(gca,'Fontsize',16);
% legend('ps1','ps2','ps3');
legend boxoff
xlabel('Hz');
ylabel('\mu V^2');
