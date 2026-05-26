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

        val callbackHandle = getSharedPreferences(
            "dev.brewkits.native_workmanager",
            Context.MODE_PRIVATE,
        ).getLong("callback_handle", -1L)

        if (callbackHandle != -1L) {
            FlutterEngineManager.setCallbackHandle(callbackHandle)
        }
    }

    override val workManagerConfiguration: Configuration
        get() {
            val workerFactory = DelegatingWorkerFactory().apply {
                addFactory(KmpWorkerFactory(SimpleAndroidWorkerFactory(this@PromajaApplication)))
            }

            return Configuration.Builder()
                .setWorkerFactory(workerFactory)
                .build()
        }
}
