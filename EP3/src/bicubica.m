% No caso bilinear temos quatro condições de interpolação:
% que a função interpoladora tenha o valor da função interpolada
% nos pontos (xi, yj), (xi, yj+1), (xi+1, yj) e (xi+1, yj+1).

% Todos os parâmetros, com exceção de <matrix> são como especificados
% no enunciado e formam a malha de pontos a ser interpolada.
% Matrix terá sempre dimensão [(nx+1)(ny+1)]x[2].

function bicubica ()

    graphics_toolkit("gnuplot");

    disp("Funções que serão testadas:");
    disp(" 1: f(x,y) = x + y");
    disp(" 2: f(x,y) = sen(x - y)");
    disp(" 3: f(x,y) = (x² - y²)²");

    image_1 = imread("folhas.jpg");
    info_1 = imfinfo("folhas.jpg");

    image_2 = imread("bolas.jpg");
    info_2 = imfinfo("bolas.jpg");

    %Comente qualquer umas das funções "testing" ou "draw" abaixo para reduzir o número de imagens.

    testing(info_1, -2, 2, -2, 2, 10, 10, "f1", "f1_z");
    testing(info_1, -2, 2, -2, 2, 10, 10, "f2", "f2_z");
    testing(info_1, -2, 2, -2, 2, 10, 10, "f3", "f3_z");

    testing(info_1, -2, 2, -2, 2, 20, 20, "f1", "f1_z");
    testing(info_1, -2, 2, -2, 2, 20, 20, "f2", "f2_z");
    testing(info_1, -2, 2, -2, 2, 20, 20, "f3", "f3_z");

    testing(info_1, -2, 2, -2, 2, 40, 40, "f1", "f1_z");
    testing(info_1, -2, 2, -2, 2, 40, 40, "f2", "f2_z");
    testing(info_1, -2, 2, -2, 2, 40, 40, "f3", "f3_z");

    draw(image_1, info_1, 5, 5, 350, 400, 69, 79);
    draw(image_1, info_1, 5, 5, 350, 400, 115, 79);
    draw(image_1, info_1, 6, 2, 350, 400, 172, 199);

    draw(image_2, info_2, 1, 2, 427, 640, 71, 58);
    draw(image_2, info_2, 1, 2, 427, 640, 142, 58);
    draw(image_2, info_2, 1, 2, 427, 640, 213, 319);
end

function testing (info, ax, bx, ay, by, nx, ny, f, f_z)
    
    control = zeros(info.Height, info.Width);

    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;

    points = interpolate_points (nx, ny, ax, bx, ay, by);
    [function_data, error_dx, error_dy, error_dxy] = find_values (control, control, 1, nx, ny, points, f, ax, bx, ay, by);
    coeficientes = constroiv (nx, ny, ax, bx, ay, by, points, function_data);
    
    [ax_x, ax_y, ax_z, ax_z_v] = grid(control, control, 0, nx, ny, ax, bx, ay, by, points, coeficientes, f_z);
    plot(ax_x, ax_y, ax_z);
    
    if (strcmp(f, "f1") == 1)
        title ("Original: f(x,y) = x + y");
    elseif (strcmp(f, "f2") == 1)
        title ("Original: f(x,y) = sen(x - y)");
    else
        title ("Original: f(x,y) = (x² - y²)²");
    endif

    xlabel ("x");
    ylabel ("y");
    zlabel ("f(x,y)");
    
    figure
	plot(ax_x, ax_y, ax_z_v);
    title ("Interpolated");
    xlabel ("x");
    ylabel ("y");
    zlabel ("s(x, y)");
    figure
    plot(ax_x, ax_y, abs(ax_z - ax_z_v));
    title ("Interpolation Error");
    xlabel ("x");
    ylabel ("y");
    zlabel ("f(x,y) - s(x, y)");

    figure
    plot(ax_x, ax_y, error_dx);
    title ("df/dx Error");
    xlabel ("x");
    ylabel ("y");
    zlabel ("dx - aprox_dx");
    figure
    plot(ax_x, ax_y, error_dy);
    title ("df/dy Error");
    xlabel ("x");
    ylabel ("y");
    zlabel ("dy - aprox_dy");
    figure
    plot(ax_x, ax_y, error_dxy);
    title ("df/dxdy Error");
    xlabel ("x");
    ylabel ("y");
    zlabel ("dxy - aprox_dxdy");
end

function [z, zx, zy, zxy] = f1(image, control, x, y, ax, bx, ay, by, hx, hy, f)
    z = x + y;
    [zx, zy, zxy] = aproxdf(image, control, x, y, ax, bx, ay, by, hx, hy, f);    
end

function [z, zx, zy, zxy] = f2(image, control, x, y, ax, bx, ay, by, hx, hy, f)
    z = sin(x - y);
    [zx, zy, zxy] = aproxdf(image, control, x, y, ax, bx, ay, by, hx, hy, f);
end 

function [z, zx, zy, zxy] = f3(image, control, x, y, ax, bx, ay, by, hx, hy, f)
    z = (x^2-y^2)^2;
    [zx, zy, zxy] = aproxdf(image, control, x, y, ax, bx, ay, by, hx, hy, f);  
end


function z = f1_z(x, y)
    z = x + y;
end

function z = f2_z(x, y)
    z = sin(x - y); 
end

function z = f3_z(x, y)
    z = (x^2-y^2)^2;  
end

function [zx, zy, zxy] = f1_dz(x, y)
    zx = zy = 1;
    zxy = 0;
end

function [zx, zy, zxy] = f2_dz(x, y)
    zx = cos(x - y);
    zy = - cos(x - y);
    zxy = sin(x - y);
end

function [zx, zy, zxy] = f3_dz(x, y)
    zx = 4*x*(x^2 - y^2);
    zy = -4*y*(x^2 - y^2);
    zxy = -8*x*y;
end
     
function [xdf, ydf, xydf] = aproxdf (image, control, x, y, ax, bx, ay, by, hx, hy, f)
  
    if (image == control)
        %Lado Esquerdo
        if (x == ax)

            xdf = (4*str2func(f)(x + hx, y) - str2func(f)(x + 2*hx, y) - 3*str2func(f)(x, y))/(2*hx);
       
            if (y == ay)
                %Canto Inferior
                ydf = (4*str2func(f)(x, y + hy) - str2func(f)(x, y + 2*hy) - 3*str2func(f)(x, y))/(2*hy);
                xydf = (8*(-str2func(f)(x + hx, y) - str2func(f)(x, y + hy) + str2func(f)(x + hx, y + hy)) - str2func(f)(x + 2*hx, y + 2*hy) + str2func(f)(x + 2*hx, y) + str2func(f)(x, y + 2*hy) + 7*str2func(f)(x, y))/(4*hx*hy);

            elseif (y == by)
                %Canto Superior
                ydf = (str2func(f)(x, y - 2*hy) - 4*str2func(f)(x, y - hy) + 3*str2func(f)(x, y))/(2*hy);
                xydf = (8*(str2func(f)(x + hx, y) + str2func(f)(x, y - hy) - str2func(f)(x + hx, y - hy)) + str2func(f)(x + 2*hx, y - 2*hy) - str2func(f)(x + 2*hx, y) - str2func(f)(x, y - 2*hy) - 7*str2func(f)(x, y))/(4*hx*hy);

            else
                ydf = (str2func(f)(x, y + hy) - str2func(f)(x, y - hy))/(2*hy);
                xydf = (4*(str2func(f)(x + hx, y + hy) - str2func(f)(x + hx, y - hy)) + str2func(f)(x + 2*hx, y - hy) - str2func(f)(x + 2*hx, y + hy) - 3*(str2func(f)(x, y + hy) - str2func(f)(x, y - hy)))/(4*hx*hy);
            endif
    
        %Lado Direito     
        elseif (x == bx)
            xdf = (str2func(f)(x - 2*hx, y) - 4*str2func(f)(x - hx, y) + 3*str2func(f)(x, y))/(2*hx);

            %Canto Inferior
            if (y == ay)
                ydf = (4*str2func(f)(x, y + hy) - str2func(f)(x, y + 2*hy) - 3*str2func(f)(x, y))/(2*hy);
                xydf = (8*(str2func(f)(x - hx, y) + str2func(f)(x, y + hy) - str2func(f)(x - hx, y + hy)) + str2func(f)(x - 2*hx, y + 2*hy) - str2func(f)(x - 2*hx, y) - str2func(f)(x, y + 2*hy) - 7*str2func(f)(x, y))/(4*hx*hy);
        
            %Canto Superior    
            elseif(y == by)
                ydf = (str2func(f)(x, y - 2*hy) - 4*str2func(f)(x, y - hy) + 3*str2func(f)(x, y))/(2*hy);
                xydf = (8*(-str2func(f)(x - hx, y) - str2func(f)(x, y - hy) + str2func(f)(x - hx, y - hy)) - str2func(f)(x - 2*hx, y - 2*hy) + str2func(f)(x - 2*hx, y) + str2func(f)(x, y - 2*hy) + 7*str2func(f)(x, y))/(4*hx*hy);
        
            else
                ydf = (str2func(f)(x, y + hy) - str2func(f)(x, y - hy))/(2*hy);
                xydf = (4*(str2func(f)(x - hx, y - hy) - str2func(f)(x - hx, y + hy)) + str2func(f)(x - 2*hx, y + hy) - str2func(f)(x - 2*hx, y - hy) + 3*(str2func(f)(x, y + hy) - str2func(f)(x, y - hy)))/(4*hx*hy);
            endif
   
        %Lado Baixo
        elseif (y == ay)
            xdf = (str2func(f)(x + hx, y) - str2func(f)(x - hx, y))/(2*hx);
            ydf = (4*str2func(f)(x, y + hy) - str2func(f)(x, y + 2*hy) - 3*str2func(f)(x, y))/(2*hy);
            xydf = (4*(str2func(f)(x + hx, y + hy) - str2func(f)(x - hx, y + hy)) + str2func(f)(x - hx, y + 2*hy) - str2func(f)(x + hx, y + 2*hy) - 3*(str2func(f)(x + hx, y) - str2func(f)(x - hx, y)))/(4*hx*hy);

        %Lado Cima
        elseif (y == by)
            xdf = (str2func(f)(x + hx, y) - str2func(f)(x - hx, y))/(2*hx);
            ydf = (str2func(f)(x, y - 2*hy) - 4*str2func(f)(x, y - hy) + 3*str2func(f)(x, y))/(2*hy);
            xydf = (4*(str2func(f)(x - hx, y - hy) - str2func(f)(x + hx, y - hy)) + str2func(f)(x + hx, y - 2*hy) - str2func(f)(x - hx, y - 2*hy) + 3*(str2func(f)(x + hx, y) - str2func(f)(x - hx, y)))/(4*hx*hy);

        else
            xdf = (str2func(f)(x + hx, y) - str2func(f)(x - hx, y))/(2*hx);
            ydf = (str2func(f)(x, y + hy) - str2func(f)(x, y - hy))/(2*hy);
            xydf = (str2func(f)(x + hx, y + hy) + str2func(f)(x - hx, y - hy) - (str2func(f)(x - hx, y) + str2func(f)(x + hx, y)) - (str2func(f)(x, y - hy) + str2func(f)(x, y + hy)) + 2*str2func(f)(x, y))/(2*hx*hy);
        endif

    else
        %Lado Esquerdo
        if (x == ax)

            xdf = (4*str2func(f)(image, x + hx, y) - str2func(f)(image, x + 2*hx, y) - 3*str2func(f)(image, x, y))/(2*hx);
       
            if (y == ay)
                %Canto Inferior
                ydf = (4*str2func(f)(image, x, y + hy) - str2func(f)(image, x, y + 2*hy) - 3*str2func(f)(image, x, y))/(2*hy);
                xydf = (8*(-str2func(f)(image, x + hx, y) - str2func(f)(image, x, y + hy) + str2func(f)(image, x + hx, y + hy)) - str2func(f)(image, x + 2*hx, y + 2*hy) + str2func(f)(image, x + 2*hx, y) + str2func(f)(image, x, y + 2*hy) + 7*str2func(f)(image, x, y))/(4*hx*hy);

            elseif (y == by)
                %Canto Superior
                ydf = (str2func(f)(image, x, y - 2*hy) - 4*str2func(f)(image, x, y - hy) + 3*str2func(f)(image, x, y))/(2*hy);
                xydf = (8*(str2func(f)(image, x + hx, y) + str2func(f)(image, x, y - hy) - str2func(f)(image, x + hx, y - hy)) + str2func(f)(image, x + 2*hx, y - 2*hy) - str2func(f)(image, x + 2*hx, y) - str2func(f)(image, x, y - 2*hy) - 7*str2func(f)(image, x, y))/(4*hx*hy);

            else
                ydf = (str2func(f)(image, x, y + hy) - str2func(f)(image, x, y - hy))/(2*hy);
                xydf = (4*(str2func(f)(image, x + hx, y + hy) - str2func(f)(image, x + hx, y - hy)) + str2func(f)(image, x + 2*hx, y - hy) - str2func(f)(image, x + 2*hx, y + hy) - 3*(str2func(f)(image, x, y + hy) - str2func(f)(image, x, y - hy)))/(4*hx*hy);
            endif
    
        %Lado Direito     
        elseif (x == bx)
            xdf = (str2func(f)(image, x - 2*hx, y) - 4*str2func(f)(image, x - hx, y) + 3*str2func(f)(image, x, y))/(2*hx);

            %Canto Inferior
            if (y == ay)
                ydf = (4*str2func(f)(image, x, y + hy) - str2func(f)(image, x, y + 2*hy) - 3*str2func(f)(image, x, y))/(2*hy);
                xydf = (8*(str2func(f)(image, x - hx, y) + str2func(f)(image, x, y + hy) - str2func(f)(image, x - hx, y + hy)) + str2func(f)(image, x - 2*hx, y + 2*hy) - str2func(f)(image, x - 2*hx, y) - str2func(f)(image, x, y + 2*hy) - 7*str2func(f)(image, x, y))/(4*hx*hy);
        
            %Canto Superior    
            elseif(y == by)
                ydf = (str2func(f)(image, x, y - 2*hy) - 4*str2func(f)(image, x, y - hy) + 3*str2func(f)(image, x, y))/(2*hy);
                xydf = (8*(-str2func(f)(image, x - hx, y) - str2func(f)(image, x, y - hy) + str2func(f)(image, x - hx, y - hy)) - str2func(f)(image, x - 2*hx, y - 2*hy) + str2func(f)(image, x - 2*hx, y) + str2func(f)(image, x, y - 2*hy) + 7*str2func(f)(image, x, y))/(4*hx*hy);
        
            else
                ydf = (str2func(f)(image, x, y + hy) - str2func(f)(image, x, y - hy))/(2*hy);
                xydf = (4*(str2func(f)(image, x - hx, y - hy) - str2func(f)(image, x - hx, y + hy)) + str2func(f)(image, x - 2*hx, y + hy) - str2func(f)(image, x - 2*hx, y - hy) + 3*(str2func(f)(image, x, y + hy) - str2func(f)(image, x, y - hy)))/(4*hx*hy);
            endif
   
        %Lado Baixo
        elseif (y == ay)
            xdf = (str2func(f)(image, x + hx, y) - str2func(f)(image, x - hx, y))/(2*hx);
            ydf = (4*str2func(f)(image, x, y + hy) - str2func(f)(image, x, y + 2*hy) - 3*str2func(f)(image, x, y))/(2*hy);
            xydf = (4*(str2func(f)(image, x + hx, y + hy) - str2func(f)(image, x - hx, y + hy)) + str2func(f)(image, x - hx, y + 2*hy) - str2func(f)(image, x + hx, y + 2*hy) - 3*(str2func(f)(image, x + hx, y) - str2func(f)(image, x - hx, y)))/(4*hx*hy);

    %Lado Cima
        elseif (y == by)
            xdf = (str2func(f)(image, x + hx, y) - str2func(f)(image, x - hx, y))/(2*hx);
            ydf = (str2func(f)(image, x, y - 2*hy) - 4*str2func(f)(image, x, y - hy) + 3*str2func(f)(image, x, y))/(2*hy);
            xydf = (4*(str2func(f)(image, x - hx, y - hy) - str2func(f)(image, x + hx, y - hy)) + str2func(f)(image, x + hx, y - 2*hy) - str2func(f)(image, x - hx, y - 2*hy) + 3*(str2func(f)(image, x + hx, y) - str2func(f)(image, x - hx, y)))/(4*hx*hy);

        else
            xdf = (str2func(f)(image, x + hx, y) - str2func(f)(image, x - hx, y))/(2*hx);
            ydf = (str2func(f)(image, x, y + hy) - str2func(f)(image, x, y - hy))/(2*hy);
            xydf = (str2func(f)(image, x + hx, y + hy) + str2func(f)(image, x - hx, y - hy) - (str2func(f)(image, x - hx, y) + str2func(f)(image, x + hx, y)) - (str2func(f)(image, x, y - hy) + str2func(f)(image, x, y + hy)) + 2*str2func(f)(image, x, y))/(2*hx*hy);
        endif
    endif
end


function [fx_dxdy, er_dx, er_dy, er_dxy] = find_values (image, control, error, nx, ny, points, f, ax, bx, ay, by)

    max_points = (nx + 1)*(ny + 1);
    fx_dxdy = zeros(2, 2, max_points);
    if (error == 1)
        er_dx = zeros(nx + 1, ny + 1);
        er_dy = zeros(nx + 1, ny + 1);
        er_dxy = zeros(nx + 1, ny + 1);
        f_dz = strcat(f, "_dz");
    endif

    f_z = strcat(f, "_z");

    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;
    k = 1;
    
    for i = 1 : nx + 1
        for j = 1 : ny + 1
            
            [z, zx, zy, zxy] = str2func(f)(image, control, points(j, 1, i), points(j, 2, i), ax, bx, ay, by, hx, hy, f_z);
	        
            fx_dxdy(1, 1, k) = z;
            fx_dxdy(1, 2, k) = zx;
            fx_dxdy(2, 1, k) = zy;
            fx_dxdy(2, 2, k) = zxy;
            
            if (error == 1)
                [dx, dy, dxdy] = str2func(f_dz)(points(j, 1, i), points(j, 2, i));
                er_dx(i, j) = abs(dx - zx);
                er_dy(i, j) = abs(dy - zy);
                er_dxy(i, j) = abs(dxdy - zxy);
            endif
            
            k++;
        endfor
    endfor 
end

function plot (x_axis, y_axis, z_axis)
    mesh(x_axis, y_axis, z_axis);
end

function [x_axis, y_axis, z_axis, z_axis_v] = grid (image, control, delta, nx, ny, ax, bx, ay, by, points, coef, f)
    hx = (bx - ax)/nx;
    hy = (by - ay)/ny;
    
    if (delta == 0)
        grid_nx = nx;
        grid_ny = ny;
        grid_hx = hx;
        grid_hy = hy;       
    else
        grid_nx = (bx - ax)/0.05;
        grid_ny = (by - ay)/0.05;
        grid_hx = grid_hy = 0.05;
    endif

    x_axis = zeros(1, grid_nx + 1);
    y_axis = zeros(1, grid_ny + 1);
    z_axis = zeros(grid_nx + 1, grid_ny + 1);
    z_axis_v = zeros(grid_nx + 1, grid_ny + 1);

    for i = 1  : grid_nx + 1
	x_axis(i) = ax + (i - 1) * grid_hx;
    endfor

    for j = 1 : grid_ny + 1
	y_axis(j) = ay + (j - 1) * grid_hy;
    endfor
       
    for i = 1 : grid_nx + 1 
	   for j = 1 : grid_ny + 1
            if (image == control)
	           z_axis(i, j) = str2func(f)(x_axis(i), y_axis(j));
            else
                z_axis(i, j) = str2func(f)(image, x_axis(i), y_axis(j));
            endif
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

function [z,zx,zy,zxy] = pixel_value(image, control, i, j, ax, bx, ay, by, hx, hy, f)
    
    z = image(i, j);
    [zx, zy, zxy] = aproxdf(image, control, i, j, ax, bx, ay, by, hx, hy, f);
end

function z = pixel_value_z(image, i, j)
    z = image(i, j);
end
        
function draw (image, info, ax, ay, bx, by, nx, ny)
    
    control = zeros(info.Height, info.Width);

    f = "pixel_value";
    f_z = strcat(f, "_z");
    
    points = interpolate_points (nx, ny, ax, bx, ay, by);
    function_data = find_values (image, control, 0, nx, ny, points, f, ax, bx, ay, by);
    coeficientes = constroiv (nx, ny, ax, bx, ay, by, points, function_data);
    [x_axis, y_axis, z_axis, z_axis_v] = grid (image, control, 0, nx, ny, ax, bx, ay, by, points, coeficientes, f_z);
    lim = [];
    figure
    imshow(z_axis_v,lim);
    title('Imagem gerada da Malha Reduzida');
end