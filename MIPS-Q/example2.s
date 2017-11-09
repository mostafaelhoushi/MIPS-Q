	.file	1 "example2.c"
	.section .mdebug.abi32
	.previous
	.text
	.align	2
	.globl	main
	.set	nomips16
	.ent	main
main:
	.frame	$fp,32,$31		# vars= 8, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	move	$4,$0
	move	$5,$0
	jal	qubit
	nop

	move	$4,$0
	li	$5,1			# 0x1
	jal	qubit
	nop

	move	$4,$0
	jal	H
	nop

	move	$4,$0
	jal	Measure
	nop

	lw	$4,16($fp)
	jal	GetQuantumMeasurementReg
	nop

	lw	$2,16($fp)
	andi	$2,$2,0x1
	sw	$2,16($fp)
	lw	$2,16($fp)
	bne	$2,$0,.L2
	nop

	li	$4,1			# 0x1
	jal	X
	nop

.L2:
	li	$4,1			# 0x1
	jal	Measure
	nop

	lw	$4,20($fp)
	jal	GetQuantumMeasurementReg
	nop

	lw	$2,20($fp)
	andi	$2,$2,0x2
	sra	$2,$2,1
	sw	$2,20($fp)
	move	$2,$0
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
	.size	main, .-main
	.ident	"GCC: (GNU) 3.4.4 mipssde-6.06.01-20070420"
