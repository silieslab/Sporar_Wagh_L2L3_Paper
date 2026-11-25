function trialAveragedNormalizedROIs = trialAverageAndNormalizeArray_ks(genotypeStimArray, targetTimes)

nTrials = 5;
lastTimePoint = find(targetTimes < 150, 1, 'last');
trialLength = floor(lastTimePoint / nTrials);
trialAveragedNormalizedROIs = zeros(size(genotypeStimArray, 2), trialLength);
for iCell = 1: size(genotypeStimArray, 2)
    thresholdPoints = find(genotypeStimArray(1:lastTimePoint, iCell) < min(genotypeStimArray(1:lastTimePoint, iCell))*1.5);
    
    if ~isempty(thresholdPoints)
        realThresholdPoint = [thresholdPoints((diff(thresholdPoints)) > mean(diff(thresholdPoints))); thresholdPoints(end)];
        realThresholdPoint(realThresholdPoint < floor(0.4* trialLength/3) | ...
                           realThresholdPoint > lastTimePoint - floor(0.4* trialLength/3)) = [];
    else
        realThresholdPoint = [];
    end
% 
%     figure; plot(genotypeStimArray(1:lastTimePoint, iCell))
%     hold on;
%     plot(thresholdPoints, genotypeStimArray(thresholdPoints, iCell), 'ro')
%     plot(realThresholdPoint, genotypeStimArray(realThresholdPoint, iCell), 'ms', 'markerFaceColor', [1 0 1])
%     pause(0.5)
%     close gcf
    
    cellTrials = reshape(genotypeStimArray(1:lastTimePoint, iCell), [], nTrials);
    if numel(realThresholdPoint) ~= nTrials
        warning('Houston, we have a problem, trials undetected!');
        for iTrial = 1: nTrials
            [~, peakIndex] = max(xcorr(cellTrials(:, iTrial), cellTrials(:, 1)));
            offset = peakIndex - trialLength;
            cellTrials(:, iTrial) = circshift(cellTrials(:, iTrial), offset);
        end
    else
        offsets = cumsum(diff(realThresholdPoint - [0:trialLength:(lastTimePoint - trialLength)]'));
%         figure; subplot(2,1,1);imagesc(cellTrials') % Show image before alignment.
        for iTrial = 1: nTrials - 1
            cellTrials(:, iTrial + 1) = circshift(cellTrials(:, iTrial+1), -offsets(iTrial));
        end
%         subplot(2,1,2);imagesc(cellTrials');pause(1);close % Show image after alignment.
    end

    baselines = nanmean(cellTrials(floor(0.4* trialLength/3):floor(0.9* trialLength/3), :), 1);
    normalizedROI = bsxfun(@rdivide, bsxfun(@minus, cellTrials, baselines), baselines);
    trialAverage = nanmean(normalizedROI, 2);
    if any(isnan(trialAverage)) %|| max(abs(trialAverage)) > 1
        trialAverage = nan(size(trialAverage));
    end
    pulseTimes = targetTimes(1:length(trialAverage)) >= 9.95 & targetTimes(1:length(trialAverage)) <= 10.75;
    trialAverage(pulseTimes) = 0;
    trialAveragedNormalizedROIs(iCell, :) = trialAverage';
end

end