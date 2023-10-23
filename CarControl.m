% Car Variables
speed_forward = 80;
speed_backward = -80;
speed_turnspeed = 80;
claw_speed_open = 40;
claw_speed_close = -40;

% Assigned Ports
color_sensor = 1;
ultrasonic_sensor = 2;
touch_sensor = 3;
% % A is the left motor
% % D is the right motor

% Booleans and States
manual_control = false;
yellow_found = false;
car_state = 0;

% Color Sensor setup
brick.setColorMode(color_sensor, 2);
% % Default = 0
% % Blue = 2
% % Yellow = 4
% % Red = 5

% Automatic Navigation
while 1
    pause(0.1);
    switch car_state
        case 0
            brick.MoveMotor('AD', speed_forward); % Automatically moves forward
    
            % Ultrasonic Sensor
            distance = brick.UltrasonicDist(ultrasonic_sensor);
            
            % Color Sensor
            color = brick.ColorCode(color_sensor);
            if(color == 5) % Color is Red
                disp("Red detected.");
                car_state = 1;
            end

            % Touch Sensor
            if(brick.TouchPressed(touch_sensor))
                disp("Touch was sensed.");
                car_state = 2;
            end

        case 1 % Red detected case
            brick.StopMotor('AD');
            pause(1); % Wait 1 second before resuming
            car_state = 0; 

        case 2 % Touch sensed case
            brick.MoveMotor('AD', speed_backwards); % Back away from the wall
            pause(1);
            brick.MoveMotor('D', speed_turnspeed); % Turn right
            brick.StopMotor('A'); % Turn right
            pause(1);
            car_state = 0;
            
        
    end
    
    
end