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
--  Instruction decode stage
--    Compute branch and jump destinations
--    Evaluate data for execution units, branch conditions and jump register
--
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library Work;
use Work.RiscPackage.all;

entity IDecode is
	port (Clk   : in std_logic;
				Reset   : in std_logic;				
				Rdy_n	:	in	std_logic;
				
				WriteRegEn  : in std_logic;
				WriteData 	: in TypeWord;
				WriteAddr 	: in TypeRegister;
				In_IP       : in TypeWord;
				In_Instr    : in TypeWord;
				 
				BP_Mem_iData: in  TypeWord;     -- Bypass from memstage
				BP_Mem_iRDest:  in  TypeRegister; -- Bypass from memstage
				BP_Mem_iRegWrite: in std_logic; -- Bypass from memstage
				BP_EX_iData:  in  TypeWord;       -- Bypass from execution
				BP_EX_iRDest: in  TypeRegister; -- Bypass from execution
				BP_EX_iRegWrite: in std_logic;  -- Bypass from execution
				 
				In_Ctrl_ID  : in  TypeIDCtrl;
				In_Ctrl_Ex  : in  TypeExCtrl;
				In_Ctrl_Mem:  in  TypeMemCtrl;
				In_Ctrl_WB  : in  TypeWBCtrl;
      		In_Ctrl_Q  : in  TypeQCtrl;
				
				In_MemBusAccess_n	:	in	std_logic;
				 
				ID_Stall  : out std_logic;          
				ID_Req    : out std_logic;
				ID_BAddr  : out TypeWord;
				 
				ID_Ctrl_Ex  : out TypeExCtrl;
				ID_Ctrl_Mem : out TypeMemCtrl;
				ID_Ctrl_WB  : out TypeWBCtrl;
				ID_Ctrl_Q  : out TypeQCtrl;
				ID_A    : out TypeWord;
				ID_B    : out TypeWord;
				ID_IMM  : out TypeWord;           
				ID_Shift: out TypeRegister;
				ID_DestReg  : out TypeRegister;
				ID_IP       : out TypeWord;
				
				ID_qopcode: out unsigned(5 downto 0);
        ID_qparameter1: out unsigned(4 downto 0);
        ID_qaddress1: out unsigned(4 downto 0);
        ID_qaddress2: out unsigned(4 downto 0)
		 );
end;

architecture RTL of IDecode is

	-- Instruction aliases
	alias Op : unsigned(5 downto 0) is In_Instr(31 downto 26);
	alias Rs : TypeRegister is In_Instr(25 downto 21);
	alias Rt : TypeRegister is In_Instr(20 downto 16);
	alias Rd : TypeRegister is In_Instr(15 downto 11);
	alias Shift : TypeRegister is In_Instr(10 downto 6);
	alias Funct : unsigned(5 downto 0) is In_Instr(5 downto 0);

	-- Register file
	signal rf_Regs  : TypeArrayWord(31  downto 0) := (others => (others => '0'));  

	signal rf_RegA :  TypeWord;
	signal rf_RegB :  TypeWord;  
	signal rf_RegC :  TypeWord;  
	signal rf_WE    : std_logic;
		
	-- Signed extended immediate    
	signal immSigned : TypeWord;
	
	-- Destination reg multiplexer
	signal dm_TempReg : TypeRegister; 
	signal dm_DestReg : TypeRegister;
	
	-- Shift multiplexer
	signal sm_Shift : TypeRegister;
	
	-- Branch logic
	signal br_JAddr : TypeWord;
	signal br_BAddr : TypeWord;  
	
	-- Quantum Instruction signals
	signal qopcode: unsigned(5 downto 0);
  signal qparameter1: unsigned(4 downto 0);
  signal qaddress1: unsigned(4 downto 0);
  signal qaddress2: unsigned(4 downto 0); 	

	-- Hazard detection signals
	signal hd_Nop : std_logic;
	signal hd_Stall : std_logic;
	
	-- Bypass signals	
	signal bp_ID_Ctrl_Mem: TypeMemCtrl;
	signal bp_ID_Rt : TypeRegister;
	
		-- Forwarding unit  
	signal bp_Rs_A: std_logic;
	signal bp_Rt_A: std_logic;
  signal bp_Rd_A: std_logic;  
	signal bp_Rs_B: std_logic;
	signal bp_Rt_B: std_logic;  
	signal bp_Rd_B: std_logic;
	signal bp_Rs_C: std_logic;
	signal bp_Rt_C: std_logic;  
	signal bp_Rd_C: std_logic; 		
	
	signal bp_Rs_A_val: TypeWord;
	signal bp_Rt_A_val: TypeWord;
	signal bp_Rd_A_val: TypeWord;
	
	signal bp_Rs_B_val: TypeWord;
	signal bp_Rt_B_val: TypeWord;
	signal bp_Rd_B_val: TypeWord;
	
	signal bp_Rs_C_val: TypeWord;
	signal bp_Rt_C_val: TypeWord;
	signal bp_Rd_C_val: TypeWord;
	
	signal	Stall: std_logic;
	
begin	

-------------------------------------------------------------------------------
-- Register file
-------------------------------------------------------------------------------
	
	-- Write register file -- Write on positive flank    
	rf : process(Clk)
	begin
		if rising_edge(Clk) then                        
			if rf_WE  = '1' then                                 
					rf_Regs(to_integer(WriteAddr)) <= WriteData;  
			end if;
		end if;
	end process;

	rf_WE <= WriteRegEn when WriteAddr /= "00000" else
								'0';  
	
	-- Read register file 
	rf_RegA <= rf_Regs(to_integer(Rs));               
	rf_RegB <= rf_Regs(to_integer(Rt)); 
	rf_RegC <= rf_Regs(to_integer(Rd));
	
-------------------------------------------------------------------------------
-- Sign or zero extend immediate data
--
-- If In_Ctrl_ID.ZeroExtend is asserted then we will zero extend
--
------------------------------------------------------------------------------- 
	immSigned(15 downto 0) <= In_Instr(15 downto 0) ;
	immSigned(31 downto 16) <= (others => (In_Instr(15) and not(In_Ctrl_ID.ZeroExtend))); 

-------------------------------------------------------------------------------
-- Regdest multiplexer 
-------------------------------------------------------------------------------

	dm_TempReg <= Rd when In_Ctrl_Ex.ImmSel = '0' else  -- always asserted when ImmSel is ssserted
								Rt; 
								
	dm_DestReg <= dm_TempReg when In_Ctrl_Ex.JumpLink = '0' else  -- If jal instruction, load destreg with $31
								"11111";                    
								
-------------------------------------------------------------------------------
-- Shift amount multiplexer 
-------------------------------------------------------------------------------

	sm_Shift <= "10000" when In_Ctrl_ID.Lui = '1' else        			-- If lui instruction force ALU to shift left 16bits
							bp_Rs_C_val(4 downto 0) when In_Ctrl_ID.ShiftVar = '1' else  -- If shift variable is used
							Shift;                                        			-- Else shift amount is used
	
-------------------------------------------------------------------------------
-- Branch and Jump logic
-------------------------------------------------------------------------------

	-- Calculate branch target
	br_BAddr <= (immSigned sll 2) + In_IP;
	
	-- Assert Req if bp_Rs_C_val equals bp_Rt_C_val
	ID_Req <=   '1' when bp_Rs_C_val =  bp_Rt_C_val else
							'0';
		
	-- Multiplex jump target
	br_JAddr <= bp_Rs_C_val when In_Ctrl_ID.Jr = '1' else
							In_IP(31 downto 28) & shift_left(In_Instr(27 downto 0), 2);
							

	-- Multiplex Jump and Branch targets
	ID_BAddr <= br_BAddr when In_Ctrl_ID.Branch = '1' else
							br_JAddr;
							
							
-------------------------------------------------------------------------------
-- Quantum instruction operands 
-------------------------------------------------------------------------------

  qopcode <=   Funct when (In_Ctrl_Ex.ImmSel = '0') else 
               Op;
  qparameter1 <=   bp_Rs_C_val(4 downto 0) when (In_Ctrl_Ex.ImmSel = '0') else 
                   Rs;
  qaddress1 <=   bp_Rt_C_val(4 downto 0) when (In_Ctrl_Ex.ImmSel = '0') else 
                 Rt;
  qaddress2 <=   rf_RegC(4 downto 0) when (In_Ctrl_Ex.ImmSel = '0') else 
                 Rd;                                                      
			

-------------------------------------------------------------------------------
-- Forwarding units
-------------------------------------------------------------------------------
	
-------------------------------------------------------------------------------
-- ALU bypass multiplexer Rs_A	From Writeback stage
-------------------------------------------------------------------------------

	bp_Rs_A_val <=  WriteData when bp_Rs_A = '1' else
									rf_RegA;	
	
-------------------------------------------------------------------------------
-- Bypass multiplexer Rs_B	From Memstage
-------------------------------------------------------------------------------

	bp_Rs_B_val <=  BP_Mem_iData when bp_Rs_B = '1' else
									bp_Rs_A_val;
	
-------------------------------------------------------------------------------
-- ALU bypass multiplexer Rs_C	From Execution stage
-------------------------------------------------------------------------------

	bp_Rs_C_val <=  BP_EX_iData when bp_Rs_C = '1' else
									bp_Rs_B_val;							
									
-------------------------------------------------------------------------------
-- ALU bypass multiplexer Rt_A	From Writeback stage
-------------------------------------------------------------------------------

	bp_Rt_A_val <=  WriteData when bp_Rt_A = '1' else
									rf_RegB;								
									
-------------------------------------------------------------------------------
-- Bypass multiplexer Rt_B	From Memstage
-------------------------------------------------------------------------------

	bp_Rt_B_val <=  BP_Mem_iData when bp_Rt_B = '1' else
									bp_Rt_A_val;
	
-------------------------------------------------------------------------------
-- ALU bypass multiplexer Rt_C From Execution stage
-------------------------------------------------------------------------------

	bp_Rt_C_val <=  BP_EX_iData when bp_Rt_C = '1' else
									bp_Rt_B_val;
										
	
-------------------------------------------------------------------------------
-- Forwarding evaluation
-------------------------------------------------------------------------------
			
	-- See if want to bypass Rs from Writeback stage							
	bp_Rs_A <= '1' when (WriteRegEn = '1' and 
											 WriteAddr /= "00000" and 
											 WriteAddr = Rs) else
							'0';	
								
	-- See if want to bypass Rs from MemStage
	bp_Rs_B <=  '1' when (BP_Mem_iRegWrite = '1' and 
												BP_Mem_iRDest /= "00000" and
												BP_Mem_iRDest = Rs)
												--TODO???
												--(BP_EX_iRDest /= In_Rs or BP_EX_MEM(0) = '0') and       -- Prevent dest reg after load instr.
												else                          
							'0';
	
	-- See if want to bypass Rs from Execution stage
	bp_Rs_C <= '1' when (BP_EX_iRegWrite = '1' and 
											 BP_EX_iRDest /= "00000" and 
											 BP_EX_iRDest = Rs) else
							'0';

	-- See if want to bypass Rt from Writeback stage						
	bp_Rt_A <= '1' when (WriteRegEn = '1' and 
											 WriteAddr /= "00000" and 
											 WriteAddr = Rt) else
							'0';							
																
		
	-- See if want to bypass Rt from MemStage							
	bp_Rt_B <=  '1' when (BP_Mem_iRegWrite = '1' and
												BP_Mem_iRDest /= "00000" and
												BP_Mem_iRDest = Rt)
												--TODO???
												--(BP_EX_iRDest /= In_Rs or BP_EX_MEM(0) = '0') and       -- Prevent dest reg after load instr.
												else  
							'0';                
								
	-- See if want to bypass Rt from Execution stage						
	bp_Rt_C <= '1' when (BP_EX_iRegWrite = '1' and 
											 BP_EX_iRDest /= "00000" and 
											 BP_EX_iRDest = Rt) else
							'0';	
	
-------------------------------------------------------------------------------
-- Hazard detection
--
-- Stall the pipeline if use of the same register as the load instruction in
-- the previous operation.
--
-------------------------------------------------------------------------------

	hd_Nop <= '1' when  (bp_ID_Ctrl_Mem.MemRead = '1' and 
											((bp_ID_Rt = Rs) or  bp_ID_Rt = Rt)) else
						'0';
	
	hd_Stall <= hd_Nop or not(In_MemBusAccess_n);
	
	ID_Stall <= hd_Stall;     -- Avoid using inout type...              
	
	Stall <= hd_Stall or (not Rdy_n);

-------------------------------------------------------------------------------
-- Shift pipeline
-------------------------------------------------------------------------------
	
	pipeline : process(Clk,Reset)  
	begin                                        
		if reset = '1' then   
					
			ID_Ctrl_EX <= ('0','0','0',"0000");
			bp_ID_Ctrl_Mem <= ('0','0','1', '0');
			ID_Ctrl_WB <= (others => '0');
			ID_Ctrl_Q <= (others => '0');
			ID_A <= (others => '0');
			ID_B <= (others => '0');
			ID_IMM <= (others => '0');            
			ID_Shift <= (others => '0');
			ID_DestReg <= (others => '0');    
			ID_IP <= (others => '0');   
			bp_ID_Rt <= (others => '0'); 
			ID_qopcode <=  (others => '0'); 
      ID_qparameter1 <=  (others => '0'); 
      ID_qaddress1 <=  (others => '0');  
      ID_qaddress2 <=  (others => '0');  
			
		elsif rising_edge(Clk) then
			if (Stall = '0') then
				ID_Ctrl_EX <= In_Ctrl_Ex;
				bp_ID_Ctrl_Mem <= In_Ctrl_Mem;
				ID_Ctrl_WB <= In_Ctrl_WB;				
				ID_Ctrl_Q <= In_Ctrl_Q;				
			
				ID_A <= bp_Rs_C_val;
				ID_B <= bp_Rt_C_val;
				ID_IMM <= immSigned;              
				ID_Shift <= sm_Shift;
				ID_DestReg <= dm_DestReg;
				ID_IP <= In_IP;
				bp_ID_Rt <= Rt;
				
        ID_qopcode <=  qopcode;
        ID_qparameter1 <=  qparameter1;
        ID_qaddress1 <=  qaddress1; 
        ID_qaddress2 <=  qaddress2;
			end if;
			
			if (hd_Stall = '1')	then
				--If the pipeline is stalled by hazard detection: insert NOP...   
				ID_Ctrl_EX <= ('0','0','0',"0000");
		 		bp_ID_Ctrl_Mem <= ('0','0','1', '0');
				ID_Ctrl_WB <= (others => '0');
			end if;
							
		end if;                                      
	end process;
	
	ID_Ctrl_Mem <= bp_ID_Ctrl_Mem;
	
end architecture RTL;
