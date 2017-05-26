% No caso bilinear temos quatro condições de interpolação:
% que a função interpoladora tenha o valor da função interpolada
% nos pontos (xi, yj), (xi, yj+1), (xi+1, yj) e (xi+1, yj+1).

% Todos os parâmetros, com exceção de <matrix> são como especificados
% no enunciado e formam a malha de pontos a ser interpolada.
% Matrix terá sempre dimensão [(nx+1)(ny+1)]x[2].

function bicubica ()

    disp("Funções disponíveis:")
    disp(" 1: ")
    disp(" 2: ")
    disp(" 3: ")
    fun = input("Escolha a função pelo seu número correspondente: ");
    
    disp("Passe os parâmetros que definirão a malha [ax, bx] x [ay, by],")
    disp("de maneira que ax < bx e ay < by.")
    ax = input("Escolha ax: ");
    bx = input("Escolha bx: ");
    ay = input("Escolha ay: ");
    by = input("Escolha by: ");
  
    disp("Interpolarei (nx + 1)(ny + 1) pontos contidos na malha passada")
    nx = input("Escolha nx: ");
    ny = input("Escolha ny: ");

    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;


    disp("Escolha um ponto da malha para avaliar v");
    x = input("x: ");
    y = input("y: ");
  
    teste = points (nx, ny, ax, bx, ay, by);
    teste_pontos = example_1 (nx, ny, teste);
    coeficientes = constroiv (nx, ny, ax, bx, ay, by, teste, teste_pontos)
    avalia = avaliav(x, y, nx, ny, teste, hx, hy, coeficientes)

end

function fx_dxdy = example_1 (nx, ny, points)

    max_points = (nx + 1)*(ny + 1);
    fx_dxdy = zeros(2, 2, max_points);
    k = 1;
    
    for i = 1 : nx + 1
        for j = 1 : ny + 1
            
            fx_dxdy(1, 1, k) = points(j, 1, i) + points(j, 2, i);
            fx_dxdy(1, 2, k) = 1;
            fx_dxdy(2, 1, k) = 1;
            fx_dxdy(2, 2, k) = 0;
            
            k++;
        endfor
    endfor
 
end

function matrix = points (nx, ny, ax, bx, ay, by)

    matrix = zeros(ny + 1, 2, nx + 1);
  
    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;
  
    for i = 1 : nx + 1
        for j = 1 : ny + 1	    
            matrix(j, 1, i) = ax + (i - 1) * hx;
            matrix(j, 2, i) = ay + (j - 1) * hy;    
        endfor
    endfor
  
end
  
function coef = constroiv (nx, ny, ax, bx, ay, by, points, fx_dxdy)
    coef = zeros(4, 4, nx*ny);
    
    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;
    
    max_line = k = init = 1;
    dist = ny + 1;


    for j = 1 : nx*ny

        coef(1, 1, j) = fx_dxdy(1, 1, k);
        coef(1, 2, j) = fx_dxdy(2, 1, k)*hy;
        coef(2, 1, j) = fx_dxdy(1, 2, k)*hx;
        coef(2, 2, j) = fx_dxdy(2, 2, k)*hx*hy;
        
        coef(1, 3, j) = 3*(fx_dxdy(1, 1, k + 1) - fx_dxdy(1, 1, k)) - hy*(2*fx_dxdy(2, 1, k) + fx_dxdy(2, 1, k + 1));
        coef(1, 4, j) = 2*(fx_dxdy(1, 1, k) - fx_dxdy(1, 1, k + 1)) + hy*(fx_dxdy(2, 1, k) + fx_dxdy(2, 1, k + 1));
        coef(2, 3, j) = 3*hx*(fx_dxdy(1, 2, k + 1) - fx_dxdy(1, 2, k)) - hx*hy*(2*fx_dxdy(2, 2, k) + fx_dxdy(2, 2, k + 1));
        coef(2, 4, j) = 2*hx*(fx_dxdy(1, 2, k) - fx_dxdy(1, 2, k + 1)) + hx*hy*(fx_dxdy(2, 2, k) + fx_dxdy(2, 2, k + 1));
        
        coef(3, 1, j) = 3*(fx_dxdy(1, 1, k + dist) - fx_dxdy(1, 1, k)) - hx*(2*fx_dxdy(1, 2, k) + fx_dxdy(1, 2, k + dist));
        coef(3, 2, j) = 3*hy*(fx_dxdy(2, 1, k + dist) - fx_dxdy(2, 1, k)) - hx*hy*(2*fx_dxdy(2, 2, k) + fx_dxdy(2, 2, k + dist));
        coef(4, 1, j) = 2*(fx_dxdy(1, 1, k) - fx_dxdy(1, 1, k + dist)) + hx*(fx_dxdy(1, 2, k) + fx_dxdy(1, 2, k + dist));
        coef(4, 2, j) = 2*hy*(fx_dxdy(2, 1, k) - fx_dxdy(2, 1, k + dist)) + hx*hy*(fx_dxdy(2, 2, k) + fx_dxdy(2, 2, k + dist));

        a = 3*hy*fx_dxdy(2, 1, k + dist + 1) - hx*hy*fx_dxdy(2, 2, k + dist + 1) - 2*(fx_dxdy(1, 1, k + dist + 1) + fx_dxdy(1, 1, k));
        b = 2*(fx_dxdy(1, 1, k + 1) + fx_dxdy(1, 1, k + dist)) - 3*(coef(1, 2, j) + 2* coef(1, 3, j) + 3*coef(1, 4, j));
        c = coef(3,2,j) - 2*coef(2,3,j) - 4*coef(2,4,j);
        coef(3, 4, j) = a + b + c;

        a = fx_dxdy(1,1,k+dist+1) + fx_dxdy(1,1,k) - fx_dxdy(1,1,k+1);
        b = -fx_dxdy(1,1,k+dist) - coef(2,2,j) - coef(2,3,j);
        c = -coef(2,4,j) - coef(3,2,j) - coef(3,4,j);
        coef(3,3,j) = a + b + c;

        a = hx*fx_dxdy(1, 2, k + dist + 1) - 2*(fx_dxdy(1, 1, k + dist + 1) + fx_dxdy(1, 1, k));
        b = 2*(fx_dxdy(1, 1, k + 1) + fx_dxdy(1, 1, k + dist) + hy*fx_dxdy(2, 1, k + dist + 1)) - hx*hy*fx_dxdy(2, 2, k + dist + 1);
        c = coef(1, 2, j) - coef(2, 2, j) + coef(4, 2, j) - 4*coef(1,3,j) - 2*coef(2,3,j) + 6*coef(1,4,j) - 3*coef(2,4,j);          
        coef(4,3,j) = a + b + c;

        a = hx*fx_dxdy(1,2,k+dist+1) - 2*(fx_dxdy(1,1,k+dist+1) + fx_dxdy(1,1,k));
        b = 2*(fx_dxdy(1,1,k+1) + fx_dxdy(1,1,k+dist));
        c = -3*coef(4,3,j);
        coef(4,4,j) = (a + b + c)/3;

        if (max_line < nx)
            k = k + dist;
            max_line++;
        else
            k = init + 1;
            init++;
            max_line = 1;
        endif
    endfor

end

function ret = avaliav(x, y, nx, ny, points, hx, hy, coef)

    i = 1;
    j = 2;
    init = 0;
    found = false;
    
    while(j <= nx+1 && !found)
        if (x <= points(1, 1, j))
            sqxmax = points(1, 1, j);
            i = 2;
            while (i <= ny+1 && !found)
                if (y <= points(i, 2, j))
                    sqymax = points(i, 2, j);
                    found = true;
                endif
                i++;
            endwhile  
        endif
        j++;
    endwhile
    
    indx = (sqxmax - points(1, 1, 1))/hx;
    indy = (sqymax - points(1, 2, 1))/hy;
    ind = indx + (indy - 1)*nx;

    w = (x - (sqxmax - hx))/hx;
    z = (y - (sqymax - hy))/hy;

    ret = [1, w, w^2, w^3]*coef(:,:,ind)*[1; z; z^2; z^3];
end
