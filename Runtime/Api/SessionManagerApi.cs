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

        public static IntPtr GetPixelBuffer()
        {
#if UNITY_IOS && !UNITY_EDITOR
            return SessionManageriOS.GetPixelBuffer();
#else
            return IntPtr.Zero;
#endif
        }

        public static void StartRecording()
        {
#if UNITY_IOS && !UNITY_EDITOR
            SessionManageriOS.StartRecording();
#endif
        }

        public static void UpdateRecording()
        {
#if UNITY_IOS && !UNITY_EDITOR
            SessionManageriOS.UpdateRecording();
#endif
        }

        public static void StopRecording()
        {
#if UNITY_IOS && !UNITY_EDITOR
            SessionManageriOS.StopRecording();
#endif
        }
    }
}
