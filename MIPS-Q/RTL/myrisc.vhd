-------------------------------------------------------------------------------
--
--	MYRISC project in	SME052 by
--
--	Anders Wallander
--	Department of	Computer Science and Electrical	Engineering
--	Luleå	University of	Technology
--	
--	A	VHDL implementation	of a MIPS, based on	the	MIPS R2000 and the
--	processor	described	in Computer	Organization and Design	by 
--	Patterson/Hennessy
--
--
--	MYRISC toplevel
--
-------------------------------------------------------------------------------
library	IEEE;
use	IEEE.std_logic_1164.all;
use	IEEE.numeric_std.all;

library	work;
use	work.RiscPackage.all;

library quantum;
use quantum.all;

entity myrisc	is
	port (Clk					:	in std_logic;
				Reset				:	in std_logic;	
				Bus_Data		:	inout	TypeWord;		
				Bus_Addr		:	out	TypeWord;
				Bus_Rd_n		:	out	std_logic;
				Bus_Wr_n		:	out	std_logic;
				Init_n			:	in std_logic;
				Rdy_n				:	in	std_logic);
end	myrisc;

architecture behavior	of myrisc	is	

	component	Controller is
	port (Instr			:	in TypeWord;		 
				Ctrl_IF		:	out	TypeIFCtrl;
				Ctrl_ID		:	out	TypeIDCtrl;
				Ctrl_Ex		:	out	TypeExCtrl;
				Ctrl_Mem	:	out	TypeMemCtrl;
				Ctrl_WB		:	out	TypeWBCtrl;
				Ctrl_Q   : out TypeQCtrl
		 );
	end	component;
	
  component	IntBusSM is
	 port	(
			Clk						:	in	std_logic;
			Reset					:	in	std_logic;						
			Rdy_n					:	in std_logic;
			IntBusReq_n		:	in std_logic;		-- Memory	request	signal
			IntBusGrant_n	:	out	 std_logic	-- Memory	grant	signal							
			);
	end	component	IntBusSM;
	
	component	ifetch is	 
		port (
			Clk						:	in	std_logic;
			Reset					:	in	std_logic;			
			In_Stall_IF		:	in	std_logic;		-- Asserted	if pipe	line is	stalled	or memstage	memaccess
			In_ID_Req			:	in	std_logic;		-- Asserted	if RegA	equals RegB	from the registerfile	(Including bypass...)	
			In_ID_BAddr		:	in	TypeWord;			-- Jump/Branch target	address
			In_Ctrl_IF		:	in	TypeIFCtrl;	
			Init_n				:	in std_logic;
			Rdy_n					:	in std_logic;
			Bus_Data			:	inout	TypeWord;		
			Bus_Addr			:	out	TypeWord;
			Bus_Rd_n			:	out	std_logic;					 
			Bus_Wr_n			:	out	std_logic;			
			IF_IP					:	out	TypeWord;
			IF_Instr			:	out	TypeWord);	
	end	component	ifetch;
	
	component	IDecode	is
		port (Clk					:	in std_logic;
					Reset				:	in std_logic;
					Rdy_n				:	in	std_logic;
					WriteRegEn	:	in std_logic;
					WriteData		:	in TypeWord;
					WriteAddr		:	in TypeRegister;
					In_IP				:	in TypeWord;
					In_Instr		:	in TypeWord;					
					 
					BP_Mem_iData		:	in	TypeWord;			-- Bypass	from memstage
					BP_Mem_iRDest		:	in	TypeRegister;	-- Bypass	from memstage
					BP_Mem_iRegWrite:	in std_logic;			-- Bypass	from memstage
					BP_EX_iData			:	in	TypeWord;			-- Bypass	from execution
					BP_EX_iRDest		:	in	TypeRegister;	-- Bypass	from execution
					BP_EX_iRegWrite	:	in std_logic;			-- Bypass from	execution
					 
					In_Ctrl_ID	:	in	TypeIDCtrl;
					In_Ctrl_Ex	:	in	TypeExCtrl;
					In_Ctrl_Mem	:	in	TypeMemCtrl;
					In_Ctrl_WB	:	in	TypeWBCtrl;			
					In_Ctrl_Q  : in  TypeQCtrl;
							
					In_MemBusAccess_n:	in	std_logic;
					 
					ID_Stall	:	out	std_logic;					
					ID_Req		:	out	std_logic;
					ID_BAddr	:	out	TypeWord;
					 
					ID_Ctrl_Ex	:	out	TypeExCtrl;
					ID_Ctrl_Mem	:	out	TypeMemCtrl;
					ID_Ctrl_WB	:	out	TypeWBCtrl;
					ID_Ctrl_Q	:	out	TypeQCtrl;
					ID_A				:	out	TypeWord;
					ID_B				:	out	TypeWord;
					ID_IMM			:	out	TypeWord;						
					ID_Shift		:	out	TypeRegister;
					ID_DestReg	:	out	TypeRegister;
					ID_IP				:	out	TypeWord;			
					ID_qopcode: out unsigned(5 downto 0);
          ID_qparameter1: out unsigned(4 downto 0);
          ID_qaddress1: out unsigned(4 downto 0);
          ID_qaddress2: out unsigned(4 downto 0)
			 );
	end	component;
	
	component	Execute	is
		port (Clk					:	in std_logic;
					Reset				:	in std_logic;				
					Rdy_n				:	in	std_logic;
					In_Ctrl_Ex	:	in TypeExCtrl;
					In_Ctrl_Mem	:	in TypeMEMCtrl;
					In_Ctrl_WB	:	in TypeWBCtrl;
					In_Ctrl_Q	:	in TypeQCtrl;
					In_A				:	in TypeWord;
					In_B				:	in TypeWord;
					In_IMM			:	in TypeWord;	
					In_Shift		:	in TypeRegister;		
					In_DestReg	:	in TypeRegister; 
					In_IP				:	in TypeWord;	 
					In_qopcode: in unsigned(5 downto 0);
          In_qparameter1: in unsigned(4 downto 0);
          In_qaddress1: in unsigned(4 downto 0);
          In_qaddress2: in unsigned(4 downto 0);
									
					BP_EX_iData			:	out	TypeWord;			-- Bypass to	idecode
					BP_EX_iRDest		:	out	TypeRegister;	-- Bypass	to idecode
					BP_EX_iRegWrite	:	out	std_logic;		-- Bypass	to idecode				 
					
					EX_Ctrl_WB	:	out	TypeWBCtrl;
					EX_Ctrl_Mem	:	out	TypeMemCtrl;						
					EX_Ctrl_Q	:	out	TypeQCtrl;						
					EX_ALU			:	out	TypeWord;
					EX_DATA			:	out	TypeWord;
					EX_DestReg	:	out	TypeRegister;
					EX_qopcode: out unsigned(5 downto 0);
          EX_qparameter1: out unsigned(4 downto 0);
          EX_qaddress1: out unsigned(4 downto 0);
          EX_qaddress2: out unsigned(4 downto 0)	
					);
	end	component;
	
	component qprocessor is
    port(
      qopcode: unsigned(5 downto 0);
      parameter1: signed(4 downto 0);
      address1: unsigned(4 downto 0);
      address2: unsigned(4 downto 0); 
      clock, reset, exec: in std_logic;
      measurement_reg: out unsigned(3 downto 0)
    );  
  end component;	
	
	component	MemStage is
		port (Clk							:	in std_logic;
					Reset						:	in std_logic;
					Rdy_n						:	in	std_logic;
					In_Ctrl_WB			:	in TypeWBCtrl;
					In_Ctrl_Mem			:	in TypeMEMCtrl;
					In_ALU					:	in TypeWord;
					In_Data					:	in TypeWord;
					In_DestReg			:	in TypeRegister;
					In_IntBusGrant_n:	in	std_logic;		
					
					Bus_Data		:	inout	TypeWord;		
					Bus_Addr		:	out	TypeWord;
					Bus_Rd_n		:	out	std_logic;
					Bus_Wr_n		:	out	std_logic;				
	
					BP_Mem_iData	:	out	TypeWord;			-- Bypass	to idecode
					BP_Mem_iRDest	:	out	TypeRegister;	-- Bypass	to idecode
					BP_Mem_iRegWrite:	out	std_logic;	-- Bypass	to idecode
					
					Mem_Ctrl_WB	:	out	TypeWBCtrl;
					Mem_Data		:	out	TypeWord;
					Mem_DestReg	:	out	TypeRegister;
					
					Quantum_Measurement_Reg  : in unsigned(	3 downto	0	)
					);
	end	component;
	
	-- Controller
	signal	ctrl_IF	:	TypeIFCtrl;
	signal	ctrl_ID	:	TypeIDCtrl;
	signal	ctrl_Ex	:	TypeExCtrl;
	signal	ctrl_Mem:	TypeMemCtrl;	
	signal	ctrl_WB	:	TypeWBCtrl;
	signal	ctrl_Q	:	TypeQCtrl;
	
	-- IntBusSM
	signal	ib_IntBusGrant_n	:	 std_logic;	 --	Bus	grant	signal							

	-- ifetch
	signal IF_IP		:	TypeWord;
	signal IF_Instr	:	TypeWord :=	(others	=> '0');			-- Avoid metastability during	simulation
	
	-- iDecode
	signal ID_Stall		:	std_logic;
	signal ID_Req			:	std_logic;
	signal ID_BAddr		:	TypeWord;	
	signal ID_Ctrl_Ex	:	TypeExCtrl;
	signal ID_Ctrl_Mem:	TypeMemCtrl;
	signal ID_Ctrl_WB	:	TypeWBCtrl;
	signal ID_Ctrl_Q	:	TypeQCtrl;	
	signal ID_A				:	TypeWord;
	signal ID_B				:	TypeWord;
	signal ID_IMM			:	TypeWord;
	signal ID_Shift		:	TypeRegister;	
	signal ID_DestReg	:	TypeRegister;
	signal ID_IP			:	TypeWord;
	signal ID_qopcode: unsigned(5 downto 0);
  signal ID_qparameter1: unsigned(4 downto 0);
  signal ID_qaddress1: unsigned(4 downto 0);
  signal ID_qaddress2: unsigned(4 downto 0); 
	
	-- Execute
	signal BP_EX_iData:	TypeWord;				-- Bypass	to idecode
	signal BP_EX_iRDest:TypeRegister;		-- Bypass	to idecode
	signal BP_EX_iRegWrite:	std_logic;	-- Bypass	to idecode
	signal BP_Mem_iData:	TypeWord;			-- Bypass	to idecode
	signal BP_Mem_iRDest:TypeRegister;	-- Bypass	to idecode
	signal BP_Mem_iRegWrite:	std_logic;-- Bypass	to idecode	
	
	signal EX_Ctrl_Mem:	TypeMemCtrl;		 
	signal EX_Ctrl_WB	:	TypeWBCtrl;
	signal EX_Ctrl_Q	:	TypeQCtrl;	
	signal EX_ALU			:	TypeWord;
	signal EX_DATA		:	TypeWord;
	signal EX_DestReg	:	TypeRegister :=	(others	=> '0');
	signal EX_qopcode: unsigned(5 downto 0);
  signal EX_qparameter1: unsigned(4 downto 0);
  signal EX_qaddress1: unsigned(4 downto 0);
  signal EX_qaddress2: unsigned(4 downto 0); 
	
	-- Memstage
	signal Mem_Ctrl_WB:		TypeWBCtrl;	
	signal Mem_Data		:		TypeWord :=	(others	=> '0');
	signal Mem_DestReg:		TypeRegister :=	(others	=> '0'); --	Avoid	metastability	during simulation
	
	-- Quantum
	signal Quantum_Measurement_Reg: unsigned(3 downto 0);

	
	
begin

	controller1: controller
		port map (Instr	=>	IF_Instr,
							Ctrl_IF	=>	ctrl_IF,
							Ctrl_ID	=>	ctrl_ID,
							Ctrl_Ex	=>	ctrl_Ex,
							Ctrl_Mem =>	ctrl_Mem,							
							Ctrl_WB	=>	ctrl_WB,
							Ctrl_Q => ctrl_Q);		
							
	intBusSM1: IntBusSM
		port map (
			Clk	=> Clk,
			Reset	=> Reset,			
			Rdy_n	=>	Rdy_n,
			IntBusReq_n	=> ID_Ctrl_Mem.MemBusAccess_n,		-- Internal	bus	request	signal
			IntBusGrant_n	=> ib_IntBusGrant_n);	
													
	ifetch1: ifetch	
		port map (Clk	=> Clk,
							Reset	=> reset,
							In_Stall_IF	=>	ID_Stall,
							In_ID_Req		=>	ID_Req,
							In_ID_BAddr	=>	ID_Baddr,
							In_Ctrl_IF	=>	ctrl_IF,		 
							Init_n			=>	Init_n,
							Rdy_n			=>	Rdy_n,				 
							Bus_Data	=>	Bus_Data,
							Bus_Addr	=>	Bus_Addr,
							Bus_Rd_n	=>	Bus_Rd_n,
							Bus_Wr_n	=>	Bus_Wr_n,
							IF_IP	=> if_ip,
							IF_Instr =>	if_instr);
											
	IDecode1:	IDecode
		port map (Clk	=> Clk,
							Reset	=> reset,
							Rdy_n	=>	Rdy_n,
							WriteRegEn =>	Mem_Ctrl_WB.RegWrite,
							WriteData	=> Mem_Data,
							WriteAddr	=> Mem_DestReg,
							In_IP			=> IF_IP,
							In_Instr	=> IF_Instr,
							 
							BP_Mem_iData =>	BP_Mem_iData,					-- Bypass	from memstage
							BP_Mem_iRDest	=> BP_Mem_iRDest,				-- Bypass	from memstage
							BP_Mem_iRegWrite =>	BP_Mem_iRegWrite,	-- Bypass	from memstage
							BP_EX_iData	=> BP_EX_iData,						-- Bypass	from execution
							BP_EX_iRDest =>	BP_EX_iRDest,					-- Bypass	from execution
							BP_EX_iRegWrite	=> BP_EX_iRegWrite,		-- Bypass	from execution			
							 
							In_Ctrl_ID	=> ctrl_ID,
							In_Ctrl_Ex	=> ctrl_Ex,
							In_Ctrl_Mem	=> ctrl_Mem,							
							In_Ctrl_WB	=> ctrl_WB,
							In_Ctrl_Q => ctrl_Q,
							
							In_MemBusAccess_n	=> Ex_Ctrl_mem.MemBusAccess_n,
							
							ID_Stall	=>	ID_Stall,
							ID_Req		=>	ID_Req,
							ID_BAddr	=>	ID_BAddr,
							
							ID_Ctrl_Ex	=>	ID_Ctrl_Ex,
							ID_Ctrl_Mem	=>	ID_Ctrl_Mem,							
							ID_Ctrl_WB	=>	ID_Ctrl_WB,
							ID_Ctrl_Q => ID_Ctrl_Q,
							ID_A				=>	ID_A,
							ID_B				=>	ID_B,
							ID_IMM			=>	ID_IMM,																																	
							ID_Shift		=>	ID_Shift,
							ID_DestReg	=>	ID_DestReg,
							ID_IP				=>	ID_IP,
							ID_qopcode => ID_qopcode,
							ID_qparameter1 => ID_qparameter1,
							ID_qaddress1 => ID_qaddress1,
							ID_qaddress2 => ID_qaddress2							
							);			
											
	execute1:	execute
	 port	map	(	Clk	=> Clk,
							Reset	=> reset,	 
							Rdy_n	=>	Rdy_n,										
							In_Ctrl_WB	=> ID_Ctrl_WB,
							In_Ctrl_Mem	=> ID_Ctrl_Mem,
							In_Ctrl_Ex =>	ID_Ctrl_Ex,
							In_Ctrl_Q =>	ID_Ctrl_Q,
							In_A =>	ID_A,
							In_B =>	ID_B,
							In_IMM =>	ID_IMM,
							In_Shift =>	ID_Shift,											
							In_DestReg =>	ID_DestReg,
							In_IP	=>	ID_IP,
							In_qopcode => ID_qopcode,
							In_qparameter1 => ID_qparameter1,
							In_qaddress1 => ID_qaddress1,
							In_qaddress2 => ID_qaddress2,	
							BP_EX_iData	=> BP_EX_iData,
							BP_EX_iRDest =>	BP_EX_iRDest,
							BP_EX_iRegWrite	=> BP_EX_iRegWrite,											
							EX_Ctrl_Mem	=> EX_Ctrl_Mem,
							EX_Ctrl_WB =>	EX_Ctrl_WB,
							EX_Ctrl_Q =>	EX_Ctrl_Q,
							EX_ALU =>	EX_ALU,
							EX_DATA	=> EX_DATA,
							EX_DestReg =>	EX_DestReg,
							EX_qopcode => EX_qopcode,
							EX_qparameter1 => EX_qparameter1,
							EX_qaddress1 => EX_qaddress1,
							EX_qaddress2 => EX_qaddress2							
					);	
					
	qprocessor1: qprocessor
		port map (qopcode	=>	EX_qopcode,
							parameter1	=>	signed(EX_qparameter1),
							address1	=>	EX_qaddress1,
							address2	=> EX_qaddress2,
							clock =>	Clk,							
							reset	=>	Reset,
							exec => EX_ctrl_Q.QuantumEnable,
							measurement_reg => Quantum_Measurement_Reg);
								
	memstage1:	memstage
		port map (Clk	=> Clk,
							Reset	=> reset,
							Rdy_n	=>	Rdy_n,
							In_Ctrl_WB =>	EX_Ctrl_WB,
							In_Ctrl_Mem	=> EX_Ctrl_Mem,
							In_ALU =>	EX_ALU,
							In_Data	=> EX_Data,
							In_DestReg =>	EX_DestReg,
							
							In_IntBusGrant_n =>	ib_IntBusGrant_n,
							
							Bus_Data	=>	Bus_Data,
							Bus_Addr	=>	Bus_Addr,
							Bus_Rd_n	=>	Bus_Rd_n,
							Bus_Wr_n =>	Bus_Wr_n,
							BP_Mem_iData =>	BP_Mem_iData,
							BP_Mem_iRDest	=> BP_Mem_iRDest,
							BP_Mem_iRegWrite =>	BP_Mem_iRegWrite,
							Mem_Ctrl_WB	=> Mem_Ctrl_WB,
							Mem_Data =>	Mem_Data,											
							Mem_DestReg	=> Mem_DestReg,
							
							Quantum_Measurement_Reg => unsigned(Quantum_Measurement_Reg)
						);				
																	
	
end	behavior;	