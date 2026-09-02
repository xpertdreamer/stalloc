#include <stdio.h>

#define TRACE(var)                                                      \
    do {                                                                \
        printf("%s\t%d\t%p\n", #var, *var, (void*)var);                 \
} while (0);

extern void* stalloc(int size);

int main(void) {
  int *a;
  a = (int*)stalloc(sizeof(int));
  if (a == NULL) {
    printf("ERROR");
    return 1;
  }
  *a = 42;
  int *b;
  b = (int*)stalloc(sizeof(int));
  // b = (int*)stalloc(0); // used to debug
  if (b == NULL) {
      printf("ERROR");
      return 1;
  }
  *b = 38;

  TRACE(a);
  TRACE(b);
  return 0;
}
