//#include "quantum.h"

#define qasm(string)	{asm(string); asm("nop"); asm("nop"); asm("nop"); asm("nop");}	
#define QUBIT(val, num)	qasm("q " #val ", " #num);
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

void G();
void Z0();
void Zf();
void Uf();

#define TOFFOLI(q0, q1, q2)	/
	CRk(1,q2,q1)	/
	H(q2)		/
	Rk(-3,q2)	/
	CNOT(q2,q0)	/
	Rk(3,q2)	/
	CNOT(q2,q1)	/
	Rk(-3,q2)	/
	CNOT(q2,q0)	/
	Rk(3,q2)	/
	H(q2)		/
	CRk(2,q1,q0)

#define negI(q) X(q); Z(q); X(q); Z(q);

#define x0	0
#define x1	1
#define x2	2
#define ax	3
#define a	4

int main()
{
	int i = 0;
	int k = 4;

	// initialize X
	QUBIT(0,x0);
	QUBIT(0,x1);
	QUBIT(0,x2);

	// initialize ancilla for Uf
	QUBIT(0,ax);

	// initialize a
	QUBIT(0,a);

	// perform H on X
	H(x0);
	H(x1);
	H(x2);

	for(i=0; i<k; i++)
	{
		//Apply G
		G();
	}

	// measure X
	MEASURE(x0);
	MEASURE(x1);
	MEASURE(x2);
	int meas;
	GETQMEASURE(meas);
	meas = meas && 0x07;	
}

void G()
{
	// Apply -HZ0HZf
	
	// Apply -I on X
	negI(x0);
	negI(x1);
	negI(x2);
	
	// perform H on X
	H(x0);
	H(x1);
	H(x2);

	//Apply Z0
	Z0();

	// perform H on X
	H(x0);
	H(x1);
	H(x2);

	//Apply Zf
	Zf();
}

void Z0()
{
	// invert X
	X(x0);
	X(x1);
	X(x2);
	
	// apply Uf
	Uf();

	// invert X
	X(x0);
	X(x1);
	X(x2);
}

void Zf()
{
	// perform H on X
	H(x0);
	H(x1);
	H(x2);
	// invert a
	X(a);

	// apply Uf
	Uf();

	// perform H on X
	H(x0);
	H(x1);
	H(x2);
	// invert a
	X(a);
}

void Uf()
{
	TOFFOLI(x0,x1,ax);
	TOFFOLI(x2,ax,a);
	TOFFOLI(x0,x1,ax);
}