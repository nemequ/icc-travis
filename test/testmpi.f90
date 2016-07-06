program main

  use mpi

  implicit none

  integer :: ierr
  integer, parameter :: requested = MPI_THREAD_MULTIPLE
  integer :: provided
  integer :: me, np, s

  call mpi_init_thread(requested, provided, ierr)
  if (requested .lt. provided) call mpi_abort(MPI_COMM_WORLD, 1, ierr)

  call mpi_comm_rank(MPI_COMM_WORLD, me, ierr)
  call mpi_comm_size(MPI_COMM_WORLD, np, ierr)

  s = 0
  call mpi_allreduce(me, s, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD, ierr)
  if (s .ne. (np*(np-1)/2) ) call mpi_abort(MPI_COMM_WORLD,2, ierr)

  if (me.eq.0) write(6,'(a8)') 'Success'

  call mpi_Finalize(ierr)

end program main
