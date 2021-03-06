library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.complex_pkg.all;
use work.quantum_systems.all;

entity qmeasure is
  generic (
      gSEED1, gSEED2: positive := 1
  );
  port (
      q: inout qubit_vector (0 to 2**qubit_memory_length-1);
      clock, enable_input, enable_output, reset:in std_logic;
      address: in unsigned(qubit_memory_address_length-1 downto 0);
      measurement_reg: out unsigned(0 to qubit_memory_length-1)
  );
end entity qmeasure;

architecture ideal of qmeasure is
begin
  process(reset, clock, enable_input)
  variable q_temp:qubit_vector (0 to 2**qubit_memory_length-1) := (OTHERS=>((0.0),(0.0)));
  variable probEq1, probSum : real := 0.0;
  variable seed1, seed2: positive;
  variable rand: real;
  variable i_slv: std_logic_vector(qubit_memory_length-1 downto 0);
  variable temp_measurement_reg: unsigned(qubit_memory_length-1 downto 0);
  begin
   if(rising_edge(clock)) then
     if(reset='1') then
       seed1 := gSEED1;
       seed2 := gSEED2;
       q_temp := (OTHERS=>(0.0,0.0));
       q <= (OTHERS=>NULL_COMPLEX);
       probEq1 := 0.0;
       probSum := 0.0;
       measurement_reg <= (OTHERS=>'0');
       temp_measurement_reg := (OTHERS=>'0');
     else 
       if enable_input = '1' then 
        q_temp := q;
        for i in 0 to 2**qubit_memory_length-1 loop
          i_slv := std_logic_vector(to_unsigned(i, qubit_memory_length));
          if i_slv(to_integer(address)) = '1' then
            probEq1 := probEq1 + ABS(q(i))*ABS(q(i));
          end if;
        end loop;
        
        UNIFORM(seed1, seed2, rand);
        if (rand < probEq1) then
          temp_measurement_reg(to_integer(address)) := '1';
        else
          temp_measurement_reg(to_integer(address)) := '0';
        end if;
        
        probSum := 0.0;
        for i in 0 to 2**qubit_memory_length-1 loop
          i_slv := std_logic_vector(to_unsigned(i, qubit_memory_length));
          if i_slv(to_integer(address)) /= temp_measurement_reg(to_integer(address)) then
            q_temp(i) := (0.0, 0.0);
          end if;
          probSum := probSum + ABS(q_temp(i))*ABS(q_temp(i));
        end loop;
        
        for i in 0 to 2**qubit_memory_length-1 loop
          q_temp(i) := q_temp(i) / sqrt(probSum);
        end loop;         
        
       elsif enable_output = '1' then
         q <= q_temp;
         measurement_reg <= temp_measurement_reg;
       else
         q <= (OTHERS=>NULL_COMPLEX);
         probEq1 := 0.0;
       end if;
   end if;
  end if;
  end process;
  
end architecture ideal;