plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.client_app"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // --- ADD THESE TWO LINES FOR DESUGARING ---
        isCoreLibraryDesugaringEnabled = true
        // ------------------------------------------
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = "com.example.client_app"
        minSdk = flutter.minSdkVersion
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17)
    }
}

dependencies {
    // --- ADD THIS LINE FOR DESUGARING ---
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // ------------------------------------
}

flutter {
    source = "../.."
}
