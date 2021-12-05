#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_LEN 256
#define BIT_COUNT 5

int binToDec(char *bin) {
  int result = 0;
  while(*bin) {
    result *= 2;
    result += *bin == '1' ? 1 : 0;
    ++bin;
  }
  return result;
}

bool startsWith(char *haystack, char *needle, int curBitCount) {
  printf("\t\t%s %s\n", haystack, needle);
  for (int i = 0; i < curBitCount; i++) {
    if (haystack[i] != needle[i]) {
      return false;
    }
  }
  return true;
}

int singleIn(char *value, char* values[], int curBitCount) {
  int index = -1;
  for(int i = 0; i < 12; i++) {
    printf("\t%s, index = %d / %s\n", values[i], i, value);
    if(startsWith(values[i], value, curBitCount)) {
      if(index != -1) {
        printf("\t!!! breaking\n");
        return -1;
      }
      index = i;
    }
  }
  return index;
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

  char buffer[MAX_LEN];
  int counter = 0, i;
  int part1 = 0, oneCount[BIT_COUNT] = {};
  char gamma[BIT_COUNT + 1] = {}, epsilon[BIT_COUNT + 1] = {};
  int part2 = 0;
  char co2[BIT_COUNT + 1] = {}, oxygen[BIT_COUNT + 1] = {}, *values[12] = {};

  for(i = 0; i < BIT_COUNT; i++) {
    oneCount[i] = 0;
  }

  while(fgets(buffer, MAX_LEN, file)) {
    buffer[strcspn(buffer, "\n")] = 0;
    values[counter] = buffer;
    printf("%s\n", buffer);
    for(i = 0; i < BIT_COUNT; i++) {
      if(buffer[i] == '1') {
        oneCount[i] += 1;
      }
    }

    counter++;
  }
  printf("\n");

  for(i = 0; i < BIT_COUNT; i++) {
    // printf("%d ", oneCount[i]);
    if(oneCount[i] > counter / 2) {
      gamma[i] = '1';
      epsilon[i] = '0';
      co2[i] = '0';
      oxygen[i] = '1';
    } else {
      gamma[i] = '0';
      epsilon[i] = '1';
      co2[i] = '1';
      oxygen[i] = '0';
    }
    
    printf("%s len(%d)\n", co2, i + 1);
    int co2SingleIn = singleIn(co2, values, i + 1);
    int oxygenSingleIn = singleIn(oxygen, values, i + 1);
    if(co2SingleIn != -1) {
      printf("\t%s : %d\t", co2, co2SingleIn);
      *co2 = *values[co2SingleIn];
    }
    if(oxygenSingleIn != -1) {
      *oxygen = *values[oxygenSingleIn];
    }
  }

  printf("\n");
  gamma[BIT_COUNT] = 0;
  epsilon[BIT_COUNT] = 0;

  fclose(file);
  part1 = binToDec(gamma) * binToDec(epsilon);
  part2 = binToDec(co2) * binToDec(oxygen);
  printf("counter: %d\n", counter);
  printf("Part 1: %s * %s = %d\n", gamma, epsilon, part1);
  printf("Part 2: %s * %s = %d\n", co2, oxygen, part2);

  return 0;
}
