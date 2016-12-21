function [ onsets, offsets ] = post_thextonizer( isSignal )
%POST_THEXTONIZER 
%   This script allows you to run Thextonizer separately so that
%   you can get the visualization
%   Not called up as part of the EMG-Extractor when running
%   the EMG_driver script

nSignals = 0;
i = 1;
while i <= length(isSignal)
    if isSignal(i) == 1
        nSignals = nSignals + 1;
        onsets(nSignals) = i;
        while isSignal(i) == 1
            i = i + 1;
        end
        offsets(nSignals) = i - 1;
    end
    i = i + 1;
end



end

