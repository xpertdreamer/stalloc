#include <stdio.h>

extern void* stalloc(int size);

int main(void) {
  int *a;
  a = (int*)stalloc(sizeof(int));
  if (a == NULL) {
    printf("ERROR");
    return 1;
  }
  *a = 42;
  printf("value:   \t%d\n", *a);
  printf("address: \t%p", (void*)a);
  return 0;
}
