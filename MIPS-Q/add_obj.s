	.file	1 "add_obj.cpp"
	.section .mdebug.abi32
	.previous
	.text
	.align	2
	.globl	main
.LFB4:
	.set	nomips16
	.ent	main
main:
	.frame	$fp,48,$31		# vars= 24, regs= 2/0, args= 16, gp= 0
	.mask	0xc0000000,-4
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-48
.LCFI0:
	sw	$31,44($sp)
.LCFI1:
	sw	$fp,40($sp)
.LCFI2:
	move	$fp,$sp
.LCFI3:
	li	$2,20			# 0x14
	sw	$2,16($fp)
	li	$2,40			# 0x28
	sw	$2,20($fp)
	addiu	$2,$fp,32
	move	$4,$2
	lw	$5,16($fp)
	lw	$6,20($fp)
	jal	_ZN5AdderC1Eii
	nop

	addiu	$2,$fp,32
	move	$4,$2
	jal	_ZN5Adder3addEv
	nop

	sw	$2,24($fp)
	move	$2,$0
	move	$sp,$fp
	lw	$31,44($sp)
	lw	$fp,40($sp)
	addiu	$sp,$sp,48
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	main
.LFE4:
	.size	main, .-main
	.section	.gnu.linkonce.t._ZN5Adder3addEv,"ax",@progbits
	.align	2
	.weak	_ZN5Adder3addEv
.LFB3:
	.set	nomips16
	.ent	_ZN5Adder3addEv
_ZN5Adder3addEv:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-8
.LCFI4:
	sw	$fp,0($sp)
.LCFI5:
	move	$fp,$sp
.LCFI6:
	sw	$4,8($fp)
	lw	$2,8($fp)
	lw	$3,8($fp)
	lw	$4,0($2)
	lw	$2,4($3)
	addu	$2,$4,$2
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	_ZN5Adder3addEv
.LFE3:
	.size	_ZN5Adder3addEv, .-_ZN5Adder3addEv
	.section	.gnu.linkonce.t._ZN5AdderC1Eii,"ax",@progbits
	.align	2
	.weak	_ZN5AdderC1Eii
.LFB2:
	.set	nomips16
	.ent	_ZN5AdderC1Eii
_ZN5AdderC1Eii:
	.frame	$fp,8,$31		# vars= 0, regs= 1/0, args= 0, gp= 0
	.mask	0x40000000,-8
	.fmask	0x00000000,0
	.set	noreorder
	.set	nomacro
	
	addiu	$sp,$sp,-8
.LCFI7:
	sw	$fp,0($sp)
.LCFI8:
	move	$fp,$sp
.LCFI9:
	sw	$4,8($fp)
	sw	$5,12($fp)
	sw	$6,16($fp)
	lw	$3,8($fp)
	lw	$2,12($fp)
	sw	$2,0($3)
	lw	$3,8($fp)
	lw	$2,16($fp)
	sw	$2,4($3)
	move	$sp,$fp
	lw	$fp,0($sp)
	addiu	$sp,$sp,8
	j	$31
	nop

	.set	macro
	.set	reorder
	.end	_ZN5AdderC1Eii
.LFE2:
	.size	_ZN5AdderC1Eii, .-_ZN5AdderC1Eii
	.ident	"GCC: (GNU) 3.4.4 mipssde-6.06.01-20070420"
