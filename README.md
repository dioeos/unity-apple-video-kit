Repository for Unity package that exposes a C# API that uses an Objective-C bridge to interact with video functionality on iOS devices, such as the Apple ReplayKit and AVAssetWriter. The package was created (and is still being developed) to serve [LLIOS](https://github.com/dioeos/LLIOS), a spatial computing app being developed by the [Link Lab](https://engineering.virginia.edu/labs-groups/link-lab) @ UVA.

## Package Structure & Navigation

The C# API that is used in a Unity project is located in the `Runtime/` directory of the root of the package. The core implementation logic is implemented in the `Plugins/iOS`. Inside of `iOS` directory, there are 3 subdirectories:

1. `Apple/` - contains code for directly interacting with the [Apple Developer API](https://developer.apple.com/documentation/) to implement specific functionality in iOS devices.
2. `Utilities/` - contains simple utility code that is called throughout the package
3. `Core/` - contains the main source code that is exposed to the C# API through an Objective-C++ bridge. The code in this directory makes use of functions and classes written in both `Apple/` and `Utilities/`.
