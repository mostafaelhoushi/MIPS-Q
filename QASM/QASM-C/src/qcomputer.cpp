/*
* qcomputer.cpp
*
*  Created on: Dec 17, 2010
*      Author: melhoush
*/

#include "qcomputer.h"

const complex<double> qcomputer::I_matrix[2][2]={		{1,		0},
													{0,		1}};
const complex<double> qcomputer::X_matrix[2][2]={		{0,		1},
													{1,		0}};
const complex<double> qcomputer::Y_matrix[2][2]={		{0,						1},
													{complex<double>(0,-1),	0}};
const complex<double> qcomputer::Z_matrix[2][2]={		{1,		0},
													{0,		-1}};
const complex<double> qcomputer::H_matrix[2][2]={		{1/sqrt(2),		1/sqrt(2)},
													{1/sqrt(2),		-1/sqrt(2)}};
const complex<double> qcomputer::S_matrix[2][2]={		{1,		0},
													{0,		complex<double>(0,1)}};
const complex<double> qcomputer::T_matrix[2][2]={		{1,		0},
													{0,		complex<double>(sqrt(2),sqrt(2))}};
const complex<double> qcomputer::CNOT_matrix[4][4]={	{1,	0,	0,	0},
													{0,	1,	0,	0},
													{0,	0,	0,	1},
													{0,	0,	1,	0}};
const complex<double> qcomputer::SWAP_matrix[4][4]={	{1,	0,	0,	0},
													{0,	0,	1,	0},
													{0,	1,	0,	0},
													{0,	0,	0,	1}};
const complex<double> qcomputer::CZ_matrix[4][4]={		{1,	0,	0,	0},
													{0,	1,	0,	0},
													{0,	0,	1,	0},
													{0,	0,	0,	-1}};
const complex<double> qcomputer::CS_matrix[4][4]={		{1,	0,	0,	0},
													{0,	1,	0,	0},
													{0,	0,	1,	0},
													{0,	0,	0,	complex<double>(0,1)}};
const complex<double> qcomputer::CT_matrix[4][4]={		{1,	0,	0,	0},
													{0,	1,	0,	0},
													{0,	0,	1,	0},
													{0,	0,	0,	complex<double>(sqrt(2),sqrt(2))}};
const complex<double> qcomputer::TOFFOLI_matrix[8][8]={	{1,	0,	0,	0,	0,	0,	0,	0},
													{0,	1,	0,	0,	0,	0,	0,	0},
													{0,	0,	1,	0,	0,	0,	0,	0},
													{0,	0,	0,	1,	0,	0,	0,	0},
													{0,	0,	0,	0,	1,	0,	0,	0},
													{0,	0,	0,	0,	0,	1,	0,	0},
													{0,	0,	0,	0,	0,	0,	0,	1},
													{0,	0,	0,	0,	0,	0,	1,	0}};
const complex<double> qcomputer::FREDKIN_matrix[8][8]={	{1,	0,	0,	0,	0,	0,	0,	0},
													{0,	1,	0,	0,	0,	0,	0,	0},
													{0,	0,	1,	0,	0,	0,	0,	0},
													{0,	0,	0,	1,	0,	0,	0,	0},
													{0,	0,	0,	0,	1,	0,	0,	0},
													{0,	0,	0,	0,	0,	0,	1,	0},
													{0,	0,	0,	0,	0,	1,	0,	0},
													{0,	0,	0,	0,	0,	0,	0,	1}};

qcomputer::qcomputer(int p_intNoOfQubits)
: m_intNoOfQubits(p_intNoOfQubits)
, qregister(p_intNoOfQubits)
, I_gate(*I_matrix, 2)
, X_gate(*X_matrix, 2)
, Y_gate(*Y_matrix, 2)
, Z_gate(*Z_matrix, 2)
, H_gate(*H_matrix, 2)
, S_gate(*S_matrix, 2)
, T_gate(*T_matrix, 2)
, CZ_gate(*CZ_matrix, 4)
, CS_gate(*CS_matrix, 4)
, CT_gate(*CT_matrix, 4)
, CNOT_gate(*CNOT_matrix, 4)
, SWAP_gate(*SWAP_matrix, 4)
, TOFFOLI_gate(*TOFFOLI_matrix, 8)
, FREDKIN_gate(*FREDKIN_matrix, 8)
{
	srand ( time(NULL) );

	m_pintMeasuredResults = new int[p_intNoOfQubits];
	for(int i= 0; i < p_intNoOfQubits; i++)
		m_pintMeasuredResults[i] = -1;
};

int qcomputer::getMeasuredQubit(unsigned int p_uintQubit)
{
	return m_pintMeasuredResults[p_uintQubit];
}

void qcomputer::exec(qinstruction p_enumQInstruction, int p_intQubit)
{
	qgate* pgate;
	switch(p_enumQInstruction)
	{
	 case X:
		pgate = &X_gate;
		break;

	case Z:
		pgate = &Z_gate;
		break;

	case Y:
		pgate = &Y_gate;
		break;

	case I:
		pgate = &I_gate;
		break;

	case H:
		pgate = &H_gate;
		break;

	case S:
		pgate = &S_gate;
		break;

	case T:
		pgate = &T_gate;
		break;

	case MEASURE:
		m_pintMeasuredResults[p_intQubit] = qregister.measure(p_intQubit);
		return;

	default:
		// throw exception
		return;
	}

	exec(*pgate, p_intQubit);
}

void qcomputer::exec(qgate p_qgate, int p_intQubit)
{

	complex<double> trivial_matrix[1][1] = {{1}};
	qgate gResult(*trivial_matrix, 1);
	for(int i=0; i<m_intNoOfQubits; i++)
		gResult = qgate::tensor(i== p_intQubit? p_qgate : I_gate, gResult);

	qregister = gResult*qregister;
}

void qcomputer::exec(qinstruction p_enumQInstruction, int p_intQubit1, int p_intQubit2)
{
	qgate* pgate;
	switch(p_enumQInstruction)
	{
	case CZ:
		pgate = &CZ_gate;
		break;

	case CS:
		pgate = &CS_gate;
		break;

	case CT:
		pgate = &CT_gate;
		break;

	case CNOT:
		// 1st bit control & 2nd bit target
		pgate = &CNOT_gate;
		break;

	case SWAP:
		pgate = &SWAP_gate;
		break;

	default:
		// throw exception
		break;
	}

	exec(*pgate, p_intQubit1, p_intQubit2);
}

void qcomputer::exec(qgate p_qgate, int p_intQubit1, int p_intQubit2)
{
	complex<double> trivial_matrix[1][1] = {{1}};
	qgate gResult1(*trivial_matrix, 1);
	qgate gResult2 = p_qgate;
	qgate gResult3(*trivial_matrix, 1);


	for(int i=0; i<min(p_intQubit1, p_intQubit2); i++)
		gResult1 = qgate::tensor(gResult1, I_gate);

	cout << "gResult1: " << endl << gResult1 << endl;

	if(p_intQubit2 > p_intQubit1)
		gResult2 = gResult2.rotate(*SWAP_matrix, 4);

	for(int i=min(p_intQubit2, p_intQubit1)+1; i <max(p_intQubit2, p_intQubit1); i++)
		gResult2 =qgate::tensor(I_gate, gResult2);

	cout << "gResult2 before rotation: " << endl << gResult2 << endl;

	if(abs((double)(p_intQubit1 - p_intQubit2)) != 1)
	{
		unsigned int uintRotationDimension = pow(2, abs((double)(p_intQubit2 - p_intQubit1))  +1);
		complex <double>** mtrxRotation = new complex <double>*[uintRotationDimension];
		for(int i=0; i < uintRotationDimension; i++)
		{
			mtrxRotation[i] = new complex <double>[uintRotationDimension];
			unsigned int uintTrueIndex = swap_bits(i, 1,  abs((double)(p_intQubit1 - p_intQubit2)));
			cout << "i: " << i << " uintTrueIndex: " << uintTrueIndex << endl;
			for(int j=0; j < uintRotationDimension; j++)
				mtrxRotation[i][j] = (j == uintTrueIndex) ? 1 : 0;
		}
		gResult2 = gResult2.rotate((const complex <double>**)mtrxRotation, uintRotationDimension);

		qgate rot((const complex <double>**)mtrxRotation, uintRotationDimension);
		cout << "rot: " << rot << endl;
	}


	cout << "gResult2 after rotation: " << endl << gResult2 << endl;

	for(int i=max(p_intQubit1, p_intQubit2)+1; i<m_intNoOfQubits; i++)
		gResult3 = qgate::tensor(gResult3, I_gate);

	cout << "gResult3: " << endl << gResult3 << endl;

	qgate gResult(qgate::tensor(qgate::tensor(gResult3, gResult2), gResult1));

	qregister = gResult*qregister;
}

void qcomputer::exec(int p_intQubit1, int p_intQubit2, int p_intQubit3, qinstruction p_enumQInstruction)
{

}



