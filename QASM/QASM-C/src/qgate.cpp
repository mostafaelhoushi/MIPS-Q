/*
* qgate.cpp
*
*  Created on: Dec 17, 2010
*      Author: melhoush
*/

#include "qgate.h"

qgate::qgate(const complex<double>** p_cplxMatrix, int p_intDimension)
: m_intDimension(p_intDimension)
{
	m_cplxMatrix = new complex<double>* [m_intDimension];
	for(int i=0; i<m_intDimension; i++)
	{
		m_cplxMatrix[i] = new complex<double> [m_intDimension];
		for(int j=0; j<m_intDimension; j++)
			m_cplxMatrix[i][j] = p_cplxMatrix[i][j];
	}
};

qgate::qgate(const complex<double>* p_cplxMatrix, int p_intDimension)
: m_intDimension(p_intDimension)
{
	m_cplxMatrix = new complex<double>* [m_intDimension];
	for(int i=0; i<m_intDimension; i++)
	{
		m_cplxMatrix[i] = new complex<double> [m_intDimension];
		for(int j=0; j<m_intDimension; j++)
			m_cplxMatrix[i][j] = p_cplxMatrix[i*m_intDimension + j];
	}
};

qgate::qgate(int p_intDimension)
: m_intDimension(p_intDimension)
{
	m_cplxMatrix = new complex<double>* [m_intDimension];
	for(int i=0; i<m_intDimension; i++)
		m_cplxMatrix[i] = new complex<double> [m_intDimension];
};

qubit qgate::operator * (qubit q)
{
	complex<double> cplxAlpha = m_cplxMatrix[0][0]*q.alpha() + m_cplxMatrix[0][1]*q.beta();
	complex<double> cplxBeta = m_cplxMatrix[1][0]*q.alpha() + m_cplxMatrix[1][1]*q.beta();

	return qubit(cplxAlpha, cplxBeta);
};

qubit_vector qgate::operator * (qubit_vector q)
{
	qubit_vector p(q.dimension());

	for(int i=0; i<m_intDimension; i++)
	{
		p[i] = 0;
		for(int j=0; j<m_intDimension; j++)
			p[i] += m_cplxMatrix[i][j]*q[j];
	}
	return p;
};

qgate qgate::operator * (qgate g)
{
	if(g.dimension() != m_intDimension)
		throw non_equal_dimension_exception;

	qgate g1(m_intDimension);

	for(int i=0; i<m_intDimension; i++)
		for(int j=0; j<m_intDimension; j++)
		{
			g1[i][j]=0;
			for(int k=0; k<m_intDimension; k++)
				g1[i][j] += m_cplxMatrix[i][k] * g[k][j];
		}
	return g1;
};

qgate qgate::tensor(qgate A, qgate B)
{
	qgate C(A.dimension() * B.dimension());
	for(int i1=0; i1<A.dimension(); i1++)
		for(int j1=0; j1<A.dimension(); j1++)
			for(int i2=0; i2<B.dimension(); i2++)
				for(int j2=0; j2<B.dimension(); j2++)
					C[i1*B.dimension()+i2][j1*B.dimension() + j2] = A[i1][j1]*B[i2][j2];

	return C;
}

qgate qgate::getConjugate()
{
	qgate qgtConjugate(m_intDimension);

	for(int i=0; i<m_intDimension; i++)
		for(int j=0; j<m_intDimension; j++)
			qgtConjugate[i][j] = conj(m_cplxMatrix[j][i]);

	return qgtConjugate;
}

bool qgate::isValid()
{
	return true;
}

qgate qgate::getInverse()
{
	if(!isValid())
		throw non_unitary_exception;
	else
		return getConjugate();
}

qgate qgate::rotate(const complex<double>** p_cplxMatrix, unsigned int p_intDimension)
{
	qgate R(p_cplxMatrix, p_intDimension);
	return R * (*this) * R.getConjugate();
}

qgate qgate::rotate(const complex<double>* p_cplxMatrix, unsigned int p_intDimension)
{
	qgate R(p_cplxMatrix, p_intDimension);
	return R * (*this) * R.getConjugate();
}
