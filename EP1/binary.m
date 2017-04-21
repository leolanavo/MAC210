% 2 --> 0 10000000 00000000000000000000000
% 3 --> 0 10000000 10000000000000000000000
% 5 --> 0 10000001 01000000000000000000000

function binary()
 %            |   exponent  | |              significand                   |  
    num2 = [0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1];
    num5 = [0,1,0,0,0,0,0,0,1,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];
    result = sum(num2, num5);
endfunction

function num_ret = sum(bin_a, bin_b)

% Creates the guardian bits and the sticky bit.  
  
  G1 = G2 = SB = 0;

% Creates standard significands, where:
%     |     23 bits         |
%  01 00000000000000000000000
%  ||
%  ||_ ocult bit
%  |_ extra space to make the sum
  
  significand_a = significand_b = zeros(1, 25);
  significand_a(2) = significand_b(2) = 1;

  [offset, exp_ret, comp] = compareExp(bin_a, bin_b);

% Set the significands for the sum, according to the calculated offset, and
% set the guardian bits, as well as the sticky bit.

  if (offset > 0)
    guard = 33 - offset;

% If bin_a has the bigger exponent, then bin_b needs to be rearranged.

    if (comp > 0)
      G1 = bin_b(guard);
      guard++;

      if (guard <= 32)
	G2 = bin_b(guard);
        guard++;
      endif

      while (guard <= 32 && SB != 1)
	if (bin_b(guard == 1)) SB = 1;
        endif
      endwhile

% Set the significands.

      for i = 32:-1:10
	significand_a(i - 7) = bin_a(i);
      endfor

      dif = 32 - offset - 25;
      for i = 32 - offset:-1:10  
	significand_b(i - dif) = bin_b(i); 
      endfor

% If bin_b has the bigger exponent, then bin_a needs to be rearranged.

    else
      G1 = bin_a(guard);
      guard++;

      if (guard <= 32)
	G2 = bin_a(guard);
        guard++;
      endif

      while (guard <= 32 && SB != 1)
	if (bin_a(guard == 1)) SB = 1;
        endif
      endwhile

% Set the significands.
	
      for i = 32:-1:10
	significand_b(i - 7) = bin_b(i);
      endfor

      dif = 32 - offset - 25;
      for i = 32 - offset:-1:10  
	significand_a(i - dif) = bin_a(i); 
      endfor

    endif

% In case the exponents are equal, the rearrangement is not necessary.
  else
    for i = 32:-1:10
      significand_a(i - 7) = bin_a(i);
      significand_b(i - 7) = bin_b(i);
    endfor
    
  endif
    
  bin_a
  bin_b
  exp_ret
  significand_a
  significand_b
  G1
  G2
  num_ret = 0
endfunction


%  The variable comp returns the result of the comparation between bin_a and bin_b
%  (-1, if bin_a < bin_b; 1, if bin_a > bin_b; 0, if bin_a = bin_b).
%  The variable exp_ret returns the value of the biggest exponent.
%  The variable offset returns the number of rows that should be moved.

function [offset, exp_ret, comp] = compareExp(bin_a, bin_b)
  
  expA = expB = 0;
  n = 7;

  for i = 2:9
    expA += bin_a(i)*(2^n);
    expB += bin_b(i)*(2^n); 
    n--;
  endfor

  expA -= 127;
  expB -= 127;

  exp_ret = expA;

  if (expA == expB)
    comp = 0;
    offset = 0;

  elseif (expA < expB)
    offset = expB - expA;
    comp = -1;
    exp_ret = expB;

  else
    offset = expA - expB;
    comp = 1;
  endif

endfunction
