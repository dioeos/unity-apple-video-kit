#ifndef Coordinator_h
#define Coordinator_h

#include <stdbool.h>

#ifdef __cplusplus
extern "C" {
#endif

typedef struct UnityXRNativeSessionPtr
{
  int version;
  void *session;
} UnityXRNativeSessionPtr;

typedef struct ARCameraPoseNative
{
  float tx;
  float ty;
  float tz;

  float qx;
  float qy;
  float qz;
  float qw;
} ARCameraPoseNative;

/*
Session lifecycle functions
*/
bool attach_to_session(void *unitySessionNativePtr);
void detach_from_session(void);

/*
Recording lifecycle functions
*/
void start_recording(ARCameraPoseNative pose);
void update_recording(ARCameraPoseNative pose);
void stop_recording(void);

const char* latest_location_string(void);
void free_native_string(const char* str);

#ifdef __cplusplus
}
#endif

#endif
