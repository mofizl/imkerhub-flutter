- Bei build ios app: Run flutter build ios --release --no-codesign
  
Warning: Building for device with codesigning disabled. You will have to manually codesign before deploying to device.
Building com.example.imkerhubFlutter for device (ios-release)...
Running pod install...                                              3.4s
Running Xcode build...                                          
Xcode build done.                                            2.4s
Failed to build iOS app
Uncategorized (Xcode): Unable to find a destination matching the provided destination specifier:
        { generic:1, platform:iOS }
    Ineligible destinations for the "Runner" scheme:
        { platform:iOS, id:dvtdevice-DVTiPhonePlaceholder-iphoneos:placeholder, name:Any iOS Device, error:iOS 18.0 is not installed. To use with Xcode, first download and install the platform }
════════════════════════════════════════════════════════════════════════════════
iOS 18.0 is not installed. To download and install the platform, open
Xcode, select Xcode > Settings > Platforms, and click the GET button for the
required platform.
For more information, please visit:
  https://developer.apple.com/documentation/xcode/installing-additional-simulator-runtimes
════════════════════════════════════════════════════════════════════════════════
Encountered error while building for device.
Error: Process completed with exit code 1.