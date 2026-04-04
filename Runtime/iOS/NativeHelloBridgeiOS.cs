using System;
using System.Runtime.InteropServices;

namespace NativeHelloBridge
{
  internal static class NativeHelloBridgeiOS
  {
    [DllImport("__Internal")]
    private static extern bool nh_is_available();

    [DllImport("__Internal")]
    private static extern string nh_say_hello();

    internal static bool IsAvailable()
    {
      return nh_is_available();
    }

    internal static string SayHello()
    {
      return nh_say_hello();
    }
  }
}
