function [ noiseIntervals ] = roughNoise( emg, allowedGap, hwSize )
%ROUGHNOISE Roughly identify the noise region used to build noise model
%   
%   Return: 
%   noiseRegions: [n-by-2] matrix. Each row represents a noise interval
%   using the indices of the interval end points
%
%   Reference: 
%   A randomisation method for discriminating between signal and noise in recordings 
%   of rhythmic electromyographic activity.
%   A.J. Thexton (1996) Journal of Neuroscience Methods 66:93-98
%   This is the Thextonizer

if exist('hwSize', 'var')
    [ threshold, ~ ] = thextonizer( emg, allowedGap, hwSize );
else
    [ threshold, ~ ] = thextonizer( emg, allowedGap );
end
fprintf('Threshold set at: %d\n', threshold);

%% use threshold to find noise regions

%hwSize = 24;
%emg = integrateEMG(emg, hwSize);

isNoise = emg < threshold;
if ~isrow(isNoise)
    isNoise = isNoise';
end
% a noise region has to be of length at least minDuration
minDuration = 200;

diffNoise = diff([0, isNoise, 0]);
startIndex = find(diffNoise > 0) + 30;
endIndex = find(diffNoise < 0) - 1 - 30;
duration = endIndex-startIndex+1;

rmIntervals = duration < minDuration;
startIndex(rmIntervals) = [];
endIndex(rmIntervals) = [];

noiseIntervals = [startIndex', endIndex'];

end

