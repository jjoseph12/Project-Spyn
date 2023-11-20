global key;
InitKeyboard();
pause(1);

speed_right = -60;
speed_left = -58.5;
speed_claw = 5;

% % A is the right motor
% % D is the left motor
% % B is the claw motor
while 1
    pause(0.1);
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
            break;
        case '0' % Kill switch
            disp("Exiting manual contro!");
            for i = 1:3
                pause(0.2);
                brick.beep();
            end
            break;
    end % key switch end
end
brick.StopMotor('ABD');
CloseKeyboard();