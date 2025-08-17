import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val secrets = Properties().apply {
    val f = rootProject.file("secrets.properties")
    if (f.exists()) f.inputStream().use { load(it) }
}

android {
    namespace = "com.example.e_commerce_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions { jvmTarget = JavaVersion.VERSION_11.toString() }

    defaultConfig {
        applicationId = "com.example.e_commerce_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        val fbAppId = secrets.getProperty("FACEBOOK_APP_ID", "")
        val fbClient = secrets.getProperty("FACEBOOK_CLIENT_TOKEN", "")
        val webClient = secrets.getProperty("DEFAULT_WEB_CLIENT_ID", "")

        resValue("string", "facebook_app_id", fbAppId)
        resValue("string", "facebook_client_token", fbClient)
        resValue("string", "default_web_client_id", webClient)
        resValue("string", "fb_login_protocol_scheme", "fb$fbAppId")
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter { source = "../.." }
