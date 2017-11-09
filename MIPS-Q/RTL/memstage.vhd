-------------------------------------------------------------------------------
--
--  MYRISC project in SME052 by
--
--  Anders Wallander
--  Department of Computer Science and Electrical Engineering
--  Luleå University of Technology
--  
--  A VHDL implementation of a MIPS, based on the MIPS R2000 and the
--	processor described in Computer Organization and Design by 
--	Patterson/Hennessy
--
--
--  Memory stage
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library Work;
use Work.RiscPackage.all;

entity MemStage is
	port (Clk   : in std_logic;
				Reset   : in std_logic;				
				Rdy_n	:	in	std_logic;
				
				In_Ctrl_WB    : in TypeWBCtrl;
				In_Ctrl_Mem : in TypeMEMCtrl;
				In_ALU  : in TypeWord;
				In_Data : in TypeWord;
				In_DestReg: in TypeRegister;
				
				In_IntBusGrant_n :	in	std_logic;
				
				Bus_Data  : inout TypeWord;   
				Bus_Addr  : out TypeWord;
				Bus_Rd_n    : out std_logic;
				Bus_Wr_n    : out std_logic;

				BP_Mem_iData: out TypeWord;     -- Bypass to idecode
				BP_Mem_iRDest:  out TypeRegister; -- Bypass to idecode
				BP_Mem_iRegWrite: out std_logic;  -- Bypass to idecode
				
				Mem_Ctrl_WB : out TypeWBCtrl;
				Mem_Data: out TypeWord;
				Mem_DestReg: out TypeRegister;
				Quantum_Measurement_Reg:  in unsigned(	3 downto	0	) 
				);
end;

architecture RTL of MemStage  is

	-- Mem to Reg mux
	signal mr_mux:  TypeWord;

begin 
		

-------------------------------------------------------------------------------
-- Mem to reg multiplexer
------------------------------------------------------------------------------- 
	mr_mux <= "0000000000000000000000000000" & Quantum_Measurement_Reg when In_Ctrl_Mem.QuantumMeasRead ='1' else
	          Bus_Data when In_Ctrl_Mem.MemRead = '1' else
						In_ALU; 

--------------------------------------------------------------------------------------              
-- Bus stuff
--------------------------------------------------------------------------------------    
	
	-- Tristate address bus if no access...
	Bus_Addr <= In_ALU when In_IntBusGrant_n = '0' else
							(others => 'Z');
							
	Bus_Rd_n <= not In_Ctrl_Mem.MemRead when In_IntBusGrant_n = '0' else
							'Z';                  

	-- Write when MemWrite asserted                   
	Bus_Wr_n <= not In_Ctrl_Mem.MemWrite when In_IntBusGrant_n = '0' else
							'Z';                     
								
	-- Output data when MemWrite asserted
	Bus_Data <= In_Data when In_Ctrl_Mem.MemWrite = '1' and In_IntBusGrant_n = '0' else
					(others => 'Z');    
	
-------------------------------------------------------------------------------
-- Shift the pipeline
-------------------------------------------------------------------------------
	
	pipeline : process(Clk,Reset)  
	begin                                        
		if reset = '1' then   
			-- TODO - do we really need to flush everything?
			Mem_Ctrl_WB <= (others => '0');
			Mem_DATA <= (others => '0');
			Mem_DestReg <= (others => '0');     
		elsif rising_edge(Clk) then
			if (Rdy_n = '1') then
				Mem_Ctrl_WB <= In_Ctrl_WB;
				Mem_DATA <= mr_mux;
				Mem_DestReg <= In_DestReg;
			end if;
		end if;                                      
	end process;    
	
-------------------------------------------------------------------------------
-- Pass signals to idecode
------------------------------------------------------------------------------- 
	BP_Mem_iData <= mr_mux;
	BP_Mem_iRDest <= In_DestReg;
	BP_Mem_iRegWrite <= In_Ctrl_WB.RegWrite;
	
end architecture RTL;


