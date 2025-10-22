# Flutter Wrapper
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# OFFICIAL STRIPE PROGUARD RULES - Updated for 2024/2025
# From: https://pub.dev/packages/flutter_stripe
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivity$g
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Args
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter$Error
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningActivityStarter
-dontwarn com.stripe.android.pushProvisioning.PushProvisioningEphemeralKeyProvider
# Keep Stripe classes
-keep class com.stripe.** { *; }

# Additional Stripe Push Provisioning rules
-dontwarn com.stripe.android.pushProvisioning.EphemeralKeyUpdateListener
-keep class com.stripe.android.pushProvisioning.** { *; }

# Google Play Core Library (for Split APKs and Dynamic Delivery)
-dontwarn com.google.android.play.core.**
-keep class com.google.android.play.core.** { *; }

# Flutter Stripe plugin
-keep class com.reactnativestripesdk.** { *; }
-keep interface com.reactnativestripesdk.** { *; }

# Firebase
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# OkHttp and networking
-dontwarn okhttp3.**
-dontwarn okio.**
-keep class okhttp3.** { *; }
-keep interface okhttp3.** { *; }

# Gson (used by Firebase and other libraries)
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# Location services
-keep class com.google.android.gms.location.** { *; }

# Image picker and file handling
-keep class androidx.lifecycle.** { *; }

# General Android optimizations
-keep class androidx.** { *; }
-keep interface androidx.** { *; }

# Prevent obfuscation of model classes (if using JSON serialization)
-keepclassmembers class ** {
    @com.google.gson.annotations.SerializedName <fields>;
}

# Keep native methods
-keepclasseswithmembernames class * {
    native <methods>;
}

# Keep enum classes
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

# Remove debugging logs in release
-assumenosideeffects class android.util.Log {
    public static boolean isLoggable(java.lang.String, int);
    public static int v(...);
    public static int i(...);
    public static int w(...);
    public static int d(...);
    public static int e(...);
}