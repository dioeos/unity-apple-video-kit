using UnityEngine;

namespace NativeHelloBridge 
{
  public static class NativeHello 
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
