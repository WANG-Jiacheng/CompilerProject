#include <stdio.h>
#include <string.h>

int calculate(char * s){
    int n = strlen(s);
    if (n == 1){    //只有一个直接返回
        return s[0] - '0';
    }

    long numsStack[n / 2 + 1];  //装数字用的
    char signStack[n / 2];  //装加减乘除用的
    int nums_top = -1;
    int sign_top = -1;

    int i = 0;
    while (i < n){
        if (s[i] == ' '){   //空字符什么都不在
            i++;

        } else if (s[i] == '+' || s[i] == '-' || s[i] == '*' || s[i] == '/'){   
            //遇到加减乘除直接进栈
            signStack[++sign_top] = s[i];
            i++;
        } else {    //遇到数字
            long nums = 0;
            //下面的while用来检测数字
            while (i < n && s[i] >= '0' && s[i] <= '9'){
                nums = nums * 10 + s[i] - '0';
                i++;
            }
            //如果装符号的栈顶为乘除 取出装数字栈栈顶的数字和当前数字运算
            if (sign_top >= 0 && (signStack[sign_top] == '*' || signStack[sign_top] == '/')){
                long n = numsStack[nums_top--];
                if (signStack[sign_top] == '*')
                    nums = n * nums;
                else
                    nums = n / nums;

                sign_top--;
            }
            //将运算后的数字压入栈中
            numsStack[++nums_top] = nums;
        }
    }

    int ret;
    int pos = 0;
    i = 0;
    //从前到后依次运算
    while (i <= sign_top){
        int ret = numsStack[pos++];

        if (signStack[i] == '+')
            numsStack[pos] += ret;
        else
            numsStack[pos] = ret - numsStack[pos];
        
        i++;
    }

    return numsStack[pos];
}

int main() {
    char s[100] = {'\0'};
    scanf("%s", s);
    printf("%d\n", calculate(s));
}