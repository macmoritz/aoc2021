#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LEN 256

int main(int argc, char *argv[]) {
  FILE* file;
  char filename[] = "input.txt";
  if(argc > 1) {
    strcpy(filename, argv[1]);
  }
  file = fopen(filename, "r");
  if(file == NULL) {
    perror("failed to read file");
    return 1;
  }

  char buffer[MAX_LEN];
  int counter = 0, num;
  int part1 = 0;
  int part2 = 0;

  while(fgets(buffer, MAX_LEN, file)) {
    num = atoi(buffer);
    buffer[strcspn(buffer, "\n")] = 0;
    printf("%d\t", num);
    printf("\n");

    counter++;
  }
  fclose(file);
  printf("Part 1: %d\n", part1);
  printf("Part 2: %d\n", part2);

  return 0;
}
