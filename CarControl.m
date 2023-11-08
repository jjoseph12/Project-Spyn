% Car Variables
speed_left_f = 63.5*1.4;
speed_left_b = -63.5*1.4;
speed_left_t = 63.5*1.4;
speed_right_f = 57*1.4;
speed_right_b = -57*1.4;
speed_right_t = 57*1.4;
claw_speed_open = 50;
claw_speed_close = -50;
% f = forward
% b = backward
% t = turning

% Assigned Ports
ultrasonic_sensor = 1;
color_sensor = 2;
touch_sensor = 3;
% % A is the left motor
% % D is the right motor
% % B is the claw motor

% Booleans and States
yellow_found = false;
car_state = 0;
threshold = 50; % Distance threshold for car to act upon

% Timers
reverse_time = 0.5;
left_turn_time = 0.42;
right_turn_time = 0.6;
turn_cooldown = 1;

% Color Sensor setup
brick.SetColorMode(color_sensor, 2);
% % Default = 0
% % Blue = 2
% % Greed = 3
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
                % '/1.4' on all speeds to move slower in manual control
                % hopefully giving us better control in manual
                case 'w' % Move forward
                    brick.MoveMotor('D', speed_right_f/1.4);
                    brick.MoveMotor('A', speed_left_f/1.4);
                case 's' % Move backward
                    brick.MoveMotor('D', speed_right_b/1.4);
                    brick.MoveMotor('A', speed_left_b/1.4);
                case 'a' % Turn left
                    brick.MoveMotor('D', speed_right_t/1.4);
                    brick.StopMotor('A');
                case 'd' % Turn right
                    brick.MoveMotor('A', speed_left_t/1.4);
                    brick.StopMotor('D');
                case 'backspace'
                    brick.StopMotor('ABD', 'Brake');
                case 'c'
                    brick.MoveMotor('B', claw_speed_open);
                case 'z' 
                    brick.MoveMotor('B', claw_speed_close);
                case 'p'
                    car_state = 0;
                case '0'
                    car_state = 0;
            end % key switch end, manual control end
            
        case 0 % Move forward and use sensors
            brick.MoveMotor('D', speed_right_f);
            brick.MoveMotor('A', speed_left_f);
            
            % Information gathering using sensors
            distance = brick.UltrasonicDist(ultrasonic_sensor);
            color = brick.ColorCode(color_sensor);
            pressed = brick.TouchPressed(touch_sensor);
            
            % Sensor Information processing
            if(color == 5) % Color is Red
                disp("Red detected.");
                brick.StopMotor('AD', 'Brake');
                pause(1); % Wait 1 second before resuming

            elseif(color == 4 && yellow_found == false) % Color is Yellow and the passenger HASN'T been picked up
                yellow_found = true;
                brick.StopMotor('AD');
                disp("Yellow detected.");
                disp("!!! Manual control activated !!!");
                car_state = -1;

            elseif(color == 2 && yellow_found == true) % Color is Blue and the passenger HAS been picked up
                brick.StopMotor('AD');
                disp("Blue detected.");
                disp("!!! Manual control activated !!!");
                car_state = -1;
            end
            
            % Turn right if wall isn't sensed and the touch sensor isn't
            % pressed
            if(distance >= threshold && ~pressed)
                disp("No press and Wall not detected - turning right");
                pause(0.25);
                brick.StopMotor('AD', 'Brake');
                brick.MoveMotor('A', speed_left_t);
                pause(right_turn_time); % Turning right
                brick.MoveMotor('D', speed_right_f);
                brick.MoveMotor('A', speed_left_f);
                pause(turn_cooldown); % Moving forward and not instantly turning after first turn
            end
            
            % Turn left if wall is sensed and the touch sensor is pressed
            if(pressed && distance < threshold)
                disp("Press and Wall detected - turning left");
                brick.StopMotor('AD', 'Brake');
                pause(0.2);
                brick.MoveMotor('D', speed_right_b);
                brick.MoveMotor('A', speed_left_b); 
                pause(reverse_time); % Backing away from the wall
                brick.StopMotor('AD', 'Brake');
                brick.MoveMotor('D', speed_right_t); % Turning left
                pause(left_turn_time); % Turn time
            end
            
    end % car_state switch end

    if(key == 'm' || key == '0') % Different kill switch key to end program
        brick.StopAllMotors();
        disp("Stopping program.");
        break;
    end

end % while loop end
CloseKeyboard();