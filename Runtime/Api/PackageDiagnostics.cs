using UnityEngine;

namespace Dioeos.UnityAppleReplayKit
{
  public static class UnityAppleVideoKitHealthApi
  {
    public static bool IsPackageHealthy()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return PackageHealthValidator.IsPackageHealthy();
#else
      return false;
#endif
    }

    public static string SayHello()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return PackageHealthValidator.SayHello();
#else
      return "";
#endif
    }
  }
}
