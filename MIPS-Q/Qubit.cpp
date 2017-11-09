#include "Qubit.h"

Qubit::Qubit(int p_intValue) 
{
   number = count++;
   asm("qr %0, %1" :: "r" (p_intValue ), "r" (number));
}

void Qubit::X() 
{
  asm("Xr %0" :: "r" (number));
}

void Qubit::Z() 
{
  asm("Zr %0" :: "r" (number));
}

void Qubit::Y() 
{
  asm("Yr %0" :: "r" (number));
}

void Qubit::H() 
{ 
  asm("Hr %0" :: "r" (number));
}

void Qubit::Rk(int param)
{
  asm("Rkr %0, %1" :: "r" (param), "r" (number));
}

void Qubit::CNOT(Qubit q2) 
{
  asm("CNOTr %0, %1" :: "r" (number), "r" (q2.GetNumber()));
}

void Qubit::CRk(int param, Qubit q2) 
{
  asm("CRkr %0, %1, %2" :: "r" (param), "r" (number), "r" (q2.GetNumber()));
}

int Qubit::GetNumber() 
{
  return number;
}

int Qubit::Measure() 
{
  asm("MEASUREr %0" :: "r" (number)); 
  int reg; 
  asm("lqmeas %0" : "=r" (reg) :);
  return (reg & (1 << number)); 
}

void Qubit::Toffoli(Qubit q0, Qubit q1)
{
	this->CRk(1,q1);
	this->H();
	this->Rk(-3);
	this->CNOT(q0);
	this->Rk(3);
	this->CNOT(q1);
	this->Rk(-3);
	this->CNOT(q0);
	this->Rk(3);
	this->H();
	q1.CRk(2,q0);
}

void Qubit::negI()
{
	this->Z(); this->X(); this->Z(); this->X();
}

