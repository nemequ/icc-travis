program main

  use mpi_f08

  implicit none

  integer, parameter :: requested = MPI_THREAD_MULTIPLE
  integer :: provided
  integer :: me, np, s

  call MPI_Init_thread(requested, provided)
  if (requested .lt. provided) call MPI_Abort(MPI_COMM_WORLD, 1)

  call MPI_Comm_rank(MPI_COMM_WORLD, me)
  call MPI_Comm_size(MPI_COMM_WORLD, np)

  s = 0
  call MPI_Allreduce(me, s, 1, MPI_INT, MPI_SUM, MPI_COMM_WORLD)
  if (s .ne. (np*(np-1)/2) ) call MPI_Abort(MPI_COMM_WORLD,2)

  if (me.eq.0) write(6,'(a8)') 'Success'

  call MPI_Finalize()

end program main
