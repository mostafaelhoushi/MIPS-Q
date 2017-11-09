library ieee;
use ieee.std_logic_1164.all;
use ieee.math_real;
use ieee.math_complex.all;
use work.fixed_float_types.all;
use work.fixed_pkg.all;

package complex_fixed is 

constant N : integer := 10;

type complex_ufixed is record
  RE : sfixed (1 downto -N);
  IM : sfixed (1 downto -N);
end record;

constant NULL_REAL: sfixed (1 downto -N) := (OTHERS=>'Z');
constant NULL_IMAGINARY: sfixed (1 downto -N) := (OTHERS=>'Z');
constant NULL_COMPLEX: complex_ufixed := (NULL_REAL, NULL_IMAGINARY);

function to_cplxfixed (CMPLX: complex) return complex_ufixed;
function "*" ( L: in complex_ufixed;  R: in complex_ufixed) return complex_ufixed;
function "+" ( L: in complex_ufixed;  R: in complex_ufixed) return complex_ufixed;

type complex_ufixed_vector is array(natural range<>) of complex_ufixed;
function resolved (drivers : in complex_ufixed_vector) return complex_ufixed;
subtype complex_fixed is resolved complex_ufixed;
type complex_fixed_vector is array(natural range<>) of complex_fixed;

end package complex_fixed;

package body complex_fixed is

function to_cplxfixed (CMPLX: complex) return complex_ufixed is
begin
  return (to_sfixed(CMPLX.RE, -1, N), to_sfixed(CMPLX.IM, -1, N));
end function;

function "*" ( L: in complex_ufixed;  R: in complex_ufixed ) return complex_ufixed is
begin
	return (resize(L.RE*R.RE - L.IM*R.IM, -1, N) , resize(L.RE*R.IM + L.IM*R.RE, -1, N));
end function;

function "+" ( L: in complex_ufixed;  R: in complex_ufixed ) return complex_ufixed is
begin
	return (L.RE+R.RE, L.IM+R.IM);
end function;

function resolved (drivers : in complex_ufixed_vector) return complex_ufixed is
variable resolved_value: complex_ufixed:= to_cplxfixed((0.0, 0.0)); 
begin
   if (drivers'length = 1) 
      then return drivers(drivers'low);
   else
      for index in drivers'range loop
         if drivers(index) /= NULL_COMPLEX then
            resolved_value:= drivers(index); 
           exit; 
         end if;
      end loop;
      return resolved_value;
   end if;
end resolved;

end complex_fixed;