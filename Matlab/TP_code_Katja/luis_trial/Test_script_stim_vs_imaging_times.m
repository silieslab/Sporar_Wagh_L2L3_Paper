changeFrameTime = zeros(length(ts), 1);
afterFrameTriggers = zeros(length(ts), 1);

for iFrame = 1: length(ts)
    % Check stimulus frames that follow each trigger of start of recording
    % frame.
    afterFrameTriggers(iFrame) = find((stimTimes >= ts(iFrame) ~= 0), 1);
    % Check the first frame time after start trigger.
    changeFrameTime(iFrame) = stimTimes(afterFrameTriggers(iFrame));
end

% Get the recording frames from the stimulus output file correspondinf to
% the first stimulus frame after a start trigger.
transitionFrames = frame_nums(afterFrameTriggers);
% If two consecutive entries of the transition frames are not separated by
% one frame, then there are transition errors.
frameTransitionError = find(diff(transitionFrames) ~= 1);

if ~isempty(frameTransitionError)
    error('Frame transition error!')
end

% Recording frame durations according to the stimulus output file.
frameDuration = diff(changeFrameTime);
meanFrameDuration = mean(frameDuration);
uniqueFrameTimes = unique(frameDuration);

% Retrieve the stimulus times and correspondind frame numbers, for entries
% after the last trigger, and after the putative end fo the last frame.
stimulusAfterLastTrigger = stimTimes >= ts(end);
stimulusAfterLastFrame = stimTimes >= (ts(end) + mean(diff(ts)));

afterLastTriggerStimTimes = stimTimes(stimulusAfterLastTrigger);
afterLastTriggerStimNumbers = frame_nums(stimulusAfterLastTrigger);

afterLastFrameStimTimes = stimTimes(stimulusAfterLastFrame);
afterLastFrameStimNumbers = frame_nums(stimulusAfterLastFrame);

validStimFrames = frame_nums(~stimulusAfterLastFrame);


frameDuration = diff(changeFrameTime);
meanFrameDuration = mean(frameDuration);
uniqueFrameTimes = unique(frameDuration);