#include <stdio.h>
#include <math.h>
#include <mkl.h>

int main(int argc, char *argv[]) {

    const int n = 10;
    const double a = 10.0;
    double x[n], y[n];

    for (int i=0; i<n; i++) x[i] = (double)i;
    for (int i=0; i<n; i++) y[i] = 0.0;

    cblas_daxpy(n, a, x, 1, y, 1);

    double error = 0.0;
    for (int i=0; i<n; i++) {
        error += (y[i] - a*i);
    }
    if (fabs(error) > 1.e-13) {
        for (int i=0; i<n; i++) {
            printf("%d,%lf\n", i, y[i]);
        }
    } else {
        printf("Success\n");
    }

    return 0;
}
