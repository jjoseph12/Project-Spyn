%ConnectToEV3

brick = ConnectBrick('GROUP3');   % Name of our brick, Done once in the beginning of class 

%% Example 1: Play Tone and Get Battery Level
% Play tone with frequency 800Hz and duration of 500ms.

brick.playTone(30, 800, 100);
% Get current battery level.
disp(brick.GetBattVoltage());
