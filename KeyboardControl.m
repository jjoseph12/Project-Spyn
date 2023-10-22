global key;
InitKeyboard();
pause(1);
while 1
    pause(0.02);
    switch key
        case 'w'
            % Move forward
            brick.MoveMotor('1', 80);
            brick.MoveMotor('4', 80);
            pause(0.1);
            brick.StopMotor('1');
            brick.StopMotor('4');
            disp("w");
        case 's'
            % Move backward
            brick.MoveMotor('1', -80);
            brick.MoveMotor('4', -80);
            pause(0.1);
            brick.StopMotor('1');
            brick.StopMotor('4');
           disp("s");
        case 'a'
            % Turn left
            brick.MoveMotor('1', 80);
            pause(0.1);
            brick.StopMotor('1');
            disp("a");
        case 'd'
            % Turn right
            brick.MoveMotor('4', 80);
            pause(0.1);
            brick.StopMotor('4');
           disp("d");
        case 0
            % Nothing is being pressed
        case 'g'
            break;
    end
end
brick.StopMotor('1');
brick.StopMotor('4');
CloseKeyboard();