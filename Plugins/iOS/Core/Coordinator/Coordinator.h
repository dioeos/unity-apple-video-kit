#ifndef Coordinator_h
#define Coordinator_h

#ifdef __cplusplus
extern "C" {
#endif

bool attach_to_session(void *unitySessionNativePtr);
void detach_from_session(void);

void start_recording(void);
void update_recording(void);
void stop_recording(void);

#ifdef __cplusplus
}
#endif

#endif
