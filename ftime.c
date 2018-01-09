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

  return nanoTs;
}

struct tm_ext {
  struct tm dateTime;
  int64_t nanos;
};

void nsToUtcDateTime(int64_t nanoTs, struct tm_ext *timeInfo) {
  time_t timestamp;
  struct tm *dateTime;

  timestamp = (time_t)(nanoTs / SECOND);
  dateTime = gmtime(&timestamp);

  memcpy(&(timeInfo->dateTime), dateTime, sizeof(struct tm));
  timeInfo->nanos = nanoTs % SECOND;
}


void getUtcDateTime(struct tm_ext *timeInfo) {
  int64_t nanoTs = getNanoTimestamp();
  nsToUtcDateTime(nanoTs, timeInfo);
}

void getDateTime(struct tm *dateTime) {
  time_t timestamp;
  struct tm *dt;
  
  timestamp = time(NULL);
  dt = localtime(&timestamp);

  memcpy(dateTime, dt, sizeof(struct tm));
}

void printNanoDuration(int64_t nanos) {
  int64_t high = 0;
  int64_t low = 0;
  int negative = nanos < (int64_t)0 ? 1 : 0;
  nanos = negative ? ((int64_t)-1 * nanos) : nanos;

  if (nanos >= HOUR) {
    high = nanos / HOUR;
    low = nanos % HOUR / MINUTE;
    printf("%lld h, %lld m\n", high, low);
  } else if (nanos >= MINUTE) {
    high = nanos / MINUTE;
    low = nanos % MINUTE / SECOND;
    printf("%lld m, %lld s\n", high, low);
  } else if (nanos >= SECOND) {
    high = nanos / SECOND;
    low = nanos % SECOND / MILLISECOND;
    printf("%lld.%03lld s\n", high, low);
  } else if (nanos >= MILLISECOND) {
    high = nanos / MILLISECOND;
    low = nanos % MILLISECOND / MICROSECOND;
    printf("%lld.%03lld ms\n", high, low);
  } else {
    high = nanos / MICROSECOND;
    low = nanos % MICROSECOND;
    printf("%lld.%03lld us\n", high, low);
  }
}

void iso(struct tm_ext *timeInfo) {
    struct tm *dt = &(timeInfo->dateTime); 
    int64_t millis = timeInfo->nanos / (int64_t)1000000;
    printf("%04d-%02d-%02dT%02d:%02d:%02d.%03lldZ\n",
        dt->tm_year + 1900,
        dt->tm_mon + 1,
        dt->tm_mday,
        dt->tm_hour,
        dt->tm_min,
        dt->tm_sec,
        millis
    );
}

void bash(struct tm *dt) {
  char *dateColor = COLOR_GREEN;
  char *timeColor = COLOR_YELLOW;
  char *noColor = COLOR_OFF;

  getDateTime(dt);
  printf("%s%04d%s-%s%02d%s-%s%02d%s %s%02d%s:%s%02d%s:%s%02d%s\n",
      dateColor, dt->tm_year + 1900, noColor,
      dateColor, dt->tm_mon + 1, noColor,
      dateColor, dt->tm_mday, noColor,
      timeColor, dt->tm_hour, noColor,
      timeColor, dt->tm_min, noColor,
      timeColor, dt->tm_sec, noColor
  );
}

void isoBash(struct tm_ext *timeInfo) {
  char *dateColor = COLOR_GREEN;
  char *timeColor = COLOR_YELLOW;
  char *noColor = COLOR_OFF;

  struct tm *dt = &(timeInfo->dateTime); 
  int64_t millis = timeInfo->nanos / (int64_t)1000000;
  printf("%s%04d%s-%s%02d%s-%s%02d%sT%s%02d%s:%s%02d%s:%s%02d%s.%s%03lld%sZ\n",
      dateColor, dt->tm_year + 1900, noColor,
      dateColor, dt->tm_mon + 1, noColor,
      dateColor, dt->tm_mday, noColor,
      timeColor, dt->tm_hour, noColor,
      timeColor, dt->tm_min, noColor,
      timeColor, dt->tm_sec, noColor,
      timeColor, millis, noColor
  );
}

void usage(void) {
  printf("Usage: ftime format <nano_duration>\n");
  printf("       ftime ns|us|ms|s|m|h\n");
  printf("       ftime ns-iso|us-iso|m-iso|s-iso <timestamp>\n");
  printf("       ftime iso|iso-bash\n");
  printf("       ftime bash\n");
}

int main(int argc, char **argv) {
  int64_t nanos;
  int64_t millis;
  struct tm_ext timeInfo;
  struct tm dt;

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
    iso(&timeInfo);
  } else if (argc == 2 && strcmp(argv[1], "iso-bash") == 0) {
    getUtcDateTime(&timeInfo);
    isoBash(&timeInfo);
  } else if (argc == 2 && strcmp(argv[1], "bash") == 0) {
    getDateTime(&dt);
    bash(&dt);
  } else if (argc == 3 && strcmp(argv[1], "format") == 0) {
    nanos = atoll(argv[2]);
    printNanoDuration(nanos);
  } else if (argc == 3 && strcmp(argv[1], "ns-iso") == 0) {
    millis = atoll(argv[2]);
    nsToUtcDateTime(millis, &timeInfo);
    iso(&timeInfo);
  } else if (argc == 3 && strcmp(argv[1], "us-iso") == 0) {
    millis = atoll(argv[2]) * MICROSECOND;
    nsToUtcDateTime(millis, &timeInfo);
    iso(&timeInfo);
  } else if (argc == 3 && strcmp(argv[1], "ms-iso") == 0) {
    millis = atoll(argv[2]) * MILLISECOND;
    nsToUtcDateTime(millis, &timeInfo);
    iso(&timeInfo);
  } else if (argc == 3 && strcmp(argv[1], "s-iso") == 0) {
    millis = atoll(argv[2]) * SECOND;
    nsToUtcDateTime(millis, &timeInfo);
    iso(&timeInfo);
  } else {
    usage();
    return 1;
  }

  return 0;
}
