/*
* qubit_vector.cpp
*
*  Created on: Dec 17, 2010
*      Author: melhoush
*/

#include "qubit_vector.h"

qubit_vector::qubit_vector(complex<double> p_cplxVector[], int p_intDimension): m_intDimension(p_intDimension)
{
	m_cplxVector = new complex<double> [length()];

	for(int i=0; i<length(); i++)
		m_cplxVector[i] = p_cplxVector[i];
};

qubit_vector::qubit_vector(complex<double> p_cplxVector[]): m_intDimension(log((double)sizeof(p_cplxVector))/log((double)2))
{
	m_cplxVector = new complex<double> [length()];

	for(int i=0; i<length(); i++)
		m_cplxVector[i] = p_cplxVector[i];
};

qubit_vector::qubit_vector(int p_intDimension): m_intDimension(p_intDimension)
{
	m_cplxVector = new complex<double>[length()];

	// Default value: all qubits set to 0
	m_cplxVector[0] = 1;
};

bool qubit_vector::operator == (qubit_vector q) const
{
	bool bResult = true;
	for(int i=0; i<q.length() && bResult; i++)
		bResult = bResult && (m_cplxVector[i] == q[i]);

	return bResult;
};

qubit_vector qubit_vector::tensor(qubit_vector q, qubit_vector p)
{
	complex<double>* r = new complex<double>[q.length() * p.length()];

	for(int i=0; i<q.length(); i++)
		for(int j=0; j<p.length(); j++)
			{r[j+i*p.length()] = q[i]*p[j]; }

	return qubit_vector(r, q.dimension() + p.dimension());
};

bool qubit_vector::isValid()
{
	double sum2 = 0;
	for(int i=0; i< length(); i++)
		sum2 += norm(m_cplxVector[i]);
	stringstream ss;
	ss << setprecision(15) << sum2; // output the rounded number on the stream
	ss >> sum2; // put the rounded value back to the number
	return (sum2  == 1.0);
}

double qubit_vector::measure(unsigned int p_uintQubitNumber)
{
	double dbProbabilityEq1 = 0;
	unsigned int p_uintShiftedNumber = 1 << p_uintQubitNumber;
	for(int i=0; i < pow(2, m_intDimension); i++)
		if(i & p_uintShiftedNumber)
			dbProbabilityEq1 += norm(m_cplxVector[i]);

	unsigned int uintMeasurement = ((double)rand() / RAND_MAX) < dbProbabilityEq1 ? 1 : 0;

	double dbProbabilitySum = 0;
	for(int i=0; i < pow(2, m_intDimension); i++)
	{
		if(bool(i & p_uintShiftedNumber) != uintMeasurement)
			m_cplxVector[i] = 0;
		dbProbabilitySum += norm(m_cplxVector[i]);
	}

	for(int i=0; i < pow(2, m_intDimension); i++)
		m_cplxVector[i] /= sqrt(dbProbabilitySum);

	return uintMeasurement;
}
