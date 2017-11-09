#include "quantum.h"

int main()
{
	int a,b;

	qubit(0,0); qubit(0,1);

	H(0);
	Measure(0);
	GetQuantumMeasurementReg(a);
	a = (a&1);

	if(a==1)
	{
		asm("nop"); asm("nop"); asm("nop"); asm("nop");
		X(1);
		asm("nop"); asm("nop"); asm("nop"); asm("nop");
	}

	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	Measure(1);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	GetQuantumMeasurementReg(b);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	b = (b & 1<<1) >> 1;

	return 0;
}