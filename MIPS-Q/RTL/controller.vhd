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
--  Controller
--    Decode instructions
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library Work;
use Work.RiscPackage.all;

entity Controller is
	port (Instr     : in TypeWord;       
				Ctrl_IF   : out TypeIFCtrl;
				Ctrl_ID   : out TypeIDCtrl;
				Ctrl_Ex   : out TypeExCtrl;
				Ctrl_Mem  : out TypeMemCtrl;
				Ctrl_WB   : out TypeWBCtrl;
				Ctrl_Q    : out TypeQCtrl
		 );
end;

architecture RTL of Controller  is

	-- Instruction aliases
	alias Op : unsigned(5 downto 0) is Instr(31 downto 26);
	alias Rs : TypeRegister is Instr(25 downto 21);
	alias Rt : TypeRegister is Instr(20 downto 16);
	alias Rd : TypeRegister is Instr(15 downto 11);
	alias Shift : TypeRegister is Instr(10 downto 6);
	alias Funct : unsigned(5 downto 0) is Instr(5 downto 0);

begin

-------------------------------------------------------------------------------
-- Main Controller
-------------------------------------------------------------------------------
	mainController: Process(Op, Funct)
	
	variable OP_iForm:  std_logic;
	variable OP_lw  : std_logic;
	variable OP_sw  : std_logic; 
	variable OP_branch: std_logic;
	variable OP_jump: std_logic;    
	variable OP_jal:  std_logic;    
	variable OP_jr: std_logic;    
	variable OP_lui:  std_logic;    
	variable OP_ShiftSel: std_logic;
	variable OP_ZeroExtend: std_logic;
	variable OP_RegWrite: std_logic;    
	variable OP_q: std_logic;
	variable OP_qmeas: std_logic; 
	variable OP_ALU_OP: TypeALUOpcode;
	
	begin
		OP_iForm := '0';
		OP_lw := '0';
		OP_sw := '0';
		OP_branch := '0';   
		OP_jump := '0';   
		OP_jal := '0';  
		OP_jr := '0';
		OP_lui := '0';
		OP_ShiftSel := '0';
		OP_ZeroExtend := '0';
		OP_RegWrite := '0';
		OP_q := '0';
		OP_qmeas := '0';
		OP_ALU_OP := (others => '0');				
	              
		if (OP = "000000") then -- If OP field is null analyse extended opfield
			OP_RegWrite := Funct(5) or not(Funct(3)); -- RegWrite asserted when arithmetic operation...
			case Funct(5 downto 3) is
				--when  "100000" | 
				--			"100001" => OP_ALU_OP := ALU_ADD;         -- (add) -Note: No care is taken for overflow...
				--when  "100010" | 
				--			"100011" => OP_ALU_OP := ALU_SUB;         -- (sub) -Note: No care is taken for overflow...
				--when  "100100" => OP_ALU_OP := ALU_AND;         -- (and)
				--when  "100101" => OP_ALU_OP := ALU_OR;          -- (or)
				--when  "100110" => OP_ALU_OP := ALU_XOR;         -- (xor)				
				when	"100" => OP_ALU_OP	:= '0' & Funct(2 downto 0);	-- Arithmetic
				
				--when  "101010" => OP_ALU_OP := ALU_SLT;         -- (slt)
				--when  "101011" => OP_ALU_OP := ALU_SLTU;        -- (sltu)				
				when	"101" =>	OP_ALU_OP := "10" & Funct(1 downto 0);	-- Slt and sltu
				
				--when  "000000" => OP_ALU_OP := ALU_SLL; OP_ShiftSel := '1';   -- (sll)
				--when  "000010" => OP_ALU_OP := ALU_SRL; OP_ShiftSel := '1'; -- (slr)
				--when  "000011" => OP_ALU_OP := ALU_SRA; OP_ShiftSel := '1'; -- (sra)				
				when	"000" =>	OP_ALU_OP	:= "11" & Funct(1 downto 0);	OP_ShiftSel := '1';-- Shift operations
				
				when  "001" => OP_jump := '1'; OP_jr:='1';   -- (jr)
				when  "110" | "111" => OP_q := '1'; OP_RegWrite := '0';
				when others =>  null;				-- TODO exception
			end case;
		elsif (OP(5 downto 4) = "11") then
		  OP_q := '1';
		  OP_iForm := '1';
		  if (OP(5 downto 0) = "111111") then
		    OP_q := '0';
		    OP_qmeas := '1';
		    OP_lw := '1';
		    --OP_RegWrite := '1';
		  end if; 
		else
			OP_iForm := '1';
			OP_RegWrite := (not OP(5)) and OP(3); -- RegWrite asserted when arithmetic operation...
			case OP is                      
				when  "001000" | 
							"001001"=>  OP_ALU_OP := ALU_ADD;         -- (addi) -Note: No care is taken for overflow...                         
				when  "001100" => OP_ALU_OP := ALU_AND; OP_ZeroExtend := '1'; -- (andi)
				when  "001101" => OP_ALU_OP := ALU_OR;  OP_ZeroExtend := '1'; -- (ori)
				when  "001110" => OP_ALU_OP := ALU_XOR; OP_ZeroExtend := '1'; -- (xori)								
				
				when  "001010" => OP_ALU_OP := ALU_SLT;         -- (slti)
				when  "001011" => OP_ALU_OP := ALU_SLTU;        -- (sltiu)				
				
				when  "100011" => OP_lw := '1';                 -- (lw)
													OP_ALU_OP := ALU_ADD;       
				when  "101011" => OP_sw := '1';                 -- (sw)
													OP_ALU_OP := ALU_ADD; 
														
				when  "001111" => OP_ALU_OP := ALU_SLL;         -- (lui)
													OP_lui := '1';              
													OP_ShiftSel := '1';                      
				when  "000100" |
							"000101" => OP_branch := '1';             -- (beq)                            
				when  "000010" => OP_jump   := '1';             -- (j)
				when  "000011" => OP_jump   := '1'; 
													OP_jal := '1';
													OP_ALU_OP := ALU_ADD;         --(jal)
				when others =>  null;			-- TODO exception
			end case;               
		end if;
				
		Ctrl_IF.bne <= OP(0);
		Ctrl_IF.Branch <= OP_branch;
		Ctrl_IF.Jump <= OP_jump;
		
		Ctrl_ID.Branch <= OP_branch;        
		Ctrl_ID.Jr  <= OP_jr;
		Ctrl_ID.Lui <= OP_lui;        
		Ctrl_ID.ShiftVar <= Funct(2);   -- Always asserted if variable shift instruction          
		Ctrl_ID.ZeroExtend <= OP_ZeroExtend;  
		
		Ctrl_Ex.JumpLink <= OP_jal;
		Ctrl_Ex.ShiftSel <= OP_ShiftSel and not (OP_jal); -- Assert if shift operations
		Ctrl_Ex.ImmSel <= OP_iForm and not (OP_jal);
		Ctrl_Ex.OP <= OP_ALU_OP;
	
		Ctrl_Mem.MemRead <= OP_lw;
		Ctrl_Mem.MemWrite <= OP_sw;     
		Ctrl_Mem.MemBusAccess_n <= not(OP_lw or OP_sw);
		Ctrl_Mem.QuantumMeasRead <= OP_qmeas;
		
		Ctrl_WB.RegWrite <= OP_RegWrite or OP_lw or OP_jal;
		
		Ctrl_Q.QuantumEnable <= OP_q;     
	
	end process;  

end architecture RTL;