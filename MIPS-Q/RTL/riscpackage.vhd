-------------------------------------------------------------------------------
--
--	MYRISC project in	SME052 by
--
--	Anders Wallander
--	Department of	Computer Science and Electrical	Engineering
--	Luleå	University of	Technology
--	
--	A	VHDL implementation	of the MIPS	RISC processor described in	
--	Computer Organization	and	Design by	Patterson/Hennessy
--
--
--	Package	for	MYRISC
--
-------------------------------------------------------------------------------
library	IEEE,	STD;
use	IEEE.std_logic_1164.all;
use	IEEE.numeric_std.all;


package	RiscPackage	is

	subtype	TypeWord is	unsigned(	31 downto	0	);
	type		TypeArrayWord	is array (natural	range	<>)	of unsigned( 31	downto 0 );

	subtype	TypeRegister is	unsigned(4 downto	0);
	
	subtype	TypeALUOpcode	is unsigned(3	downto 0);	
				 
	type TypeIFCtrl	is record
		Branch		:	std_logic;		-- If	asserted,	branch to	new	address	if (registers	are	equal) xor (bne).
		Jump			:	std_logic;		-- If	asserted,	branch to	new	address.
		bne			:	std_logic;			-- If	assered, branch	only on	non	equal	registers.
	end	record;
	
	type TypeIDCtrl	is record
		Branch		:	std_logic;		-- If	asserted branch	target = branch	address, else	jump address.		
		Jr				:	std_logic;		-- If	asserted jumpaddress = Rs.
		Lui				:	std_logic;		-- If	asserted Shiftvalue	=	16.
		ShiftVar	:	std_logic;		-- If	asserted Shiftvalue	=	Rs(4 downto	0).
		ZeroExtend:	std_logic;		-- If	asserted,	zero extend	imm	value, else	sign extend	imm	value.
	end	record;	
	
	type TypeExCtrl	is record		
		ImmSel		:	std_logic;		-- If	asserted,	ALU_B	=	imm	value, else	ALU_B	=	Rt.
		JumpLink	:	std_logic;		-- If	asserted DestReg = 31, WriteData = IP	+	1		
		ShiftSel	:	std_logic;		-- If	asserted,	ALU_A	=	zero extended	shiftvalue,	else ALU_A=Rs.		
		OP:	TypeALUOpcode;				-- ALU opcode.
	end	record;
	
	type TypeMemCtrl is	record
		MemRead		:	std_logic;		-- Read	from datamemory	if asserted.
		MemWrite	:	std_logic;		-- Write to	datamemory if	asserted.		
		MemBusAccess_n : std_logic;	-- Asserted	when memory	stage	is active	(will	stall	instruction	fetch)
		QuantumMeasRead : std_logic; -- Read from Quantum Measurement register
	end	record;	
	
	type TypeWBCtrl	is record		
		RegWrite	:	std_logic;		-- Write to	registerfile if	asserted.
	end	record;
	
	type TypeQCtrl is record
    QuantumEnable	:	std_logic;		-- Enable quantum processing module to execute the instruction
  end record;
		

	-- Try to	match	up against MIPS	op-codes
	constant ALU_ADD		:	TypeALUOpcode	:= "0000";
	constant ALU_ADDU		:	TypeALUOpcode	:= "0001";
	constant ALU_SUB		:	TypeALUOpcode	:= "0010";
	constant ALU_SUBU		:	TypeALUOpcode	:= "0011";
	constant ALU_AND		:	TypeALUOpcode	:= "0100";
	constant ALU_OR			:	TypeALUOpcode	:= "0101";	
	constant ALU_XOR		:	TypeALUOpcode	:= "0110";
	constant ALU_NOR		:	TypeALUOpcode	:= "0111";	
	constant ALU_SLT		:	TypeALUOpcode	:= "1010";
	constant ALU_SLTU		:	TypeALUOpcode	:= "1011";
	constant ALU_SLL		:	TypeALUOpcode	:= "1100";	-- This	one	failed...	;-(	
	constant ALU_SRL		:	TypeALUOpcode	:= "1110";
	constant ALU_SRA		:	TypeALUOpcode	:= "1111";
	
end	package	RiscPackage;

