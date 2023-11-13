% Car Variables
speed_right = 63.5 * 1.4;
speed_left = 57 * 1.4;
speed_claw = 50;

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
time_reverse = 0.5;
time_turn_cooldown = 1;
time_turn_left = 0.6;
time_turn_right = 0.42;

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
                case 'c'
                    brick.MoveMotor('B', speed_claw);
                case 'z'
                    brick.MoveMotor('B', -speed_claw);
                case 'p'
                    car_state = 0;
                case '0'
                    car_state = 0;
            end
        
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
            elseif(color == 4 && yellow_found == false)
                yellow_found = true;
                brick.StopMotor('AD', 'Brake');
                disp("Yellow detected.");
                disp("!!! Manual control activated !!!");
                car_state = -1;
            elseif(color == 2 && yellow_found == true)
                brick.StopMotor('AD', 'Brake');
                disp("Blue detected.")
                disp("!!! Manual control activated !!!");
                car_state = -1;
            end

            if(distance >= threshold && pressed == false)
                disp("No press and Wall not detected - turning right");
                pause(0.25); % Buffer time to go past the wall
                brick.StopMotor('AD', 'Brake');
                brick.MoveMotor('D', speed_left);
                pause(time_turn_right); % Turning right
                brick.MoveMotor('A', speed_right);
                brick.MoveMotor('D', speed_left);
                pause(time_turn_cooldown); % Cooldown to prevent a lot of turning
            
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
            end
    end

    if(key == 'm' || key == '0')
        brick.StopAllMotors();
        disp("Stopping program");
        break;
    end
end
CloseKeyboard();