#ifndef NativeHelloBridge_h
#define NativeHelloBridge_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

bool nh_is_available(void);
const char* nh_say_hello(void);

#ifdef __cplusplus
}
#endif

#endif /* NativeHelloBridge_h */
