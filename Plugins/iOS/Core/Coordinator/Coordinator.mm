#import "Coordinator.h"
#import <Foundation/Foundation.h>
#import <ARKit/ARKit.h>
#import <CoreLocation/CoreLocation.h>
#import <stdlib.h>
#import <string.h>

#if __has_include(<UnityFramework/UnityFramework-Swift.h>)
#import <UnityFramework/UnityFramework-Swift.h>
#else
#import "UnityFramework-Swift.h"
#endif

static ARCameraPoseBox *MakePoseBox(ARCameraPoseNative pose)
{
    return [[ARCameraPoseBox alloc] initWithTx:pose.tx
                                            ty:pose.ty
                                            tz:pose.tz
                                            qx:pose.qx
                                            qy:pose.qy
                                            qz:pose.qz
                                            qw:pose.qw];
}

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

    void start_recording(ARCameraPoseNative pose)
    {
      ARCameraPoseBox *poseBox = MakePoseBox(pose);
      [Coordinator startRecordingWithPose:poseBox];
    }

    void update_recording(ARCameraPoseNative pose)
    {
      ARCameraPoseBox *poseBox = MakePoseBox(pose);
      [Coordinator updateRecordingWithPose:poseBox];
    }

    void stop_recording(void)
    {
      [Coordinator stopRecording];
    }

    const char* latest_location_string(void) {
        NSString *location = [Coordinator latestLocationString];
        if (location == nil)
        {
            return NULL;
        }

        const char *utf8 = [location UTF8String];
        if (utf8 == NULL)
        {
            return NULL;
        }

        char *result = strdup(utf8);

        return result;
    }

    void free_native_string(const char* str) {
        free((void*)str);
    }
}
