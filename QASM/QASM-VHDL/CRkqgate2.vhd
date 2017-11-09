library ieee;
use ieee.math_real.all;
use ieee.math_complex.all;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.complex_pkg.all;
use work.quantum_systems.all;
use std.textio.all;

entity CRkqgate2 is
  port (
    q: inout qubit_vector (0 to 2**qubit_memory_length-1);
    clock, enable_input, enable_output, reset:in std_logic;
    parameter1: in signed(4 downto 0);
    address1, address2: in unsigned(qubit_memory_address_length-1 downto 0)
  );
end entity CRkqgate2;

architecture ideal of CRkqgate2 is
    signal gate_matrix: cplx_matrix(0 to 3, 0 to 3) := (((1.0,0.0), (0.0,0.0), (0.0,0.0), (0.0,0.0)),
                                                          ((0.0,0.0), (1.0,0.0), (0.0,0.0), (0.0,0.0)),
                                                          ((0.0,0.0), (0.0,0.0), (1.0,0.0), (0.0,0.0)),
                                                          ((0.0,0.0), (0.0,0.0), (0.0,0.0), (0.0,1.0)));
    signal effective_gate_matrix: cplx_matrix(0 to 2**qubit_memory_length-1, 0 to 2**qubit_memory_length-1);
begin

  process(enable_input)
  begin
    if(enable_input = '1') then
      if (to_integer(ieee.numeric_std.signed(parameter1)) >= 0) then
        gate_matrix(3,3) <= polar_to_complex((1.0,(2*3.14159/(2**to_integer(ieee.numeric_std.signed(parameter1)))) - 3.14159 ));
      else
        gate_matrix(3,3) <= polar_to_complex((1.0,(3.14159 - 2*3.14159/(2**to_integer(ieee.numeric_std.signed(-1*parameter1)))) ));
      end if;
    end if;
  end process;

  process(reset, clock, enable_input)
  variable q_temp:qubit_vector (0 to 2**qubit_memory_length-1) := (OTHERS=>((0.0),(0.0)));
  begin
   if(rising_edge(clock)) then
     if(reset='1') then
       q_temp := (OTHERS=>(0.0,0.0));
       q <= (OTHERS=>NULL_COMPLEX);
     else
       if enable_input = '1' then 
        q_temp := (OTHERS=>(0.0,0.0));
        q <= (OTHERS=>NULL_COMPLEX);
        
        q_temp := effective_gate_matrix * q;
       elsif enable_output = '1' then
         q <= q_temp;
       else
         q <= (OTHERS=>NULL_COMPLEX);
       end if;
   end if;
  end if;
  end process;
  
  process(reset, clock, address1, address2)
  variable temp_effective_gate_matrix1, temp_effective_gate_matrix2, temp_effective_gate_matrix3, temp_effective_gate_matrix: cplx_matrix(0 to 2**qubit_memory_length-1, 0 to 2**qubit_memory_length-1);
  variable res_gate_matrix: cplx_matrix(0 to 3, 0 to 3);
  variable min_address : integer;
  variable max_address : integer;
  variable j : integer := 0;
  variable trueIndex : std_logic_vector(2**qubit_memory_length-1 downto 0);
  variable rotDimension : integer;
  variable rotMatrix: bit_matrix(0 to 2**qubit_memory_length-1, 0 to 2**qubit_memory_length-1); -- TODO: optimize by making this matrix bit matrix
  variable bitVal1, bitVal2 : std_logic;
  begin
     if(rising_edge(clock)) then
       if(reset='1') then
        temp_effective_gate_matrix := (OTHERS => (OTHERS=>(0.0,0.0)));
        temp_effective_gate_matrix(0,0) := (1.0,0.0);
        
        temp_effective_gate_matrix1 := (OTHERS => (OTHERS=>(0.0,0.0)));
        temp_effective_gate_matrix1(0,0) := (1.0,0.0);
        
        temp_effective_gate_matrix2 := (OTHERS => (OTHERS=>(0.0,0.0)));
        temp_effective_gate_matrix2(0,0) := (1.0,0.0);        
        
        for i in 0 to gate_matrix'LENGTH(1)-1 loop
          for j in 0 to gate_matrix'LENGTH(2)-1 loop
            temp_effective_gate_matrix2(i,j) := gate_matrix(i,j);
          end loop;
        end loop;
        
        temp_effective_gate_matrix3 := (OTHERS => (OTHERS=>(0.0,0.0)));
        temp_effective_gate_matrix3(0,0) := (1.0,0.0);
       else
          res_gate_matrix := gate_matrix;
         
          --min_address := minimum(to_integer(ieee.numeric_std.unsigned(address1)),to_integer(ieee.numeric_std.unsigned(address2)));
          --max_address := maximum(to_integer(ieee.numeric_std.unsigned(address1)),to_integer(ieee.numeric_std.unsigned(address2)));

          min_address := 0;
          max_address := 0;
          if to_integer(ieee.numeric_std.unsigned(address1))  > to_integer(ieee.numeric_std.unsigned(address2)) then
              min_address := to_integer(ieee.numeric_std.unsigned(address2));
              max_address := to_integer(ieee.numeric_std.unsigned(address1));
          else
              min_address := to_integer(ieee.numeric_std.unsigned(address1));
              max_address := to_integer(ieee.numeric_std.unsigned(address2));
          end if;
          
          rotDimension := 2 ** (max_address - min_address + 1);
         
          temp_effective_gate_matrix := (OTHERS => (OTHERS=>(0.0,0.0)));
          temp_effective_gate_matrix(0,0) := (1.0,0.0);
          
          temp_effective_gate_matrix1 := (OTHERS => (OTHERS=>(0.0,0.0)));
          temp_effective_gate_matrix1(0,0) := (1.0,0.0);
          
          if to_integer(ieee.numeric_std.unsigned(address1)) > to_integer(ieee.numeric_std.unsigned(address2)) then
            res_gate_matrix := SWAP_matrix * gate_matrix * CONJ(SWAP_matrix);
          else
            res_gate_matrix := gate_matrix;
          end if;
          
          rotMatrix := (OTHERS => (OTHERS=>'0'));
          
          if (max_address - min_address) > 1 then
            for i in 0 to rotDimension-1 loop
              trueIndex := std_logic_vector(ieee.numeric_std.to_unsigned(i, 2**qubit_memory_length));
              bitVal1 := trueIndex(1); 
              bitVal2 := trueIndex(max_address - min_address);
              trueIndex(max_address - min_address) := bitVal1;
              trueIndex(1) := bitVal2;

              for j in 0 to rotDimension-1 loop
                if to_integer(ieee.numeric_std.unsigned(trueIndex)) = j then
                  rotMatrix(i,j) :=  '1';
                end if;
              end loop;
            end loop;
            
          end if;
          
          for i in 0 to gate_matrix'LENGTH(1)-1 loop
            for j in 0 to gate_matrix'LENGTH(2)-1 loop
              temp_effective_gate_matrix2(i,j) := res_gate_matrix(i,j);
            end loop;
          end loop;          
            
          temp_effective_gate_matrix3 := (OTHERS => (OTHERS=>(0.0,0.0)));
          temp_effective_gate_matrix3(0,0) := (1.0,0.0);
         
          j := 0;
          while j < min_address loop
           temp_effective_gate_matrix1 := tensor_indexed(temp_effective_gate_matrix1, 2 ** j , I_matrix);
           j := j+1;
          end loop;
          
          j := min_address + 1;
          while j <max_address loop
           temp_effective_gate_matrix2 := tensor_indexed(I_matrix, temp_effective_gate_matrix2, 2 ** (j-min_address+1));
           j := j+1;
          end loop;
          
          if (max_address - min_address) > 1 then          
            temp_effective_gate_matrix2 := MULT(rotMatrix, rotDimension, temp_effective_gate_matrix2, 2**(max_address - min_address+1), 2**qubit_memory_length);
            temp_effective_gate_matrix2 := MULT(temp_effective_gate_matrix2, 2**(max_address - min_address+1),  CONJ(rotMatrix), rotDimension, 2**qubit_memory_length);  
          end if;
          
          j := max_address + 1;
          while j <qubit_memory_length loop
           temp_effective_gate_matrix3 := tensor_indexed(temp_effective_gate_matrix3, 2 ** (j-max_address - 1) , I_matrix);
           j := j+1;
          end loop;
      
          temp_effective_gate_matrix := tensor_indexed(temp_effective_gate_matrix3, 2 ** (qubit_memory_length - max_address - 1), 
                                                       temp_effective_gate_matrix2, 2 ** (max_address - min_address + 1),
                                                       2**qubit_memory_length);
           
          temp_effective_gate_matrix := tensor_indexed(temp_effective_gate_matrix, 2 ** (qubit_memory_length - min_address), temp_effective_gate_matrix1, 2 ** (min_address), 2**qubit_memory_length);
                                                       
           effective_gate_matrix <= temp_effective_gate_matrix;
      end if;
    end if;
  end process;
   
end architecture ideal;
