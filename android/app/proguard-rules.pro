# Zachowaj wszystkie klasy ML Kit Vision i Text Recognition
-keep class com.google.mlkit.** { *; }
-dontwarn com.google.mlkit.**

# Zachowaj Firebase i Play Services, jeśli używasz ML Kit on-device
-keep class com.google.firebase.** { *; }
-dontwarn com.google.firebase.**

# Zachowaj klasy związane z TensorFlow i native models
-keep class com.google.android.gms.internal.mlkit_vision_** { *; }
-dontwarn com.google.android.gms.internal.mlkit_vision_**

# Zachowaj Flutter plugin bridge (czasami też potrzebne)
-keep class io.flutter.plugins.** { *; }
-dontwarn io.flutter.plugins.**
