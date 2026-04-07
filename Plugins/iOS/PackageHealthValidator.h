#ifndef PackageHealthValidator_h
#define PackageHealthValidator_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

bool pv_is_available(void);
const char* pv_say_hello(void);

#ifdef __cplusplus
}
#endif

#endif /* PackageHealthValidator_h */
