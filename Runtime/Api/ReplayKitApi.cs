using UnityEngine;

namespace Dioeos.UnityAppleReplayKit
{
  public static class UnityAppleReplayKitApi
  {
    public static bool IsReplayKitAvailable()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return ReplayKitManageriOS.IsAvailable();
#else
      return false;
#endif
    }

    public static bool StartRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return ReplayKitManageriOS.StartRecording();
#else
      return false;
#endif
    }

    public static bool StopRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return ReplayKitManageriOS.StopRecording();
#else
      return false;
#endif
    }
  }
}
