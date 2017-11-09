#define qasm(string)	{asm(string); asm("nop"); asm("nop"); asm("nop"); asm("nop");}	
#define QUBIT(val, num)	qasm("q " #val ", " #num);
#define X(q)		qasm("X " #q);
#define Z(q)		qasm("Z " #q);
#define Y(q)		qasm("Y " #q);
#define H(q)		qasm("H " #q);
#define Rk(param,q)		qasm("Rk " #param ", " #q);
#define CNOT(q1,q2)	qasm("CNOT " #q1 ", " #q2);
#define CRk(param,q1,q2)	qasm("CRk " #param ", " #q1 ", " #q2);
#define SWAP(q1,q2)	qasm("SWAP " #q1 ", " #q2);
#define MEASURE(q)	qasm("MEASURE " #q);
#define GETQMEASURE(a)	asm("lqmeas %0" : "=r" (a) :);

#define negI(q) X(q); Z(q); X(q); Z(q);

#define TOFFOLI(q0, q1, q2)	\
	CRk(1,q2,q1);		\
	H(q2);			\
	Rk(-3,q2);			\
	CNOT(q2,q0);		\
	Rk(3,q2);			\
	CNOT(q2,q1);		\
	Rk(-3,q2);			\
	CNOT(q2,q0);		\
	Rk(3,q2);			\
	H(q2);			\
	CRk(2,q1,q0);

