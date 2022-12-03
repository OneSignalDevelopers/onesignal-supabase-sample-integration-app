![OneSignal](https://github.com/OneSignal/.github/blob/439e36ade56b001643ff3b07eeaf95b20129f3e6/assets/onesignal-banner.png)

<div align="center">
  <a href="https://documentation.onesignal.com/docs/onboarding-with-onesignal" target="_blank">Quickstart</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://onesignal.com/" target="_blank">Website</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://documentation.onesignal.com/docs" target="_blank">Docs</a>
  <span>&nbsp;&nbsp;•&nbsp;&nbsp;</span>
  <a href="https://github.com/OneSignalDevelopers" target="_blank">Examples</a>
  <br />
  <hr />
</div>

# OneSignal + Supabase Sample Integration App
OneSignal makes engaging customers simple and is the fastest, most reliable service to send push notifications, in-app messages, SMS, and emails.

This repo contains the companion app to the [Onesignal + Supabase Sample Integration guide](https://github.com/onesignaldevelopers/onesignal-supabase-sample-integration-supabase).

![App demo](readme_assets/push-notification-demo.gif)

⚠️⚠️ Follow the integration guide to succesfully test the integration end-to-end. The [Supabase](https://github.com/onesignaldevelopers/onesignal-supabase-sample-integration-supabase) and [Next.js](https://github.com/onesignaldevelopers/onesignal-supabase-sample-integration-api) projects must be running first.

## 🚦 Getting Started

1. Run `cp .env.example .env.local` to duplicate the environment file template and set their values based on what you setup in the [integration guide](https://github.com/onesignaldevelopers/onesignal-supabase-sample-integration-supabase).
2. If you're building for iOS, update the app's bundle and group IDs with the identifier you setup in Apple Developer Network ![runner](/readme_assets/runner-capabilities.png) ![nse](/readme_assets/nse-capabilities.png)

Your project diff should look similar to this 👇 after the changes.

```diff
diff --git a/ios/Runner.xcodeproj/project.pbxproj b/ios/Runner.xcodeproj/project.pbxproj
index 2864eb6..62cf60e 100644
--- a/ios/Runner.xcodeproj/project.pbxproj
+++ b/ios/Runner.xcodeproj/project.pbxproj
@@ -494,7 +494,7 @@
 					"$(inherited)",
 					"@executable_path/Frameworks",
 				);
-				PRODUCT_BUNDLE_IDENTIFIER = "com.onesignal.devrel.supabase-sample-integration";
+				PRODUCT_BUNDLE_IDENTIFIER = your.bundle.id;
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SWIFT_OBJC_BRIDGING_HEADER = "Runner/Runner-Bridging-Header.h";
 				SWIFT_VERSION = 5.0;
@@ -738,7 +738,7 @@
 					"$(inherited)",
 					"@executable_path/Frameworks",
 				);
-				PRODUCT_BUNDLE_IDENTIFIER = "com.onesignal.devrel.supabase-sample-integration";
+				PRODUCT_BUNDLE_IDENTIFIER = your.bundle.id;
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SWIFT_OBJC_BRIDGING_HEADER = "Runner/Runner-Bridging-Header.h";
 				SWIFT_OPTIMIZATION_LEVEL = "-Onone";
@@ -765,7 +765,7 @@
 					"$(inherited)",
 					"@executable_path/Frameworks",
 				);
-				PRODUCT_BUNDLE_IDENTIFIER = "com.onesignal.devrel.supabase-sample-integration";
+				PRODUCT_BUNDLE_IDENTIFIER = your.bundle.id;
 				PRODUCT_NAME = "$(TARGET_NAME)";
 				SWIFT_OBJC_BRIDGING_HEADER = "Runner/Runner-Bridging-Header.h";
 				SWIFT_VERSION = 5.0;
diff --git a/ios/Runner/Runner.entitlements b/ios/Runner/Runner.entitlements
index ad08247..903def2 100644
--- a/ios/Runner/Runner.entitlements
+++ b/ios/Runner/Runner.entitlements
@@ -4,9 +4,5 @@
 <dict>
 	<key>aps-environment</key>
 	<string>development</string>
+	<key>com.apple.security.application-groups</key>
+	<array>
+		<string>group.your.app.group</string>
+	</array>
 </dict>
 </plist>
```

3. Run `flutter start` to launch the app on your iOS device or emulator (iOS Simulator doesn't support push notifications).

## 👀 Looking For a Getting Started With Flutter Guide?

[![YT Thumb](readme_assets/flutter-sdk-setup-yt-thumb.png)](https://www.youtube.com/watch?v=5klspCULQe4)

### We have other guides to help get your started

* [OneSignal SDK + Flutter Integration Sample](https://github.com/OneSignalDevelopers/OneSignal-Flutter-Sample)
* [OneSignal + Flutter Push Sample](https://github.com/OneSignalDevelopers/OneSignal-Flutter-Push-Sample)
* [Flutter SDK Setup](https://documentation.onesignal.com/docs/flutter-sdk-setup)

## How it works

Todo: graphic 

### Setting External User ID

The EUID is when the user signs up or logs in.

https://github.com/OneSignalDevelopers/onesignal-supabase-sample-integration-app/blob/0277752c4e88d7e4b13bbb20af84a6700d9e141b/lib/screens/auth/login_screen.dart#L51-L59

### Triggering an In-App Message

Prompt user for notification consent upon completing purchase with an in-app message.

https://github.com/OneSignalDevelopers/onesignal-supabase-sample-integration-app/blob/0277752c4e88d7e4b13bbb20af84a6700d9e141b/lib/screens/payment_sheet/payment_sheet_screen.dart#L130-L134

---

# ❤️ Developer Community

For additional resources, please join the [OneSignal Developer Community](https://onesignal.com/onesignal-developers).

Get in touch with us or learn more about OneSignal through the channels below.

- [Follow us on Twitter](https://twitter.com/onesignaldevs) to never miss any updates from the OneSignal team, ecosystem & community
- [Join us on Discord](https://discord.gg/EP7gf6Uz7G) to be a part of the OneSignal Developers community, showcase your work and connect with other OneSignal developers
- [Read the OneSignal Blog](https://onesignal.com/blog/) for the latest announcements, tutorials, in-depth articles & more.
- [Subscribe to us on YouTube](https://www.youtube.com/channel/UCe63d5EDQsSkOov-bIE_8Aw/featured) for walkthroughs, courses, talks, workshops & more.
- [Follow us on Twitch](https://www.twitch.tv/onesignaldevelopers) for live streams, office hours, support & more.

## Show your support

Give a ⭐️ if this project helped you, and watch this repo to stay up to date.

