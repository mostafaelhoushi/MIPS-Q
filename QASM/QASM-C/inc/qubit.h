/*
 * qubit.h
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#ifndef QUBIT_H_
#define QUBIT_H_

#include "qubit_vector.h"

class qubit: public qubit_vector
{
public:
	qubit(complex<double> p_cplxAlpha, complex<double> p_cplxBeta): qubit_vector(1)
	{
		m_cplxVector[0] = p_cplxAlpha;
		m_cplxVector[1] = p_cplxBeta;
	};

	complex<double> alpha() {return m_cplxVector[0];};
	complex<double> beta() {return m_cplxVector[1];};


protected:
};


#endif /* QUBIT_H_ */
