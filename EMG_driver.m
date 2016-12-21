
%% Script to classify noise from EMG signals
%
%  Author: Rex Ying
%  Please cite: Ying R and Wall CE (2016)A method for discrimination of
%  noise and EMG signal regions recorded during rhythmic behaviors.
%  Journal of Biomechanics 49:4113 http://dx.doi.org/10.1016/j.jbiomech.2016.10.010

% Change the name of the input csv file
% The first column of the file 
set_opt;
filename = opt.inputFileName;

wave = importSignal(opt);
p = noiseModel(wave, opt, false, true);
[onsets, offsets] = postProcessing(wave, p, opt);

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

p = noiseModel(wave, opt, false, true, noiseAll, noiseIntervals);
[onsets, offsets] = postProcessing(wave, p, opt);
