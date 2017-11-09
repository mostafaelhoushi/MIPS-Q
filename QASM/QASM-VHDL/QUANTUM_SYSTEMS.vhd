library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.math_complex.all;
use work.complex_pkg.all;

package quantum_systems is
  
constant qubit_memory_address_length: integer := 2;
constant qubit_memory_length: integer := 2**qubit_memory_address_length;

subtype qubit_vector is cplx_vector;

type qop is (q, I, X, Z, Y, H, Rk, CNOT, CRk, SWAP, MEASURE);
attribute ENUM_ENCODING: STRING;
attribute ENUM_ENCODING of qop:type is "110000 110001 110010 110011 110100 110101 110110 110111 111000 111001 111010";

type qinst is
record
  qopcode: qop;
  parameter1: signed(4 downto 0);
  address1: unsigned(qubit_memory_address_length-1 downto 0);
  address2: unsigned(qubit_memory_address_length-1 downto 0);
end record;
 
end package quantum_systems;


package body quantum_systems is
end quantum_systems;