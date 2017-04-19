% 2 --> 0 10000000 1.00000000000000000000000
% 3 --> 0 10000000 1.10000000000000000000000
% Vetor de 33 posições v  
%   - v(1) --> sinal;
%   - v(2) - v(9) --> expoente;
%   - v(10) --> oculto;
%   - v(11) - v(33) --> número;

function main()
    x = 10;
    if (abs(mod(x,1)) != 0)
        printf ("diabo\n");
    endif
    conv = conversion(x);
    num2str(conv)
end

% Recieves a number and convert it to the floating point
% notation from the book
function conv = conversion(x)
    if (x < -127 || x > 128 || abs(mod(x, 1)) != 0)
        printf("deu ruim\n");
        return;
    endif

    x = x + 127;

    if (x == 0)
        for i = 2:9
            conv(i) = 0;
        endfor
    elseif (x == 255)
        for i = 2:9
            conv(i) = 1;
        endfor
    else 
        for i = 2:9
            conv(11 - i) = abs(mod(x, 2));
            x = x/2;
        endfor
    endif

endfunction

