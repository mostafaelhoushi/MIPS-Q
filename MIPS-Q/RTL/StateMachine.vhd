library ieee;
use ieee.std_logic_1164.all;


entity StateMachine is
	 port (
			Clk                 : in  std_logic;
			Reset               : in  std_logic;      
			Mem_CS_n						:	in	std_logic;
			MemBusReq_n         : out std_logic;  -- Memory request signal
			MemBusGrant_n       : in  std_logic;  -- Memory grant signal      
			Init_n              : out std_logic;
			Rdy_n              	: out std_logic
			);
end StateMachine;

architecture RTL of StateMachine is

type state_type is (Start, WaitMemGrant, WaitState1, WaitState2, Go);

signal PresentState, NextState : state_type;

begin 
	
	process( Clk, Reset)
	begin				
		if Reset = '1' then	
			PresentState <= Start;
		elsif rising_edge(Clk) then
			PresentState <= NextState;
		end if;
	end process;
		
	process(PresentState, MemBusGrant_n, Mem_Cs_n) 
	
	begin
		case PresentState is
			when Start   =>  
						Init_n <= '0';
						Rdy_n <= '0';					
						MemBusReq_n <= '1';
								
						NextState <= WaitMemGrant;						
	
			when WaitMemGrant =>						
						
						Init_n <= '0';
						Rdy_n <= '0';
						MemBusReq_n <= '0';
						
						if MemBusGrant_n = '0' then
							NextState <= Go;
						else 
							NextState <= WaitMemGrant;
						end if;								
						
			when WaitState1 =>						
						
						Init_n <= '1';
						Rdy_n <= '0';
						MemBusReq_n <= '0';						
						
						NextState <= WaitState2;									
						
			when WaitState2 =>						
						
						Init_n <= '1';
						Rdy_n <= '1';
						MemBusReq_n <= '0';						
						
						NextState <= Go;
						
			when Go  =>						
			
						Init_n <= '1';
						Rdy_n <= Mem_Cs_n;
						MemBusReq_n <= '0';						
			
						if Mem_Cs_n = '0' then			-- Insert two wait states if Memory is selected
							NextState <= WaitState1;
						else 
							NextState <= Go;							
						end if;	
						
			when others =>  NextState <= Start;	
		end case;	
	end process;
end;
