library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;
use std.textio.all;
use work.complex_pkg.all;
use work.quantum_systems.all;

entity qprocessor is
  port(
    qopcode: unsigned(5 downto 0);
    parameter1: signed(4 downto 0);
    address1: unsigned(4 downto 0);
    address2: unsigned(4 downto 0); 
    clock, reset, exec: in std_logic;
    measurement_reg: out unsigned(qubit_memory_length-1 downto 0)
    );  
end;

architecture test of qprocessor is
  
  signal qinstruction: qinst;
  signal qmemory: qubit_vector (0 to 2**qubit_memory_length-1) := (OTHERS => NULL_COMPLEX);
  
begin
  qalu1:entity work.qalu port map(qinstruction, clock, reset, exec, qmemory, measurement_reg);
    
  process(exec)
  begin
    if (exec = '1') then
      if (to_integer(qopcode) <= 58 and to_integer(qopcode) >= 48 ) then
        qinstruction.qopcode <= qop'val(to_integer(qopcode) - 48);
      end if;
      qinstruction.parameter1 <= parameter1;
      qinstruction.address1 <= address1(qubit_memory_address_length-1 downto 0);
      qinstruction.address2 <= address2(qubit_memory_address_length-1 downto 0);
    end if;
  end process;

end;