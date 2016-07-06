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

    MPI_Comm nodecomm = MPI_COMM_NULL;
    MPI_Comm_split_type(MPI_COMM_WORLD, MPI_COMM_TYPE_SHARED, 0, MPI_INFO_NULL, &nodecomm);

    int bytes = 1024;
    MPI_Win nodewin = MPI_WIN_NULL;
    void * nodeptr = NULL;
    MPI_Win_allocate_shared((MPI_Aint)bytes, 1, MPI_INFO_NULL, nodecomm, &nodeptr, &nodewin);

    int noderank;
    MPI_Comm_rank(nodecomm, &noderank);
    if (noderank==0) memset(nodeptr,1,(size_t)bytes);

    MPI_Win_free(&nodewin);
    MPI_Comm_free(&nodecomm);

    if (rank==0) printf("Success\n");

    MPI_Finalize();
    return 0;
}
