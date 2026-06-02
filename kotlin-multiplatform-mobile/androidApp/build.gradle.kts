import java.io.File
import java.util.*
import org.jetbrains.kotlin.gradle.dsl.JvmTarget

val keystoreProperties =
        Properties().apply {
            val file = File("androidApp/key.properties")
            if (file.exists()) load(file.reader())
        }

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
}

android {
    namespace = "io.codemagic.kmmsample"
    compileSdk = 34

    val appVersionCode = (findProperty("versionCode") as String?)?.toInt()
        ?: System.getenv("NEW_BUILD_NUMBER")?.toInt()
        ?: 1
    val appVersionName = (findProperty("versionName") as String?) ?: "1.0"
    val hasCiSigning = System.getenv("CI").toBoolean()
        && System.getenv("CM_KEYSTORE_PATH") != null
        && System.getenv("CM_KEYSTORE_PASSWORD") != null
        && System.getenv("CM_KEY_ALIAS") != null
        && System.getenv("CM_KEY_PASSWORD") != null
    val hasLocalSigning = keystoreProperties.getProperty("storeFile") != null
        && keystoreProperties.getProperty("storePassword") != null
        && keystoreProperties.getProperty("keyAlias") != null
        && keystoreProperties.getProperty("keyPassword") != null

    defaultConfig {
        applicationId = "io.codemagic.kmmsample"
        minSdk = 21
        targetSdk = 34
        versionCode = appVersionCode
        versionName = appVersionName
    }
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    signingConfigs {
        if (hasCiSigning || hasLocalSigning) {
            create("release") {
                if (hasCiSigning) { // CI=true is exported by Codemagic
                    storeFile = file(System.getenv("CM_KEYSTORE_PATH"))
                    storePassword = System.getenv("CM_KEYSTORE_PASSWORD")
                    keyAlias = System.getenv("CM_KEY_ALIAS")
                    keyPassword = System.getenv("CM_KEY_PASSWORD")
                } else {
                    storeFile = file(keystoreProperties.getProperty("storeFile"))
                    storePassword = keystoreProperties.getProperty("storePassword")
                    keyAlias = keystoreProperties.getProperty("keyAlias")
                    keyPassword = keystoreProperties.getProperty("keyPassword")
                }
            }
        }
    }
    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            if (hasCiSigning || hasLocalSigning) {
                signingConfig = signingConfigs.getByName("release")
            }
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget.set(JvmTarget.JVM_17)
    }
}

dependencies {
    implementation(project(":shared"))
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.appcompat:appcompat:1.7.0")
    implementation("androidx.constraintlayout:constraintlayout:2.2.0")
}
