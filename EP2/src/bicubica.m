% No caso bilinear temos quatro condições de interpolação:
% que a função interpoladora tenha o valor da função interpolada
% nos pontos (xi, yj), (xi, yj+1), (xi+1, yj) e (xi+1, yj+1).

% Todos os parâmetros, com exceção de <matrix> são como especificados
% no enunciado e formam a malha de pontos a ser interpolada.
% Matrix terá sempre dimensão [(nx+1)(ny+1)]x[2].

function bicubica ()

    disp("Funções disponíveis:");
    disp(" 1: f(x,y) = x + y");
    disp(" 2: f(x,y) = sen(x - y)");
    disp(" 3: f(x,y) = (x² - y²)²");
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

    points = interpolate_points (nx, ny, ax, bx, ay, by);

    if (fun == 1)
        function_data = find_values (nx, ny, points, "f1");
        coeficientes = constroiv (nx, ny, ax, bx, ay, by, points, function_data);
        [ax_x, ax_y, ax_z, ax_z_v] = grid(0.05, nx, ny, ax, bx, ay, by, points, coeficientes, "f1", 1);
        plot(ax_x, ax_y, ax_z);
        title ("Original: f(x,y) = x + y");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");
        figure
	plot(ax_x, ax_y, ax_z_v);
        title ("Interpolated");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");
        figure
        plot(ax_x, ax_y, abs(ax_z - ax_z_v));
        title ("Error");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");

        disp("Escolha um ponto da malha para avaliar:");
        x = input("x: ");
        y = input("y: ");
        disp("Valor da Função Interpoladora:");
        disp(avaliav(x, y, nx, ny, points, hx, hy, coeficientes));
        disp("Valor da Função Original:");
        [z, zx, zy, zxy] = f1(x, y);
        disp(z);


    elseif (fun == 2)
        function_data = find_values (nx, ny, points, "f2");
        coeficientes = constroiv (nx, ny, ax, bx, ay, by, points, function_data);
        [ax_x, ax_y, ax_z, ax_z_v] = grid(0.05, nx, ny, ax, bx, ay, by, points, coeficientes, "f2", 1);
         plot(ax_x, ax_y, ax_z);
        title ("Original: f(x,y) = sen(x - y)");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");
        figure
	plot(ax_x, ax_y, ax_z_v);
        title ("Interpolated");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");
        figure
        plot(ax_x, ax_y, abs(ax_z - ax_z_v));
        title ("Error");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");

        disp("Escolha um ponto da malha para avaliar:");
        x = input("x: ");
        y = input("y: ");
        disp("Valor da Função Interpoladora:");
        disp(avaliav(x, y, nx, ny, points, hx, hy, coeficientes));
        disp("Valor da Função Original:");
        [z, zx, zy, zxy] = f2(x, y);
        disp(z);

    elseif (fun == 3)
        function_data = find_values (nx, ny, points, "f3");
        coeficientes = constroiv (nx, ny, ax, bx, ay, by, points, function_data);
        [ax_x, ax_y, ax_z, ax_z_v] = grid(0.05, nx, ny, ax, bx, ay, by, points, coeficientes, "f3", 1);
         plot(ax_x, ax_y, ax_z);
        title ("Original: f(x,y) = (x² - y²)²");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");
        figure
	plot(ax_x, ax_y, ax_z_v);
        title ("Interpolated");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");
        figure
        plot(ax_x, ax_y, abs(ax_z - ax_z_v));
        title ("Error");
        xlabel ("x");
        ylabel ("y");
        zlabel ("z");

        disp("Escolha um ponto da malha para avaliar:");
        x = input("x: ");
        y = input("y: ");
        disp("Valor da Função Interpoladora:");
        disp(avaliav(x, y, nx, ny, points, hx, hy, coeficientes));
        disp("Valor da Função Original:");
        [z, zx, zy, zxy] = f3(x, y);
        disp(z);
    endif
end

function [z, zx, zy, zxy] = f1(x, y)
    z = x + y;
    zx = zy = 1;
    zxy = 0;
end

function [z, zx, zy, zxy] = f2(x, y)
    z = sin(x - y);
    zx = cos(x - y);
    zy = - cos(x - y);
    zxy = sin(x - y);
end

function [z, zx, zy, zxy] = f3(x, y)
    z = (x^2-y^2)^2;
    zx = 4*x*(x^2 - y^2);
    zy = -4*y*(x^2 - y^2);
    zxy = -8*x*y;
end


function fx_dxdy = find_values (nx, ny, points, f)

    max_points = (nx + 1)*(ny + 1);
    fx_dxdy = zeros(2, 2, max_points);
    k = 1;
    
    for i = 1 : nx + 1
        for j = 1 : ny + 1

	    [z, zx, zy, zxy] =  str2func(f)(points(j, 1, i), points(j, 2, i));
            
	    fx_dxdy(1, 1, k) = z;
            fx_dxdy(1, 2, k) = zx;
            fx_dxdy(2, 1, k) = zy;
            fx_dxdy(2, 2, k) = zxy;
            
            k++;
        endfor
    endfor
 
end

function plot (x_axis, y_axis, z_axis)
    mesh(x_axis, y_axis, z_axis);
end

function [x_axis, y_axis, z_axis, z_axis_v] = grid (delta, nx, ny, ax, bx, ay, by, points, coef, f)

    grid_nx = (bx - ax)/delta;
    grid_ny = (by - ay)/delta;

    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;

    x_axis = zeros(1, grid_nx + 1);
    y_axis = zeros(1, grid_ny + 1);
    z_axis = zeros(grid_nx + 1, grid_ny + 1);
    z_axis_v = zeros(grid_nx + 1, grid_ny + 1);

    for i = 1  : grid_nx + 1
	x_axis(i) = ax + (i - 1) * delta;
    endfor

    for j = 1 : grid_ny + 1
	y_axis(j) = ay + (j - 1) * delta;
    endfor
       
    for i = 1 : grid_nx + 1 
	for j = 1 : grid_ny + 1
	    z_axis(i, j) = str2func(f)(x_axis(i), y_axis(j));
            z_axis_v(i, j) = avaliav(x_axis(i), y_axis(j), nx, ny, points, hx, hy, coef);
        endfor
    endfor
end
	  
function matrix = interpolate_points (nx, ny, ax, bx, ay, by)

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

        a = fx_dxdy(1, 1, k + dist + 1) + fx_dxdy(1, 1, k) - fx_dxdy(1, 1, k + 1) - fx_dxdy(1, 1, k + dist);
        b = coef(2, 2, j) + coef(2, 3, j) + coef(2, 4, j) + coef(3, 2, j) + coef(4, 2, j);
	eq_4 = a - b;

        a = hx*fx_dxdy(1, 2, k + dist + 1) - coef(2, 1, j) - coef(2, 2, j) - coef(2, 3, j) - coef(2, 4, j) ;
        b = 2*coef(3, 1, j) + 2*coef(3, 2, j) + 3*coef(4, 1, j) + 3*coef(4, 2, j);
        eq_8 = a - b;

        a = hy*fx_dxdy(2, 1, k + dist + 1) - coef(1, 2, j) - coef(2, 2, j) - coef(3, 2, j) - coef(4, 2, j);
        b = 2*coef(1, 3, j) + 2*coef(2, 3, j) + 3*coef(1, 4, j) + 3*coef(2, 4, j);
        eq_12 = a - b;

        a = hx*hy*fx_dxdy(2, 2, k + dist + 1) - coef(2, 2, j) - 2*coef(3, 2, j);
        b = 3*coef(4, 2, j) + 2*coef(2, 3, j) + 3*coef(2, 4, j);
        eq_16 = a - b;

        coef(4, 4, j) = eq_16 - 2*eq_12 - 2*(eq_8 - 2*eq_4);
        coef(4, 3, j) = eq_8 - 2*eq_4 - coef(4, 4, j);
        coef(3, 4, j) = 3*eq_12 - eq_16 -2*(3*eq_4 - eq_8); 
        coef(3, 3, j) = 3*eq_4 - eq_8 - coef(3, 4, j);

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

    j = 2;
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

    ind = int32(ind);

    ret = [1, w, w^2, w^3]*coef(:,:,ind)*[1; z; z^2; z^3];
end
