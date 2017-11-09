library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real;
use ieee.math_complex.all;
use STD.textio.all;
use IEEE.std_logic_textio.all;
use work.txt_util.all;

package complex_pkg is 
  
subtype ucplx is complex;
--type ucplx is
--record
--  RE: REAL;        -- Real part
--  IM: REAL;        -- Imaginary part
--end record;

--function "+" ( L: in ucplx;  R: in ucplx ) return ucplx;
--function "*" ( L: in ucplx;  R: in ucplx ) return ucplx;
function "*" ( L: in ucplx;  R: in bit ) return ucplx;
function "*" ( L: in bit;  R: in ucplx ) return ucplx;

constant NULL_COMPLEX: ucplx := (-1.0, -1.0);

type ucplx_vector is array(natural range<>) of ucplx;
function resolved (drivers : in ucplx_vector) return ucplx;
subtype cplx is resolved ucplx;
type cplx_vector is array(natural range<>) of cplx;

type bit_matrix is array (natural range<>, natural range<>) of bit;

type cplx_matrix is array (natural range<>, natural range<>) of cplx;
constant I_matrix: cplx_matrix(0 to 1, 0 to 1) := (  
                                            ( (1.0,0.0), (0.0,0.0)  ),
                                            ( (0.0,0.0), (1.0,0.0)  )
                                            );
                                            
constant SWAP_matrix: cplx_matrix(0 to 3, 0 to 3) := (  
                                            ( (1.0,0.0), (0.0,0.0), (0.0,0.0), (0.0,0.0)  ),
                                            ( (0.0,0.0), (0.0,0.0), (1.0,0.0), (0.0,0.0)  ),
                                            ( (0.0,0.0), (1.0,0.0), (0.0,0.0), (0.0,0.0)  ),
                                            ( (0.0,0.0), (0.0,0.0), (0.0,0.0), (1.0,0.0)  )
                                            );                                            
                                            
function CONJ (x:cplx_matrix) return cplx_matrix;
function CONJ (x:bit_matrix) return bit_matrix;                                            
                                            
function tensor (x,y:cplx_matrix) return cplx_matrix;
function tensor_indexed (x: cplx_matrix; x_size: integer; y:cplx_matrix) return cplx_matrix;
function tensor_indexed (x: cplx_matrix; y:cplx_matrix; y_size: integer) return cplx_matrix;
function tensor_indexed (x: cplx_matrix; x_size: integer; y:cplx_matrix; y_size: integer) return cplx_matrix;
function tensor_indexed (x: cplx_matrix; x_size: integer; y:cplx_matrix; y_size: integer; z_size: integer) return cplx_matrix;

type real_vector is array(natural range<>) of real;
type real_matrix is array (natural range<>, natural range<>) of real;
function to_real_vector(x:cplx) return real_vector;
function to_real_vector(x:cplx_matrix) return real_vector;
function to_real_matrix(x:cplx_matrix) return real_matrix;

function "*" ( L: in cplx_matrix;  R: in cplx_vector ) return cplx_vector;
function "*" ( L: in cplx_matrix;  R: in cplx_matrix ) return cplx_matrix;

function MULT (x: cplx_matrix; x_size: integer; y:cplx_matrix; y_size: integer; z_size: integer) return cplx_matrix;
function MULT (x: bit_matrix; x_size: integer; y:cplx_matrix; y_size: integer; z_size: integer) return cplx_matrix;
function MULT (x: cplx_matrix; x_size: integer; y:bit_matrix; y_size: integer; z_size: integer) return cplx_matrix;

procedure PRINT (x:cplx_vector);
procedure PRINT (x:cplx_matrix);

end package complex_pkg;

package body complex_pkg is
  
function CONJ (x:cplx_matrix) return cplx_matrix is
variable y: cplx_matrix(0 to x'LENGTH(1)-1, 0 to x'LENGTH(2)-1);
begin
  for i in 0 to x'LENGTH(1)-1 loop
    for j in 0 to x'LENGTH(2)-1 loop
      y(i,j) := CONJ(x(j,i));
    end loop;
  end loop;
  return y;
end CONJ;

function CONJ (x:bit_matrix) return bit_matrix is
variable y: bit_matrix(0 to x'LENGTH(1)-1, 0 to x'LENGTH(2)-1);
begin
  for i in 0 to x'LENGTH(1)-1 loop
    for j in 0 to x'LENGTH(2)-1 loop
      y(i,j) := x(j,i);
    end loop;
  end loop;
  return y;
end CONJ;

function resolved (drivers : in ucplx_vector) return ucplx is
variable resolved_value: cplx:= (0.0, 0.0); 
begin
   resolved_value:= NULL_COMPLEX;
   if (drivers'length = 1) then
      resolved_value := drivers(drivers'low);
   else
      for index in drivers'range loop
         if drivers(index) /= NULL_COMPLEX then
            resolved_value:= drivers(index); 
           exit; 
         end if;
      end loop;
   end if;
   return resolved_value;
end resolved;

function tensor (x,y:cplx_matrix) return cplx_matrix is
variable z:cplx_matrix(0 to x'LENGTH(1)*y'LENGTH(1)-1, 0 to x'LENGTH(2)*y'LENGTH(2)-1):=(OTHERS =>(OTHERS=>(0.0,0.0)));
begin
  for i1 in 0 to x'LENGTH(1)-1 loop
    for j1 in 0 to x'LENGTH(2)-1 loop
      for i2 in 0 to y'LENGTH(1)-1 loop
        for j2 in 0 to y'LENGTH(2)-1 loop
          z(i1*y'LENGTH(1)+i2,j1*y'LENGTH(2) + j2) := x(i1,j1)*y(i2,j2);
          end loop;
        end loop;
     end loop;
  end loop;
  return z;
end function;

function tensor_indexed (x: cplx_matrix; x_size: integer; y:cplx_matrix) return cplx_matrix is
variable z:cplx_matrix(0 to x'LENGTH(1)-1, 0 to x'LENGTH(2)-1) := (OTHERS =>(OTHERS=>(0.0,0.0)));
begin
  for i1 in 0 to x_size-1 loop
    for j1 in 0 to x_size-1 loop
      for i2 in 0 to y'LENGTH(1)-1 loop
        for j2 in 0 to y'LENGTH(2)-1 loop
          z(i1*y'LENGTH(1)+i2,j1*y'LENGTH(2) + j2) := x(i1,j1)*y(i2,j2);
          end loop;
        end loop;
     end loop;
  end loop;
  return z;
end function;

function tensor_indexed (x: cplx_matrix; y:cplx_matrix; y_size: integer) return cplx_matrix is
variable z:cplx_matrix(0 to y'LENGTH(1)-1, 0 to y'LENGTH(2)-1) := (OTHERS =>(OTHERS=>(0.0,0.0)));
begin
  for i1 in 0 to x'LENGTH(1)-1 loop
    for j1 in 0 to x'LENGTH(2)-1 loop
      for i2 in 0 to y_size-1 loop
        for j2 in 0 to y_size-1 loop
          z(i1*y_size+i2,j1*y_size + j2) := x(i1,j1)*y(i2,j2);
          end loop;
        end loop;
     end loop;
  end loop;
  return z;
end function;

function tensor_indexed (x: cplx_matrix; x_size: integer; y:cplx_matrix; y_size: integer) return cplx_matrix is
variable z:cplx_matrix(0 to x_size*y_size-1, 0 to x_size*y_size-1):=(OTHERS =>(OTHERS=>(0.0,0.0)));
begin
  for i1 in 0 to x_size-1 loop
    for j1 in 0 to x_size-1 loop
      for i2 in 0 to y_size-1 loop
        for j2 in 0 to y_size-1 loop
          z(i1*y_size+i2,j1*y_size + j2) := x(i1,j1)*y(i2,j2);
          end loop;
        end loop;
     end loop;
  end loop;
  return z;
end function;

function tensor_indexed (x: cplx_matrix; x_size: integer; y:cplx_matrix; y_size: integer; z_size: integer) return cplx_matrix is
variable z:cplx_matrix(0 to z_size-1, 0 to z_size-1):=(OTHERS =>(OTHERS=>(0.0,0.0)));
begin
  for i1 in 0 to x_size-1 loop
    for j1 in 0 to x_size-1 loop
      for i2 in 0 to y_size-1 loop
        for j2 in 0 to y_size-1 loop
          z(i1*y_size+i2,j1*y_size + j2) := x(i1,j1)*y(i2,j2);
          end loop;
        end loop;
     end loop;
  end loop;
  return z;
end function;

function to_real_vector(x:cplx) return real_vector is
variable y: real_vector(0 to 1);
begin
  y(0) := x.RE;
  y(1) := x.IM;
  return y;
end function;

function to_real_matrix(x:cplx_matrix) return real_matrix is
variable z:real_matrix(0 to x'LENGTH(1)-1, 0 to x'LENGTH(2)*2-1);
begin
  for i in 0 to x'LENGTH(1)-1 loop
    for j in 0 to x'LENGTH(2)-1 loop
      z(i, j*2) := x(i,j).RE;
      z(i, j*2+1) := x(i,j).IM;
    end loop;
  end loop;
  return z;
end function;

function to_real_vector(x:cplx_matrix) return real_vector is
variable z:real_vector(0 to x'LENGTH(1)*x'LENGTH(2)*2-1);
begin
  for i in 0 to x'LENGTH(1)-1 loop
    for j in 0 to x'LENGTH(2)-1 loop
      z(i*x'LENGTH(1) + j*2) := x(i,j).RE;
      z(i*x'LENGTH(1) + j*2+1) := x(i,j).IM;
    end loop;
  end loop;
  return z;
end function;

--function "+" ( L: in ucplx;  R: in ucplx ) return ucplx is
--begin
--  return (L.RE + R.RE, L.IM + R.IM);
--end function;

--function "*" ( L: in ucplx;  R: in ucplx ) return ucplx is
--begin
-- return (L.RE*R.RE - L.IM*R.IM, L.IM*R.RE + L.RE*R.IM);
--end function;

function "*" ( L: in cplx_matrix;  R: in cplx_vector ) return cplx_vector is
variable z: cplx_vector(0 to R'LENGTH - 1) := (OTHERS=>(0.0,0.0));
begin
  ASSERT L'LENGTH(2) = R'LENGTH
    REPORT "Inconsistent dimensions in matrix-vector multiplication"
    SEVERITY ERROR;
  for i in 0 to L'LENGTH(1) - 1 loop
    for j in 0 to L'LENGTH(2) - 1 loop
      z(i) := z(i) + R(j)*L(i,j);
    end loop;
  end loop;
  return z;
end function;

function "*" ( L: in cplx_matrix;  R: in cplx_matrix ) return cplx_matrix is
variable z: cplx_matrix(0 to L'LENGTH(1) - 1, 0 to R'LENGTH(2) - 1) := (OTHERS => (OTHERS=>(0.0,0.0)));
begin
  ASSERT L'LENGTH(2) = R'LENGTH(1)
    REPORT "Inconsistent dimensions in matrix multiplication"
    SEVERITY ERROR;
  for i in 0 to L'LENGTH(1) - 1 loop
    for j in 0 to R'LENGTH(2) - 1 loop
      for k in 0 to R'LENGTH(1) - 1 loop
        z(i,j) := z(i,j) + L(i,k)*R(k,j);
      end loop;
    end loop;
  end loop;
  return z;
end function;

function MULT (x: cplx_matrix; x_size: integer; y:cplx_matrix; y_size: integer; z_size: integer) return cplx_matrix is
variable z: cplx_matrix(0 to z_size - 1, 0 to z_size - 1) := (OTHERS => (OTHERS=>(0.0,0.0)));
begin
  for i in 0 to x_size - 1 loop
    for j in 0 to y_size - 1 loop
      for k in 0 to y_size - 1 loop
        z(i,j) := z(i,j) + x(i,k)*y(k,j);
      end loop;
    end loop;
  end loop;
  return z;
end function;

function MULT (x: cplx_matrix; x_size: integer; y:bit_matrix; y_size: integer; z_size: integer) return cplx_matrix is
variable z: cplx_matrix(0 to z_size - 1, 0 to z_size - 1) := (OTHERS => (OTHERS=>(0.0,0.0)));
begin
  for i in 0 to x_size - 1 loop
    for j in 0 to y_size - 1 loop
      for k in 0 to y_size - 1 loop
        z(i,j) := z(i,j) + x(i,k)*y(k,j);
      end loop;
    end loop;
  end loop;
  return z;
end function;

function MULT (x: bit_matrix; x_size: integer; y:cplx_matrix; y_size: integer; z_size: integer) return cplx_matrix is
variable z: cplx_matrix(0 to z_size - 1, 0 to z_size - 1) := (OTHERS => (OTHERS=>(0.0,0.0)));
begin
  for i in 0 to x_size - 1 loop
    for j in 0 to y_size - 1 loop
      for k in 0 to y_size - 1 loop
        z(i,j) := z(i,j) + x(i,k)*y(k,j);
      end loop;
    end loop;
  end loop;
  return z;
end function;

function "*" ( L: in ucplx;  R: in bit ) return ucplx is
begin
  if R ='0' then
    return (0.0, 0.0);
  else
  return L;
  end if;
end function;

function "*" ( L: in bit;  R: in ucplx ) return ucplx is
begin
  return R*L;
end function;

procedure PRINT (x:cplx_matrix) is
variable my_line : line;
begin
  for i in 0 to x'LENGTH(1)-1 loop
    for j in 0 to x'LENGTH(2)-1 loop
      write(my_line, string'("("));
      write(my_line, real'image(x(i,j).RE));
      write(my_line, string'(","));
      write(my_line, real'image(x(i,j).IM));
      write(my_line, string'(")"));
      write(my_line, string'(" "));
    end loop;
    writeline(output, my_line);
  end loop;
end procedure;

procedure PRINT (x:cplx_vector) is
variable my_line : line;
begin
  for i in 0 to x'LENGTH-1 loop
    write(my_line, string'("("));
    write(my_line, real'image(x(i).RE));
    write(my_line, string'(","));
    write(my_line, real'image(x(i).IM));
    write(my_line, string'(")"));
    write(my_line, string'(" "));
    writeline(output, my_line);
    end loop;
end procedure;

end complex_pkg;
