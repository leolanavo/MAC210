% acha as bacias de convergência da função f no dominio [l1, u1]×[l2, u2]
% e gera um arquivo output.txt que contém os dados para a geração da
% imagem das bacias (pode usar gnuplot para gerar as imagens). 
%Os dados gerados preenchem uma imagem com p1 × p2 pixels.

function newton_basins(f, l, u, p)
    newton (polynomial(), -10);
end

%aplica o método de Newton para achar uma raiz da função f
%(com primeira derivada f0), partindo do ponto x0.

function newton (f, x0)
    xn = x0; 
    lim = 0;
    xn1 = 0;    
    der = polyder(f);   
    err = xn1 - xn;
    
    while(absolute(err) > 10^(-6) && lim < 100)        
        
        div = fun(f, xn)/fun(der, xn);
        xn1 = xn - div;
        err = xn1 - xn;
        xn = xn1;
        
        lim++;  
        
    endwhile
    
    xn
    disp(roots(f));
end

function fx = fun (f, x0)

    dim = columns(f);
    exp = dim - 1;
    fx = fx_1 = 0;
   
    for i = 1:dim
        
        fx_1 = f(i)*(x0^exp);
        fx += fx_1;
        
        exp--;
        
    endfor
       
end

function p = polynomial ()
    p = [1 0 0 0 -1];    
end

function ret = absolute(n)
    if(n > 0)
        ret = n;
    else
        ret = -n;
    endif
end   

