/*
 * misc.h
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#ifndef MISC_H_
#define MISC_H_

#include <iostream>
#include <complex>
#include <stdio.h>
#include <string.h>
#include <iomanip>
#include <stdlib.h>
#include <time.h>
using namespace std;

string convert_binary(unsigned int number, unsigned int digits);

unsigned int swap_bits(unsigned int p_uintNumber, unsigned int p_uintPosition1, unsigned int p_uintPosition2);

ostream& operator << (ostream& s, complex<double> c);


#endif /* MISC_H_ */
