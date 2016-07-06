#if !defined(__INTEL_COMPILER)
#error Not Intel
#endif

#include <iostream>

int main(int argc, char *argv[]) {
  std::cout << "Success" << std::endl;
  return 0;
}
