//#include "quantum.h"

#define qasm(string)	{asm(string); asm("nop"); asm("nop"); asm("nop"); asm("nop");}	
#define QUBIT(val, param)	qasm("q " #val ", " #param);
#define X(q)		qasm("X " #q);
#define Z(q)		qasm("Z " #q);
#define Y(q)		qasm("Y " #q);
#define H(q)		qasm("H " #q);
#define Rk(param,q)		qasm("Rk " #param ", " #q);
#define CNOT(q1,q2)	qasm("CNOT " #q1 ", " #q2);
#define CRk(param,q1,q2)	qasm("CRk " #param ", " #q1 ", " #q2);
#define SWAP(q1,q2)	qasm("SWAP " #q1 ", " #q2);
#define MEASURE(q)	qasm("MEASURE " #q);
#define GETQMEASURE(a)	asm("lqmeas %0" : "=r" (a) :);


int main()
{
	int a;

	QUBIT(0,0);
	X(0);

	H(1);
	CNOT(2,1);
	
	CNOT(1,0);
	H(0);
	MEASURE(0);
	MEASURE(1);

	GETQMEASURE(a);

	if(a & (1 << 1))
	{
		asm("nop");asm("nop"); asm("nop"); asm("nop");
		X(2);
	}

	if(a & (1 << 0))
	{
		asm("nop");asm("nop"); asm("nop"); asm("nop");
		Z(2);
	}
}
