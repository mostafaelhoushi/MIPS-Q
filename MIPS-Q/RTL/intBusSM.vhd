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
--  Internal Bus State Machine
--
-------------------------------------------------------------------------------
library	ieee;
use	ieee.std_logic_1164.all;


entity IntBusSM	is
	 port	(
			Clk							 : in	 std_logic;
			Reset						 : in	 std_logic;						
			Rdy_n					 : in	std_logic;
			IntBusReq_n			 : in	std_logic;		-- Memory	request	signal
			IntBusGrant_n		 : out	std_logic	 --	Memory grant signal							
			);
end	IntBusSM;

architecture RTL of	IntBusSM is

type state_type	is (ProgramMemAccess,	DataMemAccess);

signal PresentState, NextState : state_type;

begin	
	
	process( Clk,	Reset)
	begin				
		if Reset = '1' then	
			PresentState <=	ProgramMemAccess;
		elsif	rising_edge(Clk) then
			PresentState <=	NextState;
		end	if;
	end	process;
		
	process(PresentState,	Rdy_n,	IntBusReq_n) 
	
	begin
		case PresentState	is
			when ProgramMemAccess	=>							
						
						IntBusGrant_n	<=	'1';
							
						if (IntBusReq_n	=	'0'	and	Rdy_n = '1')	then						
							NextState	<= DataMemAccess;
						else
							NextState	<= ProgramMemAccess;
						end	if;							
	
			when DataMemAccess =>
			
						IntBusGrant_n <= '0';														
							
						if (IntBusReq_n	=	'1'	and	Rdy_n = '1')	then						
							NextState	<= ProgramMemAccess;
						else
							NextState	<= DataMemAccess;
						end	if;									
			
			when others	=>	NextState	<= ProgramMemAccess;	
		end	case;	
	end	process;
end;
