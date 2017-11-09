#!/usr/local/bin/perl
use strict;
use warnings;
use feature "switch";
###############################################################################
#
#	QASM project by
#
#	Mostafa Elhoushi
#	Department of Computer & Systems Engineering
#	Ain Shams University
#	
#	A QASM assembler for a quantum processing module
#
# Created: 2011-4-16
#
###############################################################################

#Globals...
my $inputFile =  $ARGV[0];
my $outputFile = $ARGV[1];

#Constants
my %opcode_map = (
	q => 0b110000,
	I => 0b110001,
	X => 0b110010,
	Z => 0b110011,
	Y => 0b110100,
	H => 0b110101,
	Rk => 0b110110,
	CNOT => 0b110111,
	CRk => 0b111000,
	SWAP => 0b111001,
	MEASURE => 0b111010
);

#
# Main...
#

printf "- QASM Assembler - Mostafa Elhoushi (2011-04-16)\n\n";

open(my $in,  "<",  $inputFile)  or die "Can't open $inputFile: $!";
open(my $out, ">",  $outputFile ) or die "Can't open $outputFile: $!";

my $pow26 = 67108864;
my $pow21 = 2097152;
my $pow16 = 65536;
my $pow11 = 2048;
my $pow6 = 64;

my $opcode;
my $parameter;
my $number1;
my $number2;

while (<$in>) # assigns each line in turn to $_
{ 
	print "Interpreting line: $_";
	given ($_)
	{
		when(/\s*(I|X|Z|Y|H|MEASURE)\s*(\d+)/) 
		{
			$opcode = $opcode_map{$1};
			$parameter = 0;
			$number1 = $2;
			$number2 = 0;	
		}
		when(/\s*(CRk)\s*(\d+)\s*,\s*(\d+),\s*(\d+)/) 
		{
			$opcode = $opcode_map{$1};
			if($2 >= 0)
			{
				$parameter = $2;
			}
			else
			{
				$parameter = 0x1F + $2 + 1;
			}
			$number1 = $3;
			$number2 = $4;
		}
		when(/\s*(q)\s*(\d+)\s*,\s*(\d+)/) 
		{
			$opcode = $opcode_map{$1};
			$parameter = $2;
			$number1 = $3;
			$number2 = 0;
		}
		when(/\s*(Rk)\s*(-?\d+)\s*,\s*(\d+)/) 
		{
			$opcode = $opcode_map{$1};
			if($2 >= 0)
			{
				$parameter = $2;
			}
			else
			{
				$parameter = 0x1F + $2 + 1;
			}
			$number1 = $3;
			$number2 = 0;
		}
		when(/\s*(CNOT|SWAP)\s*(\d+)\s*,\s*(\d+)/) 
		{
			$opcode = $opcode_map{$1};
			$parameter = 0;
			$number1 = $2;
			$number2 = $3;
		}
		default
		{
			die "Cannot interpret command: $_";
		}
	}

	print $out sprintf("%08X", $opcode*$pow26 + $parameter*$pow21 + $number1*$pow16 + $number2*$pow11 );
	print $out " --$_";
}

close $in or die "$in: $!";
close $out or die "$in: $!";

exit 0;

