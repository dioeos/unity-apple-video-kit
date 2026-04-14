#ifndef SessionManager_h
#define SessionManager_h

#ifdef __cplusplus
extern "C" {
#endif

bool sm_attach_to_session(void *unitySessionNativePtr);
void sm_detach_from_session(void);
double sm_get_session_timestamp(void);
void* sm_get_pixel_buffer(void);

void sm_start_recording(void);
void sm_update_recording(void);
void sm_stop_recording(void);

#ifdef __cplusplus
}
#endif

#endif
