% No caso bilinear temos quatro condições de interpolação:
% que a função interpoladora tenha o valor da função interpolada
% nos pontos (xi, yj), (xi, yj+1), (xi+1, yj) e (xi+1, yj+1).

% Todos os parâmetros, com exceção de <matrix> são como especificados
% no enunciado e formam a malha de pontos a ser interpolada.
% Matrix terá sempre dimensão [(nx+1)(ny+1)]x[2].

function bilinear ()

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
    coeficientes = constroiv (nx, ny, ax, bx, ay, by, teste, teste_pontos);
    avalia = avaliav(x, y, nx, ny, teste, hx, hy, coeficientes)

end

function fx = example_1 (nx, ny, points)

    fx = zeros(ny + 1, 1, nx + 1);
    
    for i = 1 : nx + 1
        for j = 1 : ny + 1
            fx(j, 1, i) = points(j, 1, i) + points(j, 2, i);    
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
  
function coef = constroiv (nx, ny, ax, bx, ay, by, points, fx)
    coef = zeros(2, 2, nx*ny);
    i = 1;
    init = 0;
    
    for j = 1 : nx*ny
        coef(1, 1, j) = fx(1 + init, 1, i);
        coef(1, 2, j) = fx(1 + init, 1, i + 1) - coef(1, 1, j);
        coef(2, 1, j) = fx(2 + init, 1, i) - coef(1, 1, j);
        coef(2, 2, j) = fx(2 + init, 1, i + 1) - coef(1,1, j) - coef(1, 2, j) - coef(2, 1, j);
        if (i < nx)
            i++;
        else
            i = 1;
            init++;
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
            endwhile  
        endif
    endwhile
    
    indx = (sqxmax - points(1, 1, 1))/hx;
    indy = (sqymax - points(1, 2, 1))/hy;
    ind = indx + (indy - 1)*nx;

    ret = [1, (x - (sqxmax - hx))/hx]*coef(:,:,ind)*[1; (y - (sqymax - hy))/hy];
end
