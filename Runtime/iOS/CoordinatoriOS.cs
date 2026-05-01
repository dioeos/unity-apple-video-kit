using System;
using System.Runtime.InteropServices;
using UnityEngine;

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
    private static extern void start_recording(ARCameraPoseNative pose);

    [DllImport("__Internal")]
    private static extern void update_recording(ARCameraPoseNative pose);

    [DllImport("__Internal")]
    private static extern void stop_recording();

    internal static void StartRecording(Transform cameraTransform)
    {
#if UNITY_IOS && !UNITY_EDITOR
      ARCameraPoseNative pose = ARCameraPoseNative.ConvertTransformToPose(cameraTransform);
      start_recording(pose);
#endif
    }

    internal static void UpdateRecording(Transform cameraTransform)
    {
#if UNITY_IOS && !UNITY_EDITOR
      ARCameraPoseNative pose = ARCameraPoseNative.ConvertTransformToPose(cameraTransform);
      update_recording(pose);
#endif
    }

    internal static void StopRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      stop_recording();
#endif
    }

    [DllImport("__Internal")]
    private static extern IntPtr latest_location_string();

    [DllImport("__Internal")]
    private static extern void free_native_string(IntPtr str);

    internal static string GetLatestLocationString()
    {
#if UNITY_IOS && !UNITY_EDITOR
      IntPtr ptr = latest_location_string();
      if (ptr != IntPtr.Zero)
      {
        string result = Marshal.PtrToStringAnsi(ptr);
        free_native_string(ptr);
        return result;
      }
      return "Location unavailable";
#else
      return "Location unavailable";
#endif
    }
  }
}
