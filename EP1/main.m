% 0 --> 0 00000000 00000000000000000000000
%       | |------| |---------------------|
%       |    |               |--> significand
%       |    |--> bitstring
%       |--> signal

% We will use a 32 positions vector to represent the 
% number in the floating point notation within the normal
% interval, where v is our vector and:
%   - v(1) --> signal;
%   - v(2) - v(9) --> bitstring;
%   - v(10) - v(32) --> significand;

function main()
    %       s |   exponent  |                significand                      |
    num0 = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num1 = [0,0,1,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num9 = [0,0,1,1,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num2 = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num3 = [0,1,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num5 = [0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num7 = [0,1,0,0,0,0,0,0,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    num8 = [0,1,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    conv = resub(num0, num3);
    printVec(conv);
endfunction

% Recieves two vectors that represent numbers in the 
% floating point notation  within the normal interval 
% and sums them, the result may not be in the floating 
% point notation at first
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
    
    % copy the smallest number to the result with
    % an offset 
    for i = 32:-1:10
        ret(i + abs(offset)) = minor(i);
    endfor

    % puts the hidden bit of the smallest number
    % in right location
    if (offset != 0)
        ret(9 + abs(offset)) = 1;
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

% Recieves two numbers in the floating point notation 
% within the normal interval and subtracts them, the 
% result may not be in the normal interval.
function ret = resub(num1, num2)
    
    % if the numbers are equals, returns 0
    if (num1 == num2)
        ret = zeros(1, 32);
        return
    endif

    offset = expDiff(num1, num2);
    ret = zeros(1, 32 + abs(offset));
    
    num2(1) = !num2(1);
    ret(1) = signalSetter(num1, num2, offset);

    % if one of them are 0, return the other
    if (num1 == zeros(1, 32))
        ret = num2;
        return;
    endif
    
    if (num2 == zeros(1, 32))
        ret = num1;
        return;
    endif
    
    % Set which is the biggest and smallest number
    % and copy the smallest significand to the result 
    % with an offset vector.
    if (offset >= 0)
        minor = negateNum(num2, abs(offset));
        major = num1;
        
        for i = 10:32 + abs(offset)
            ret(i + offset) = minor(i);
        endfor
    else
        minor = num1;
        major = negateNum(num2, 0);

        for i = 10:32
            ret(i + abs(offset)) = minor(i);
        endfor
    endif

    carryout = 1;

    % Sums the numbers, with the second number
    % being negated, according to the 2's complement
    for i = 32:-1:10
        ret(i) += major(i);

        if (ret(i) > 1) 
            if (ret(i) == 2) ret(i) = 0;
            else ret(i) = 1;
            endif
            
            if (i != 10) ret(i-1) += 1;
            else carryout += 1;
            endif
        endif
    endfor

    % Normalize the result
    if (carryout == 1 || carryout == 2)
        count = 1;
        

        expo = btsToDec(major);
        if (expo == 1) return;
        endif

        % Seeks the first non-zero bit in the significand,
        % shift the vector so it will be normalized and
        % subtracts the amount needed in the biggest number's 
        % exponent
        if (carryout == 2)
            while (ret(count + 10) == 0)
                count += 1;
            endwhile

            if(count >= expo) return;
            endif
    
            ret(count + 10) = 0;
    
            for i = 10:32 + abs(offset) - count
                ret(i) = ret(i + count);
            endfor
    
            for i = 32 + abs(offset) - count:32+abs(offset)
                ret(i) = 0;
            endfor
        endif 
        
        expo -= count;
        disp(expo);
        expo = dec2bin(expo)
        
        i = 9;
        j = length(expo);
        while (j > 0)
            ret(i) = str2num(expo(j));
            i -= 1;
            j -= 1;
        endwhile
    else
        for i = 2:9
            ret(i) = major(i);
        endfor
    endif
    printVec(ret);
    
endfunction

% Recieves a vector and prints it according to
% the format "<index> : <content>\n"
function printVec(ret)
    for i = 1:length(ret)
        printf("%d : %d\n", i, ret(i));
    endfor
endfunction

% Recieves two vectors that represent numbers in the floating 
% point notation. Returns the difference between exponents.
function dif = expDiff(num1, num2)
    expo1 = btsToDec(num1);
    expo2 = btsToDec(num2);
    
    dif = expo1 - expo2;

endfunction

% Recieves two vectors that represent numbers in the floating
% point notationand the difference between their exponents.
% Returns the correct signal for the sum's or subtraction's 
% result
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

% Recieves a vector that represents a number in the
% floating point notation. Returns true if the number
% is a NaN, false otherwise.
function nan = checkNaN(num) 
    nan = false;

    if (btsToDec(num) == 255)
        for i = 10:32
            if (num1(i) == 1) 
                nan = true;
                break;
            endif
        endfor
    endif

endfunction

% Recieves a vector that represents a number in the
% floating point notation. Returns the value of the
% bitstring in the decimal base.
function expo = btsToDec(num)
    
    expo = 0;
    for i = 9:-1:2
        expo += num(i)*(10^(9-i));
    endfor
    expo = bin2dec(num2str(expo));

endfunction


% Recieves a vector that represents a number in the
% floating point notation and an offset. Returns a vector 
% with the significand negated according to the 2's complement 
%  notation and with an offset provided.
function neg = negateNum(num, offset)
    neg = zeros (1, 32 + offset);
   
    for i = 1:32
        neg(i + offset) = num(i);
    endfor

    if (offset != 0) 
        neg(9 + offset) = 1;
    endif

    for i = 10:32+offset
        neg(i) = !neg(i);
    endfor

    neg(32+offset) += 1;

    for i = 32 + offset:-1:10
        
        if (neg(i) == 2)
            neg (i) = 0;
            
            if (i != 10) 
                neg (i - 1) += 1;
            
            endif
        endif
    endfor

endfunction

% Recieves a vector that represents a number in the
% floating point notation, but with the significand with any
% number of bits. Returns the vector in the floating point
% notation with two guard bits and one sticky bit.
function prec = precisionBits(num)
    prec = zeros (1, 35)

    for i = 1:32
        prec(i) = num(i);
    endfor

    % set the first guard bit
    if (length(num) > 32)
        prec(33) = num(33);
    else
        prec(33) = 0;
    endif

    % set the second guard bit
    if (length(num) > 33)
        prec(34) = num(34);
    else
        prec(34) = 0;
    endif

    % set the sticky bit
    if (length(num) > 34)
        for i = 35:length(num)
            if (num(i) == 1)
                prec(35) = 1;
                break;
            endif
        endfor
    else
        prec(35) = 0;
    endif
endfunction
