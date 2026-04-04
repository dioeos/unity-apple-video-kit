using UnityEngine;

namespace Dioeos.UnityAppleReplayKit
{
  public static class UnityAppleReplayKitApi
  {
    public static string SayHello()
    {
#if UNITY_IOS && !UNITY_EDITOR
      return NativeHelloBridgeiOS.SayHello();
#else
      return "Not properly calling";
#endif
    }
  }
}
