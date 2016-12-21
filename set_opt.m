%% Set options for the EMG extractor
%
% Author: Rex Ying
%

opt = struct;

opt.samplingRate = 10000;
% 10000 Hz is the default and was the frequency used to develop the code.
ratio = opt.samplingRate / 10000;

% I/O
opt.inputFolderName = 'data/';
% enter file name for analysis here,then specify the colmn number (channel)
% for analysis at opt.channel
opt.inputFileName = 'trial_701 Tupaia Doughboy 9-27-2001 cricket wave0';
opt.channel = 1;
% set to true if we want to generate intermediate figures at each step
opt.debug = true;

% winSize is the number of points we use to average for postprocessing
% posterior threshold value, when greater than 5, will yield a less
% conservative estimate of EMG signal
opt.winSize = 20;

% example posteriorThreshold for Tupaia data is 10; 
% for data that needs high sensitivity, adjust posteriorThreshold to 5.
opt.posteriorThreshold = 10;


% default value is a gap of 120 zero entries within the 
% EMG signal for including a 
% silent period. If the gap is
% larger than that, the signal is split into two.
opt.allowedGap = 120 * ratio;


% signalLenThresh is sensitive to sampling frequency.  A signalLenThresh
% of 1000 will delete all EMG signal that is less than 1000 data points.
% This gets rid of short duration orphan spikes.  A lower signalLenThresh
% is recommended for sampling rates less than 10 Khz.
opt.signalLenThresh = 100;


% the 100 points before onset and after offset are considered 
% ambiguous and not included in noise during feedback steps.
opt.ambiguousLen = 100 * ratio;


% Optional: the half window size for integration in Thextonizer. 
% The default is 24
opt.thextonizerHwSize = 24 * ratio;
