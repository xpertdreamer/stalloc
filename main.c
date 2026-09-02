#include <stdio.h>

#define TRACE(var)                                              \
do {                                                            \
    printf("%s\t%d\t%p\n", #var, *var, (void *)var);            \
} while (0);

#define ADIFF(l, r)                                                     \
do {                                                                    \
   printf("diff %s:%s %d bytes\n", #l, #r, (int)((void*)r - (void*)l)); \
} while (0);

extern void* stalloc(int size);

int main(void) {
  int *a;
  a = (int*)stalloc(sizeof(int));
  if (a == NULL) {
    printf("ERROR: a is NULL");
    return 1;
  }
  *a = 42;
  int *b;
  b = (int*)stalloc(sizeof(int));
  // b = (int*)stalloc(0); // used to debug
  if (b == NULL) {
      printf("ERROR: b is NULL");
      return 1;
  }
  *b = 38;

  TRACE(a);
  TRACE(b);
  ADIFF(a, b);
  return 0;
}
