#ifndef ReplayKitBridge_h
#define ReplayKitBridge_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

bool replaykit_is_available(void);
bool replaykit_start_recording(void);
bool replaykit_stop_recording(void);

#ifdef __cplusplus
}
#endif

#endif /* ReplayKitBridge_h */