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
% % C is the claw motor

% Booleans and States
manual_control = false;
yellow_found = false;
car_state = 0;
threshold = 50; % Distance threshold for car to act upon

% Timers
timer_reverse = 0;
timer_turn = 0;
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
            disp("!!! Manual control activated !!!");
            switch key
                case 'w' % Move forward
                    brick.MoveMotor('AD', speed_forward);
                case 's' % Move backward
                    brick.MoveMotor('AD', speed_backward);
                case 'a' % Turn left
                    brick.MoveMotor('A', speed_turnspeed);
                    brick.StopMotor('D');
                case 'd' % Turn right
                    brick.MoveMotor('D', speed_turnspeed);
                    brick.StopMotor('A');
                case 'backspace'
                    brick.StopMotor('AD');
                case 'c'
                    brick.MoveMotor('C', speed_claw_open);
                case 'z' 
                    brick.MoveMotor('C', speed_claw_close);
                case 'p'
                    break;
            end % key switch end
            
        case 0 % Move forward and sense
            brick.MoveMotor('AD', speed_forward); % Automatically moves forward
  
            distance = brick.UltrasonicDist(ultrasonic_sensor);
            color = brick.ColorCode(color_sensor);
            touched = brick.TouchPressed(touch_sensor);
            
            if(color == 5) % Color is Red
                disp("Red detected.");
                car_state = 1;

            elseif(color == 4 && yellow_found == false) % Color is Yellow and the passenger HASN'T been picked up
                yellow_found = true;
                brick.StopMotors('AD');
                disp("Yellow detected.");
                car_state = -1;

            elseif(color == 2 && yellow_found == true) % Color is Blue and the passenger HAS been picked up
                brick.StopMotors('AD');
                disp("Blue detected.");
                car_state = -1;
            end

            if(touched)
                disp("Touch was sensed.");
                car_state = 2;
            end

        

        case 1 % Red detected case
            brick.StopMotor('AD');
            pause(1); % Wait 1 second before resuming
            car_state = 0; 

        case 2 % Touch sensed case
            brick.MoveMotor('AD', speed_backwards); % Back away from the wall
            timer_reverse = tic;
            if(toc(timer_reverse) >= reverse_time)
                brick.MoveMotor('D', speed_turnspeed); % Turn right
                brick.StopMotor('A'); % Turn right
                timer_turn = tic;
                if(toc(timer_turn) >= turn_timer)
                    car_state = 0;
                    timer_reverse = 0;
                    timer_turn = 0;
                end
            end
        
        case 3 % Ultrasonic sensor - wall close case
            brick.MoveMotor('AD', speed_backwards); % Back away from the wall
            timer_reverse = tic;
            if(toc(timer_reverse) >= reverse_time)
                brick.MoveMotor('D', speed_turnspeed); % Turn right
                brick.StopMotor('A'); % Turn right
                timer_turn = tic;
                if(toc(timer_turn) >= turn_timer)
                    car_state = 0;
                    timer_reverse = 0;
                    timer_turn = 0;
                end
            end

            
            
        
    end % car_state switch end
     
    if(key == 'p')
        brick.StopMotors('ACD');
        break;
    end

end % while loop end
CloseKeyboard();