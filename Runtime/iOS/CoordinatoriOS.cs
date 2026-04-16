using System;
using System.Runtime.InteropServices;

namespace Dioeos.UnityAppleReplayKit
{
  internal static class CoordinatoriOS
  {
    [DllImport("__Internal")]
    private static extern bool attach_to_session(IntPtr unitySessionNativePtr);

    [DllImport("__Internal")]
    private static extern void detach_from_session();

    internal static bool AttachSession(IntPtr unitySessionNativePtr)
    {
#if UNITY_IOS && !UNITY_EDITOR
      return attach_to_session(unitySessionNativePtr);
#else
      return false;
#endif
    }

    internal static void DetachSession()
    {
#if UNITY_IOS && !UNITY_EDITOR
      detach_from_session();
#endif
    }


    [DllImport("__Internal")]
    private static extern void start_recording();

    [DllImport("__Internal")]
    private static extern void update_recording();

    [DllImport("__Internal")]
    private static extern void stop_recording();

    internal static void StartRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      start_recording();
#endif
    }

    internal static void UpdateRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      update_recording();
#endif
    }

    internal static void StopRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      stop_recording();
#endif
    }
  }
}
