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
  int num;
  unsigned long part1 = 0;
  unsigned long part2 = 0;
  unsigned long fishs[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};

  while(fgets(buffer, MAX_LEN, file)) {
    num = atoi(buffer);

    fishs[num] += 1;
  }
  fclose(file);

  unsigned long temp;
  for (int day = 0; day < 10; day++) {
    temp = fishs[0];
    fishs[0] = fishs[1];
    fishs[1] = fishs[2];
    fishs[2] = fishs[3];
    fishs[3] = fishs[4];
    fishs[4] = fishs[5];
    fishs[5] = fishs[6];
    fishs[6] = fishs[7] + temp;
    fishs[7] = fishs[8];
    fishs[8] = temp;
  }

  for (int i = 0; i < 18; i++) {
    part1 += fishs[i];
    part2 += fishs[i];
  }
  printf("Part 1: %d\n", part1);
  printf("Part 2: %d\n", part2);

  return 0;
}
