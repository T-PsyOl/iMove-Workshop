% KEYBOARD XDF SONIFICATION TOOL
% -------------------------------------------------------------
% This script loads one or more keyboard-based LSL streams from an XDF file, 
% extracts press/release events, visualizes the performance of each participant, 
% aligns the time axes across streams, and generates an audio sonification 
% (individual and mixed).
%
% The tool also includes a synchrony analysis between participants, producing 
% pairwise and overall asynchrony measures, as well as a matrix visualization.
%
% -------------------------------------------------------------
% PURPOSE
%   - Visualize multi-person keyboard performances recorded via LSL
%   - Align participants on a shared time axis
%   - Sonify individual streams and create a mixed audio rendering
%   - Compute synchrony/asynchrony between participants
%   - Provide combined raster-like plots of note durations
%
% -------------------------------------------------------------
% INPUT
%   User is prompted to select an *.xdf file containing:
%       * At least one LSL stream with keyboard markers
%       * Events encoded as strings, e.g.: 
%             "pressed C"   or   "released G"
%
% -------------------------------------------------------------
% OUTPUT / VISUALIZATIONS
%   1) Per-participant note-duration plot (press → release)
%   2) Combined multi-participant plot with slight vertical offsets
%   3) Mixed sonification of all players
%   4) Pairwise mean asynchrony matrix
%   5) Console output showing synchrony estimates
%
% -------------------------------------------------------------
% SONIFICATION
%   Each note (C–B) is mapped to a frequency:
%       C=261.63, D=293.66, E=329.63, F=349.23,
%       G=392.00, A=440.00, B=493.88 Hz
%
%   Durations are taken from:
%       release_time - press_time
%   A short linear fade-in/out is added to reduce artifacts.
%
% -------------------------------------------------------------
% TIME ALIGNMENT
%   All participants' timestamps are aligned by subtracting the earliest 
%   press event across all streams (t0). This ensures a consistent shared
%   time axis, enabling direct visual and auditory comparison.
%
% -------------------------------------------------------------
% REQUIREMENTS
%   - MATLAB
%   - LabStreamingLayer XDF loader (load_xdf)
%   - "sound" function available on system
%   - XDF files with keyboard marker streams
%
% -------------------------------------------------------------
% LIMITATIONS
%   - No guarantee of accurate or high-precision timing in source streams
%   - If streams use inconsistent event naming, parsing may fail
%   - Some variables (e.g., "fmtHit") must exist or be corrected by user
%   - Sonification is purely illustrative and not musically precise
%
% -------------------------------------------------------------
% AUTHOR
%   Martin Bleichner, 2025
%   Created by Martin Bleichner for multi-user keyboard LSL visualization 
%   and audio rendering. Please cite appropriately where used.
%
% -------------------------------------------------------------
% VERSION
%   v1.0 (2025-01)
%
% -------------------------------------------------------------
% See also:
%   load_xdf, sound, figure, LSL, synchrony analysis
% -------------------------------------------------------------
clear; clc;

%% --- 1. Load XDF ---
[fname, fpath] = uigetfile('*.xdf', 'Select XDF File');
if isequal(fname,0)
    error('No file selected.');
end

file = fullfile(fpath, fname);
fprintf('Loading XDF file: %s\n', file);

[data] = load_xdf(file);

%% --- 2. Identify keyboard streams (by name) ---
% Robust stream detection: match either 'Keyboard' OR channel format 'string'

isKeyboard = false(1, numel(data));
keyIndex = [];

for i = 1:numel(data)
    s = data{i}.info;

    nameHit = (isfield(s,'name') && contains(lower(s.name), 'keyboard'));
    typeHit = (isfield(s,'type') && contains(lower(s.type), 'keyboard'));
    % mark as keyboard stream if any condition matches

    isKeyboard(i) = nameHit || typeHit || fmtHit;
    keyIndex = [keyIndex i];
end

nStreams = numel(keyIndex);
fprintf('\nFound %d keyboard streams.\n', nStreams);

% --- 3. Tone → number mapping (for plot) ---
toneMap = containers.Map( ...
    {'C','D','E','F','G','A','B', ...
     'c','d','e','f','g','a','b'}, ...
    [1 2 3 4 5 6 7, ...
     1 2 3 4 5 6 7] );

%% --- 4. Prepare figure ---
figure; clf; set(gcf,'Color','w');

% --- 5. Process each stream ---
all_pressTimes   = {};
all_releaseTimes = {};
all_toneVals     = {};

for s = keyIndex

    stream = data{s};

    % time stamps
    t = stream.time_stamps;

    % events: cell array of strings like "C pressed"
    evt = stream.time_series;
    if iscell(evt)
        evtStrings = evt;
    else
        evtStrings = cellstr(evt); % fallback
    end

    nEvents = numel(evtStrings);
    fprintf('Stream %d (%s %): %d events\n', ...
        s, stream.info.name, stream.info.hostname, nEvents);

    % containers for presses/releases
    pressTimes   = [];
    pressTones   = {};
    releaseTimes = [];
    releaseTones = {};
    
    % --- Parse each event ---
    for k = 1:nEvents
        str = evtStrings{k};     % e.g. "C pressed"
        parts = split(str);      % {"C", "pressed"}
        action = parts{1};
        tone   = parts{2};

        if strcmpi(action, 'pressed')
            pressTimes(end+1) = t(k);
            pressTones{end+1} = tone;
        elseif strcmpi(action, 'released')
            releaseTimes(end+1) = t(k);
            releaseTones{end+1} = tone;
        end
    end

    % Pair presses to releases
    nNotes = min(length(pressTimes), length(releaseTimes));

    toneVals = zeros(1, nNotes);
    for k = 1:nNotes
        tone = pressTones{k};
        if isKey(toneMap, tone)
            toneVals(k) = toneMap(tone);
        else
            toneVals(k) = NaN;
        end
    end

    all_pressTimes{s}   = pressTimes;
    all_releaseTimes{s} = releaseTimes;
    all_toneVals{s}     = toneVals;

    % --- Plot single participant ---
    subplot(nStreams,1,s);
    hold on;

    for k = 1:nNotes
        if isnan(toneVals(k)), continue; end

        plot([pressTimes(k), releaseTimes(k)], ...
             [toneVals(k),  toneVals(k)], ...
             'LineWidth', 4);
    end

    ylim([0.5 7.5]);
    yticks(1:7);
    yticklabels({'C','D','E','F','G','A','B'});
    xlabel('Time (s)');
    ylabel('Tone');
    title(sprintf('Participant %d (%s)', s, stream.info.name), ...
        'Interpreter','none');
end

%% --- 6. Combined Plot of All Participants ---
figure; clf; set(gcf,'Color','w');
hold on;

colors = lines(nStreams);   % distinct colors
yOffsetScale = 0.12;        % adjust vertical jitter strength

legendHandles = gobjects(1, nStreams);

for idx = 1:length(keyIndex)
    s = keyIndex(idx);
    thisColor = colors(idx,:);

    p = all_pressTimes{s};
    r = all_releaseTimes{s};
    v = all_toneVals{s};

    % per-participant y-offset
    yOffset = (idx - mean(1:length(keyIndex))) * yOffsetScale;

    % plot first segment with handle for the legend
    firstPlotted = false;

    for k = 1:numel(v)
        if isnan(v(k)), continue; end

        yVal = v(k) + yOffset;

        h = plot([p(k), r(k)], [yVal, yVal], ...
                 'LineWidth', 4, ...
                 'Color', thisColor);

        if ~firstPlotted
            legendHandles(idx) = h;
            firstPlotted = true;
        end
    end
end

ylim([0.5 7.5]);
yticks(1:7);
yticklabels({'C','D','E','F','G','A','B'});
xlabel('Time (s)');
ylabel('Tone');
title('All Participants Combined');

legend(legendHandles, ...
       arrayfun(@(s) sprintf('P%d', s), keyIndex, 'UniformOutput', false), ...
       'Location','best');

hold off;

%% --- 7. Sonify Participants and Mix ---
fs = 44100;
toneFreqs = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88];
participantAudio = cell(1, nStreams);

allStartTimes = [];
for s = keyIndex
    allStartTimes = [allStartTimes, all_pressTimes{s}];
end
t0 = min(allStartTimes);

% subtract t0 from all times
for s = keyIndex
    all_pressTimes{s}   = all_pressTimes{s} - t0;
    all_releaseTimes{s} = all_releaseTimes{s} - t0;
end

allEndTimes = [];
for s = keyIndex
    allEndTimes = [allEndTimes, all_releaseTimes{s}];
end
allEndTimes = allEndTimes - allEndTimes(1);

totalDuration = ceil(max(allEndTimes)) + 0.5;
tAudio = 0:1/fs:totalDuration;
fadeSamples = round(0.01 * fs);

% --- Generate participant audio ---
for s = keyIndex
    y = zeros(size(tAudio));
    p = all_pressTimes{s};
    r = all_releaseTimes{s};
    v = all_toneVals{s};

    for k = 1:numel(v)
        if isnan(v(k)), continue; end

        freq = toneFreqs(v(k));
        dur  = r(k) - p(k);
        if dur <= 0, dur = 0.1; end
        tNote = 0:1/fs:dur;
        noteWave = 0.3 * sin(2*pi*freq*tNote);
        % alternative using harmonics
        %noteWave = 0.3*( ...
        %    1.00 * sin(2*pi*freq*1*tNote)  ... fundamental
        %    + 0.50 * sin(2*pi*freq*2*tNote)  ... 2nd harmonic
        %    + 0.30 * sin(2*pi*freq*3*tNote)  ... 3rd harmonic
        %    + 0.15 * sin(2*pi*freq*4*tNote)  ... 4th harmonic
        %    );
        startIdx = round(p(k)*fs) + 1;
        endIdx   = startIdx + length(noteWave) - 1;
        if endIdx > length(y)
            endIdx = length(y);
            noteWave = noteWave(1:(endIdx-startIdx+1));
        end

        n = length(noteWave);
        fade = ones(1,n);
        fade(1:min(fadeSamples,n)) = linspace(0,1,min(fadeSamples,n));
        fade(end-min(fadeSamples,n)+1:end) = linspace(1,0,min(fadeSamples,n));
        noteWave = noteWave .* fade;

        y(startIdx:endIdx) = y(startIdx:endIdx) + noteWave;
    end

    participantAudio{s} = y;
end

% --- Mix participants ---
mixedAudio = zeros(size(tAudio));
for s = keyIndex
    mixedAudio = mixedAudio + participantAudio{s};
end

mixedAudio = mixedAudio / max(abs(mixedAudio));

% --- Play mixed audio ---
sound(mixedAudio, fs);
sound(participantAudio{1}, fs);

%% --- 8. Synchrony analysis ---
nPlayers = length(keyIndex);
pairwiseAsynchrony = [];

for i = 1:nPlayers-1
    for j = i+1:nPlayers
        timesA = all_pressTimes{keyIndex(i)};
        timesB = all_pressTimes{keyIndex(j)};

        diffsA = arrayfun(@(t) min(abs(timesB - t)), timesA);
        diffsB = arrayfun(@(t) min(abs(timesA - t)), timesB);

        allDiffs = [diffsA, diffsB];
        meanDiff = mean(allDiffs);
        pairwiseAsynchrony(end+1) = meanDiff;

        fprintf('Mean asynchrony P%d-P%d: %.3f s\n', keyIndex(i), keyIndex(j), meanDiff);
    end
end

overallMeanAsynchrony = mean(pairwiseAsynchrony);
fprintf('Overall mean asynchrony across all participants: %.3f s\n', overallMeanAsynchrony);

%% --- 9a. Pairwise asynchrony matrix ---
nPlayers = length(keyIndex);
asynchMat = zeros(nPlayers);

for i = 1:nPlayers-1
    for j = i+1:nPlayers
        timesA = all_pressTimes{keyIndex(i)};
        timesB = all_pressTimes{keyIndex(j)};

        diffsA = arrayfun(@(t) min(abs(timesB - t)), timesA);
        diffsB = arrayfun(@(t) min(abs(timesA - t)), timesB);
        allDiffs = [diffsA, diffsB];

        meanDiff = mean(allDiffs);
        asynchMat(i,j) = meanDiff;
        asynchMat(j,i) = meanDiff;
    end
end

figure;
imagesc(asynchMat);
colorbar;
axis square;
xticks(1:nPlayers); yticks(1:nPlayers);
xticklabels(arrayfun(@(s) sprintf('P%d', s), keyIndex, 'UniformOutput', false));
yticklabels(arrayfun(@(s) sprintf('P%d', s), keyIndex, 'UniformOutput', false));
title('Pairwise mean asynchrony (s)');
