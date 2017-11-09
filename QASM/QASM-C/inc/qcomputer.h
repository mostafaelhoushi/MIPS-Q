/*
 * qcomputer.h
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#ifndef QCOMPUTER_H_
#define QCOMPUTER_H_

#include "qgate.h"
#include "qubit_register.h"

class qcomputer
{
public:
	qcomputer(int p_intNoOfQubits = 8);

	enum qinstruction
	{
		X, Z, Y, I, S, T, H, MEASURE, CS,CZ, CT, CNOT, SWAP, TOFFOLI, FREDKIN
	};

	int getMeasuredQubit(unsigned int p_uintQubit);
	void exec(qinstruction p_enumQInstruction, int p_intQubit);
	void exec(qgate p_qgate, int p_intQubit);
	void exec(qinstruction p_enumQInstruction, int p_intQubit1, int p_intQubit2);
	void exec(qgate p_qgate, int p_intQubit1, int p_intQubit2);
	void exec(int p_intQubit1, int p_intQubit2, int p_intQubit3, qinstruction p_enumQInstruction);

	qubit_register memory() {return qregister;}

protected:
	const int m_intNoOfQubits;
	qubit_register qregister;

	qgate X_gate,Z_gate,Y_gate,I_gate, H_gate, S_gate, T_gate;
	qgate CZ_gate, CS_gate, CT_gate, CNOT_gate, SWAP_gate;
	qgate TOFFOLI_gate, FREDKIN_gate;
	int* m_pintMeasuredResults;

	static const complex<double>  I_matrix[2][2], X_matrix[2][2], Y_matrix[2][2], Z_matrix[2][2], H_matrix[2][2], S_matrix[2][2], T_matrix[2][2];
	static const complex<double> CNOT_matrix[4][4], SWAP_matrix[4][4], CZ_matrix[4][4], CS_matrix[4][4], CT_matrix[4][4];
	static const complex<double> TOFFOLI_matrix[8][8], FREDKIN_matrix[8][8];
};


#endif /* QCOMPUTER_H_ */
