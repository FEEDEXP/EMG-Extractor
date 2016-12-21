
%% Script to classify noise from EMG signals
%
% Author: Rex Ying
%

% Change the name of the input csv file
% The first column of the file 
set_opt;
filename = opt.inputFileName;

wave = importSignal(opt);
p = noiseModel(wave, false, true);
postProcessing(p, opt);

%% Feedback
noiseAll = [];

ambiguousLen = opt.ambiguousLen;
for i = 1: length(offsets) - 1
    if (onsets(i+1) - offsets(i) < 2 * ambiguousLen)
        continue;
    end
    noiseAll = [noiseAll; wave(offsets(i) + ambiguousLen: onsets(i + 1) - ambiguousLen)]; %#ok<AGROW>
end

% noise intervals
noiseIntervals = [offsets(1: length(offsets) - 1) + ambiguousLen, onsets(2: length(onsets)) - ambiguousLen];

p = noiseModel(wave, false, true, noiseAll, noiseIntervals);
post_processing
