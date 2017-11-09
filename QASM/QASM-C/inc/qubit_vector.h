/*
 * qubit_vector.h
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#ifndef QUBIT_VECTOR_H_
#define QUBIT_VECTOR_H_

#include "misc.h"

class qubit_exception: public exception
{
public:
	virtual const char* what() const throw()
	{
		return "quantum bit not normalized.";
	}
};

class qubit_vector
{
public:
	qubit_vector(complex<double> p_cplxVector[], int p_intDimension);
	qubit_vector(complex<double> p_cplxVector[]);
	qubit_vector(int p_intDimension);

	bool operator == (qubit_vector q) const;

	int length() const {return pow((double)2,(int)m_intDimension);};
	int dimension() const {return m_intDimension;}

	complex<double>& operator[] (int n){return m_cplxVector[n];};

	static qubit_vector tensor(qubit_vector q, qubit_vector p);

	friend ostream& operator << (ostream& s, qubit_vector q)
	{
		s << "[";
		for(int i=0; i<q.length(); i++)
		{
			s << q[i] << " ";
		}
		s << "]";
		return s;
	};

	bool isValid();

	double measure(unsigned int p_uintQubitNumber);

protected:
	qubit_exception non_normalized_exception;

	int m_intDimension;
	complex<double>* m_cplxVector;
};


#endif /* QUBIT_VECTOR_H_ */
