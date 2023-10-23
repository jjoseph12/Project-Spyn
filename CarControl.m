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

% Timers
timer_reverse = 1;
timer_turn = 1;

% Color Sensor setup
brick.setColorMode(color_sensor, 2);
% % Default = 0
% % Blue = 2
% % Yellow = 4
% % Red = 5

% Keyboard control setup
global key;
InitKeyboard();

% Automatic Navigation
while 1
    pause(0.1);
    switch car_state

        case -1 % Manual control
            disp("Manual control activated");
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
  
        case 0 % Move forward and sense
            brick.MoveMotor('AD', speed_forward); % Automatically moves forward
    
            % Ultrasonic Sensor
            distance = brick.UltrasonicDist(ultrasonic_sensor);
            % % May need to implement more for the ultrasonic sensor but idk
            
            % Color Sensor 
            color = brick.ColorCode(color_sensor);
            if(color == 5) % Color is Red
                disp("Red detected."); % This might infinite loop the car because of distance
                car_state = 1;
            end
            
            if(color == 4 && yellow_found == false) % Color is Yellow and the passenger HASN'T been picked up
                yellow_found = true;
                brick.StopMotors('AD');
                disp("Yellow detected.");
                car_state = -1;
            end
            
            if(color == 2 && yellow_found == true) % Color is Blue and the passenger HAS been picked up
                brick.StopMotors('AD');
                disp("Blue detected.");
                car_state = -1;
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
            pause(timer_reverse);
            brick.MoveMotor('D', speed_turnspeed); % Turn right
            brick.StopMotor('A'); % Turn right
            pause(timer_turn);
            car_state = 0;
            
        
    end
    if(key == 'p')
        brick.StopMotors('AD');
        break;
    end
    
end
CloseKeyboard();