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
--  Testbench
--
-------------------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

library work;
use work.RiscPackage.all;

entity test is
end test;

architecture behavior of test is  
	
	component myrisc is
		port (Clk : in std_logic;
					Reset : in std_logic; 
					Bus_Data  : inout TypeWord;   
					Bus_Addr  : out TypeWord;
					Bus_Rd_n    : out std_logic;
					Bus_Wr_n    : out std_logic;
					Init_n			:	in std_logic;
					Rdy_n				:	in	std_logic);
	end component myrisc;	
		
	component Memory_Part is
		port
		(
			Mem_A  : in TypeWord;
			Mem_D  : inout TypeWord;
			OE_n   : in std_ulogic;
			WE_n   : in std_ulogic;
			CS_n   : in std_ulogic
		);
	end component Memory_Part;
	
	signal	Clk	:	std_logic;
	signal	Reset	:	std_logic;
	signal  Bus_Data  : TypeWord;
	signal  Bus_Addr  : TypeWord; 
	signal  Bus_Rd_n  : std_logic;
	signal  Bus_Wr_n  : std_logic;
	signal	Init_n		:	std_logic;
	signal	Rdy_n			:	std_logic;
	
	signal  Mem_Cs_n : std_logic;	
	
begin

	mem1:	Memory_Part 
	port map 
		(
			Mem_A  => Bus_Addr,
			Mem_D  => Bus_Data,
			OE_n   => Bus_Rd_n,
			WE_n   => Bus_Wr_n,
			CS_n   => Mem_CS_n
		);	

	dut : myrisc
	port map (  Clk => Clk,
							Reset => reset,
							Bus_Data  =>  Bus_Data,
							Bus_Addr  =>  Bus_Addr,
							Bus_Rd_n  =>  Bus_Rd_n,
							Bus_Wr_n  =>  Bus_Wr_n,
							Init_n		=>	Init_n,
							Rdy_n			=>	Rdy_n);  

	
	-- Address decoding... If bit 20 is set; memory is activated             
	Mem_Cs_n <= Bus_Addr(20);																												
	
														
	stimulus: process
	begin
		-- Reset processor		
		reset <= '1'; 
		init_n <= '0';
		rdy_n <= '1';		
		  
		wait for 150 ns;
		-- Unleach it!
		-- GO!        
		reset <= '0'; 
		init_n <= '1';				
		
		
		wait;
	end process;

	clk2: process
	variable clktmp : std_logic := '0';
	begin
			clktmp := not clktmp;
			Clk <= clktmp;
			wait for 50 ns;
	end process;
end behavior; 




