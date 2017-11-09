library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.complex_pkg.all;
use work.quantum_systems.all;

entity Rkqgate1 is
  port (
      q: inout qubit_vector (2**qubit_memory_length-1 downto 0);
      clock, enable_input, enable_output, reset:in std_logic;
      parameter1: in signed(4 downto 0);
      address: in unsigned(qubit_memory_address_length-1 downto 0)
  );
end entity Rkqgate1;

architecture ideal of Rkqgate1 is
  signal gate_matrix: cplx_matrix(0 to 1, 0 to 1) := (((1.0,0.0), (0.0,0.0)),
                                                        ((0.0,0.0), (0.0,1.0)));
  signal effective_gate_matrix: cplx_matrix(0 to 2**qubit_memory_length-1, 0 to 2**qubit_memory_length-1);
begin
  
  process(enable_input)
  begin
    if(enable_input = '1') then
      if (to_integer(ieee.numeric_std.signed(parameter1)) >= 0) then
        gate_matrix(1,1) <= polar_to_complex((1.0,(2*3.14159/(2**to_integer(ieee.numeric_std.signed(parameter1)))) - 3.14159 ));
      else
        gate_matrix(1,1) <= polar_to_complex((1.0,(3.14159 - 2*3.14159/(2**to_integer(ieee.numeric_std.signed(-1*parameter1)))) ));
      end if;
    end if;
  end process;
  
  process(reset, clock, enable_input)
  variable q_temp:qubit_vector (2**qubit_memory_length-1 downto 0) := (OTHERS=>((0.0),(0.0)));
  begin
   if(rising_edge(clock)) then
     if(reset='1') then
       q_temp := (OTHERS=>(0.0,0.0));
       q <= (OTHERS=>NULL_COMPLEX);
     else 
       if enable_input = '1' then 
        q_temp := effective_gate_matrix * q;
       elsif enable_output = '1' then
         q <= q_temp;
       else
         q <= (OTHERS=>NULL_COMPLEX);
       end if;
   end if;
  end if;
  end process;
  
  process(reset, clock, address)
  variable temp_effective_gate_matrix: cplx_matrix(0 to 2**qubit_memory_length-1, 0 to 2**qubit_memory_length-1);
  begin
     if(rising_edge(clock)) then
       if(reset='1') then
        temp_effective_gate_matrix := (OTHERS => (OTHERS=>(0.0,0.0)));
        temp_effective_gate_matrix(0,0) := (1.0,0.0);
       else
        temp_effective_gate_matrix := (OTHERS => (OTHERS=>(0.0,0.0)));
        temp_effective_gate_matrix(0,0) := (1.0,0.0);
        print(temp_effective_gate_matrix); 
        for j in 0 to qubit_memory_length-1 loop
          if j = TO_INTEGER(unsigned(address)) then
            temp_effective_gate_matrix := tensor_indexed(gate_matrix, temp_effective_gate_matrix, 2 ** j);
          else
            temp_effective_gate_matrix := tensor_indexed(I_matrix, temp_effective_gate_matrix, 2 ** j);
          end if;
        print(temp_effective_gate_matrix); 
        end loop;
        effective_gate_matrix <= temp_effective_gate_matrix;
      end if;
    end if;
  end process;
   
end architecture ideal;

