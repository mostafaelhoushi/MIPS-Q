#include <math.h>

#define MAX_NUMBER_OF_ITERATIONS 10

int gcd(int a, int b)
{
	int t;	
	while( b != 0)
	{
		t = b;
		b = a % b;
		a = t;
	}
	return a
}

int fact_shor(int N)
{
	int a, d, r, x;
	
	// Check that N is not even
	if (N & 1 == 0)
		return 2;
		
	// Check that N is not a prime power
	
	// Repeat several times until solution is found
	for (int i=0; i<MAX_NUMBER_OF_ITERATIONS)
	{
		// Randomly choose a element of {2, ..., N-1}
		a = rand(N);
		
		// Compute d = gcd(a,N)
		d = gcd(a, N);
		if( d >= 2) // We've been incredibly lucky
			return d;
		else // Now we know a element of ZN
		{
			// Requires the order finding algorithm
			r = order_find(a, N);
			if(r & 1 == 0) // if r is even
			{
				x = (pow(a, r/2) - 1)%N;
				d = gcd(x,N);
				if (d >= 2) // Answer is found
					return d;
			}
		}
	}
}
