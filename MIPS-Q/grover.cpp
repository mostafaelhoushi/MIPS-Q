//#include "quantum.h"

class Qubit
{
public:
Qubit(int p_intValue = 0) 
{
   number = count++;
   asm(“qr %0, %1” :: “r” (p_intValue ), “r” (number);
}

void X() 
{
  asm(“Xr %0” :: “r” (number);
}

void Z() 
{
  asm(“Zr %0” :: “r” (number);
}

void Y() 
{
  asm(“Yr %0” :: “r” (number);
}

void H() 
{ 
  asm(“Hr %0” :: “r” (number);
}

void Rk(int param)
{
  asm(“Rkr %0, %1” :: “r” (param), “r” (number);
}

void CNOT(Qubit q2) 
{
  asm(“CNOTr %0, %1” :: “r” (number), “r” (q2.GetNumber());
}

void CRk(int param, Qubit q2) 
{
  asm(“CRkr %0, %1, %2” :: “r” (param), “r” (number), “r” (q2.GetNumber());
}

int GetNumber() 
{
  return number;
}

int Measure() 
{
  asm(“MEASUREr %0” :: “r” (number); 
  int reg; 
  asm("lqmeas %0" : "=r" (reg) :);
  return (reg & (1 << number)); 
}

protected:
   int number;
   static int count;
};

// initialize X and ancilla qubits
Qubit x0(0), x1(0), x2(0), ax(0);
Qubit a(0);

int main()
{
	// perform H on X
	x0.H(); x1.H(); x2.H();

	for(int i=0; i<k; i++)
	{
		// Apply G
		G();
	}

	// measure X
	int x = x0.Measure() + x1.Measure()*2 + x2.Measure()*4;
	return 0;
}

void G()
{
	// Apply -HZ0HZf
	
	// Apply -I on X
	negI(x0);
	negI(x1);
	negI(x2);
	
	// perform H on X
	x0.H(); x1.H(); x2.H();

	// Apply Z0
	Z0();

	// perform H on X
	x0.H(); x1.H(); x2.H();

	// Apply Zf
	Zf();
}

void Z0()
{
	// invert X
	x0.X(); x1.X(); x2.X();
	
	// apply Uf
	Uf();

	// invert X
	x0.X(); x1.X(); x2.X();
}

void Zf()
{
	// perform H on X
	x0.H(); x1.H(); x2.H();

	// invert a
	a.X();

	// apply Uf
	Uf();

	// perform H on X
	x0.H(); x1.H(); x2.H();

	// invert a
	a.X();
}

void Uf()
{
	Toffoli(x0,x1,ax);
	Toffoli(x2,ax,a);
	Toffoli(x0,x1,ax);
}

void Toffoli(Qubit q0, Qubit q1, Qubit q2)
{
	q2.CRk(1,q1);
	q2.H();
	q2.Rk(-3);
	q2.CNOT(q0);
	q2.Rk(3);
	q2.CNOT(q1);
	q2.Rk(-3);
	q2.CNOT(q0);
	q2.Rk(3);
	q2.H();
	q1.CRk(2,q0);
}

void negI(Qubit q)
{
	q.Z(); q.X(); q.Z(); q.X();
}


