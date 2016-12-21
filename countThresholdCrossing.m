function [ nCrossings ] = countThresholdCrossing( signal, threshold, hwSize )
%COUNTTHRESHOLDCROSSING Count the number of crossing of an integrated 
%   signal for a given threshold
%   This is part of the Thextonizer using the same algorithm
%   published in Thexton (1996)

signal = integrateEMG(signal, hwSize);

prev = signal(1: length(signal) - 1);
next = signal(2: length(signal));
nCrossings = sum((prev > threshold & next <= threshold) | (prev < threshold & next >= threshold));

end

