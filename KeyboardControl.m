global key;
InitKeyboard();
pause(1);
speed_forward = 80;
speed_backward = -80;
speed_turnspeed = 80;
claw_speed_open = 40;
claw_speed_close = -40;
% % A is the left motor
% % D is the right motor
while 1
    pause(0.1);
    brick.StopAllMotors();
    switch key
        case 'w' % Move forward
            brick.MoveMotor('AD', speed_forward);
        case 's' % Move backward
            brick.MoveMotor('AD', speed_backward);
        case 'a' % Turn left
            brick.MoveMotor('D', speed_turnspeed);
            brick.StopMotor('A');
        case 'd' % Turn right
            brick.MoveMotor('A', speed_turnspeed);
            brick.StopMotor('D');
        case 'backspace'
            brick.StopMotor('AD');
        case 'c'
            brick.MoveMotor('B', speed_claw_open);
        case 'z' 
            brick.MoveMotor('B', speed_claw_close);
        case 'p'
            break;
    end % key switch end
end
brick.StopMotor('ACD');
CloseKeyboard();