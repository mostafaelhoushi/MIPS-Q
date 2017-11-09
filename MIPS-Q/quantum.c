#include "quantum.h"

void qubit(int param, int num)
{	
	asm("qr %0, %1" :: "r" (param), "r" (num));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void X(int q)
{
	asm("Xr %0" :: "r" (q));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void Z(int q)
{
	asm("Zr %0" :: "r" (q));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void Y(int q)
{
	asm("Yr %0" :: "r" (q));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void H(int q)
{
	asm("Hr %0" :: "r" (q));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void Rk(int param, int q)
{
	asm("Rkr %0, %1" :: "r" (param), "r" (q));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void CNOT(int q1, int q2)
{
	asm("CNOTr %0, %1" :: "r" (q1), "r" (q2));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void CRk(int param, int q1, int q2)
{
	asm("CRkr %0, %1, %2" :: "r" (param), "r" (q1), "r" (q2));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void Measure(int q)
{
	asm("MEASUREr %0" :: "r" (q));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void GetQuantumMeasurementReg(int a)
{
	asm("lqmeas %0" : "=r" (a));
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
}

void Toffoli(int q0, int q1, int q2)
{
	CRk(1,q2,q1);
	H(q2);
	Rk(-3,q2);
	CNOT(q2,q0);
	Rk(3,q2);
	CNOT(q2,q1);
	Rk(-3,q2);
	CNOT(q2,q0);
	Rk(3,q2);
	H(q2);
	CRk(2,q1,q0);
}

void negI(int q)
{
	Z(q); X(q); Z(q); X(q);
}