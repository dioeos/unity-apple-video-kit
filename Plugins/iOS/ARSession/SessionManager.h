#ifndef SessionManager_h
#define SessionManager_h

#ifdef __cplusplus
extern "C" {
#endif

bool sm_attach_to_session(void *unitySessionNativePtr);
void sm_detach_from_session(void);
double sm_get_session_timestamp(void);

#ifdef __cplusplus
}
#endif

#endif
