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
	addiu	$sp,$sp,-32
	sw	$31,28($sp)
	sw	$fp,24($sp)
	move	$fp,$sp
	move	$4,$0
	move	$5,$0
	jal	qubit
	move	$4,$0
	li	$5,1			# 0x1
	jal	qubit
	move	$4,$0
	jal	H
	move	$4,$0
	jal	Measure
	lw	$4,16($fp)
	jal	GetQuantumMeasurementReg
	lw	$2,16($fp)
	andi	$2,$2,0x1
	sw	$2,16($fp)
	lw	$3,16($fp)
	li	$2,1			# 0x1
	bne	$3,$2,.L2
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,1			# 0x1
	jal	X
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
.L2:
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,1			# 0x1
	jal	Measure
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	lw	$4,20($fp)
	jal	GetQuantumMeasurementReg
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	lw	$2,20($fp)
	andi	$2,$2,0x2
	sra	$2,$2,1
	sw	$2,20($fp)
	move	$2,$0
	move	$sp,$fp
	lw	$31,28($sp)
	lw	$fp,24($sp)
	addiu	$sp,$sp,32
	jr	$31
	.end	main
	.size	main, .-main
	.align	2
	.globl	qubit
	.set	nomips16
	.ent	qubit
qubit:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	lw	$3,8($fp)
	lw	$2,12($fp)
 #APP
	qr $3, $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	qubit
	.size	qubit, .-qubit
	.align	2
	.globl	X
	.set	nomips16
	.ent	X
X:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
 #APP
	Xr $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	X
	.size	X, .-X
	.align	2
	.globl	Z
	.set	nomips16
	.ent	Z
Z:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
 #APP
	Zr $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	Z
	.size	Z, .-Z
	.align	2
	.globl	Y
	.set	nomips16
	.ent	Y
Y:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
 #APP
	Yr $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	Y
	.size	Y, .-Y
	.align	2
	.globl	H
	.set	nomips16
	.ent	H
H:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
 #APP
	Hr $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	H
	.size	H, .-H
	.align	2
	.globl	Rk
	.set	nomips16
	.ent	Rk
Rk:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	lw	$3,8($fp)
	lw	$2,12($fp)
 #APP
	Rkr $3, $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	Rk
	.size	Rk, .-Rk
	.align	2
	.globl	CNOT
	.set	nomips16
	.ent	CNOT
CNOT:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	lw	$3,8($fp)
	lw	$2,12($fp)
 #APP
	CNOTr $3, $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	CNOT
	.size	CNOT, .-CNOT
	.align	2
	.globl	CRk
	.set	nomips16
	.ent	CRk
CRk:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	sw	$5,12($fp)
	sw	$6,16($fp)
	lw	$4,8($fp)
	lw	$3,12($fp)
	lw	$2,16($fp)
 #APP
	CRkr $4, $3, $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	CRk
	.size	CRk, .-CRk
	.align	2
	.globl	Measure
	.set	nomips16
	.ent	Measure
Measure:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
	lw	$2,8($fp)
 #APP
	MEASUREr $2
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	Measure
	.size	Measure, .-Measure
	.align	2
	.globl	GetQuantumMeasurementReg
	.set	nomips16
	.ent	GetQuantumMeasurementReg
GetQuantumMeasurementReg:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
	sw	$fp,0($sp)
	move	$fp,$sp
	sw	$4,8($fp)
 #APP
	lqmeas $2
 #NO_APP
	sw	$2,8($fp)
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	jr	$31
	.end	GetQuantumMeasurementReg
	.size	GetQuantumMeasurementReg, .-GetQuantumMeasurementReg
	.align	2
	.globl	Toffoli
	.set	nomips16
	.ent	Toffoli
Toffoli:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$6,32($fp)
	li	$4,1			# 0x1
	lw	$5,32($fp)
	lw	$6,28($fp)
	jal	CRk
	nop

	lw	$4,32($fp)
	jal	H
	nop

	li	$4,-3			# 0xfffffffffffffffd
	lw	$5,32($fp)
	jal	Rk
	nop

	lw	$4,32($fp)
	lw	$5,24($fp)
	jal	CNOT
	nop

	li	$4,3			# 0x3
	lw	$5,32($fp)
	jal	Rk
	nop

	lw	$4,32($fp)
	lw	$5,28($fp)
	jal	CNOT
	nop

	li	$4,-3			# 0xfffffffffffffffd
	lw	$5,32($fp)
	jal	Rk
	nop

	lw	$4,32($fp)
	lw	$5,24($fp)
	jal	CNOT
	nop

	li	$4,3			# 0x3
	lw	$5,32($fp)
	jal	Rk
	nop

	lw	$4,32($fp)
	jal	H
	nop

	li	$4,2			# 0x2
	lw	$5,28($fp)
	lw	$6,24($fp)
	jal	CRk
	nop

	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	Toffoli
	.size	Toffoli, .-Toffoli
	.align	2
	.globl	negI
	.set	nomips16
	.ent	negI
negI:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
	sw	$31,20($sp)
	sw	$fp,16($sp)
	move	$fp,$sp
	sw	$4,24($fp)
	lw	$4,24($fp)
	jal	Z
	nop

	lw	$4,24($fp)
	jal	X
	nop

	lw	$4,24($fp)
	jal	Z
	nop

	lw	$4,24($fp)
	jal	X
	nop

	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	jr	$31
	nop

	.set	macro
	.set	reorder
	.end	negI
	.size	negI, .-negI
