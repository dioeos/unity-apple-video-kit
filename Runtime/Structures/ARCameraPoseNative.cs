using System.Runtime.InteropServices;
using UnityEngine;

[StructLayout(LayoutKind.Sequential)]
public struct ARCameraPoseNative
{
    public float tx;
    public float ty;
    public float tz;

    public float qx;
    public float qy;
    public float qz;
    public float qw;

    public ARCameraPoseNative(Vector3 position, Quaternion rotation)
    {
        tx = position.x;
        ty = position.y;
        tz = position.z;

        qx = rotation.x;
        qy = rotation.y;
        qz = rotation.z;
        qw = rotation.w;
    }

    public static ARCameraPoseNative ConvertTransformToPose(Transform t)
    {
        return new ARCameraPoseNative(t.position, t.rotation);
    }
}
