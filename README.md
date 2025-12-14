# Subaru.specs.n.parts
Subaru specs and parts list / compatibility

## Building an Android APK
The repository includes a .NET MAUI app targeting Android (`SubaruPartsSuite/SubaruParts.App`).
Use `build_android_apk.sh` from the repository root to create an APK in the root directory. Example:

```bash
chmod +x build_android_apk.sh
./build_android_apk.sh
```

Prerequisites:
- .NET 9 SDK
- MAUI Android workload installed (`dotnet workload install maui-android`)
- Android SDK components required by .NET MAUI

Installation tips (Ubuntu/Debian):
- Add the Microsoft package feed, then `apt-get update` and `apt-get install dotnet-sdk-9.0`.
- Install Android build dependencies with `dotnet workload install maui-android`.
- In restricted environments (for example, corporate proxies that return HTTP 403 for outbound package requests), the above steps may fail; install the SDK and workloads on a machine with external network access and copy the resulting APK back to this repository.

The script restores the solution, publishes a Release APK, and copies it to `SubaruParts.App-Release.apk` in the root for easy access.

### Build via GitHub Actions
If you prefer the APK to be built in CI, use the **Build Android APK (.NET 9)** workflow:

1. Push a branch/PR or manually trigger the workflow from the **Actions** tab (click **Build Android APK (.NET 9)** → **Run workflow**).
2. After the run finishes, download the `android-apk` artifact from the workflow run details (it contains the `dist/*.apk` output).
