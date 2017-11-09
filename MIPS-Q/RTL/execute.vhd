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
--  Execute stage
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library Work;
use Work.RiscPackage.all;

entity Execute is
	port (Clk   : in std_logic;
				Reset : in std_logic;				
				Rdy_n	:	in	std_logic;    
				
				In_Ctrl_Ex  : in TypeExCtrl;
				In_Ctrl_Mem	: in TypeMEMCtrl;
				In_Ctrl_WB  : in TypeWBCtrl;
				In_Ctrl_Q  : in TypeQCtrl;
				In_A  			: in TypeWord;
				In_B  			: in TypeWord;
				In_IMM			: in TypeWord;  
				In_Shift		: in TypeRegister;    
				In_DestReg	: in TypeRegister; 
				In_IP 			: in TypeWord;  
				In_qopcode: in unsigned(5 downto 0);
        In_qparameter1: in unsigned(4 downto 0);
        In_qaddress1: in unsigned(4 downto 0);
        In_qaddress2: in unsigned(4 downto 0);
								
				BP_EX_iData	:	out TypeWord;       -- Bypass to idecode
				BP_EX_iRDest:	out TypeRegister;   -- Bypass to idecode
				BP_EX_iRegWrite: out  std_logic;  -- Bypass to idecode         
				
				EX_Ctrl_WB  : out TypeWBCtrl;
				EX_Ctrl_Mem : out TypeMemCtrl;
				EX_Ctrl_Q	:	out	TypeQCtrl;		            
				EX_ALU  : out TypeWord;
				EX_DATA: out TypeWord;
				EX_DestReg: out TypeRegister;
				EX_qopcode: out unsigned(5 downto 0);
        EX_qparameter1: out unsigned(4 downto 0);
        EX_qaddress1: out unsigned(4 downto 0);
        EX_qaddress2: out unsigned(4 downto 0)  
				);
end;

architecture RTL of Execute is

	-- ALU  
	signal alu_RegA : TypeWord;
	signal alu_RegB : TypeWord;
	signal alu_Shift  : TypeWord;
	signal alu_Result: TypeWord;

begin
-------------------------------------------------------------------------------
-- Zero extend shift value
-------------------------------------------------------------------------------   
	-- TODO ... Isn't this just too ugly...?
	alu_Shift <= x"000000" & "000" & In_Shift;
	
-------------------------------------------------------------------------------
-- Shift / JumpLink multiplexer
-------------------------------------------------------------------------------                         
	alu_RegA <= alu_Shift when In_Ctrl_Ex.ShiftSel = '1' else
							x"0000_0004" when In_Ctrl_Ex.JumpLink = '1' else
							In_A;
	
-------------------------------------------------------------------------------
-- Immediate / JumpLink multiplexer
-------------------------------------------------------------------------------
	alu_RegB <= In_IMM when In_Ctrl_Ex.ImmSel = '1' else
							In_IP when In_Ctrl_Ex.JumpLink = '1' else
							In_B;
	
-------------------------------------------------------------------------------
-- ALU
-------------------------------------------------------------------------------
	
	ALU : process(alu_RegA, alu_RegB)  
	variable alu_TempResult : TypeWord;
	begin                                        
		case In_Ctrl_Ex.OP is
			when	ALU_ADD | 
						ALU_ADDU	=> alu_Result <= alu_RegA + alu_RegB;                                     
			when	ALU_SUB |
						ALU_SUBU	=> alu_Result <=  alu_RegA - alu_RegB;
			when	ALU_AND => alu_Result <= alu_RegA and alu_RegB;
			when	ALU_OR => alu_Result <= alu_RegA or alu_RegB; 
			when	ALU_XOR => alu_Result <= alu_RegA xor alu_RegB;
			when	ALU_NOR => alu_Result <= alu_RegA nor alu_RegB;
			
--			when ALU_SLT => alu_Result(31 downto 1) <= (others => '0'); alu_Result(0) <=  (signed(alu_RegA) - signed(alu_RegB))(31);
--			when ALU_SLTU=> alu_Result(31 downto 1) <= (others => '0'); alu_Result(0) <=  ( alu_RegA - alu_RegB )(31);
			when	ALU_SLT => alu_Result(31 downto 1) <= (others => '0'); alu_TempResult := unsigned((signed(alu_RegA) - signed(alu_RegB))); alu_Result(0) <=  alu_TempResult(31);
			when	ALU_SLTU=> alu_Result(31 downto 1) <= (others => '0'); alu_TempResult :=  unsigned(( alu_RegA - alu_RegB )); alu_Result(0) <=  alu_TempResult(31);      
			
			when	ALU_SLL => alu_Result <=  shift_left( alu_RegB, to_integer(alu_RegA(4 downto 0))); 
			when	ALU_SRL => alu_Result <=  shift_right( alu_RegB, to_integer(alu_RegA(4 downto 0))); 
			when	ALU_SRA => alu_Result <=  unsigned(shift_right( signed(alu_RegB), to_integer(alu_RegA(4 downto 0)))); 
			when	others => alu_Result <= (others=>'-');
		end case;                                                                         
	end process;  
					
	
-------------------------------------------------------------------------------
-- Shift the pipeline
-------------------------------------------------------------------------------
	
	pipeline : process(Clk,Reset)  
	begin                                        
		if reset = '1' then   
			EX_Ctrl_Mem <= ('0','0','1', '0');    
			EX_Ctrl_WB <= (others => '0');
			EX_Ctrl_Q <= (others => '0');
			EX_ALU <= (others => '0');
			EX_DATA <= (others => '0');
			EX_DestReg <= (others => '0'); 
			EX_qopcode <= (others => '0'); 
      EX_qparameter1 <= (others => '0'); 
      EX_qaddress1 <= (others => '0'); 
      EX_qaddress2 <= (others => '0'); 
		elsif rising_edge(Clk) then  
			if (Rdy_n = '1') then 
				EX_Ctrl_Mem <= In_Ctrl_Mem;           
				EX_Ctrl_WB <= In_Ctrl_WB;
				EX_Ctrl_Q <= In_Ctrl_Q;
				EX_ALU <= alu_Result;  
				EX_DATA <= In_B;      
				EX_DestReg <= In_DestReg; 
				EX_qopcode <= In_qopcode; 
        EX_qparameter1 <= In_qparameter1; 
        EX_qaddress1 <= In_qaddress1; 
        EX_qaddress2 <= In_qaddress2; 
			end if;
		end if;                                      
	end process;            


-------------------------------------------------------------------------------
-- Bypass signals to idecode
-------------------------------------------------------------------------------
	
	BP_EX_iData <= alu_Result;
	BP_EX_iRDest <= In_DestReg;
	BP_EX_iRegWrite <= In_Ctrl_WB.RegWrite;

end architecture RTL;





