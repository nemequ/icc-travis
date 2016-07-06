#if !defined(__INTEL_COMPILER)
#error Not Intel
#endif

program main
  implicit none
  write(6,'(a8)') 'Success'
end program main
