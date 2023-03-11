#include "mpi.h"
#include <math.h>
#include <stdio.h>

int TAG = 1;

int power(int base, int exponent) {
    if (exponent == 0) {
        return 1;
    }
    int result = 1;
    for (int i=0; i<exponent; i++) {
        result = result * base;
    }
    return result;
}

void broadcast(int* data, int root, MPI_Comm comm) {
    int n, myid, numprocs;
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);

    int d = 3;
    int mask = power(2, d) - 1;
    for (int i=d-1; i >= 0; i--) {
        mask = mask ^ power(2, i);
        if ((myid & mask) == 0) {
            if ((myid & power(2, i)) == 0) {
                int dest = myid ^ power(2, i);
                // send()
                printf("id: %d, sending to %d\n", myid, dest);
                MPI_Send(data, 1, MPI_INT, dest, TAG, comm);
            } else {
                int source = myid ^ power(2, i);
                printf("id: %d, recv from %d\n", myid, source);
                MPI_Recv(data, 1, MPI_INT, source, TAG, comm, MPI_STATUS_IGNORE);
            }
        }
    }
}

void reduce(double* data, double* acc, int root, MPI_Comm comm) {
    int n, myid, numprocs;
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);

    double sum = *data;
    int mask = 0;
    int d = 3;
    for (int i=0; i<d; i++) {
        if ((myid & mask) == 0) {
            if ((myid & power(2, i)) != 0) {
                int dest = myid ^ power(2, i);
                //send()
                MPI_Send(&sum, 1, MPI_DOUBLE, dest, TAG, comm);
            } else {
                int source = myid ^ power(2, i);
                // recv()
                int recved = 0;
                MPI_Recv(&recved, 1, MPI_DOUBLE, source, TAG, comm, MPI_STATUS_IGNORE);
                sum = sum + recved;
            }
        }
        mask = mask ^ power(2, i);
    }
}

int main(argc, argv)
int argc;
char *argv[];
{
    int done = 0, n, myid, numprocs, i, rc;
    double PI25DT = 3.141592653589793238462643;
    double mypi, pi, h, sum, x, a;
    MPI_Init(&argc, &argv);
    MPI_Comm_size(MPI_COMM_WORLD, &numprocs);
    MPI_Comm_rank(MPI_COMM_WORLD, &myid);
    /* parallelization of pi= (1/n)* S i=1n 4/(1 +( (i-0.5)/n)2), where n is the accuracy term. */

    n = 10;

    if (myid == 0) {
        printf("numprocs: %d\n", numprocs);
    } else {
        n = 0;
    }
    printf("My id is: %d\n", myid);

    printf("Before broadcast id: %d | n: %d\n", myid, n);
    // MPI_Bcast(&n, 1, MPI_INT, 0, MPI_COMM_WORLD);
    broadcast(&n, 0, MPI_COMM_WORLD);
    printf("After broadcast id: %d | n: %d\n", myid, n);

    h = 1.0 / (double)n;
    sum = 0.0;
    for (i = myid + 1; i <= n; i += numprocs)
    {
        x = h * ((double)i - 0.5);
        sum += 4.0 / (1.0 + x * x);
    }
    mypi = h * sum;
    // MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    reduce(&mypi, &pi, 0, MPI_COMM_WORLD);
    if (myid == 0)
        printf("PI4 is approximately %.16f, Error is %.16f\n", pi, fabs(pi - PI25DT));
    MPI_Finalize();
}

