using System;
using System.Runtime.InteropServices;

namespace Dioeos.UnityAppleReplayKit
{
  internal static class SessionManageriOS
  {
    [DllImport("__Internal")]
    private static extern bool sm_attach_to_session(IntPtr unitySessionNativePtr);

    [DllImport("__Internal")]
    private static extern void sm_detach_from_session();

    [DllImport("__Internal")]
    private static extern double sm_get_session_timestamp();

    internal static bool AttachSession(IntPtr unitySessionNativePtr)
    {
#if UNITY_IOS && !UNITY_EDITOR
      return sm_attach_to_session(unitySessionNativePtr);
#else
      return false;
#endif
    }

    internal static void DetachSession()
    {
#if UNITY_IOS && !UNITY_EDITOR
      sm_detach_from_session();
#endif
    }

    internal static double GetSessionTimestamp()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return sm_get_session_timestamp();
#else
      return 0.0;
#endif
    }

  }
}
