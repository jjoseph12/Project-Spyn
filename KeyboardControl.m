global key;
InitKeyboard();
pause(1);
speed_right_forward = 57*1.4;
speed_left_forward = 63.5*1.4;
speed_right_backward = -57*1.4;
speed_left_backward = -63.5*1.4;
speed_left_turnspeed = 63.5*1.4;
speed_right_turnspeed = 57*1.4;
claw_speed_open = 40;
claw_speed_close = -40;
% % A is the left motor
% % D is the right motor
while 1
    pause(0.1);
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
            break;
    end % key switch end
end
brick.StopMotor('ABD');
CloseKeyboard();