% 0 --> 0 00000000 00000000000000000000000
%
% 2 --> 0 10000000 00000000000000000000000
% 3 --> 0 10000000 10000000000000000000000
% 5 --> 0 10000001 01000000000000000000000      10     10       11
% 7 --> 0 10000001 11000000000000000000000     +11    101     +101
% 8 --> 0 10000100 00000000000000000000000 
% i --> 0 11111111 11111111111111111111111     101    111     1000
% Vetor de 32 posições v  
%   - v(1) --> sinal;
%   - v(2) - v(9) --> expoente;
%   - v(10) - v(32) --> significando;

function main()
    %       s |   exponent  |                signify                      |
    num2 = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num5 = [0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num3 = [0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    conv = resum(num2, num3);
endfunction

% Recieves two numbers in the floating point notation
% and sums them, the result may not be in the floating
% point notation at first
function ret = resum(num1, num2)
    offset = expDiff(num1, num2);
    ret = zeros(1, 32 + abs(offset));
    carryout = 0;
    
    if (offset >= 0)
        minor = num2;
        major = num1;
    
    else
        minor = num1;
        major = num2;
    endif
    
    % copy the smaller number to the result with
    % an offset 
    for i = 32:-1:10
        ret(i + abs(offset)) = minor(i);
    endfor

    for i = 32:-1:2
        ret(i) += major(i);
        
        % set the carryout from the current digit sum
        if (ret(i) > 1)
            
            if (ret(i) == 2) ret(i) = 0;
            else ret(i) = 1;
            endif
            
            if (i != 2) ret(i - 1) += 1;
            endif
        endif
    endfor
    
    ret(abs(offset) + 9) += 1;
    if (offset == 0) ret(10) += 1;
    endif

    for i = 10:32
        if (ret(i) > 1)
            
            if (ret(i) == 2) ret(i) = 0;
            else ret(i) = 1;
            endif
            
            if (i != 2) ret(i + 1) += 1;
            endif
        endif
    endfor
    
    for i = 1:32
        printf("%d : %d\n", i, ret(i));
    endfor
endfunction

% Recieves two numbers in the floating point notation,
% returns the difference between exponents.
function dif = expDiff(num1, num2)
    expo1 = 0;
    expo2 = 0;
    
    for i = 9:-1:2
        expo1 = expo1 + num1(i)*(10^(9-i));
        expo2 = expo2 + num2(i)*(10^(9-i));
    endfor

    expo1 = bin2dec(num2str(expo1));
    expo2 = bin2dec(num2str(expo2));
    
    if (expo1 == 255) checkNaN(expo1, num1);
    endif

    if (expo2 == 255) checkNaN(expo2, num2);
    endif
    
    dif = expo1 - expo2;

endfunction

% Recieves two numbers and the difference between exponents
% and returns the right signal for the sum's result
function signal = signalSetter(num1, num2, dif)
    
    sig1 = 0;
    sig2 = 0;
    
    if (dif == 0)
        for i = 10:32
            sig1 = sig1 + num1(i)*(10^(i-10));
            sig2 = sig2 + num2(i)*(10^(i-10));
        endfor
        
        if (sig1 >= sig2) signal = num1(1);
        else signal = num2(1);
        endif
    
    elseif (dif > 0)
        signal = num1(1);
    
    else
        signal = num2(1);
    endif

endfunction

function nan = checkNaN(expo, num) 
    
    for i = 10:32
        if (num1(i) != 1) 
            disp(num); disp(" is NaN");
        endif
    endfor

endfunction
