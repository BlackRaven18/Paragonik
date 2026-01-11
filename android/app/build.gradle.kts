// Importy i wczytywanie kluczy (bez zmian)
import java.util.Properties
import java.io.FileInputStream

val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties()
keystoreProperties.load(FileInputStream(keystorePropertiesFile))

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    // ... (sekcje namespace, compileSdk, compileOptions, kotlinOptions, defaultConfig, signingConfigs - bez zmian)
    namespace = "com.wolski.paragonik"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.wolski.paragonik"
        minSdk = 26
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties.getProperty("storeFile"))
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    // --- KLUCZOWA ZMIANA JEST TUTAJ ---
    buildTypes {
        getByName("release") {
            // Wskazujemy, że ma używać naszej konfiguracji podpisywania
            signingConfig = signingConfigs.getByName("release")

            // JAWNIE WŁĄCZAMY MINIFIKACJĘ (R8) I USUWANIE ZASOBÓW
            isMinifyEnabled = true
            isShrinkResources = true

            // Wskazujemy pliki z regułami dla R8 (Proguard)
            proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}

flutter {
    source = "../.."
}