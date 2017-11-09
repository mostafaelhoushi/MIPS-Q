/*
 * qubit_register.h
 *
 *  Created on: Dec 17, 2010
 *      Author: melhoush
 */

#ifndef QUBIT_REGISTER_H_
#define QUBIT_REGISTER_H_

#include "qubit_vector.h"

class qubit_register : public qubit_vector
{
public:
	qubit_register(int p_intDimension):  qubit_vector(p_intDimension) {}

	qubit_register(qubit_vector q): qubit_vector(q) {}

	friend ostream& operator << (ostream& s, qubit_register q)
	{
		s << "[";
		for(int i=0; i<q.length(); i++)
		{
			s << convert_binary(i,q.dimension()) << ":\t" << q[i] << endl;
		}
		s << "]";
		return s;
	};

protected:
};

#endif /* QUBIT_REGISTER_H_ */
