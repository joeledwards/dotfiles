#include <stdlib.h>
#include <string.h>
#include <stdio.h>
#include <time.h>
#include <inttypes.h>
#include <math.h>

#define NANOSECOND        (int64_t)1LL
#define MICROSECOND    (int64_t)1000LL
#define MILLISECOND (int64_t)1000000LL
#define SECOND   (int64_t)1000000000LL
#define MINUTE  (int64_t)60000000000LL
#define HOUR  (int64_t)3600000000000LL

#define COLOR_OFF     "\x1B[0m"
#define COLOR_RED     "\x1B[31m"
#define COLOR_GREEN   "\x1B[32m"
#define COLOR_YELLOW  "\x1B[33m"
#define COLOR_BLUE    "\x1B[34m"
#define COLOR_MAGENTA "\x1B[35m"
#define COLOR_CYAN    "\x1B[36m"
#define COLOR_WHITE   "\x1B[37m"

int64_t getNanoTimestamp(void) {
  struct timespec spec;
  int64_t nanoTs;
  clock_gettime(CLOCK_REALTIME, &spec);

  nanoTs = SECOND * (int64_t)(spec.tv_sec) + (int64_t)(spec.tv_nsec);
  printf("spec.tv_sec: %ld\n", spec.tv_sec);
  printf("spec.tv_nsec: %ld\n", spec.tv_nsec);
  printf("nanoTs: %lld\n", nanoTs);

  return nanoTs;
}

struct tm_ext {
  struct tm dateTime;
  int64_t nanos;
};

void getUtcDateTime(struct tm_ext *timeInfo) {
  int64_t nanoTs;
  time_t timestamp;
  struct tm *dateTime;

  nanoTs = getNanoTimestamp();
  timestamp = (time_t)(nanoTs / SECOND);
  dateTime = gmtime(&timestamp);

  memcpy(&(timeInfo->dateTime), dateTime, sizeof(struct tm));
  timeInfo->nanos = nanoTs % SECOND;
  printf("nanoTs: %lld\n", nanoTs);
  printf("timeInfo->nanos: %lld\n", timeInfo->nanos);
}

void getDateTime(struct tm *dateTime) {
  time_t timestamp;
  struct tm *dt;
  
  timestamp = time(NULL);
  dt = localtime(&timestamp);

  memcpy(dateTime, dt, sizeof(struct tm));
}

void printNanoTime(int64_t nanoTime) {
  int64_t high = 0;
  int64_t low = 0;
  int negative = nanoTime < (int64_t)0 ? 1 : 0;
  nanoTime = negative ? ((int64_t)-1 * nanoTime) : nanoTime;

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
  printf("       time ns|us|ms|s|m|h\n");
  printf("       time iso|iso-bash\n");
  printf("       time bash\n");
}

int main(int argc, char **argv) {
  char *dateColor = COLOR_GREEN;
  char *timeColor = COLOR_YELLOW;
  char *noColor = COLOR_OFF;
  int64_t nanoTime;
  int64_t millis;
  struct tm_ext timeInfo;
  struct tm *dt;

  // Allocate space for the 
  //timeInfo = malloc(sizeof(struct tm_ext));

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
  } else if (argc == 2 && strcmp(argv[1], "iso") == 0) {
    getUtcDateTime(&timeInfo);
    dt = &(timeInfo.dateTime); 
    millis = timeInfo.nanos / (int64_t)1000000;
    printf("millis: %lld\n", millis);
    printf("%04d-%02d-%02dT%02d:%02d:%02d.%03lldZ\n",
        dt->tm_year + 1900,
        dt->tm_mon + 1,
        dt->tm_mday,
        dt->tm_hour,
        dt->tm_min,
        dt->tm_sec,
        millis
    );
  } else if (argc == 2 && strcmp(argv[1], "iso-bash") == 0) {
    getUtcDateTime(&timeInfo);
    dt = &(timeInfo.dateTime); 
    millis = timeInfo.nanos / (int64_t)1000000;
    printf("millis: %lld\n", millis);
    printf("%s%04d%s-%s%02d%s-%s%02d%sT%s%02d%s:%s%02d%s:%s%02d%s.%s%03lld%sZ\n",
        dateColor, dt->tm_year + 1900, noColor,
        dateColor, dt->tm_mon + 1, noColor,
        dateColor, dt->tm_mday, noColor,
        timeColor, dt->tm_hour, noColor,
        timeColor, dt->tm_min, noColor,
        timeColor, dt->tm_sec, noColor,
        timeColor, millis, noColor
    );
  } else if (argc == 2 && strcmp(argv[1], "bash") == 0) {
    dt = malloc(sizeof(struct tm));
    getDateTime(dt);
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
