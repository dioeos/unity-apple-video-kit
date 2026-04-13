using UnityEngine;
using System;

namespace Dioeos.UnityAppleReplayKit
{
    public static class SessionManagerApi
    {
        public static bool AttachSession(IntPtr unitySessionNativePtr)
        {
#if UNITY_IOS && !UNITY_EDITOR
            return SessionManageriOS.AttachSession(unitySessionNativePtr);
#else
            return false;
#endif
        }

        public static void DetachSession()
        {
#if UNITY_IOS && !UNITY_EDITOR
            SessionManageriOS.DetachSession();
#endif
        }

        public static double GetSessionTimestamp()
        {
#if UNITY_IOS && !UNITY_EDITOR
            return SessionManageriOS.GetSessionTimestamp();
#else
            return 0.0;
#endif
        }
    }

}
