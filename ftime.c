#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <inttypes.h>
#include <math.h>

#define NANOSECOND 1LL
#define MICROSECOND 1000LL
#define MILLISECOND 1000000LL
#define SECOND 1000000000LL
#define MINUTE 60000000000LL
#define HOUR 3600000000000LL

uint64_t getNanoTimestamp(void) {
    long nanos; // Milliseconds
    time_t timestamp;  // Seconds
    struct timespec spec;

    uint64_t nanoTime;

    clock_gettime(CLOCK_REALTIME, &spec);

    timestamp  = spec.tv_sec;
    nanos = spec.tv_nsec;

    nanoTime = timestamp * 1000000000;
    nanoTime += nanos;

    return nanoTime;
}

void printNanoTime(uint64_t nanoTime) {
  uint64_t high;
  uint64_t low;

  if (nanoTime >= HOUR) {
    high = nanoTime / HOUR;
    low = nanoTime % HOUR / MINUTE;
    printf("%lld h, %lld m\n", high, low);
  } else if (nanoTime >= MINUTE) {
    high = nanoTime / MINUTE;
    low = nanoTime % MINUTE / SECOND;
    printf("%lld m, %lld s\n", high, low);
  } else if (nanoTime >= SECOND) {
    high = nanoTime / SECOND;
    low = nanoTime % SECOND / MILLISECOND;
    printf("%lld.%03lld s\n", high, low);
  } else if (nanoTime >= MILLISECOND) {
    high = nanoTime / MILLISECOND;
    low = nanoTime % MILLISECOND / MICROSECOND;
    printf("%lld.%03lld ms\n", high, low);
  } else {
    high = nanoTime / MICROSECOND;
    low = nanoTime % MICROSECOND;
    printf("%lld.%03lld us\n", high, low);
  }
}

void usage(void) {
  printf("Usage: time format <nano_timestamp>\n");
  printf("       time <ns|us|ms|s|m|h>\n");
}

int main(int argc, char **argv) {
  uint64_t nanoTime;

  if (argc == 2 && strcmp(argv[1], "ns") == 0) {
    printf("%lld\n", getNanoTimestamp());
  } else if (argc == 2 && strcmp(argv[1], "us") == 0) {
    printf("%lld\n", getNanoTimestamp() / MICROSECOND);
  } else if (argc == 2 && strcmp(argv[1], "ms") == 0) {
    printf("%lld\n", getNanoTimestamp() / MILLISECOND);
  } else if (argc == 2 && strcmp(argv[1], "s") == 0) {
    printf("%lld\n", getNanoTimestamp() / SECOND);
  } else if (argc == 2 && strcmp(argv[1], "m") == 0) {
    printf("%lld\n", getNanoTimestamp() / MINUTE);
  } else if (argc == 2 && strcmp(argv[1], "h") == 0) {
    printf("%lld\n", getNanoTimestamp() / HOUR);
  } else if (argc == 3 && strcmp(argv[1], "format") == 0) {
    nanoTime = atoll(argv[2]);
    printNanoTime(nanoTime);
  } else {
    usage();
    return 1;
  }

  return 0;
}
