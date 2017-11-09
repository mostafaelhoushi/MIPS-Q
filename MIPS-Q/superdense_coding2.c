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

int main()
{
	int a;
	return superdense_code(0,0);
}

BOOL superdense_code(BOOL b0, BOOL b1)
{
	BOOL result;

	// set up entangled qubit pair
	qubit(0,0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	qubit(1,0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	H(0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	CNOT(1,0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");

	// modify first qubit according to the values of the classical bits
	if(b0 == 1)
	{
		Z(0);
		asm("nop"); asm("nop"); asm("nop"); asm("nop");
	}
	if(b1 == 1)
	{
		X(0);
		asm("nop"); asm("nop"); asm("nop"); asm("nop");
	}
	
	// apply Bell measurements
	CNOT(1,0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	H(0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	Measure(0);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");
	Measure(1);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");

	GetQuantumMeasurementReg(a);
	asm("nop"); asm("nop"); asm("nop"); asm("nop");

	if((BOOL)(a & (1 << 0)) == b0 && (BOOL)(a & (1 << 1)) == b1)
		result = TRUE;
	else
		result = FALSE;

	return result;
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
