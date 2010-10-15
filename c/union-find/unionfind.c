#include <stdio.h>
#include "unionfind.h"


dsNode * parentsArray[MAX_NUMBER_OF_NODES];
int id = MAX_NUMBER_OF_NODES;

int addNode(void * payload){
  if(id<=0){
    fprintf(stderr, "exceeded max number of nodes");
    exit(1);
  }
  
  dsNode * node = (dsNode *)malloc(sizeof(dsNode));
  node->id = --id;
  node->rank = 1;
  node->payload = payload;
  parentsArray[node->id] = node;
  return id;
}

dsNode * dsFind(dsNode *operand){
  parentsArray[operand->id] = 
    ((parentsArray[operand->id] == operand) ?
     parentsArray[operand->id] :
     dsFind(parentsArray[operand->id]));
  return parentsArray[operand->id];
}

dsNode * dsUnion(dsNode *operand1, dsNode *operand2){
  dsNode *parent1 = dsFind(operand1);
  dsNode *parent2 = dsFind(operand2);
  if(parent1 != parent2){
    if(parent1->rank == parent2->rank){
      parentsArray[parent2->id] = parent1;
      parent1->rank++;
      return parent1;
    }else if(parent1->rank < parent2->rank){
      parentsArray[parent1->id] = parent2;
      return parent2;
    }else{
      parentsArray[parent2->id] = parent1;
      return parent1;
    }
  }
}

int main(){
  int payload=271828;
  printf("this is a test of the c-based union-find datastructure\n");
  dsNode * a = parentsArray[addNode((void *) &payload)];
  dsNode * b = parentsArray[addNode((void *) &payload)];
  dsNode * c = parentsArray[addNode((void *) &payload)];
  dsNode * d = parentsArray[addNode((void *) &payload)];

  printf("a's payload: %d\n", *((int *)(a->payload)));
  printf("a's parent's id: %d\n", parentsArray[a->id]->id);
  printf("a's id: %d\n", a->id);
  printf("before dsUnion(a,b)\n");
  dsUnion(a,b);
  printf("after dsUnion(a,b)\n");
  printf("b's parent's id: %d\n", parentsArray[b->id]->id);
  dsUnion(c,d);
  dsUnion(b,d);
  dsFind(d);
  printf("d's parent's id: %d\n", parentsArray[d->id]->id);  
  printf("c's parent's id: %d\n", parentsArray[c->id]->id);  
  printf("b's parent's id: %d\n", parentsArray[b->id]->id);  
} 
