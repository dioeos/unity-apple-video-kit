#import "ReplayKitBridge.h"
#import <Foundation/Foundation.h>
#import <stdlib.h>
#import <string.h>

#if __has_include(<UnityFramework/UnityFramework-Swift.h>)
#import <UnityFramework/UnityFramework-Swift.h>
#else
#import "UnityFramework-Swift.h"
#endif

bool replaykit_is_available(void)
{
    return [ReplayKitManager isReplayKitAvailable];
}

bool replaykit_start_recording(void)
{
    return [ReplayKitManager startRecording];
}

bool replaykit_stop_recording(void)
{
    [ReplayKitManager stopRecording];
    return true;
}