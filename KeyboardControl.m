global key;
InitKeyboard();
pause(1);
speed_right_forward = 57;
speed_left_forward = 63.5;
speed_right_backward = -57;
speed_left_backward = -63.5;
speed_left_turnspeed = 63.5;
speed_right_turnspeed = 57;
claw_speed_open = 40;
claw_speed_close = -40;
color_sensor = 2;
brick.SetColorMode(color_sensor, 2);
% % A is the left motor
% % D is the right motor
while 1
    pause(0.1);
    brick.StopAllMotors();
    
    color = brick.ColorCode(color_sensor);
    if(color == 5) % Color is Red
        disp("Red detected.");
        brick.StopMotor('AD', 'Brake');
        pause(1); % Wait 1 second before resuming

    elseif(color == 2) % Color is Blue
        disp("Blue detected.");
        brick.StopMotor('AD', 'Brake');
        for i = 1:2
            pause(0.2);
            brick.beep();
        end
        brick.MoveMotor('D', speed_right_forward);
        brick.MoveMotor('A', speed_left_forward);
        pause(2);

    elseif(color == 3) % Color is green
        disp("Green detected.");
        brick.StopMotor('AD', 'Brake');
        for i = 1:3
            brick.beep();
            pause(0.2);
        end
        brick.MoveMotor('D', speed_right_forward);
        brick.MoveMotor('A', speed_left_forward);
        pause(2);

    end

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
            break;
    end % key switch end
end
brick.StopMotor('ABD');
CloseKeyboard();