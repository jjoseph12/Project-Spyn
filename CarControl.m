% Car Variables
speed_right_f = 57*1.4;
speed_left_f = 63.5*1.4;
speed_right_b = -57*1.4;
speed_left_b = -63.5*1.4;
speed_right_t = 57*1.4;
speed_left_t = 63.5*1.4;
claw_speed_open = 50;
claw_speed_close = -50;
% f = forward
% b = backward
% t = turning

% Assigned Ports
color_sensor = 2;
ultrasonic_sensor = 1;
touch_sensor = 3;
% % A is the left motor
% % D is the right motor
% % B is the claw motor

% Booleans and States
yellow_found = false;
car_state = 0;
threshold = 50; % Distance threshold for car to act upon

% Timers
reverse_time = 1;
turn_time = 1;

% Color Sensor setup
brick.setColorMode(color_sensor, 2);
% % Default = 0
% % Blue = 2
% % Yellow = 4
% % Red = 5

% Keyboard control setup
global key; %#ok<GVMIS> %% blocks warning message
InitKeyboard();

% Automatic Navigation
while 1
    pause(0.1);
    switch car_state

        case -1 % Manual control
            brick.StopAllMotors();
            switch key
                case 'w' % Move forward
                    brick.MoveMotor('D', speed_right_forward);
                    brick.MoveMotor('A', speed_left_forward);
                case 's' % Move backward
                    brick.MoveMotor('D', speed_right_backward);
                    brick.MoveMotor('A', speed_left_backward);
                case 'a' % Turn left
                    brick.MoveMotor('D', speed_left_turnspeed);
                    brick.StopMotor('A');
                case 'd' % Turn right
                    brick.MoveMotor('A', speed_right_turnspeed);
                    brick.StopMotor('D');
                case 'backspace'
                    brick.StopMotor('ABD');
                case 'c'
                    brick.MoveMotor('B', claw_speed_open);
                case 'z' 
                    brick.MoveMotor('B', claw_speed_close);
                case 'p'
                    car_state = 0;
            end % key switch end, manual control end
            
        case 0 % Move forward and use sensors
            brick.MoveMotor('D', speed_right_forward);
            brick.MoveMotor('A', speed_left_forward);
            
            % Information gathering using sensors
            distance = brick.UltrasonicDist(ultrasonic_sensor);
            color = brick.ColorCode(color_sensor);
            touched = brick.TouchPressed(touch_sensor);
            
            % Sensor Information processing
            if(color == 5) % Color is Red
                disp("Red detected.");
                brick.StopMotor('AD');
                pause(1); % Wait 1 second before resuming
            elseif(color == 4 && yellow_found == false) % Color is Yellow and the passenger HASN'T been picked up
                yellow_found = true;
                brick.StopMotors('AD');
                disp("Yellow detected.");
                disp("!!! Manual control activated !!!");
                car_state = -1;
            elseif(color == 2 && yellow_found == true) % Color is Blue and the passenger HAS been picked up
                brick.StopMotors('AD');
                disp("Blue detected.");
                disp("!!! Manual control activated !!!");
                car_state = -1;
            end
            
            % Turn right if wall isn't sensed and the touch sensor isn't
            % pressed
            if(distance >= threshold && ~pressed) 
                brick.MoveMotor('D', speed_right_t);
                brick.StopMotor('A');
                pause(turn_time);
            end
            
            % Turn left if wall is sensed and the touch sensor is pressed
            if(pressed && distance < threshold)
                brick.MoveMotor('D', speed_right_backward);
                brick.MoveMotor('A', speed_left_backward); % Back away from the wall
                pause(reverse_time); % Backing away from the wall
    
                brick.MoveMotor('D', speed_right_t); 
                brick.StopMotor('A'); % turning left
                pause(turn_time); % Waiting for turn to complete 
            end
            
    end % car_state switch end

    if(key == 'm') % Different kill switch key to end program
        brick.StopAllMotors();
        break;
    end

end % while loop end
CloseKeyboard();