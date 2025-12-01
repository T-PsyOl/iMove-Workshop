function keyboardEventScript()
% KEYBOARDSCRIPT  Stream keyboard events via LabStreamingLayer (LSL).
%
%   KEYBOARDSCRIPT() creates an LSL outlet that sends keyboard press and
%   release events as string markers. A simple MATLAB figure window is used
%   to capture key press and key release events. Each event is transmitted
%   as a single string through a one-channel LSL stream of type 'Markers'.
%
%   The function blocks execution until the figure window is closed.
%
% -------------------------------------------------------------------------
% IMPORTANT DISCLAIMER
%   This tool is provided for prototyping and testing purposes only.
%   **It does NOT guarantee accurate or high-precision timing of events.**
%   Event timestamps depend on MATLAB's UI callbacks, OS scheduling,
%   keyboard latency, and GUI refresh rates, and are therefore not suitable
%   for time-critical experimental paradigms.
%
% -------------------------------------------------------------------------
% PURPOSE
%   This script enables rapid testing of keyboard-based event markers in
%   LabStreamingLayer-based setups. It is useful for validating software
%   pipelines, debugging experimental logic, and replacing hardware
%   triggers during early-stage development.
%
% -------------------------------------------------------------------------
% STREAM DETAILS
%   Name:       'keyboard'
%   Type:       'Markers'
%   Channels:    1 (string)
%   Format:     'cf_string'
%   Sampling:    Irregular (event-based)
%   Source ID:  'keyboard-HOSTNAME'
%
%   Press events are sent as:
%       'pressed<keyname>'
%   Release events are sent as:
%       'released<keyname>'
%
% -------------------------------------------------------------------------
% USAGE
%   keyboardScript
%
%   Close the figure window to stop the stream.
%
% -------------------------------------------------------------------------
% EXAMPLE
%   % Start keyboard LSL stream in MATLAB:
%   keyboardScript;
%
%   % In another LSL client:
%   %   - Resolve the 'keyboard' stream
%   %   - Receive strings such as 'presseda', 'releasedspace', etc.
%
% -------------------------------------------------------------------------
% REQUIREMENTS
%   - MATLAB
%   - LabStreamingLayer (LSL) MATLAB bindings
%
% -------------------------------------------------------------------------
% AUTHOR
%   Martin Bleichner, 2025
%   Created by Martin Bleichner. Please cite appropriately when used.
%
% -------------------------------------------------------------------------
% VERSION
%   v1.0  | Initial release
%
% -------------------------------------------------------------------------
% LICENSE
%   You may insert a license here (MIT, BSD, GPL, etc.).
%
% -------------------------------------------------------------------------
% See also: lsl_loadlib, lsl_outlet, figure, KeyPressFcn
% -------------------------------------------------------------------------

    % Create LSL stream outlet
    disp('Creating LSL stream...');
    lib = lsl_loadlib();
    if ispc
        host = getenv('COMPUTERNAME');
    else
        host = getenv('HOSTNAME');
    end
    info = lsl_streaminfo(lib, ...
        'keyboard', ...              % stream name
        'Markers', ...               % stream type
        1, ...                       % only 1 channel: event label
        0, ...                       % irregular sampling
        'cf_string', ...
        ['keyboard-' host]);         % source ID

    outlet = lsl_outlet(info);
    disp('LSL stream "KeyboardEvents" started.');

    % Create figure to capture key events
    fig = figure('Name','Keyboard LSL Stream', ...
                 'KeyPressFcn',@onKeyPress, ...
                 'KeyReleaseFcn',@onKeyRelease, ...
                 'CloseRequestFcn',@onClose);

    uiwait(fig); % block until figure closes

    % --- callbacks ---
    function onKeyPress(~, event)
        key = event.Key;
        label = ['pressed' key];
        outlet.push_sample({label});
        fprintf('Pressed: %s\n', key);
    end

    function onKeyRelease(~, event)
        key = event.Key;
        label = ['released' key];
        outlet.push_sample({label});
        fprintf('Released: %s\n', key);
    end

    function onClose(src, ~)
        delete(src);
        disp('Keyboard LSL stream stopped.');
    end
end
