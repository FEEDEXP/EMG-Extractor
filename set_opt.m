%% Set options for the EMG extractor
%
% Author: Rex
%

opt = struct;

opt.samplingRate = 10000;
% 10000 Hz was the frequency used when developing the code.
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

% example: Tupaia data: 10; for data that needs high sensitivity, adjust it
% to around 5.
opt.posteriorThreshold = 10;


% we allow this amount of zero entries within the signal for including a 
% silent period. If the gap is
% larger than that, we split the signal into two.
opt.allowedGap = 120 * ratio;

% optional, inferred by default
% signalLenThresh is sensitive to sampling frequency.  A signalLenThresh
% of 1000 will delete all EMG signal that is less than 1000 data points.
% This gets rid of short duration orphan spikes.  A lower signalLenThresh
% is recommended for sampling rates less than 10 Khz.
opt.signalLenThresh = 100;


% the 100 points after offset is considered ambiguous and not included in
% noise during feedback steps
opt.ambiguousLen = 100 * ratio;


% Optional: the half window size for integration in Thextonizer. The default is 24
opt.thextonizerHwSize = 24 * ratio;