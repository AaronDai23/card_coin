# Add project specific ProGuard rules here.
# By default, the flags in this file are appended to flags specified
# in C:\android-sdk/tools/proguard/proguard-android.txt
# You can edit the include path and order by changing the proguardFiles
# directive in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# Add any project specific keep options here:

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

##---------------Begin: proguard configuration common for all Android apps ----------
-optimizationpasses 5
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-dontpreverify
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

-keep public class * implements java.io.Serializable
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Application
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider
-keep public class * extends android.app.backup.BackupAgentHelper
-keep public class * extends android.preference.Preference

-keepclasseswithmembernames class * {
    native <methods>;
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet);
}

-keepclasseswithmembers class * {
    public <init>(android.content.Context, android.util.AttributeSet, int);
}

-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}

-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

-keep class io.flutter.app.** { *; }

-keep class io.flutter.plugin.** { *; }

-keep class io.flutter.util.** { *; }

-keep class io.flutter.view.** { *; }

-keep class io.flutter.** { *; }

-keep class io.flutter.plugins.** { *; }


##---------------End: proguard configuration common for all Android apps ----------
-dontwarn org.jdom.**
-keep class org.jdom.** { *; }
-dontwarn org.bouncycastle.**
-keep class org.bouncycastle.** { *; }
-dontwarn org.apache.commons.codec..**
-keep class org.apache.commons.codec.** { *; }

#-renamesourcefileattribute SourceFile
-keep class wallet.core.jni.** { *; }
-keep class wallet.core.jni.proto.** { *; }

-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }


# ── R8 missing class suppressions (auto-generated from missing_rules.txt) ──
-dontwarn com.huawei.android.os.BuildEx$VERSION
-dontwarn com.huawei.android.telephony.ServiceStateEx
-dontwarn com.huawei.hms.framework.network.restclient.hianalytics.RCEventListener
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.Interceptor$Chain
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.RealInterceptorChain
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.Request$Builder
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.Request
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.Response
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.plugin.BasePlugin
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.plugin.PluginInterceptor
-dontwarn com.huawei.hms.framework.network.restclient.hwhttp.url.HttpUrl
-dontwarn com.huawei.libcore.io.ExternalStorageFile
-dontwarn com.huawei.libcore.io.ExternalStorageFileInputStream
-dontwarn com.huawei.libcore.io.ExternalStorageFileOutputStream
-dontwarn com.huawei.libcore.io.ExternalStorageRandomAccessFile
-dontwarn com.huawei.secure.android.common.util.SafeBase64
-dontwarn com.huawei.secure.android.common.util.SafeString
-dontwarn org.joda.convert.FromString
-dontwarn org.joda.convert.ToString
-dontwarn org.threeten.bp.zone.TzdbZoneRulesProvider

# ── R8 missing class suppressions (round 2) ──
-dontwarn com.google.android.play.core.splitcompat.SplitCompatApplication
-dontwarn com.google.android.play.core.splitinstall.SplitInstallException
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManager
-dontwarn com.google.android.play.core.splitinstall.SplitInstallManagerFactory
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest$Builder
-dontwarn com.google.android.play.core.splitinstall.SplitInstallRequest
-dontwarn com.google.android.play.core.splitinstall.SplitInstallSessionState
-dontwarn com.google.android.play.core.splitinstall.SplitInstallStateUpdatedListener
-dontwarn com.google.android.play.core.tasks.OnFailureListener
-dontwarn com.google.android.play.core.tasks.OnSuccessListener
-dontwarn com.google.android.play.core.tasks.Task
-dontwarn java.awt.Color
-dontwarn java.beans.BeanInfo
-dontwarn java.beans.IntrospectionException
-dontwarn java.beans.Introspector
-dontwarn java.beans.PropertyDescriptor
-dontwarn org.w3c.dom.bootstrap.DOMImplementationRegistry

# ── 通配兜底：抑制所有未被打包的可选依赖警告 ──
-dontwarn org.apache.log4j.**
-dontwarn com.fasterxml.jackson.**

# ── SLF4J 配置 ──
# SLF4J 需要保持 LoggerFactory 和相关的绑定类不被混淆
-keep class org.slf4j.** { *; }
-keep interface org.slf4j.** { *; }
-dontwarn org.slf4j.**

# 保持 SLF4J 的具体实现（如果有的话）
-keep class ch.qos.logback.** { *; }
-dontwarn ch.qos.logback.**

# ── R8 自动生成的缺失规则 ──
-dontwarn org.slf4j.impl.StaticLoggerBinder
