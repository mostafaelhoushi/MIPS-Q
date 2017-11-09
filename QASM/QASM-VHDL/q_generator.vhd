library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.quantum_systems.all;
use work.complex_pkg.all;

entity q_generator is
  port (
    q: out qubit_vector (0 to 2**qubit_memory_length-1);
    clock, enable, reset:in std_logic;
    signal option: signed(4 downto 0);
    signal address: unsigned(qubit_memory_address_length-1 downto 0)
  );
end entity q_generator;

architecture ideal of q_generator is
begin
   process(reset, clock, enable)
   begin
      if reset = '1' then
         q <= (OTHERS => NULL_COMPLEX);
      elsif rising_edge(clock) then
        if enable = '1' then
          case option(0) is
            when '0' =>
              q <= (0 => (1.0, 0.0), OTHERS => (0.0, 0.0));
            when '1' => 
              q <= (2**to_integer(ieee.numeric_std.unsigned(address)) => (1.0, 0.0), OTHERS => (0.0, 0.0));
            when others =>
              q <= (0 => (1.0, 0.0), OTHERS => (0.0, 0.0));
          end case;
        else
          q <= (OTHERS => NULL_COMPLEX);
         end if;
      end if;         
   end process;
end architecture ideal;