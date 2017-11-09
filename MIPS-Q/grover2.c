//#include "quantum.h"

void qubit(int param, int num);
void X(int q);
void Z(int q);
void Y(int q);
void H(int q);
void Rk(int param, int q);
void CNOT(int q1, int q2);
void CRk(int param, int q1, int q2);
void Measure(int q);
void GetQuantumMeasurementReg(int a);

void Toffoli(int q0, int q1, int q2);
void negI(int q);

int x0=0, x1=1, x2=2, ax=3;
int a=4;

int main()
{
	int i = 0;
	int k = 4;

	// initialize X
	qubit(0,x0);
	qubit(0,x1);
	qubit(0,x2);

	// initialize ancilla for Uf
	qubit(0,ax);

	// initialize a
	qubit(0,a);

	// perform H on X
	H(x0);
	H(x1);
	H(x2);

	for(i=0; i<k; i++)
	{
		//Apply G
		G();
	}

	// Measure X
	Measure(x0);
	Measure(x1);
	Measure(x2);

	int meas;
	GetQuantumMeasurementReg(meas);
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

	// Apply Z0
	Z0();

	// perform H on X
	H(x0);
	H(x1);
	H(x2);

	// Apply Zf
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
	Toffoli(x0,x1,ax);
	Toffoli(x2,ax,a);
	Toffoli(x0,x1,ax);
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
