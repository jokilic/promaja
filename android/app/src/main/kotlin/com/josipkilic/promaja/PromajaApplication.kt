package com.josipkilic.promaja

import android.content.Context
import androidx.work.Configuration
import androidx.work.DelegatingWorkerFactory
import dev.brewkits.kmpworkmanager.background.data.KmpWorkerFactory
import dev.brewkits.native_workmanager.SimpleAndroidWorkerFactory
import dev.brewkits.native_workmanager.engine.FlutterEngineManager
import io.flutter.app.FlutterApplication

class PromajaApplication : FlutterApplication(), Configuration.Provider {
     override fun onCreate() {
        super.onCreate()

        // Restore callbackHandle that the plugin persisted during Dart-side initialize().
        // SharedPreferences name and key mirror the plugin's internal constants.
        val handle = getSharedPreferences(
            "dev.brewkits.native_workmanager", Context.MODE_PRIVATE
        ).getLong("callback_handle", -1L)

        if (handle != -1L) {
            FlutterEngineManager.setCallbackHandle(handle)
        }
    }

    // WorkManager calls this when the process is restarted after being killed,
    // before any Flutter engine or plugin is loaded.
    // It is NOT called during a normal app launch (plugin already initialized WorkManager first).
    override fun getWorkManagerConfiguration(): Configuration {
        val factory = DelegatingWorkerFactory().apply {
            addFactory(KmpWorkerFactory(SimpleAndroidWorkerFactory(this@MyApplication)))
        }
        return Configuration.Builder()
            .setWorkerFactory(factory)
            .build()
    }
}
