#if !defined(__INTEL_COMPILER)
#error Not Intel
#endif

#include <iostream>
#include <atomic>

std::atomic<int> counter{0};

int main(int argc, char *argv[])
{
    const int n = 10000;

    for (auto i=0; i<n; ++i) ++counter;

    if (counter == n) {
        std::cout << "Success" << std::endl;
        return 0;
    } else {
        std::cout << "Failure" << std::endl;
        return 1;
    }
}
