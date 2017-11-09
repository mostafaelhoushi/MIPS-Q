#!/usr/local/bin/perl
###############################################################################
#
#	MYRISC project in SME052 by
#
#	Anders Wallander
#	Department of Computer Science and Electrical Engineering
#	Luleå University of Technology
#	
#	A MIPS assembler for MYRISC
#
# Created: 1999-10-24
#
###############################################################################


#Globals...
my %labels;
my %constData;

#Constants
$PROGRAM_AREA = 0x100;
$DATA_AREA = 0x2000;
$CONST_AREA = 0x4000;		


#
# Main...
#

$inputFile =  $ARGV[0];
$outputFile = $ARGV[1];

printf "- MYRISC - MIPS Assembler - Anders Wallander (1999-10-28)\n\n";

&init();
&assemble($inputFile, $outputFile);

exit 0;


#
# Subroutines...
#

sub init {
###############################################################################
#
# Define MYRISC MIPS instructions
#
###############################################################################

	%commands = (
		"add" 	=>	[("r",0,32)],
		"addi"	=>	[("i",8,0)],		
		"addu"	=>	[("r",0,33)],
		"addiu"	=>	[("i",9,0)],
		"and"		=>	[("r",0,36)],		
		"andi"	=>	[("i",12,0)],
		"beq"		=>	[("b",4,0)],
		"bne"		=>	[("b",5,0)],		
		"j"			=>	[("j",2,0)],
		"jal"		=>	[("j",3,0)],		
		"jr"		=>	[("jr",0,8)],
		"lui"		=>	[("lui",15,0)],
		"lw"		=>	[("i",35,0)],
		"lqmeas"	=>	[("ql",63,0)],
		"nop"		=>	[("n",0,0)],
		"nor"		=>	[("r",0,39)],
		"or"		=>	[("r",0,37)],
		"ori"		=>	[("i",13,0)],
		"sll"		=>	[("s",0,0)],
		"sllv"	=>	[("sv",0,4)],
		"slt"		=>	[("r",0,42)],
		"slti"	=>	[("i",10,0)],
		"sltu"	=>	[("r",0,43)],
		"sltiu"	=>	[("i",11,0)],		
		"sra"		=>	[("s",0,3)],
		"srav"	=>	[("sv",0,7)],		
		"srl"		=>	[("s",0,2)],
		"srlv"	=>	[("sv",0,6)],
		"sub"		=>	[("r",0,34)],		
		"subu"	=>	[("r",0,35)],
		"sw"		=>	[("i",43,0)],
		"xor"		=>	[("r",0,38)],
		"xori"	=>	[("i",14,0)],
		"q"	=>	[("q11",48,0)],
		"i"	=>	[("q01",49,0)],
		"x"	=>	[("q01",50,0)],
		"z"	=>	[("q01",51,0)],
		"y"	=>	[("q01",52,0)],
		"h"	=>	[("q01",53,0)],
		"rk"	=>	[("q11",54,0)],
		"cnot"	=>	[("q02",55,0)],
		"crk"	=>	[("q12",56,0)],
		"swap"	=>	[("q02",57,0)],
		"measure"	=>	[("q01",58,0)],
		"qr"	=>	[("qr11",0,48)],
		"ir"	=>	[("qr01",0,49)],
		"xr"	=>	[("qr01",0,50)],
		"zr"	=>	[("qr01",0,51)],
		"yr"	=>	[("qr01",0,52)],
		"hr"	=>	[("qr01",0,53)],
		"rkr"	=>	[("qr11",0,54)],
		"cnotr"	=>	[("qr02",0,55)],
		"crkr"	=>	[("qr12",0,56)],
		"swapr"	=>	[("qr02",0,57)],
		"measurer"	=>	[("qr01",0,58)],
	);		
	

###############################################################################
#
# Psuedo instructions
#
###############################################################################

	%psuedo = (
		"text"	=>	".org $PROGRAM_AREA",
		"data"	=>	".org $DATA_AREA",
		"const"	=>	".org $CONST_AREA",
		
		"move"	=>	"or %1,%2,\$0",		# move $1, $2 -> or $1, $2, $0
		"beqz"	=>	"beq %1,\$0,%2",		# beqz $1, loop -> beq $1, $0, loop		
		"bneqz"	=>	"bne %1,\$0,%2",		# bneqz $1, loop -> bneq $1, $0, loop		
		"la"		=>	"addi %1,\$0,%2",		# la $1, item -> addi $1, $0, item
		"li"		=>	"lui %1,HI(%2)\nori %1,%1,LO(%2)",	#li $1, 0x80000000 -> lui $1,0x8000\nori $1,0x0000
		"la"		=>	"lui %1,HI(ADDR(%2))\nori %1,%1,LO(ADDR(%2))",	#li $1, $dataLabels{%2} -> lui $1,0x8000\n ori $1,$1,$dataLabels{%2}
		"not"		=>	"nor %1,%2,\$0",		# not $1, $2	->	nor $1, $2, $0
		"neg"		=>	"nor %1,%2,\$0\naddi %1,%1,1",		# neg $1, $2	->	nor $1, $2, $0 , addi $1, $1, 1
											
		
		# This is ugly, but we don't support bal yet...
		"bal"		=>	"jal %1",
		
		# This is ugly, but we don't support b yet...
		"b"		=>	"j %1",
		
		# This is to be compatible with Soll
		"halt"	=>	"beq \$0,\$0, -1\nnop",
		
	);

}

###############################################################################
#
# assemble
#
#	Reads the source file from a file.
#	Pass I, s&r psuedo instructions
#	Pass II, find and remember labels
# Pass III, convert to machinecode
# Write result to file.
#
###############################################################################
sub assemble {
	my $inputFile = shift;
	my $outputFile = shift;
	my $op;
	my $line;	
	my $position;	
	my @parms;	
	my @sourceList;
	my @opcodeList;
	my @source;
	my @lineNumbers;
	my $lineNumber;
	

###############################################################################
#
# Pass I
#
# Search and replace psuedo instructions. 
#
###############################################################################

	open(INPUT,"$inputFile") || die "Could not open input file.\n";
		
	$lineNumber = 1;
	
	while($line = <INPUT>) {	
				
		if (!($op = &getCommand($line))) {
			#Try to find directive...			 
			@directive = split(/[\t| |,]+/,&getDirective($line));
			$op = $directive[0];
		}
				
		if (exists $psuedo{$op}) {
			$replace = $psuedo{$op};
			
			@parms = &getParms($line,0,0);
						
			$replace =~ s/%1/$parms[0]/g;
			$replace =~ s/%2/$parms[1]/g;
			$replace =~ s/%3/$parms[2]/g;
			if ($label = &getLabel($line)) {
				push @source, $label;
				push @lineNumbers, $lineNumber;
			}
			
			@replace = split (/\n/, $replace);		
			push @source, @replace;			
			
			for ($i = 0; $i <= $#replace; $i++) {			
				if ($replace[$i]) { 
						push @lineNumbers, $lineNumber;		
				}				
			}						
		}
		else {
			push @source, $line;
			push @lineNumbers, $lineNumber; 			
		}	
		
		$lineNumber += 1;		
	}
	
	close(INPUT);

###############################################################################
#
# Pass II
#
# Look up labels in the source code and 
# remember their position.
#
###############################################################################
	
	# Start position at 0
	$position = 0;	
	
	for($i = 0; $i <= $#source; $i++) {			
		$line = $source[$i];			
		
		@directive = split(/[\t| |,]+/,&getDirective($line));
		#print join(",",@directive)."\n\n";
		if ($directive[0] eq "org") {
			$position = $directive[1];			
		}		
		
		if ($label = &getLabel($line)) {			
			if (exists $labels{$label}) {				
				&addError($lineNumbers[$i], $line, "Label already exist: ".$label);
			}
			
			$labels{$label} = $position;
		}		
		
		if (&getExecutable($line, $lineNumbers[$i], 0)) {
			$position += 4;	#Increment position counter if executable line		
		}
		else {
			if ($directive[0] eq "word") {
				for ($j = 1; $j <= $#directive; $j++) {					
					$constData{sprintf("%012d",$position)} = $directive[$j];
					$position += 4;
				}
			}
			if ($directive[0] eq "space") {
				$position += $directive[1];
			}			
		}
	}

	&exitIfErrors();		

###############################################################################
#
# Pass III
#
# Do the conversion to machinecode
#
###############################################################################
	
	if ($outputFile eq "") {
		open(OUTPUT,">-") || die "Could not open STDOUT.\n";
	}
	else {
		open(OUTPUT,">$outputFile") || die "Could not open output file.\n";
	}
	
	$position = $PROGRAM_AREA/4;
	
	print OUTPUT "clear\naddress ".($PROGRAM_AREA/4)."\n";	
	
	for($i = 0; $i <= $#source; $i++) {	
		$line = $source[$i];		
		
		if ($instr = &getExecutable($line, $lineNumbers[$i], 1)) { 
			push @opcodeList, &makeOpCode($instr, $lineNumbers[$i], $position);
			$instr =~ /[\t ]*(.*)/;
			push @sourceList, $1;
			$position++;					#Increment position counter if executable line
		}
	}
		
	&exitIfErrors;
	
	$position = $PROGRAM_AREA/4;
		
	for($i = 0; $i <= $#opcodeList; $i++) {	
		$line = $sourceList[$i];
		$line =~ tr/\t/ /;
		#printf ("when x\"%04x_%04x\" => Data_i <= x\"%04x_%04x\"; --%s\n", (($i*4)/65536) & 0xffff, ($i*4) & 0xffff, ($opcodeList[$i]/65536) & 0xffff, $opcodeList[$i] & 0xffff, $line);
		printf OUTPUT ("%08x --%08x %s\n", $opcodeList[$i], ($position*4), $line);
		$position++;
	}	
	
	$position = 0;
	foreach $key (sort keys %constData)
	{
		if ($key != $position) {			
			print OUTPUT "address ".($key/4)."\n";			
			printf OUTPUT ("%08x\n",$constData{$key});
			$position = $key + 4;
		}
		else {
			printf OUTPUT ("%08x\n",$constData{$key});
			$position += 4;
		}
		
	}
	
	close(OUTPUT);

}

###############################################################################
#
# getExecutable
#
# Parameters:
# 	$line, the current line to examine
#		$lineNumber, the current line number
#
#	Returns:
#		instruction if an executable line
#		""	if not an executable line
#
###############################################################################
sub getExecutable {
	my $line = shift;
	my $lineNumber = shift;	
	my $checkForErrors = shift;
	my $op;
	
	$line =~ s/(.*?)[#;]+.*/$1/;		#Parse line with comments!
		
	$line =~ s/.*:(.*)/$1/;					#Parse lines with labels
	
	if ($line !~ /^[\t ]*$/ ) {			#Skip lines with nothing on...				
		if ($line !~ /^[\t ]*\..*/ ) {		#Skip line starting with .				
			$op = getCommand($line);
			if (exists $commands{$op}) {
				return $line;
			}
			else {	
				if ($checkForErrors > 0) {
					&addError($lineNumber, $line, "Command not recognized: ".$op);
				}								
			}
		}
	}
		
	return "";	
}
###############################################################################
#
# getLabel
#
# Parameter:
#		$line: the current line to examine
#		
#	Returns:
#		The label
#
###############################################################################
sub getLabel {
	my $line = shift;

	$line =~ s/(.*?)[#;]+.*/$1/;		#Parse line with comments!
		
	if ($line =~ /[\t ]*(.*):.*/) {			#Parse lines with labels
		return $1;
		print $1."\n";		
	}
	
	return "";
}

###############################################################################
#
# getDirective
#
# Parameter:
#		$line: the current line to examine
#		
#	Returns:
#		The directive after the dot...
#
###############################################################################
sub getDirective {
	my $line = shift;		
	
	$line =~ s/(.*?)[#;]+.*/$1/;		#Parse line with comments!
		
		
	$line =~ s/^[a-zA-Z0-9_-]*:(.*)/$1/;					#Parse lines with labels

	if ($line !~ /^[\t ]*$/ ) {			#Skip lines with nothing on...				
		if ($line =~ /[\t ]*\.(.*)/) {		#Skip .		
			return $1;
		}
	}
	
	return "";
}

###############################################################################
#
# getCommand
#
# Parameter:
#		$line: the current line to examine
#		
#	Returns:
#		The command in lowercase
#
###############################################################################
sub getCommand {
	my $line = shift;	
	my $op;
	
	$line =~ s/(.*?)[#;]+.*/$1/;		#Parse line with comments!		
		
	$line =~ s/.*:(.*)/$1/;					#Parse lines with labels
		
	if ($line !~ /^[\t ]*$/ ) {			#Skip lines with nothing on...						
		if ($line !~ /^[\t ]*\..*/) {		#Skip line starting with .		
		
			# TODO - Clean this up!!!
			@array = split (/,/,$line);						
			@array = split (' ',$array[0]);									
			$line = $array[0];
			$line =~ /[\t ]*(.*)[\t ]+.*?/;
			$line =~ tr/A-Z/a-z/;			# Make opcode lowercase								
			return $line;
			
		}	
	}
	
	return "";
}

###############################################################################
#
# getParms
#
# Parameter:
#		$line: the current line to examine
#		$chopDollar:	set if you want to chop dollar sign...
#		$unWind:	set if you want to unwind parameters
#		
#	Returns:
#		An array with the parameters.
#
###############################################################################
sub getParms {
	my $line = shift;
	my $chopDollar = shift;
	my $unWind = shift;
	my $i;
	my @paramList;
	my @array;
	my $cmd;	
	my $temp;
	my $memoryOp = 0;
	
	$line =~ s/(.*?)[#;]+.*/$1/;		#Parse line with comments!
		
	$line =~ s/.*:(.*)/$1/;			#Parse lines with labels		
	
	$line =~ /[\t ]*.*?[\t ]+(.*)/;		#Drop command	
	$params = $1;	

	#special case for lw and sw instructions with a 100($1) parameter...				
	if ($params =~ /[0-9]+\(\$.*\)/ ) {		
		$memoryOp = 1;
		$params =~ tr/\(/,/;
		$params =~ tr/\)/ /;		
	}
	
	#Be sure to drop spaces in the begining and the end of line...	
	$params =~ s/(.*)[ \t]*/$1/;				# Chop trailing spaces... 		
	
	# split with commas, spaces and tabs
	@paramList = split(/[\t| |,]+/, $params);		
	
	for ($i = 0; $i <= $#paramList; $i++) {
		if ($unWind) {
			$paramList[$i] = &unWindParameter($paramList[$i]);
		}
		if ($chopDollar) {
			$paramList[$i] =~ s/.*\$(.*)/$1/;						# Chop $..
		}
		# TODO fix this!
		$paramList[$i] =~ s/[\t ]+(.*?)/$1/;				# Chop leading and trailing spaces... 		
		$paramList[$i] =~ s/(.*?)[\t ]+/$1/;				# Chop leading and trailing spaces... 		
	}	
	
	#Special case if 100($1)
	if ($memoryOp == 1) {			
			$temp = $paramList[2];
			$paramList[2] = $paramList[1];
			$paramList[1] = $temp;				
	}	
	
	# Return the array of parameters...
	@paramList;				
}

###############################################################################
#
# unWindParameter
#
# Parameter:
#		$parameter to unwind
#		
#	Returns:
#		An evaluted parameter
#
###############################################################################
sub unWindParameter {
	my $param = shift;
	my $operand;
	my $value;
	
	if ($param =~ /(.*?)\((.*)\)[\t ]*/) {
		$operand = $1;		
		
		$operand =~ s/[\t ]+(.*?)/$1/;				# Chop leading and trailing spaces... 		
		$operand =~ s/(.*?)[\t ]+/$1/;				# Chop leading and trailing spaces... 		
		$value = &unWindParameter($2);		
	}
	
	if ($operand eq "LO") {		
		return $value & 0xffff
	}
	elsif ($operand eq "HI") {
		return ($value & 0xffff0000) / 65536;
	}
	elsif ($operand eq "ADDR") {		
		if (exists $labels{$value}) {				
			return $labels{$value};			
		}
		else {
			# TODO - Add line number
			&addError(0, $line, "Label not found: ".$value);
		}
	}
	
	$param =~ s/[\t ]+(.*?)/$1/;				# Chop leading and trailing spaces... 		
	$param =~ s/(.*?)[\t ]+/$1/;				# Chop leading and trailing spaces... 		
	
	# Convert parameter to hex if 0xDeadBeef form on parameter
	if ($param =~ /0[xX][0-9a-fA-F]/) {
		$param = hex($param);
	}
	return $param;	
}


###############################################################################
#
#	makeOpCode
#
# Converts an assembler instruction to machine code.
#
# Parameters:
# 	$line, the current line to examine
#		$lineNumber, the current line number
#		$position, the current program position
#
#	Returns:
#		32-bit opcode
#
###############################################################################
sub makeOpCode {
	my $line = shift;
	my $lineNumber = shift;
	my $position = shift;
	my $cmd;
	my @parms;
	
	my @commandOptions;

	chomp($line);
	
	$pow26 = 67108864;
	$pow21 = 2097152;
	$pow16 = 65536;
	$pow11 = 2048;
	$pow6 = 64;
	
	$cmd = &getCommand($line);
	@parms = &getParms($line,1,1);	
	$cmdOpts = @commands{$cmd};

	if (@$cmdOpts[0] eq "r") {	#reg op
		&checkEnoughParams($lineNumber, $line, \@parms, 3);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[1]*$pow21 + $parms[2]*$pow16 + $parms[0]*$pow11 + @$cmdOpts[2];
	}	
	elsif (@$cmdOpts[0] eq "jr") {	#Special case for jr
		&checkEnoughParams($lineNumber, $line, \@parms, 1);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow21 + @$cmdOpts[2];
	}	
	elsif (@$cmdOpts[0] eq "i") { 	#imm op
		&checkEnoughParams($lineNumber, $line,\@parms, 3);
		if (exists $labels{$parms[2]}) {
			$position = $labels{$parms[2]}
		}
		else {
			$position = $parms[2];
		}		
		$opcode = @$cmdOpts[1]*$pow26 + $parms[1]*$pow21 + $parms[0]*$pow16 + ($position & 0xffff);		
	}		
	elsif (@$cmdOpts[0] eq "lui") { 	#imm op
		&checkEnoughParams($lineNumber, $line,\@parms, 2);
		if (exists $labels{$parms[1]}) {
			$position = $labels{$parms[1]};
		}
		else {
			$position = $parms[1];
		}		
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow16 + ($position & 0xffff);		
		
	}	
	elsif (@$cmdOpts[0] eq "s") { 	#shift op
		&checkEnoughParams($lineNumber, $line, \@parms, 3);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[1]*$pow16 + $parms[0]*$pow11 + ($parms[2] & 0x1f)*$pow6 + @$cmdOpts[2];
	}
	
	elsif (@$cmdOpts[0] eq "sv") { 	#variable shift op
		&checkEnoughParams($lineNumber, $line, \@parms, 3);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[2]*$pow21 + $parms[1]*$pow16 + $parms[0]*$pow11 + @$cmdOpts[2];
	}
	
	elsif (@$cmdOpts[0] eq "b") {	#branch op
		&checkEnoughParams($lineNumber, $line, \@parms, 3);
		if (exists $labels{$parms[2]} || ($parms[2] !~ /[A-Za-z]/)) {
			if ($parms[2] =~ /[A-Za-z]/) {
				$branchTarget = $labels{$parms[2]}/4 - ($position + 1);
			}
			else {
				$branchTarget = $parms[2];
			}			
			$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow21 + $parms[1]*$pow16 + ($branchTarget & 0xffff);
		}
		else {
			&addError($lineNumber, $line, "Label not found: ".$parms[2]);
		}
	}
	elsif (@$cmdOpts[0] eq "j") {	# jump op
		&checkEnoughParams($lineNumber, $line, \@parms, 1);				
		if (exists $labels{$parms[0]}) {
			$opcode = @$cmdOpts[1]*$pow26 + $labels{$parms[0]}/4;			
		}
		else {
			&addError($lineNumber, $line, "Label not found: ".$parms[2]);
		}
		
	}
	elsif (@$cmdOpts[0] eq "ql") {	#Load quantum measurement 
		&checkEnoughParams($lineNumber, $line, \@parms, 1);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow16;
	}
	elsif (@$cmdOpts[0] eq "q01") {	#Quantum operation (1 immediate op)
		&checkEnoughParams($lineNumber, $line, \@parms, 1);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow16;
	}
	elsif (@$cmdOpts[0] eq "q11") {	#Quantum operation (1 param + 1 immediate op)
		&checkEnoughParams($lineNumber, $line, \@parms, 2);
		$opcode = @$cmdOpts[1]*$pow26 + $param[0]*$pow21 + $parms[1]*$pow16;
	}
	elsif (@$cmdOpts[0] eq "q02") {	#Quantum operation (2 immediate op)
		&checkEnoughParams($lineNumber, $line, \@parms, 2);
		$opcode = @$cmdOpts[1]*$pow26 + $param[0]*$pow16 + $parms[1]*$pow11;
	}
	elsif (@$cmdOpts[0] eq "q12") {	#Quantum operation (1 param + 2 immediate op)
		&checkEnoughParams($lineNumber, $line, \@parms, 3);
		$opcode = @$cmdOpts[1]*$pow26 + $param[0]*$pow21 + $parms[1]*$pow16 + $parms[2]*$pow11;
	}
	elsif (@$cmdOpts[0] eq "qr01") {#Quantum operation (1 reg op)
		&checkEnoughParams($lineNumber, $line, \@parms, 1);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow16 + @$cmdOpts[2];
	}
	elsif (@$cmdOpts[0] eq "qr11") {#Quantum operation (1 reg param + 1 reg op)
		&checkEnoughParams($lineNumber, $line, \@parms, 2);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow21 + $parms[1]*$pow16 + @$cmdOpts[2];
	}
	elsif (@$cmdOpts[0] eq "qr02") {#Quantum operation (2 reg op)
		&checkEnoughParams($lineNumber, $line, \@parms, 2);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow16 + $parms[1]*$pow11 + @$cmdOpts[2];
	}
	elsif (@$cmdOpts[0] eq "qr12") {#Quantum operation (1 reg param + 2 reg op)
		&checkEnoughParams($lineNumber, $line, \@parms, 3);
		$opcode = @$cmdOpts[1]*$pow26 + $parms[0]*$pow21 + $parms[1]*$pow16 + $parms[2]*$pow11 + @$cmdOpts[2];
	}
	elsif (@$cmdOpts[0] eq "n") {
		$opcode = 0;	#nop
	}
	else
	{		
		&addError($lineNumber, $line, "Command not recognized: ".$line);		
	}	
	
	return $opcode;	
}

###############################################################################
#
# Add error to error list if actual number of parameters differs from
#	expected.
#
# Parameters:
#		$lineNumber, current line number
#		$line			, current line
#		$parms_ref, reference to parameter array
#		$nExpected, number of expected parameters
#
###############################################################################
sub checkEnoughParams{
	my $lineNumber = shift;
	my $line = shift;
	my $parms_ref = shift;
	my $nExpected = shift;
		
	if ($nExpected != (($#$parms_ref + 1))) {
		printf "nExpected = $nExpected\tparms_ref = $parms_ref \t $#$parms_ref\n";
		&addError($lineNumber, $line, "Expected ".$nExpected." parameters");
	}
	
	return;
}

###############################################################################
#
# Add errors to errors list
#
# Parameters:
#		$lineNumber, current line number
#		$line, current line
#		$errorText, error text
#
###############################################################################
sub addError {
	my $lineNumber = shift;
	my $line = shift;
	my $errorText = shift;
	chomp($errorText);
	$line =~ tr/[\t]/ /;
	push @errors, "Line ".$lineNumber.": ".$errorText." (".$line.")";
}

###############################################################################
#
# If errors were found, 
# 	print them and exit.
#
###############################################################################
sub exitIfErrors {
	
	if ($#errors >= 0) {		
		print "Errors found:\n";
		print join("\n",@errors)."\n";
		
		print "\nLabels found:\n";
		foreach $key (keys %labels)
		{
			print $key." = ".$labels{$key}."\n";
		}
		
		exit 1; 
	}
}
