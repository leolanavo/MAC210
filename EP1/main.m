% 2 --> 0 10000000 1.00000000000000000000000
% 3 --> 0 10000000 1.10000000000000000000000
% Vetor de 33 posições v  
%   - v(1) --> sinal;
%   - v(2) - v(9) --> expoente;
%   - v(10) --> oculto;
%   - v(11) - v(33) --> número;

function main()
    x = zeros(1,32);
    conv = fpsum(x);
    num2str(conv)
endfunction

function ret = resum(num1, num2)
    offset = compareEXP(num1, num2, ret);
    ret = zeros(1, 32+offset);

    if (offset >= 0)
        for i = 10:32
            ret(i+offset) = num2(i);
            ret(i) = num1(i) + ret(i);
        endfor
    else
        for i = 10:32
            ret(i+offset) = num1(i);
            ret(i) = num2(i) + ret(i);
        endfor
    endif

endfunction

function dif = expSetter(num1, num2)
    expo1 = 0;
    expo2 = 0;
    
    for i = 2:9
        expo1 = expo1 + num1(i)*(10^(i-2));
        expo2 = expo2 + num2(i)*(10^(i-2));
    endfor

    expo1 = bin2dec(num2str(expo1));
    expo2 = bin2dec(num2str(expo2));
    
    dif = expo1 - expo2;
    return dif;

endfunction

function signal = signalSetter(num1, num2, dif)
    
    sig1 = 0;
    sig2 = 0;
    
    if (dif == 0)
        for i 10:32
            sig1 = sig1 + num1(i)*(10^(i-10));
            sig2 = sig2 + num2(i)*(10^(i-10));
        endfor
        if (sig1 >= sig2)
            signal = num1(1);
        else
            signal = num2(1);
        endif
    
    elseif (dif > 0)
        signal = num1(1);
    
    else
        signal = num2(1);
    endif

endfunction
