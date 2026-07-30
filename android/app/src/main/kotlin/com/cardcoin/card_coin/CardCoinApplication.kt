package com.cardcoin.card_coin

import android.content.Context
import androidx.appcompat.app.AppCompatDelegate
import io.flutter.app.FlutterMultiDexApplication

/**
 * Force light mode as early as possible.
 * MIUI/HyperOS Force Dark otherwise paints the Android 12 system splash black
 * even when windowSplashScreenBackground is white.
 */
class CardCoinApplication : FlutterMultiDexApplication() {
    override fun attachBaseContext(base: Context) {
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
        super.attachBaseContext(base)
    }

    override fun onCreate() {
        AppCompatDelegate.setDefaultNightMode(AppCompatDelegate.MODE_NIGHT_NO)
        super.onCreate()
    }
}
