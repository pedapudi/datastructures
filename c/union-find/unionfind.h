#include <stdlib.h>

enum {MAX_NUMBER_OF_NODES = 1024};

typedef struct disjointSetNode {
  int id;
  int rank;
  void * payload;
} dsNode;

dsNode *dsUnion(dsNode *operand1, dsNode *operand2);
dsNode *dsFind(dsNode *child);
