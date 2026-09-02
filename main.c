#include <stdio.h>
#include <assert.h>

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
  // b = (int*)stalloc(0);
  if (b == NULL) {
      printf("ERROR");
      return 1;
  }
  *b = 38;
  /* printf("a value:   \t%d\n", *a); */
  /* printf("a address: \t%p\n", (void *)a); */
  /* printf("b value:   \t%d\n", *b); */
  /* printf("b address: \t%p", (void*)b); */
  TRACE(a);
  TRACE(b);
  return 0;
}
