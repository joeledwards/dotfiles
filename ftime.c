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


#define COLOR_OFF     "\x1B[0m"
#define COLOR_RED     "\x1B[31m"
#define COLOR_GREEN   "\x1B[32m"
#define COLOR_YELLOW  "\x1B[33m"
#define COLOR_BLUE    "\x1B[34m"
#define COLOR_MAGENTA "\x1B[35m"
#define COLOR_CYAN    "\x1B[36m"
#define COLOR_WHITE   "\x1B[37m"

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

struct tm_ext {
  struct tm *dateTime;
  uint16_t millis;
};

void getUtcDateTime(struct tm_ext * timeInfo) {
  uint64_t nanoTs;
  uint32_t millis;
  time_t timestamp;
  struct tm *dateTime;

  nanoTs = getNanoTimestamp();
  timestamp = nanoTs / 1000000000;
  dateTime = gmtime(&timestamp);

  *timeInfo = (struct tm_ext) { .dateTime = dateTime, .millis = nanoTs / 1000000 & 1000 };
}

struct tm *getDateTime(void) {
  time_t timestamp;
  struct tm *dateTime;
  
  timestamp = time(NULL);
  dateTime = localtime(&timestamp);
  
  return dateTime;
}

void printNanoTime(uint64_t nanoTime) {
  uint64_t high;
  uint64_t low;

  if (nanoTime >= HOUR) {
    high = nanoTime / HOUR;
    low = nanoTime % HOUR / MINUTE;
    printf("%ld h, %ld m\n", high, low);
  } else if (nanoTime >= MINUTE) {
    high = nanoTime / MINUTE;
    low = nanoTime % MINUTE / SECOND;
    printf("%ld m, %ld s\n", high, low);
  } else if (nanoTime >= SECOND) {
    high = nanoTime / SECOND;
    low = nanoTime % SECOND / MILLISECOND;
    printf("%ld.%03ld s\n", high, low);
  } else if (nanoTime >= MILLISECOND) {
    high = nanoTime / MILLISECOND;
    low = nanoTime % MILLISECOND / MICROSECOND;
    printf("%ld.%03ld ms\n", high, low);
  } else {
    high = nanoTime / MICROSECOND;
    low = nanoTime % MICROSECOND;
    printf("%ld.%03ld us\n", high, low);
  }
}

void usage(void) {
  printf("Usage: time format <nano_timestamp>\n");
  printf("       time ns|us|ms|s|m|h\n");
  printf("       time iso|iso-bash\n");
  printf("       time bash\n");
}

int main(int argc, char **argv) {
  char *dateColor = COLOR_GREEN;
  char *timeColor = COLOR_YELLOW;
  char *noColor = COLOR_OFF;
  uint64_t nanoTime;
  struct tm_ext timeInfo;
  struct tm *dt;

  if (argc == 2 && strcmp(argv[1], "ns") == 0) {
    printf("%ld\n", getNanoTimestamp());
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
  } else if (argc == 2 && strcmp(argv[1], "iso") == 0) {
    getUtcDateTime(&timeInfo);
    dt = timeInfo.dateTime; 
    printf("%04d-%02d-%02dT%02d:%02d:%02d.%03dZ\n",
        dt->tm_year + 1900,
        dt->tm_mon + 1,
        dt->tm_mday,
        dt->tm_hour,
        dt->tm_min,
        dt->tm_sec,
        timeInfo.millis
    );
  } else if (argc == 2 && strcmp(argv[1], "iso-bash") == 0) {
    getUtcDateTime(&timeInfo);
    dt = timeInfo.dateTime; 
    printf("%s%04d%s-%s%02d%s-%s%02d%sT%s%02d%s:%s%02d%s:%s%02d%s.%s%03d%sZ\n",
        dateColor, dt->tm_year + 1900, noColor,
        dateColor, dt->tm_mon + 1, noColor,
        dateColor, dt->tm_mday, noColor,
        timeColor, dt->tm_hour, noColor,
        timeColor, dt->tm_min, noColor,
        timeColor, dt->tm_sec, noColor,
        timeColor, timeInfo.millis, noColor
    );
  } else if (argc == 2 && strcmp(argv[1], "bash") == 0) {
    dt = getDateTime();
    printf("%s%04d%s-%s%02d%s-%s%02d%s %s%02d%s:%s%02d%s:%s%02d%s\n",
        dateColor, dt->tm_year + 1900, noColor,
        dateColor, dt->tm_mon + 1, noColor,
        dateColor, dt->tm_mday, noColor,
        timeColor, dt->tm_hour, noColor,
        timeColor, dt->tm_min, noColor,
        timeColor, dt->tm_sec, noColor
    );
  } else if (argc == 3 && strcmp(argv[1], "format") == 0) {
    nanoTime = atoll(argv[2]);
    printNanoTime(nanoTime);
  } else {
    usage();
    return 1;
  }

  return 0;
}
