%default values
Test.N=1024; % length of a period
Test.fs=1024; % sampling frequency [Hz]
Test.NInputchannels=1; % number of input channels
Test.fmin = 1;  % minimum excited frequency [Hz]
Test.fmax = 400;% maximum excited frequency [Hz]
Test.CFoptimization=1; % perform cross-factor optimization
Test.plot=1; % plot the resulting signal
Test.enforcefminfmax=1; % make sure that min and max frequencies are excited
Test.NormalizeToRMS=1; % if 1, then the signal is normalized to rms 
Test.NormalizationValue=1; % normalization factor 
Test.Mode='Combined'; % default signal type, it can be Combined, Fast, Robust
% default values for different multisine modes
Test.Robust.P=3; % number of periods 
Test.Robust.M=7; % number of realizations
Test.Fast.P=8;  % number of periods 
Test.Fast.M=1; % number of realizations
Test.Combined.P=3; % number of periods 
Test.Combined.M=7; % number of realizations

