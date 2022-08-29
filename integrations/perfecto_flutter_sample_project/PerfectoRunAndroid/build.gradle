buildscript {
    repositories {
        maven {
            url "https://repo1.perfectomobile.com/public/repositories/maven/"      
        }
        google()
        mavenCentral()
        
    }
    dependencies {
        classpath "com.perfectomobile.instrumentedtest.gradleplugin:plugin:+"
           
        // NOTE: Do not place your application dependencies here; they belong
        // in the individual module build.gradle files
    }
}
// Apply the plugin 
apply plugin: 'com.perfectomobile.instrumentedtest.gradleplugin'
perfectoGradleSettings {
    configFileLocation "ConfigFile.json"
}
    task clean(type: Delete) {
        delete rootProject.buildDir
}