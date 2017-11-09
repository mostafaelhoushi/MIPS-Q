class Adder
{
public:
	Adder(int a, int b): x(a), y(b) {}
	
	int add() {return (x+y); }


protected:
	int x, y;

};

int main()
{
	int u = 20, v = 40, w;
	Adder adder(u,v);
	w = adder.add();
	return 0;
}
