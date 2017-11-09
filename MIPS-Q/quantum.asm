	.file	1 "quantum.c"
	.section .mdebug.abi32
	.previous
	.text
	.align	2
	.globl	main
	.set	nomips16
	.ent	main
main:
	.frame	$fp,16,$31		# vars= 8, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-16
	sw	$fp,8($sp)
	move	$fp,$sp
 #APP
#	q 0, 0
	nop
	nop
	nop
	nop
#	X 0
	nop
	nop
	nop
	nop
#	H 1
	nop
	nop
	nop
	nop
#	CNOT 2, 1
	nop
	nop
	nop
	nop
#	CNOT 1, 0
	nop
	nop
	nop
	nop
#	H 0
	nop
	nop
	nop
	nop
#	MEASURE 0
	nop
	nop
	nop
	nop
#	MEASURE 1
	nop
	nop
	nop
	nop
	lqmeas $2
 #NO_APP
	sw	$2,0($fp)
	lw	$2,0($fp)
	andi	$2,$2,0x2
	beq	$2,$0,L2
 #APP
#	X 2
 #NO_APP
L2:
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	lw	$2,0($fp)
	andi	$2,$2,0x1
	beq	$2,$0,L3
 #APP
#	Z 2
 #NO_APP
L3:
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,8($sp)
	addiu	$sp,$sp,16
	jr	$31
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.4 mipssde-6.06.01-20070420"
