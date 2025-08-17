// Load secrets from properties file
val secretsProperties = java.util.Properties()
val secretsFile = rootProject.file("secrets.properties")
if (secretsFile.exists()) {
    secretsProperties.load(java.io.FileInputStream(secretsFile))
}

plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.e_commerce_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.e_commerce_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Set placeholders for secrets
        resValue("string", "facebook_app_id", "${secretsProperties["facebookAppId"] ?: ""}")
        resValue("string", "facebook_client_token", "${secretsProperties["facebookClientToken"] ?: ""}")
        resValue("string", "default_web_client_id", "${secretsProperties["webClientId"] ?: ""}")
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}
