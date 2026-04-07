using System;
using System.Runtime.InteropServices;

namespace Dioeos.UnityAppleReplayKit
{
  internal static class PackageHealthValidator
  {
    [DllImport("__Internal")]
    private static extern bool pv_is_available();

    [DllImport("__Internal")]
    private static extern string pv_say_hello();

    internal static bool IsPackageHealthy()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return pv_is_available();
#else
      return false;
#endif
    }

    internal static string SayHello()
    {
      return pv_say_hello();
    }



  }
}
