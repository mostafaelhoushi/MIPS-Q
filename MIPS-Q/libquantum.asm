	.file	1 "quantum.c"
	.section .mdebug.abi32
	.previous
	.text
	.align	2
	.globl	_Z5qubitii
.LFB0:
	.set	nomips16
	.ent	_Z5qubitii
_Z5qubitii:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI0:
	sw	$fp,0($sp)
.LCFI1:
	move	$fp,$sp
.LCFI2:
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
	j	$31
	.end	_Z5qubitii
.LFE0:
	.size	_Z5qubitii, .-_Z5qubitii
	.align	2
	.globl	_Z1Xi
.LFB1:
	.set	nomips16
	.ent	_Z1Xi
_Z1Xi:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI3:
	sw	$fp,0($sp)
.LCFI4:
	move	$fp,$sp
.LCFI5:
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
	j	$31
	.end	_Z1Xi
.LFE1:
	.size	_Z1Xi, .-_Z1Xi
	.align	2
	.globl	_Z1Zi
.LFB2:
	.set	nomips16
	.ent	_Z1Zi
_Z1Zi:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI6:
	sw	$fp,0($sp)
.LCFI7:
	move	$fp,$sp
.LCFI8:
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
	j	$31
	.end	_Z1Zi
.LFE2:
	.size	_Z1Zi, .-_Z1Zi
	.align	2
	.globl	_Z1Yi
.LFB3:
	.set	nomips16
	.ent	_Z1Yi
_Z1Yi:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI9:
	sw	$fp,0($sp)
.LCFI10:
	move	$fp,$sp
.LCFI11:
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
	j	$31
	.end	_Z1Yi
.LFE3:
	.size	_Z1Yi, .-_Z1Yi
	.align	2
	.globl	_Z1Hi
.LFB4:
	.set	nomips16
	.ent	_Z1Hi
_Z1Hi:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI12:
	sw	$fp,0($sp)
.LCFI13:
	move	$fp,$sp
.LCFI14:
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
	j	$31
	.end	_Z1Hi
.LFE4:
	.size	_Z1Hi, .-_Z1Hi
	.align	2
	.globl	_Z2Rkii
.LFB5:
	.set	nomips16
	.ent	_Z2Rkii
_Z2Rkii:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI15:
	sw	$fp,0($sp)
.LCFI16:
	move	$fp,$sp
.LCFI17:
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
	j	$31
	.end	_Z2Rkii
.LFE5:
	.size	_Z2Rkii, .-_Z2Rkii
	.align	2
	.globl	_Z4CNOTii
.LFB6:
	.set	nomips16
	.ent	_Z4CNOTii
_Z4CNOTii:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI18:
	sw	$fp,0($sp)
.LCFI19:
	move	$fp,$sp
.LCFI20:
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
	j	$31
	.end	_Z4CNOTii
.LFE6:
	.size	_Z4CNOTii, .-_Z4CNOTii
	.align	2
	.globl	_Z3CRkiii
.LFB7:
	.set	nomips16
	.ent	_Z3CRkiii
_Z3CRkiii:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI21:
	sw	$fp,0($sp)
.LCFI22:
	move	$fp,$sp
.LCFI23:
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
	j	$31
	.end	_Z3CRkiii
.LFE7:
	.size	_Z3CRkiii, .-_Z3CRkiii
	.align	2
	.globl	_Z7Measurei
.LFB8:
	.set	nomips16
	.ent	_Z7Measurei
_Z7Measurei:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI24:
	sw	$fp,0($sp)
.LCFI25:
	move	$fp,$sp
.LCFI26:
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
	j	$31
	.end	_Z7Measurei
.LFE8:
	.size	_Z7Measurei, .-_Z7Measurei
	.align	2
	.globl	_Z24GetQuantumMeasurementRegi
.LFB9:
	.set	nomips16
	.ent	_Z24GetQuantumMeasurementRegi
_Z24GetQuantumMeasurementRegi:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	addiu	$sp,$sp,-8
.LCFI27:
	sw	$fp,0($sp)
.LCFI28:
	move	$fp,$sp
.LCFI29:
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
	j	$31
	.end	_Z24GetQuantumMeasurementRegi
.LFE9:
	.size	_Z24GetQuantumMeasurementRegi, .-_Z24GetQuantumMeasurementRegi
	.align	2
	.globl	_Z7Toffoliiii
.LFB10:
	.set	nomips16
	.ent	_Z7Toffoliiii
_Z7Toffoliiii:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
.LCFI30:
	sw	$31,20($sp)
.LCFI31:
	sw	$fp,16($sp)
.LCFI32:
	move	$fp,$sp
.LCFI33:
	sw	$4,24($fp)
	sw	$5,28($fp)
	sw	$6,32($fp)
	li	$4,1			# 0x1
	lw	$5,32($fp)
	lw	$6,28($fp)
	jal	_Z3CRkiii
	nop

	lw	$4,32($fp)
	jal	_Z1Hi
	nop

	li	$4,-3			# 0xfffffffffffffffd
	lw	$5,32($fp)
	jal	_Z2Rkii
	nop

	lw	$4,32($fp)
	lw	$5,24($fp)
	jal	_Z4CNOTii
	nop

	li	$4,3			# 0x3
	lw	$5,32($fp)
	jal	_Z2Rkii
	nop

	lw	$4,32($fp)
	lw	$5,28($fp)
	jal	_Z4CNOTii
	nop

	li	$4,-3			# 0xfffffffffffffffd
	lw	$5,32($fp)
	jal	_Z2Rkii
	nop

	lw	$4,32($fp)
	lw	$5,24($fp)
	jal	_Z4CNOTii
	nop

	li	$4,3			# 0x3
	lw	$5,32($fp)
	jal	_Z2Rkii
	nop

	lw	$4,32($fp)
	jal	_Z1Hi
	nop

	li	$4,2			# 0x2
	lw	$5,28($fp)
	lw	$6,24($fp)
	jal	_Z3CRkiii
	nop

	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	_Z7Toffoliiii
.LFE10:
	.size	_Z7Toffoliiii, .-_Z7Toffoliiii
	.align	2
	.globl	_Z4negIi
.LFB11:
	.set	nomips16
	.ent	_Z4negIi
_Z4negIi:
	.frame	$fp,24,$31		# vars= 0, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-24
.LCFI34:
	sw	$31,20($sp)
.LCFI35:
	sw	$fp,16($sp)
.LCFI36:
	move	$fp,$sp
.LCFI37:
	sw	$4,24($fp)
	lw	$4,24($fp)
	jal	_Z1Zi
	nop

	lw	$4,24($fp)
	jal	_Z1Xi
	nop

	lw	$4,24($fp)
	jal	_Z1Zi
	nop

	lw	$4,24($fp)
	jal	_Z1Xi
	nop

	move	$sp,$fp
	lw	$31,20($sp)
	lw	$fp,16($sp)
	addiu	$sp,$sp,24
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	_Z4negIi
.LFE11:
	.size	_Z4negIi, .-_Z4negIi
	.ident	"GCC: (GNU) 3.4.4 mipssde-6.06.01-20070420"
