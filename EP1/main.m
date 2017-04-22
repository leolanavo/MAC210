% 0 --> 0 00000000 00000000000000000000000
% 2 --> 0 10000000 00000000000000000000000
% 3 --> 0 10000000 10000000000000000000000
% 5 --> 0 10000001 01000000000000000000000
% 7 --> 0 10000001 11000000000000000000000
% 8 --> 0 10000011 00000000000000000000000
% 9 --> 0 10000010 00100000000000000000000
% i --> 0 11111111 11111111111111111111111
% 32 positions vector
%   - v(1) --> signal;
%   - v(2) - v(9) --> exponent;
%   - v(10) - v(32) --> signify;

function main()
    %       s |   exponent  |                signify                      |
    num0 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num1 = [0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num9 = [0,0,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num2 = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num3 = [1,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num5 = [0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num7 = [0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    conv = resum(num2, num3);
endfunction

% Recieves two numbers in the floating point notation 
% within the normal interval and sums them, the result 
% may not be in the floating point notation at first
function ret = resum(num1, num2)
    offset = expDiff(num1, num2);
    ret = zeros(1, 32 + abs(offset));
    ret(1) = signalSetter(num1, num2, offset);
    
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

    % puts the hidden bit of the smallest number
    % in right location
    if (offset != 0)
        ret(9 + abs(offset)) += 1;
        carryout = 0;
    else 
        carryout = 1;
    endif

    % sums the biggest number with the smallest, 
    % but the smallest have been altered to fit
    % the exponent of the biggest number
    for i = 32:-1:10
        ret(i) += major(i);
        
        % set the carryout from the current digit sum
        if (ret(i) > 1)
            
            if (ret(i) == 2) ret(i) = 0;
            else ret(i) = 1;
            endif
            
            if (i != 10) ret(i - 1) += 1;
            else carryout += 1;
            endif
        endif
    endfor
    
    carryout += 1;

    % normalize the result of the sum
    if (carryout > 1)
        for i = 31 + abs(offset):-1:11
            ret(i) = ret(i-1);
        endfor
       
        ret(9) = 1;

        if (carryout == 2) ret(10) = 0;
        else ret(10) = 1;
        endif
    endif
    
    % set the exponent of the result according to the
    % biggest number exponent and the needed changes
    for i = 9:-1:2
        ret(i) += major(i);
        if (ret(i) > 1)
            
            if (ret(i) == 2) ret(i) = 0;
            else ret(i) = 1;
            endif

            if (i != 2) ret(i-1) += 1;
            endif
        endif
    endfor

    printVec(ret);
    
endfunction

% Recieves a vector and prints it according to
% the format "<index> : <content>\n"
function printVec(num1, num2, ret)
    for i = 1:length(vec)
        printf("%d : %d\n", i, vec(i));
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
    
    dif = expo1 - expo2

endfunction

% Recieves two numbers and the difference between exponents
% and returns the right signal for the sum's result
function signal = signalSetter(num1, num2, dif)
    
    sig1 = 0;
    sig2 = 0;
    
    if (dif == 0)
        for i = 32:-1:10
            sig1 += num1(i)*(10^(32-i));
            sig2 += num2(i)*(10^(32-i));
        endfor
        
        if (sig1 >= sig2) signal = num1(1);
        else signal = num2(1);
        endif
    
    elseif (dif >= 0)
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
