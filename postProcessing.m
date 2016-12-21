function [] = postProcessing(posterior, opt)
% Post-process the posterior (unnormalized) p, together with high passed
% signal wave1.
%
% Pre-requisite: EMG_driver.m
%
% Author: Rex
%

inds = 1: length(wave);
% left and right window size
lwSize = 40;
rwSize = 40;
wSize = lwSize + rwSize + 1;

threshold = -opt.posteriorThreshold;

lscore = zeros(size(posterior));
rscore = zeros(size(posterior));
% onset: p has high value in left window, low value in right window
for i = lwSize + 1: length(posterior) - rwSize
    l = posterior(i - lwSize: i);
    r = posterior(i: i + rwSize);
    lscore(i) = sum(log(l) <= threshold);
    rscore(i) = sum(log(r) <= threshold);
end

if opt.debug
    figure
    subplot(2, 1, 1);
    plot(inds(1: end - 1), lscore);
    subplot(2, 1, 2);
end
posterior = lscore + rscore;
% sign does not matter here
posterior = abs(posterior);
%posterior(posterior == 1) = 0;
if opt.debug
    plot(inds(1: end - 1), posterior);
    title('Posterior');
end
csvwrite([opt.inputFolderName, opt.inputFileName, '-EMG-output.csv'], posterior);

%% Isolate signal regions

% posterior threshold
minSignalPosterior = 7;

% we allow this amount of zero entries within the signal. If the gap is
% larger than that, we split the signal into two.
allowedGap = opt.allowedGap;

nSignalRegions = 0;
onsets = zeros(length(posterior), 1);
offsets = zeros(length(posterior), 1);
inSignal = false;
for i = 1: length(posterior) - allowedGap
    if ~inSignal && posterior(i) > 0
        onsetStart = i;
    end
    seg = posterior(i: i + allowedGap - 1);
    % transfer into signal region
    if ~inSignal && seg(1) >= minSignalPosterior
        inSignal = true;
        nSignalRegions = nSignalRegions + 1;
        
        onsetStart = findGap(posterior, i, allowedGap + 1, 'before');
        onsets(nSignalRegions) = onsetStart;
    % transfer out of signal region:
    % When the values are less than 4 in allowed gap
    % followed by a sequence of zeros
    elseif inSignal && ~any(seg >= minSignalPosterior) %&& ~any(posterior(i + allowedGap: i + allowedGap))
        inSignal = false;
        
        % if the length of this detected signal is too insignificant,
        % discard
        if i - onsets(nSignalRegions) <= wSize
            onsets(nSignalRegions) = 0;
            nSignalRegions = nSignalRegions - 1;
        else
            offsetEnd = findGap(posterior, i, allowedGap + 1, 'after');
            offsets(nSignalRegions) = offsetEnd;
        end
    end
end
if inSignal
    offsets(nSignalRegions) = length(posterior);
end
onsets = onsets(1: nSignalRegions);
offsets = offsets(1: nSignalRegions);


%% Merge chewing cycles / remove outliers
signalLengths = offsets - onsets;

signalLenThresh = opt.signalLenThresh;
% if exist('opt.signalLenThresh', 'var')
%     signalLenThresh = opt.signalLenThresh;
% else
%     signalLenThresh = mean(signalLengths) - 0.5 * std(signalLengths);
% end

ind = 2;
while ind <= length(onsets)
%     if signalLengths(ind-1) < signalLenThresh && signalLengths(ind) > signalLenThresh && ...
%             onsets(ind) - offsets(ind-1) < intervalThresh
    if onsets(ind) - offsets(ind-1) < opt.allowedGap
        offsets(ind-1) = offsets(ind);
        signalLengths(ind-1) = offsets(ind-1) - onsets(ind-1);
        
        signalLengths(ind) = [];
        onsets(ind) = [];
        offsets(ind) = [];
    else
        ind = ind + 1;
    end
end

i = 1;
while i <= length(onsets)
    if offsets(i) - onsets(i) < signalLenThresh
        onsets(i) = [];
        offsets(i) = [];
        signalLengths(i) = [];
    else
        i = i+1;
    end
end

% update based on onsets/offsets
nSignalRegions = length(onsets);

if opt.debug
    figure
    hist(signalLengths);
    title('Histogram of signal lengths');
end

%% categorize signals
mu = mean(signalLengths);
sigma = std(signalLengths);

% max amplitude
maxAmp = zeros(size(signalLengths));
for i = 1: length(signalLengths)
    maxAmp(i) = max(abs(wave(onsets(i): offsets(i))));
end
muMaxAmp = mean(maxAmp);
threshAmp = muMaxAmp - std(maxAmp) * 2;

signalRegionCategories = zeros(size(signalLengths));
for i = 1: length(signalLengths)
    if signalLengths(i) < mu - sigma * 2
        signalRegionCategories(i) = 0;
    end
end

signalLengths = offsets - onsets;

visualizeResults( wave, onsets, offsets, nSignalRegions, signalRegionCategories );

%% save onsets/offsets
csvwrite([opt.inputFolderName, opt.inputFileName, '-Onoff-output.csv'], [onsets, offsets]);
