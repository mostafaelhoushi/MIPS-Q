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
	BOOL result;

	// two classical bits we want to send
	BOOL b0, b1;
	b0 = 0;
	b1 = 0;

	// set up entangled qubit pair
	QUBIT(0,0);
	QUBIT(1,0);
	H(0);
	CNOT(1,0);
	

	// modify first qubit according to the values of the classical bits
	if(b0 == 1)
		Z(0);
	if(b1 == 1)
		X(0);

	// apply Bell measurements
	CNOT(1,0);
	H(0);
	MEASURE(0);
	MEASURE(1);

	GETQMEASURE(a);

	
	if((BOOL)(a & (1 << 0)) == b0 && (BOOL)(a & (1 << 1)) == b1)
		result = TRUE;
	else
		result = FALSE;

	return result;
}
