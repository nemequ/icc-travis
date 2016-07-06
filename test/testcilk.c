#include <stdio.h>
#include <cilk/cilk.h>

int main(int argc, char *argv[]) {
  cilk_sync;
  return 0;
}
