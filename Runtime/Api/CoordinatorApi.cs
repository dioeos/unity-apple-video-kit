using UnityEngine;
using System;

namespace Dioeos.UnityAppleReplayKit
{
  public static class CoordinatorApi
  {
    public static bool AttachSession(IntPtr unitySessionNativePtr)
    {
#if UNITY_IOS && !UNITY_EDITOR
      return CoordinatoriOS.AttachSession(unitySessionNativePtr);
#else
      return false;
#endif
    }

    public static void DetachSession()
    {
#if UNITY_IOS && !UNITY_EDITOR
      CoordinatoriOS.DetachSession();
#endif
    }

    public static void StartRecording(Transform cameraTransform)
    {
#if UNITY_IOS && !UNITY_EDITOR
      CoordinatoriOS.StartRecording(cameraTransform);
#endif
    }

    public static void UpdateRecording(Transform cameraTransform)
    {
#if UNITY_IOS && !UNITY_EDITOR
      CoordinatoriOS.UpdateRecording(cameraTransform);
#endif
    }
    public static void StopRecording()
    {
#if UNITY_IOS && !UNITY_EDITOR
      CoordinatoriOS.StopRecording();
#endif
    }

    public static string GetLatestLocationString()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return CoordinatoriOS.GetLatestLocationString();
#else
      return "Location unavailable";
#endif
    }
  }
}
