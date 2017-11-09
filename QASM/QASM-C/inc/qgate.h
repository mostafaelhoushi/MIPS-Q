/*
 * qgate.h
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#ifndef QGATE_H_
#define QGATE_H_

#include "qubit_vector.h"
#include "qubit.h"

class qgate_exception: public exception
{
public:
	virtual const char* what() const throw()
	{
		return "quantum gate not unitary.";
	}
};

class qgate_multiply_exception: public exception
{
public:
	virtual const char* what() const throw()
	{
		return "gates with non-equal dimensions are multiplied.";
	}
};


class qgate
{
public:
	qgate(const complex<double>** p_cplxMatrix, int p_intDimension=2);
	qgate(const complex<double>* p_cplxMatrix, int p_intDimension=2);
	qgate(int p_intDimension=2);

	qubit operator * (qubit q);

	qubit_vector operator * (qubit_vector q);

	qgate operator * (qgate g);

	complex<double>& operator() (int i){return m_cplxMatrix[i/m_intDimension][i%m_intDimension];};
	complex<double>*& operator[] (int i){return m_cplxMatrix[i];};
	complex<double>& operator() (int i, int j){return m_cplxMatrix[i][j];};

	static qgate tensor(qgate A, qgate B);

	int dimension() const {return m_intDimension;}

	int numberOfElements() const {return m_intDimension*m_intDimension;};

	friend ostream& operator << (ostream& s, qgate A)
	{
		s << "{";
		for(int i=0; i<A.dimension(); i++)
		{
			s << "{";
			for(int j=0; j<A.dimension(); j++)
				s << A(i,j) << "\t";
			s << "}" << endl;
		}
		s << "}";
		return s;
	};

	qgate getConjugate();

	bool isValid();

	qgate getInverse();

	qgate rotate(const complex<double>** p_cplxMatrix, unsigned int p_intDimension);

	qgate rotate(const complex<double>* p_cplxMatrix, unsigned int p_intDimension);

protected:
	qgate_exception non_unitary_exception;
	qgate_multiply_exception non_equal_dimension_exception;

	int m_intDimension;
	complex<double>** m_cplxMatrix;
};


#endif /* QGATE_H_ */
