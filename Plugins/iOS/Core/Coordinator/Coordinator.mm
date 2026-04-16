#import "Coordinator.h"
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
    bool attach_to_session(void *unitySessionNativePtr)
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

      [Coordinator attach:arSession];
      return true;
    }

    void detach_from_session(void)
    {
      [Coordinator detach];
    }

    void start_recording(void)
    {
      [Coordinator startRecording];
    }

    void update_recording(void)
    {
      [Coordinator updateRecording];
    }

    void stop_recording(void)
    {
      [Coordinator stopRecording];
    }
}
