#include <iostream>
#include <daal.h>

int main(int argc, char* argv[])
{
    int nt = daal::services::Environment::getInstance()->getNumberOfThreads();
    std::cout << "DAAL using " << nt << " threads" << std::endl;
    return 0;
}
