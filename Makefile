all: par_pi_jason par_pi_simple_jason

par_pi_jason: 
	mpicc par_pi_jason.c -o par_pi_jason

par_pi_simple_jason: 
	mpicc par_pi_simple_jason.c -o par_pi_simple_jason

clean:
	rm par_pi_jason
	rm par_pi_simple_jason