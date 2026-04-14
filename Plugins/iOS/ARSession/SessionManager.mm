#import "SessionManager.h"
#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import <stdlib.h>
#import <string.h>

#if __has_include(<UnityFramework/UnityFramework-Swift.h>)
#import <UnityFramework/UnityFramework-Swift.h>
#else
#import "UnityFramework-Swift.h"
#endif

typedef struct UnityXRNativeSessionPtr
{
  int version;
  void *session;
} UnityXRNativeSessionPtr;

extern "C" {
    bool sm_attach_to_session(void *unitySessionNativePtr)
    {
      if (unitySessionNativePtr == NULL)
      {
        return false;
      }

      UnityXRNativeSessionPtr *wrapper = (UnityXRNativeSessionPtr *)unitySessionNativePtr;
      if (wrapper->session == NULL)
      {
        return false;
      }

      ARSession *arSession = (__bridge ARSession *)wrapper->session;
      if (arSession == nil)
      {
          return false;
      }

      [SessionManager attach:arSession];
      return true;
    }

    void sm_detach_from_session(void)
    {
      [SessionManager detach];
    }

    double sm_get_session_timestamp(void)
    {
      return [SessionManager getTimestamp];
    }

    void* sm_get_pixel_buffer(void)
    {
      CVPixelBufferRef pixelBuffer = [SessionManager getPixelBuffer];
      return (void*)pixelBuffer;
    }

    void sm_start_recording(void)
    {
      [SessionManager startRecording];
    }

    void sm_update_recording(void)
    {
      [SessionManager updateRecording];
    }

    void sm_stop_recording(void)
    {
      [SessionManager stopRecording];
    }
}
