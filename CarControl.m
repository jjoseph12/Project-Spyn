% Car Variables
speed_right = -40;
speed_left = -38;
speed_claw = 25;

% Assigned Ports
ultrasonic_sensor = 1;
color_sensor = 2;
touch_sensor = 3;
% % A is the right motor
% % D is the left motor
% % B is the claw motor

% Booleans and States
yellow_found = false;
car_state = 0;
threshold = 50;

% Timers
time_reverse = 1;
time_turn_cooldown = 1.5;
timer_turn_cooldown = 0;
time_turn_left = 1;
time_turn_right = 1.25;

% Color Sensor setup
brick.SetColorMode(color_sensor, 2);
% % Key:
% % Default = 0
% % Blue = 2
% % Green = 3
% % Yellow = 4
% % Red = 5

% Keyboard Control Setup
global key; %#ok<GVMIS> %% blocks warning message
InitKeyboard();
brick.beep();

% Navigation
while 1
    pause(0.1);
    switch car_state
        case -1 % Manual control
            brick.StopAllMotors();
            switch key
                case 'w' % Move forward
                    brick.MoveMotor('A', speed_right);
                    brick.MoveMotor('D', speed_left);
                case 's' % Move backward
                    brick.MoveMotor('A', -speed_right);
                    brick.MoveMotor('D', -speed_left);
                case 'a' % Turn left
                    brick.MoveMotor('A', speed_right);
                case 'd' % Turn right
                    brick.MoveMotor('D', speed_left);
                case 'backspace'
                    brick.StopMotor('ABD');
                case 'c' % Claw open
                    brick.MoveMotor('B', speed_claw);
                case 'z' % Claw close
                    brick.MoveMotor('B', -speed_claw);
                case 'p' % Kill switch
                    disp("Exiting manual control!");
                    for i = 1:3
                        pause(0.2);
                        brick.beep();
                    end
                    car_state = 1;
                case '0' % Kill switch
                    disp("Exiting manual contro!");
                    for i = 1:3
                        pause(0.2);
                        brick.beep();
                    end
                    break;
            end
        % End of Case -1
        
        case 0 % Automatic navigation
            brick.MoveMotor('A', speed_right);
            brick.MoveMotor('D', speed_left);
            
            % Information gathering
            distance = brick.UltrasonicDist(ultrasonic_sensor);
            color = brick.ColorCode(color_sensor);
            pressed = brick.TouchPressed(touch_sensor);

            % Information processing
            if(color == 5) % Color is Red
                disp("Red detected.");
                brick.StopMotor('AD', 'Brake');
                pause(1); % Wait 1 second before resuming
                brick.beep();
                brick.MoveMotor('A', speed_right);
                brick.MoveMotor('D', speed_left);
                pause(0.5);
            elseif(color == 4 && yellow_found == false)
                yellow_found = true;
                brick.StopMotor('AD', 'Brake');
                disp("Yellow detected.");
                disp("!!! Manual control activated !!!");
                car_state = -1;
                for i = 1:3
                    pause(0.2);
                    brick.beep();
                end
            elseif(color == 2 && yellow_found == true)
                brick.StopMotor('AD', 'Brake');
                disp("Blue detected.")
                disp("!!! Manual control activated !!!");
                for i = 1:3
                    pause(0.2);
                    brick.beep();
                end
                car_state = -1;
            end

            if(distance > threshold && pressed == false)
                disp("No press and Wall not detected - turning right");
                pause(0.8); % Buffer time to go past the wall
                brick.StopMotor('AD', 'Brake');
                brick.MoveMotor('D', speed_left);
                pause(time_turn_right); % Turning right
                brick.StopMotor('D', 'Brake');
                pause(0.2);
                brick.MoveMotor('A', speed_right);
                brick.MoveMotor('D', speed_left);
                timer_turn_cooldown = tic; % Try to prevent car from ignoring red after turn
                while 1
                    pause(0.1);
                    if(toc(timer_turn_cooldown) >= time_turn_cooldown)
                        break;
                    end
                    color = brick.ColorCode(color_sensor);
                    if(color == 5)
                        brick.StopMotor('AD', 'Brake');
                        pause(1);
                        brick.beep();
                        brick.MoveMotor('A', speed_right);
                        brick.MoveMotor('D', speed_left);
                        pause(0.5);
                    end
                end


            elseif(distance < threshold && pressed == true)
                disp("Press and Wall detected - turning left");
                brick.StopMotor('AD', 'Brake');
                pause(0.2);
                brick.MoveMotor('A', -speed_right);
                brick.MoveMotor('D', -speed_left);
                pause(time_reverse);
                brick.StopMotor('AD', 'Brake');
                brick.MoveMotor('A', speed_right);
                pause(time_turn_left);
                brick.MoveMotor('A', 'Brake');
                pause(0.2);
            end

            % Keeping the car straight
            if(distance >= 21 && distance <= 30)
                brick.StopMotor('A', 'Brake');
                brick.MoveMotor('D', speed_left);
                pause(0.1);
                brick.MoveMotor('A', speed_right);
                pause(0.1);
            elseif(distance <= 17 && distance >= 0)
                brick.StopMotor('D', 'Brake');
                brick.MoveMotor('A', speed_right);
                pause(0.1);
                brick.MoveMotor('D', speed_left);
                pause(0.1);
            end
            
        % End of Case 0

        case 1 % Claw lowering automatically after end of manual control
            brick.MoveMotor('B', -speed_claw);
            pause(2);
            car_state = 0;
        % End of Case 1

    end % End of car_state switch

    if(key == 'm' || key == '0') % Kill Switch
        brick.StopAllMotors();
        disp("Stopping program");
        break;
    end

end
CloseKeyboard();