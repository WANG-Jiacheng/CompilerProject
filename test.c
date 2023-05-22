#include <stdio.h>

int do_math(int a) {
    int x = 1;
    if(x > a) {
        printf("a");
    }
    else {
        printf("b");
    }
    return x + 2 + a;
}

int main(){
    printf("%d", do_math(3));
}