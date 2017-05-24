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

  teste = points (nx, ny, ax, bx, ay, by)
  teste_pontos = example_1 (nx, ny, teste);
  constroiv (nx, ny, ax, bx, ay, by, teste, teste_pontos);
  
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
  
function constroiv (nx, ny, ax, bx, ay, by, points, fx)
  squares = zeros(2, 2, nx*ny);
  
  for j = 1 : nx*ny    
    squares(1, 1, j) = points(1, 1, i);
    squares(1, 2, j) = points(1, 2, i);
    squares(2, 1, j) = points(2, 1, i + 1);
    squares(2, 2, j) = points(2, 2, i + 1);
  endfor
  squares
end
