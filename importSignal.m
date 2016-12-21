function [ wave ] = importSignal( opt, plotWave )
%% Import signal from csv file and run a high pass filter of the raw data
%
% Input:
%   plot: if true, plot the signals before and after high-pass filter
%       By default, it is set to false.
%
% Author: Rex
%

if ~exist('plotWave', 'var')
    plotWave = false;
end

%rawData = csvread(, 1, 0);
rawData = csvread([opt.inputFolderName, opt.inputFileName, '.csv'], 1, 0);

fid = fopen([opt.inputFolderName, opt.inputFileName, '.csv']);
[~] = textscan(fid,'%s %s %s %s %s %s %s %s', 1, 'delimiter',',');
fclose(fid);

%% processing

wave = rawData(:, opt.channel);
if plotWave
    figure
    plot(wave);
    title 'original wave'
end

Fs = 10000;

%% High pass
sigma = 100;
% The higher scaling const is, the more precise will the later stage be
% since the transition matrix is based on rounded integer signal strength
wave = highPass(wave, Fs, sigma) * 1e5;

if plotWave
    figure
    plot(wave);
    title 'after high pass'
end






