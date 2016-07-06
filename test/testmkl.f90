program main
  use mkl_service
  implicit none
  call mkl_set_num_threads(2)
  write(6,'(a8)') 'Success'
end program main
