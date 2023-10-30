%{
ports:
ultrasonic: 1
color: 2
left motor:  A
right motor: D
%}

motorlf = -57;   %A
motorrf = -54.8; %D

threshold = 30; % Adjusted for a quicker reaction to walls

brick.SetColorMode(2, 2);

while 1
    % Default movement: Move Forward
    brick.MoveMotor('A', motorlf);
    brick.MoveMotor('D', motorrf);
    
    % Sensor Readings
    color = brick.ColorCode(2);
    distance = brick.UltrasonicDist(1);

    % Color Decisions
    if color == 5 % if color is red, stop for 4 sec
        disp('Red detected. Stopping for 4 seconds.');
        brick.StopMotor('AD', 'Brake');
        pause(4); 
        brick.MoveMotor('A', motorlf); 
        brick.MoveMotor('D', motorrf);
        pause(0.5);
    elseif color == 2 || color == 3 % if color is blue or green, activate keyboard control
        disp('Blue/Green detected. Activating keyboard control.');
        run('kbrdcontrol');
        brick.MoveMotor('A', motorlf);
        brick.MoveMotor('D', motorrf);
        pause(6);
    end

    % Navigation using Right-hand rule
    if distance > threshold 
        % No wall on the right - turn right
        brick.MoveMotor('A', motorlf/2); % Half speed for left motor
        brick.MoveMotor('D', motorrf*2); % Double speed for right motor
        pause(1); % Adjust pause as per turning requirement
    elseif distance < 10 % Assume 10 units is "too close" to a wall in front
        % Wall in front - turn left
        disp('Close obstruction detected. Turning left.');
        brick.MoveMotor('A', motorlf*2); % Double speed for left motor
        brick.MoveMotor('D', motorrf/2); % Half speed for right motor
        pause(1);
    end
end
