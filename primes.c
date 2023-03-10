#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        printf("ERROR: INVALID NUMBER OF ARGS");
        exit(1);
    }

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
