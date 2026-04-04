#if UNITY_EDITOR && UNITY_IOS
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using System.IO;

namespace NativeHelloBridge.Editor
{
    public static class NativeHelloPostprocessBuild
    {
        [PostProcessBuild(100)]
        public static void OnPostProcessBuild(BuildTarget target, string pathToBuiltProject)
        {
            if (target != BuildTarget.iOS) {
                return;
            }

            string projectPath = PBXProject.GetPBXProjectPath(pathToBuiltProject);
            PBXProject project = new PBXProject();
            project.ReadFromFile(projectPath);

            string mainTargetGuid = project.GetUnityMainTargetGuid();
            string frameworkTargetGuid = project.GetUnityFrameworkTargetGuid();

            project.SetBuildProperty(mainTargetGuid, "SWIFT_VERSION", "5.0");
            project.SetBuildProperty(frameworkTargetGuid, "SWIFT_VERSION", "5.0");

            // Helps Xcode find/generated ObjC-Swift compatibility header cleanly.
            project.SetBuildProperty(mainTargetGuid, "CLANG_ENABLE_MODULES", "YES");
            project.SetBuildProperty(frameworkTargetGuid, "CLANG_ENABLE_MODULES", "YES");

            File.WriteAllText(projectPath, project.WriteToString());
        }
    }
}
#endif
