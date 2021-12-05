#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_LEN 256

int balls[150] = {};

void getBalls(char *line) {
  printf("%s", *line);
  int i = 0;
  char *token = strtok(line, ",");
  while(token != NULL) {
    printf("%s  ", token);
    token = strtok(NULL, ",");
    if(token != NULL) {
      balls[j] = atoi(token);
      i++;
    }
  }
}

bool checkCard(int card[5][5]) {
  bool status;
  for(int j = 0; j < 5; j++) {
    if(card[j][0] == card[j][1] && card[j][1] == card[j][2] && card[j][2] == card[j][3] && card[j][3] == card[j][4]) return true;
    if(card[0][j] == card[1][j] && card[1][j] == card[2][j] && card[2][j] == card[3][j] && card[3][j] == card[4][j]) return true;
  }
  return false;
}

bool notIn(int haystack[], int needle) {
  for(int i = 0; i < sizeof(haystack) / sizeof(haystack[0]); i++) {
    if(haystack[i] == needle) return true;
  }
  return false;
}

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

  char buffer[MAX_LEN], *bbuffer;
  int counter = 0, cardCounter = 0, localCardCounter = 0, cardRowCounter = 0;
  int cards[100][5][5] = {};
  int part1 = 0, unmarked[25] = {}, unmarkedCounter = 0;
  int part2 = 0;

  while(fgets(buffer, MAX_LEN, file)) {
    buffer[strcspn(buffer, "\n")] = 0;

    if(localCardCounter == 5) {
      localCardCounter = 0;
      cardCounter++;
    }

    if(buffer[0] == 0) {
      cardCounter++;
      continue;
    }

    if(counter == 0) {
      // getBalls(buffer);
    } else {
      cardRowCounter = 0;
      bbuffer = strtok(buffer, ",");
      while(bbuffer != NULL) {
        bbuffer = strtok(NULL, ",");
        if(bbuffer != NULL) {
          cards[cardCounter][localCardCounter][cardRowCounter] = atoi(bbuffer);
          cardRowCounter++;
        }
      }
      localCardCounter++;
    }
    printf("%s\n", buffer);

    counter++;
  }

  for(int i = 0; i < sizeof(balls) / sizeof(balls[0]); i++) {
    for (int j = 0; j < 100; j++) {
      checkCard(cards[j]);

      for(int k = 0; k < 5; k++) {
        for(int l = 0; l < 5; l++) {
          if(notIn(balls, cards[j][k][l])) {
            unmarked[unmarkedCounter] = cards[j][k][l];
            unmarkedCounter++;
          }
        }
      }

      for(int i = 0; i < unmarkedCounter; i++) {
        part1 += unmarked[i];
      }
      part1 *= balls[i];
      break;
    }
  }

  fclose(file);

  printf("%d\n", balls[0]);
  printf("Part 1: %d\n", part1);
  printf("Part 2: %d\n", part2);

  return 0;
}
