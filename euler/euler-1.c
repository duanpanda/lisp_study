#include <stdio.h>

/* Find the sum of all the multiples of 3 or 5 below N. */
int p1_sum (int n)
{
  int sum = 0;
  int i;
  for (i = 1; i < n; ++i) {
    if ((i % 3 == 0) || (i % 5 == 0))
      sum += i;
  }
  return sum;
}

int main()
{
  int n;
  printf("Please input a positive number: ");
  scanf("%d", &n);
  printf("%d\n", p1_sum(n));
  return 0;
}
