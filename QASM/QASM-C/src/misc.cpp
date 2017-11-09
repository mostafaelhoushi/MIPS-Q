/*
 * misc.cpp
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#include "misc.h"

string convert_binary(unsigned int number, unsigned int digits)
{
	// bits 0 -7 written from left to right
	char* result = new char[digits+1];
	memset(result, 0, digits+1);
	for(int i = digits - 1; i >= 0; --i)
	{
		if(number & (1 << i))
			result[i]= '1';
		else
			result[i]= '0';
	}
	return result;
}

unsigned int swap_bits(unsigned int p_uintNumber, unsigned int p_uintPosition1, unsigned int p_uintPosition2)
{
	unsigned int  p_uintBit1 = 1 << p_uintPosition1;
	unsigned int  p_uintBit2 = 1 << p_uintPosition2;

	unsigned int uintTempNumber = p_uintNumber;

	uintTempNumber = (p_uintBit1 &  p_uintNumber) ? uintTempNumber | p_uintBit2 : uintTempNumber & (~p_uintBit2);
	uintTempNumber = (p_uintBit2 &  p_uintNumber) ? uintTempNumber | p_uintBit1 : uintTempNumber & (~p_uintBit1);

	return uintTempNumber;
}

ostream& operator << (ostream& s, complex<double> c)
{
	if(real(c) == 0 && imag(c) != 0)
		;
	else
		s << real(c);
	if (imag(c) != 0)
	{
		s << (imag(c) > 0 ? "+" : "-");
		if(abs(imag(c)) != 1)
			s << abs(imag(c));
		s << "i";
	}
	return s;
}
