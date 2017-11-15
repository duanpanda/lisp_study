#include <stdio.h>

int main()
{
    int i;
    for (i = 0; i < 10; i++)
        fwrite(&i, 1, 1, stdout);
    return 0;
}
