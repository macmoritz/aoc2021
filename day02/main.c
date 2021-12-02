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
  int horizontal = 0;
  int depth1 = 0;
  int aim = 0, depth2 = 0;

  while(fgets(buffer, MAX_LEN, file)) {
    buffer[strcspn(buffer, "\n")] = 0;
    if (buffer[0] == 0) continue;

    switch(buffer[0]) {
      case 'f':
        horizontal += atoi(&buffer[8]);
        depth2 += aim * atoi(&buffer[8]);
        break;
      case 'd':
        depth1 += atoi(&buffer[5]);
        aim += atoi(&buffer[5]);
        break;
      case 'u':
        depth1 -= atoi(&buffer[3]);
        aim -= atoi(&buffer[3]);
        break;
    }
  }
  fclose(file);
  printf("Part 1: %d * %d = %d\n", horizontal, depth1, horizontal * depth1);
  printf("Part 2: %d * %d = %d\n", horizontal, depth2, horizontal * depth2);

  return 0;
}
