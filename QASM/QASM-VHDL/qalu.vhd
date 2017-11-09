library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.complex_pkg.all;
use work.quantum_systems.all;

entity qalu is
  port(
    qinstruction: in qinst; 
    clock, reset, exec: in std_logic;
    qmemory: inout qubit_vector (0 to 2**qubit_memory_length-1);
    measurement_reg: out unsigned(qubit_memory_length-1 downto 0)
    );
end;

architecture ideal of qalu is
  signal enable_input : std_logic_vector(0 to 10) := (OTHERS => '0');
  signal enable_output : std_logic_vector(0 to 10):= (OTHERS => '0');
  signal qopcode: qop;
  signal address1: unsigned(qubit_memory_address_length-1 downto 0) := (OTHERS => '0');
  signal address2: unsigned(qubit_memory_address_length-1 downto 0) := (OTHERS => '0');
  signal parameter1: signed(4 downto 0) := (OTHERS => '0');
  
  type STATE_TYPE is (S0, S1, S2, S3, S4);
  attribute ENUM_ENCODING: STRING;
  attribute ENUM_ENCODING of STATE_TYPE:type is "000 001 010 011 100";
  signal CS, NS: STATE_TYPE;  
begin
   qopcode <= qinstruction.qopcode;
   address1 <= qinstruction.address1;
   address2 <= qinstruction.address2;
   parameter1 <= qinstruction.parameter1;
   
   qgen:entity work.q_generator port map(qmemory, clock, enable_output(qop'pos(q)), reset, parameter1, address1);
   qmeas:entity work.qmeasure port map(qmemory, clock, enable_input(qop'pos(MEASURE)), enable_output(qop'pos(MEASURE)), reset, address1, measurement_reg);
   Igate:entity work.qgate1 generic map((1.0,0.0),(0.0,0.0),
                                    (0.0,0.0),(1.0,0.0))
                          port map(qmemory, clock, enable_input(qop'pos(I)), enable_output(qop'pos(I)), reset, address1);  

   Xgate:entity work.qgate1 generic map((0.0,0.0),(1.0,0.0),
                                    (1.0,0.0),(0.0,0.0))
                          port map(qmemory, clock, enable_input(qop'pos(X)), enable_output(qop'pos(X)), reset, address1);  
   Zgate:entity work.qgate1 generic map((1.0,0.0),(0.0,0.0),
                                    (0.0,0.0),(-1.0,0.0))
                          port map(qmemory, clock, enable_input(qop'pos(Z)), enable_output(qop'pos(Z)), reset, address1);     
   Ygate:entity work.qgate1 generic map((1.0,0.0),(0.0,0.0),
                                    (0.0,0.0),(0.0,-1.0))
                          port map(qmemory, clock, enable_input(qop'pos(Y)), enable_output(qop'pos(Y)), reset, address1);                                                   
   Hgate:entity work.qgate1 generic map((0.707,0.0),(0.707,0.0),
                                    (0.707,0.0),(-0.707,0.0))
                          port map(qmemory, clock, enable_input(qop'pos(H)), enable_output(qop'pos(H)), reset, address1);
   Rkgate:entity work.Rkqgate1 port map(qmemory, clock, enable_input(qop'pos(Rk)), enable_output(qop'pos(Rk)), reset, parameter1, address1);
   CNOTgate:entity work.qgate2 generic map((1.0,0.0),(0.0,0.0),(0.0,0.0),(0.0,0.0),
                                       (0.0,0.0),(1.0,0.0),(0.0,0.0),(0.0,0.0),
                                       (0.0,0.0),(0.0,0.0),(0.0,0.0),(1.0,0.0),
                                       (0.0,0.0),(0.0,0.0),(1.0,0.0),(0.0,0.0)
                                     )
                          port map(qmemory, clock, enable_input(qop'pos(CNOT)), enable_output(qop'pos(CNOT)), reset, address1, address2);                 
   SWAPgate:entity work.qgate2 generic map((1.0,0.0),(0.0,0.0),(0.0,0.0),(0.0,0.0),
                                       (0.0,0.0),(0.0,0.0),(1.0,0.0),(0.0,0.0),
                                       (0.0,0.0),(1.0,0.0),(0.0,0.0),(0.0,0.0),
                                       (0.0,0.0),(0.0,0.0),(0.0,0.0),(1.0,0.0)
                                     )
                          port map(qmemory, clock, enable_input(qop'pos(SWAP)), enable_output(qop'pos(SWAP)), reset, address1, address2);                                                               
   CRkgate:entity work.CRkqgate2 port map(qmemory, clock, enable_input(qop'pos(CRk)), enable_output(qop'pos(CRk)), reset, parameter1, address1, address2);
  process(clock, reset) is
  begin
    if(rising_edge(clock)) then
      if(reset='1') then
        CS <= S0;
      else
        if(exec='1') then
          CS <= S1;
        else
          CS <= NS;
        end if;
      end if;
    end if;
  end process; 


  process(CS) is
  variable qtemp: qubit_vector (0 to 2**qubit_memory_length-1) := (OTHERS => NULL_COMPLEX);    
  begin        
    case CS is
      when S0 =>
        qmemory <= qtemp;
        enable_input <= (OTHERS => '0');
        enable_output <= (OTHERS => '0');                  
      when S1 =>
        enable_input(qop'pos(qopcode)) <= '1';
        NS <= S2;
      when S2 =>
        enable_input(qop'pos(qopcode)) <= '0';
        enable_output(qop'pos(qopcode)) <= '1';
        NS <= S3;
      when S3 =>
        qmemory <= (OTHERS => NULL_COMPLEX);
        NS <= S4;           
      when S4 =>
        enable_output(qop'pos(qopcode)) <= '0';
        qtemp := qmemory;
        NS <= S0;
    end case;
  end process;
  
  
end;
