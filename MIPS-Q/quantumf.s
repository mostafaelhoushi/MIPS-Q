	.file	1 "quantumf.c"
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
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	move	$4,$0
	jal	X
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,1			# 0x1
	jal	H
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,2			# 0x2
	li	$5,1			# 0x1
	jal	CNOT
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,1			# 0x1
	move	$5,$0
	jal	CNOT
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	move	$4,$0
	jal	H
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	move	$4,$0
	jal	Measure
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
	lw	$4,16($fp)
	jal	GetQuantumMeasurementReg
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	lw	$2,16($fp)
	andi	$2,$2,0x2
	beq	$2,$0,.L2
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,2			# 0x2
	jal	X
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
.L2:
	lw	$2,16($fp)
	andi	$2,$2,0x1
	beq	$2,$0,.L3
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
	li	$4,2			# 0x2
	jal	Z
 #APP
	nop
	nop
	nop
	nop
 #NO_APP
.L3:
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
	nop
	nop
	nop
	nop
	lw	$2,12($fp)
	nop
	nop
	nop	
	nop
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
