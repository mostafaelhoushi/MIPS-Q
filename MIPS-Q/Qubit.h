class Qubit
{
public:
	Qubit(int p_intValue = 0);

	void X();
	void Z();
	void Y();
	void H();
	void Rk(int param);
	void CNOT(Qubit q2);
	void CRk(int param, Qubit q2);

	void Toffoli(Qubit q0, Qubit q1);
	void negI();

	int GetNumber();
	int Measure();

protected:
	int number;
	static int count;
};
