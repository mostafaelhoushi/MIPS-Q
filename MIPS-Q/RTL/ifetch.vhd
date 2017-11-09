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
--  Instruction fetch stage
--    - Evaluate the program counter
--    - Fetch instructions
--
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library Work;
use Work.RiscPackage.all;

entity ifetch is
	
	port (
		Clk           : in  std_logic;
		Reset         : in  std_logic;		   
		In_Stall_IF 	: in  std_logic;    -- Asserted if pipe line is stalled
		In_ID_Req     : in  std_logic;    -- Asserted if RegA equals RegB from the registerfile (Including bypass...) 
		In_ID_BAddr   : in  TypeWord;     -- Jump/Branch target address
		In_Ctrl_IF		: in  TypeIFCtrl;
		Init_n				:	in std_logic;
		Rdy_n				:	in std_logic;
		Bus_Data  		: inout TypeWord;   
		Bus_Addr  		: out TypeWord;
		Bus_Rd_n    	: out std_logic;      
		Bus_Wr_n    	: out std_logic;      
		IF_IP     		: out TypeWord;
		IF_Instr  		: out TypeWord);
		
end ifetch;

Architecture Struct of ifetch is

	signal nextPC : TypeWord;           -- Next PC
	signal intPC : TypeWord;            -- Internal PC   
	signal intIncPC : TypeWord;         -- Internal incremented PC
	signal instrData_i: TypeWord;
	signal Stall : std_logic;
	signal TriStateBus : std_logic;
	
begin

	process (Clk, Reset)
	begin  -- process
		if Reset = '1' then
			intPC <= x"0000_0100"; --(others => '0');
		elsif rising_edge(Clk) then 
			if Stall = '0' then
				intPC <= nextPC;
			end if;
			
			if Init_n = '0' then
				intPC <= x"0000_0100"; --(others => '0');
			end if;
			
		end if;    
	end process;

	
	-- Multiplex next PC  
	nextPC <= In_ID_BAddr when ( ( (In_ID_Req = '1' xor In_Ctrl_IF.bne = '1') and In_Ctrl_IF.Branch = '1') or In_Ctrl_IF.Jump = '1') else
						intIncPC;

	-- Increment PC with 4
	intIncPC <= intPC + X"0000_0004";


--------------------------------------------------------------------------------------
-- Bus stuff
--------------------------------------------------------------------------------------    
			
	-- Evaluate stall
	Stall <= In_Stall_IF or (not Rdy_n);
	TriStateBus <= In_Stall_IF or (not Init_n);
	
	-- Tristate address bus if stall
	Bus_Addr <= intPC when TriStateBus = '0' else
								(others => 'Z');
								
	-- Insert NOP instruction if stall...               
	InstrData_i <= Bus_Data;

	-- Only read from bus when data memory is not accessed
	Bus_Rd_n <= '0' when TriStateBus = '0' else
				'Z';                  
				
	Bus_Wr_n <= '1' when TriStateBus = '0' else
				'Z';
								
	-- Always output tristate on data (never write...)
	Bus_Data <= (others => 'Z'); 

	
--------------------------------------------------------------------------------------
-- Shift pipeline
--------------------------------------------------------------------------------------    
	pipeline : process(Clk, Reset)  
	begin                                        
		if reset = '1' then       
			IF_IP <= x"0000_0100"; --(others => '0');
			IF_Instr <= (others => '0');          
		elsif rising_edge(Clk) then   	
			if Stall = '0' then 
				IF_IP <= intIncPC;
				IF_Instr <= InstrData_i;
			end if;
			
			if Init_n = '0' then
				IF_IP <= x"0000_0100"; --(others => '0');
				IF_Instr <= (others => '0');
			end if;
			
		end if;                                      
	end process;                    

	
end architecture Struct;
