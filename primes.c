#include <stdio.h>
#include <stdlib.h>

int main(char *argv[]) {
    int bound = atoi(argv[1]);
    int isPrime;
    for (int i = 2; i <= bound; i++) {
        isPrime = 1;
        for (int j = 2; j*j < i; j++) {
            if (i%j == 0) {
                isPrime = 0;
            }
        }
        if (isPrime) {
            printf("%d,", i);
        }
    }
    printf("\n");

    return 0;
}