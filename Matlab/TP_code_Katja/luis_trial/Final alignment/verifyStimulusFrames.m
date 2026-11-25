function validStimFrames = verifyStimulusFrames(frame_nums, stimTimes, ts);
%marion: I believe that this is not the correct way to do this, because it'
%relying on a precise and synchronized timing of the stimulus and the
%imaging computer. Checked on falsified on an example.

    changeFrameTime = zeros(length(ts), 1);
    afterFrameTriggers = zeros(length(ts), 1);

    for iFrame = 1: length(ts)
        % Check stimulus frames that follow each trigger of start of recording
        % frame.
        afterFrameTriggers(iFrame) = find((stimTimes >= ts(iFrame) ~= 0), 1); %ms: time where timing from stimulus output exceeds relativeFrameTimes (from images), every 6th or 7th instance
        % Check the first frame time after start trigger.
        changeFrameTime(iFrame) = stimTimes(afterFrameTriggers(iFrame)); %ms: time (from stimulus output file) where frame is changing
    end

    % Get the recording frames from the stimulus output file correspondinf to
    % the first stimulus frame after a start trigger.
    transitionFrames = frame_nums(afterFrameTriggers); %ms: frame numbers from stimulus output file at the time where timing from stimulus output exceeds relativeFrameTimes (from images)
    % If two consecutive entries of the transition frames are not separated by
    % one frame, then there are transition errors.
    frameTransitionError = find(diff(transitionFrames) ~= 1, 1);

% % %     if ~isempty(frameTransitionError)
% % %         warning('Frame transition error!') %can just happen because
% clocks running off
% % %     end

    % Recording frame durations according to the stimulus output file.
%     frameDuration = diff(changeFrameTime);
%     meanFrameDuration = mean(frameDuration);
%     uniqueFrameTimes = unique(frameDuration);

    % Retrieve the stimulus times and correspondind frame numbers, for entries
    % after the last trigger, and after the putative end fo the last frame.
%     stimulusAfterLastTrigger = stimTimes >= ts(end);
    stimulusAfterLastFrame = stimTimes >= (ts(end) + mean(diff(ts)));
% 
%     afterLastTriggerStimTimes = stimTimes(stimulusAfterLastTrigger);
%     afterLastTriggerStimNumbers = frame_nums(stimulusAfterLastTrigger);
% 
%     afterLastFrameStimTimes = stimTimes(stimulusAfterLastFrame);
%     afterLastFrameStimNumbers = frame_nums(stimulusAfterLastFrame);
    
    stimulusBeforeLastFrame = frame_nums(~stimulusAfterLastFrame);
    validStimFrames = frame_nums(stimulusBeforeLastFrame <= numel(ts));
    validStimFrames = unique(validStimFrames);
end