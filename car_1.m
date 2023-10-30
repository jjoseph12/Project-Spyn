
% Car Variables
speed_forward = -57; % Try positive values
speed_backward = -80;
speed_turnspeed = 80;
claw_open_speed = 40;
claw_close_speed = -40;

threshold_distance = 50;  % We might need to calibrate this value

% Ports  Might need to change these values
color_sensor = 2;
ultrasonic_sensor = 1;   % Ultrasonic sensor on the claw (front)

% Booleans and States
person_picked = false;

% Color Sensor setup
brick.SetColorMode(color_sensor, 2);
% Default = 0, Blue = 2, Yellow = 4, Red = 5

while 1
    % Read the sensors
    distance = brick.UltrasonicDist(ultrasonic_sensor);
    color = brick.ColorCode(color_sensor);
    
    % Navigate based on color
    if color == 5 % Red detected
        disp('Red detected. Stopping.');
        brick.StopMotor('AD');
        pause(4);  % Stop for 4 seconds if red detected

    elseif color == 4 && ~person_picked % Yellow detected and person not yet picked
        disp('Yellow detected. Picking up the person.');
        brick.StopMotor('AD');
        brick.MoveMotor('C', claw_close_speed);  % Activate claw to pick up
        pause(2); % Time required for the claw to pick up, adjust as needed
        brick.StopMotor('C');
        person_picked = true;

    elseif color == 2 && person_picked  % Blue detected and person picked
        disp('Blue detected. Dropping off the person.');
        brick.StopMotor('AD');
        brick.MoveMotor('C', claw_open_speed);   % Activate claw to drop off
        pause(2); % Time required for the claw to drop off, adjust as needed
        brick.StopMotor('C');
        person_picked = false;
    else
        brick.MoveMotor('AD', speed_forward);  % Move forward
    end
    
    % Obstacle detection and wall-following using ultrasonic sensor
    if distance < threshold_distance  % If there's an obstacle or wall close by
        disp('Obstacle detected. Turning.');
        brick.StopMotor('AD');
        pause(1);  % Pause before turning
        brick.MoveMotor('A', speed_turnspeed); % Turn left
        brick.StopMotor('D');
        pause(1); % Duration for which it turns, adjust as needed
    end
    pause(0.1);  % Short pause before the next loop iteration
end
