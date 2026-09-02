#include <stdio.h>
#include <stdint.h>

#define HEADERSIZE 0x18
#define HEADER_FLAG 0x00
#define HEADER_SIZE 0x08
#define HEADER_NEXT 0x10

#define TRACE(var)                                              \
do {                                                            \
    printf("%s\t%d\t%p\n", #var, *var, (void *)var);            \
} while (0);

#define ADIFF(l, r)                                                     \
do {                                                                    \
   printf("diff %s:%s %d bytes\n", #l, #r, (int)((void*)r - (void*)l)); \
} while (0);

#define VALHEAD(var)                                        \
    do {                                                    \
        uint8_t *header = (uint8_t *)(var) - HEADERSIZE;    \
        printf("header\tflag=%lu\tsize=%lu\tnext=%p\n",     \
               *(uint64_t*)(header + HEADER_FLAG),          \
               *(uint64_t*)(header + HEADER_SIZE),          \
               (void*)*(uint64_t*)(header + HEADER_NEXT));  \
} while(0);

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
  VALHEAD(a);
  VALHEAD(b);
  return 0;
}
