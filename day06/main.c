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
  long long num;
  long long part1 = 0;
  long long part2 = 0;
  long long fishs1[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};
  long long fishs2[9] = {0, 0, 0, 0, 0, 0, 0, 0, 0};

  while(fgets(buffer, MAX_LEN, file)) {
    char *ch;
    ch = strtok(buffer, ",");
    while (ch != NULL) {
      num = atol(ch);
      fishs1[num] += 1;
      fishs2[num] += 1;
      ch = strtok(NULL, ",");
    }

  }
  fclose(file);

  long long temp;
  for (int day = 0; day < 80; day++) {
    temp = fishs1[0];
    fishs1[0] = fishs1[1];
    fishs1[1] = fishs1[2];
    fishs1[2] = fishs1[3];
    fishs1[3] = fishs1[4];
    fishs1[4] = fishs1[5];
    fishs1[5] = fishs1[6];
    fishs1[6] = fishs1[7] + temp;
    fishs1[7] = fishs1[8];
    fishs1[8] = temp;
  }

  for (int day = 0; day < 100000000; day++) {
    temp = fishs2[0];
    fishs2[0] = fishs2[1];
    fishs2[1] = fishs2[2];
    fishs2[2] = fishs2[3];
    fishs2[3] = fishs2[4];
    fishs2[4] = fishs2[5];
    fishs2[5] = fishs2[6];
    fishs2[6] = fishs2[7] + temp;
    fishs2[7] = fishs2[8];
    fishs2[8] = temp;
  }

  for (int i = 0; i < 9; i++) {
    part1 += fishs1[i];
    part2 += fishs2[i];
  }
  printf("Part 1: %lld\n", part1);
  printf("Part 2: %lld\n", part2);

  return 0;
}
