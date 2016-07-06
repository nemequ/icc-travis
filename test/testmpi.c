#include <stdio.h>
#include <mpi.h>

int main(int argc, char *argv[])
{
    int requested=MPI_THREAD_MULTIPLE, provided;
    MPI_Init_thread(&argc, &argv, requested, &provided);
    if (requested<provided) MPI_Abort(MPI_COMM_WORLD, 1);

    int rank, size;
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    int sum = 0;
    MPI_Allreduce(&rank, &sum, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD);
    if (sum != (size*(size-1)/2) ) MPI_Abort(MPI_COMM_WORLD,2);

    if (rank==0) printf("Success\n");

    MPI_Finalize();
    return 0;
}
