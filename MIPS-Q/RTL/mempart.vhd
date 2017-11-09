-------------------------------------------------------------------------------
--
--  MYRISC project in SME052 by
--
--  Anders Wallander
--  Department of Computer Science and Electrical Engineering
--  Luleå University of Technology
--  
--  A VHDL implementation of the MIPS RISC processor described in 
--  Computer Organization and Design by Patterson/Hennessy
--
--
--  These routines are taken from the simulation files to the Wildone
--  FPGA board by Anapolis Micro Systems Inc.
--  Copyright (C) 1996-1998 Annapolis Micro Systems, Inc.
--
-------------------------------------------------------------------------------

------------------------------------------------------------------
--
--  Copyright (C) 1996-1998 Annapolis Micro Systems, Inc. 
--
------------------------------------------------------------------
--
--  Entity        : Memory_Part
--
--                  Static         : Memory storage allocated at
--                                   the beginning of simulation.
--
--  Filename      : mempart.vhd
--
------------------------------------------------------------------

---------------------- Library Declarations ----------------------

library IEEE, std;
use IEEE.std_logic_unsigned.all;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use std.textio.all;

library Work;
use Work.RiscPackage.all;
use Work.MempartPackage.all;

--------------------------------------------------------------------------
--
--  Memory_Part Generics 
--
--    Name            Description
--    ====            =========
--    Load_File       Initialization file (string).
--    Size            Address space size, ie 2**24
--
--  Memory_Part Ports
--
--    Name            Description
--    ====            =========
--    Mem_A           Memory address bus, 24 bits
--    Mem_D           Memory data bus, 32 bits
--    OE_n            Memory read strobe, active low
--    WE_n            Memory write strobe, active low
--    CS_n            Memory chip select, active low
--
--------------------------------------------------------------------------


entity Memory_Part is
	generic
	(
		Load_File  : String  := "program.mem";
		Size       : integer := 2**12
	);
	port
	(
		Mem_A  : in TypeWord;
		Mem_D  : inout TypeWord;
		OE_n   : in std_ulogic;
		WE_n   : in std_ulogic;
		CS_n   : in std_ulogic
	);
end Memory_Part;

--------------------------------------------------------------------------
--
--  Memory_Part Generics 
--
--    Name            Description
--    ====            =========
--    Load_File       Initialization file (string).
--    Size            Address space size, ie 2**24
--
--  Memory_Part Ports
--
--    Name            Description
--    ====            =========
--    Mem_A           Memory address bus, 24 bits
--    Mem_D           Memory data bus, 32 bits
--    OE_n            Memory read strobe, active low
--    WE_n            Memory write strobe, active low
--    CS_n            Memory chip select, active low
--
--------------------------------------------------------------------------


-----------------------------------------------------
--  Architecture "Static" is a memory part that
--  uses statically allocated storage implemented
--  as an array of integers.  The size of the static
--  table is specified by the "Size" generic.
-----------------------------------------------------
architecture Static of Memory_Part is
	
begin  --  Static

	P_Mem : process ( CS_n, OE_n, WE_n, Mem_A )

		variable Initialized : boolean := FALSE;
		variable IntAddr     : integer := 0;
		variable Cleared     : boolean := False;
		variable Cleared_Val: TypeWord;
		variable RAM_Array   : TypeArrayWord ( 0 to Size - 1 );

	begin  --  process P_Mem

		--
		--  If the user provided a file name,
		--  initialize the memory from it
		--
		if Initialized = FALSE then

			Initialized := TRUE;

			if ( Load_File /= "" ) then
				Load_Mem ( File_Name => Load_File, Head => RAM_Array, 
					Cleared_Flag => Cleared, Cleared_Val => Cleared_Val );
			end if;

		end if;

		--
		--  Convert the address to an integer
		--
		-- TODO Fix this!
		if ( Is_X ( Mem_A ) ) then
			IntAddr := 0;
		else
			IntAddr := to_integer( Mem_A(31 downto 2) );
		end if;

		--
		--  If the chip is not selected, tri-state
		--  the data bus
		--
		if ( CS_n = '1' ) then

			Mem_D <= (others => 'Z');

		--
		--  If the chip is selected for reading,
		--  find the data in the static array.
		--
		elsif ( OE_n = '0' ) then 

			Mem_D <= RAM_Array (IntAddr)  after RAM_Access_Time;


		--
		--  If the chip is selected for writing,
		--  store the data in the memory array.
		--
		elsif ( WE_n = '0' ) then

			Mem_D <= (others => 'Z');

			-- TODO!
			if ( Is_X ( Mem_D ) ) then
			--	RAM_Array ( IntAddr ) := (others => '0');
			else
				RAM_Array ( IntAddr ) := Mem_D;
			end if;

		--
		--  If the chip is selected neither for,
		--  reading nor writing, tri-state the
		--  output data.
		--
		else

			Mem_D <= (others => 'Z');

		end if;

	end process P_Mem;

end Static;


