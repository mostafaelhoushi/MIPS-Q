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

int Measure() {
  asm(“MEASUREr %0” :: “r” (number); 
  int reg; 
  asm("lqmeas %0" : "=r" (reg) :);
  return (reg & (1 << number)); 
}

protected:
   int number;
   static int count;
};

int main()
{
  return superdense_code(0,0);
}

bool superdense_coding(bool b1, bool b2)
{
  // set up entangled qubit pair
  Qubit q0(0), q1(0);
  q0.H(); 
  q1.CNOT(q0); 

  // modify first qubit according to the values of the classical bits
  if(b0 == 1)
    q0.Z();
  if(b1 == 1)
    q0.X();

  // apply Bell measurements
  q1.CNOT(q0);
  q0.H();

  return (q0.Measure() == b0 && q1.Measure() == b1);
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
