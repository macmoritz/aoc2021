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
  int part1 = 0, prev1 = 99999;
  int part2 = 0, history[4] = {}, historyCounter = 0;
  while(fgets(buffer, MAX_LEN, file)) {
    num = atoi(buffer);
    printf("%d\t", num);
    if(prev1 < num) {
      printf("increased\t");
      part1++;
    } else if(prev1 > num) {
      printf("decreased\t");
    }
    prev1 = num;

    if(historyCounter == 4) {
      for (int i = 1; i < 4; i++) {
        history[i - 1] = history[i];
      }
      historyCounter = 3;
    }
    history[historyCounter] = num;
    historyCounter++;

    if(counter >= 3) {
      if(history[0] + history[1] + history[2] < history[1] + history[2] + history[3]){
        printf("increased");
        part2++;
      } else {
        printf("decreased");
      }
    }
    printf("\n");

    counter++;
  }
  fclose(file);
  printf("Part 1: %d\n", part1);
  printf("Part 2: %d\n", part2);

  return 0;
}
