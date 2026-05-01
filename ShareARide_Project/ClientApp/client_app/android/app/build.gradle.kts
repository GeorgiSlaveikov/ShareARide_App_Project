plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.client_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        // --- ADD THESE TWO LINES FOR DESUGARING ---
        isCoreLibraryDesugaringEnabled = true
        // ------------------------------------------
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.client_app"
        minSdk = "23"
        targetSdk = flutter.targetSdkVersion
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

dependencies {
    // --- ADD THIS LINE FOR DESUGARING ---
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
    // ------------------------------------
}

flutter {
    source = "../.."
}