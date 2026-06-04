package com.cardcoin.card_coin
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Bundle
import android.os.PersistableBundle
import com.chipcore.sdk.flutter.ChipCoreBlockchainApi
import com.tencent.bugly.crashreport.CrashReport
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterFragmentActivity() {
    private val eventsChannel = "com.walletconnect.flutterwallet/events"
    private val methodsChannel = "com.walletconnect.flutterwallet/methods"

    private var initialLink: String? = null
    private var linksReceiver: BroadcastReceiver? = null


    /** NFC action 集合，这类 intent 不应被当成 deeplink 处理 */
    private fun isNfcIntent(i: Intent?) =
        i?.action?.let {
            it == "android.nfc.action.NDEF_DISCOVERED" ||
            it == "android.nfc.action.TECH_DISCOVERED" ||
            it == "android.nfc.action.TAG_DISCOVERED"
        } ?: false

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        // 冷启动时 NFC 可能作为 launchIntent 传入；在任何插件（app_links）读取之前
        // 把它替换成空 intent，防止被当成 deeplink 投递给 Flutter。
        if (isNfcIntent(intent)) {
            setIntent(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER))
        }
        ChipCoreBlockchainApi.register(flutterEngine.dartExecutor.binaryMessenger, this)
        val intent: Intent? = intent
        initialLink = if (isNfcIntent(intent)) null else intent?.data?.toString()

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, eventsChannel).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(args: Any?, events: EventChannel.EventSink) {
                    linksReceiver = createChangeReceiver(events)
                }
                override fun onCancel(args: Any?) {
                    linksReceiver = null
                }
            }
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, methodsChannel).setMethodCallHandler { call, result ->
            if (call.method == "initialLink") {
                if (initialLink != null) {
                    result.success(initialLink)
                }
            }
        }
        super.configureFlutterEngine(flutterEngine)
        CrashReport.initCrashReport(applicationContext,"5eb7318bee",false)
    }

    override fun onResume() {
        super.onResume()
        // 启用前台分发：拦截 NFC intent 优先送到本 Activity，同时抑制 MIUI/ColorOS 等 OEM 系统弹窗。
        // onNewIntent 中会对 NFC action 做 early-return，不会传给 app_links。
        val adapter = NfcAdapter.getDefaultAdapter(this)
        if (adapter != null && adapter.isEnabled) {
            val pendingIntent = PendingIntent.getActivity(
                this,
                0,
                Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
                PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
            )
            adapter.enableForegroundDispatch(this, pendingIntent, null, null)
        }
    }

    override fun onPause() {
        super.onPause()
        val adapter = NfcAdapter.getDefaultAdapter(this)
        adapter?.disableForegroundDispatch(this)
    }

    override fun onNewIntent(intent: Intent) {
        val action = intent.action
        // NFC intent 不转发给 Flutter 插件层：
        // app_links 通过 super.onNewIntent 拦截所有 intent，若把 NDEF_DISCOVERED 传下去
        // 它会把卡片 URL 当成 deeplink 投递给 Dart 层，导致放卡就自动跳转页面。
        // ChipCoreSDK 使用 enableReaderMode(ReaderCallback)，不依赖 onNewIntent，可安全跳过。
        if (action == "android.nfc.action.NDEF_DISCOVERED" ||
            action == "android.nfc.action.TECH_DISCOVERED" ||
            action == "android.nfc.action.TAG_DISCOVERED") {
            return
        }
        super.onNewIntent(intent)
        println("onNewIntent: $intent")
        // 只有 ACTION_VIEW（deeplink）才保留 Intent 让 app_links 读取
        if (intent.action == Intent.ACTION_VIEW) {
            setIntent(intent)
        }
        if (intent.action === Intent.ACTION_VIEW) {
            println("onNewIntent111: $intent")
            if (intent.scheme?.contains("st944a9eb04e40fdbc") == true ) {
                println("onNewIntent222: $intent")
//                  setIntent(intent)
//                linksReceiver?.onReceive(this.applicationContext, intent)
            }else {
                if (intent.scheme?.contains("wc") == true) {
                    linksReceiver?.onReceive(this.applicationContext, intent)
                }
                println("onNewIntent333: $intent")

            }
        }
    }
    fun createChangeReceiver(events: EventChannel.EventSink): BroadcastReceiver? {
        return object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val dataString = intent.dataString ?:
                events.error("UNAVAILABLE", "Link unavailable", null)
                events.success(dataString)
            }
        }
    }
}
