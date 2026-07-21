package com.cardcoin.card_coin
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.nfc.NfcAdapter
import android.os.Bundle
import android.os.PersistableBundle
import com.chipcore.sdk.flutter.ChipCoreBlockchainApi
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterFragmentActivity() {
    private val eventsChannel = "com.walletconnect.flutterwallet/events"
    private val methodsChannel = "com.walletconnect.flutterwallet/methods"
    private val nfcChannel = "com.cardcoin.card_coin/nfc"

    private var initialLink: String? = null
    private var linksReceiver: BroadcastReceiver? = null

    /**
     * 当使用 nfc_manager 的 enableReaderMode 扫描时，必须暂停本 Activity 的
     * enableForegroundDispatch，否则两者会并行分发同一次贴卡（reader 回调 + onNewIntent），
     * 造成 Activity 焦点抖动并打断正在进行的 transceive/写卡。
     * Dart 侧在 startSession 前置 true，会话结束后置 false。
     */
    private var suppressForegroundDispatch = false


    /** NFC action 集合，这类 intent 不应被当成 deeplink 处理 */
    private fun isNfcIntent(i: Intent?) =
        i?.action?.let {
            it == "android.nfc.action.NDEF_DISCOVERED" ||
            it == "android.nfc.action.TECH_DISCOVERED" ||
            it == "android.nfc.action.TAG_DISCOVERED"
        } ?: false

    /** 判断 intent 是否来自 NFC（包括 action 和 extras 两种路径） */
    private fun isNfcSource(i: Intent?): Boolean {
        if (i == null) return false
        // 常规 NFC dispatch：action 是 NFC 专属 action
        if (isNfcIntent(i)) return true
        // 当 app 注册了 autoVerify App Links 且验证通过时，Android 可能把 NFC NDEF URL
        // 以 ACTION_VIEW 发给 app（走 App Link 路径），此时 action 不再是 NDEF_DISCOVERED。
        // 但 NFC dispatch 系统仍然会在 extras 中附带 EXTRA_TAG（NFC Tag 对象），
        // 利用这个 extra 可以可靠地区分 NFC 来源和普通 deeplink 点击。
        if (i.hasExtra(NfcAdapter.EXTRA_TAG)) return true
        if (i.hasExtra(NfcAdapter.EXTRA_NDEF_MESSAGES)) return true
        return false
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        val i = intent
        android.util.Log.d("NFC_DEBUG",
            "onCreate action=${i?.action} data=${i?.data} extras=${i?.extras?.keySet()}")
        // 冷启动时 NFC 可能作为 launchIntent 传入。
        // 必须在 super.onCreate 之前替换掉，否则 app_links 等插件会在
        // super.onCreate 内部的 FlutterFragment 初始化阶段读取到原始 NFC intent，
        // 把卡片 URL 当成 deeplink 投递给 Flutter。
        if (isNfcSource(i)) {
            android.util.Log.d("NFC_DEBUG", "Suppressing NFC launch intent")
            setIntent(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_LAUNCHER))
        }
        super.onCreate(savedInstanceState)
          android.util.Log.d("NFC_DEBUG",
            "onCreate action33333=${i?.action} data=${i?.data} extras=${i?.extras?.keySet()}")
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        ChipCoreBlockchainApi.register(flutterEngine.dartExecutor.binaryMessenger, this)
        // 经过 onCreate 的 setIntent 过滤，此时 intent 一定不是 NFC intent
        val t0 = System.currentTimeMillis()
        android.util.Log.d("TIMING", "[configureFlutterEngine] start, t=${t0}")
        initialLink = intent?.data?.toString()
        android.util.Log.d("TIMING", "[configureFlutterEngine] initialLink=$initialLink, t=${System.currentTimeMillis()-t0}ms")

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
                android.util.Log.d("TIMING", "[MethodChannel] initialLink called, responding with: $initialLink, t=${System.currentTimeMillis()-t0}ms")
                // initialLink 为 null 时也必须回调，否则 Dart 侧 invokeMethod 会挂起直到超时
                result.success(initialLink)
            } else {
                result.notImplemented()
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, nfcChannel).setMethodCallHandler { call, result ->
            when (call.method) {
                "setForegroundDispatchEnabled" -> {
                    val enabled = call.argument<Boolean>("enabled") ?: true
                    suppressForegroundDispatch = !enabled
                    android.util.Log.d("NFC_DEBUG",
                        "setForegroundDispatchEnabled=$enabled (suppress=$suppressForegroundDispatch)")
                    val adapter = NfcAdapter.getDefaultAdapter(this)
                    if (suppressForegroundDispatch) {
                        adapter?.let { runCatching { it.disableForegroundDispatch(this) } }
                    } else if (adapter != null && adapter.isEnabled) {
                        enableNfcForegroundDispatch(adapter)
                    }
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
        android.util.Log.d("TIMING", "[configureFlutterEngine] calling super, t=${System.currentTimeMillis()-t0}ms")
        super.configureFlutterEngine(flutterEngine)
        android.util.Log.d("TIMING", "[configureFlutterEngine] super done, t=${System.currentTimeMillis()-t0}ms")
    }

    private fun enableNfcForegroundDispatch(adapter: NfcAdapter) {
        val pendingIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, javaClass).addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT
        )
        runCatching { adapter.enableForegroundDispatch(this, pendingIntent, null, null) }
    }

    override fun onResume() {
        super.onResume()
        // 启用前台分发：拦截 NFC intent 优先送到本 Activity，同时抑制 MIUI/ColorOS 等 OEM 系统弹窗。
        // onNewIntent 中会对 NFC action 做 early-return，不会传给 app_links。
        // 但当 Dart 侧正在用 enableReaderMode 扫描时（suppressForegroundDispatch=true），
        // 必须跳过，否则会与 reader mode 冲突、并行分发同一次贴卡。
        if (suppressForegroundDispatch) {
            android.util.Log.d("NFC_DEBUG", "onResume: skip foreground dispatch (reader mode active)")
            return
        }
        val adapter = NfcAdapter.getDefaultAdapter(this)
        if (adapter != null && adapter.isEnabled) {
            enableNfcForegroundDispatch(adapter)
        }
    }

    override fun onPause() {
        super.onPause()
        val adapter = NfcAdapter.getDefaultAdapter(this)
        adapter?.disableForegroundDispatch(this)
    }

    override fun onNewIntent(intent: Intent) {
        android.util.Log.d("NFC_DEBUG",
            "onNewIntent action=${intent.action} data=${intent.data} extras=${intent.extras?.keySet()}")
        // NFC intent 不转发给 Flutter 插件层（包括 ACTION_VIEW + EXTRA_TAG 的 App Link 路径）：
        // app_links 通过 super.onNewIntent 拦截所有 intent，若把 NDEF_DISCOVERED 传下去
        // 它会把卡片 URL 当成 deeplink 投递给 Dart 层，导致放卡就自动跳转页面。
        // ChipCoreSDK 使用 enableReaderMode(ReaderCallback)，不依赖 onNewIntent，可安全跳过。
        if (isNfcSource(intent)) {
            android.util.Log.d("NFC_DEBUG", "Suppressing NFC new-intent")
            return
        }

        super.onNewIntent(intent)
         android.util.Log.d("NFC_DEBUG",
            "onNewIntent action2222=${intent.action} data=${intent.data} extras=${intent.extras?.keySet()}")
        // 只有 ACTION_VIEW（deeplink）才保留 Intent 让 app_links 读取
        if (intent.action == Intent.ACTION_VIEW) {
            setIntent(intent)
        }
        if (intent.action == Intent.ACTION_VIEW) {
            if (intent.scheme?.contains("st944a9eb04e40fdbc") == true) {
                // st 链接：setIntent 已经在上面做了，intentReceiver 不需要额外触发
            } else {
                if (intent.scheme?.contains("wc") == true) {
                    linksReceiver?.onReceive(this.applicationContext, intent)
                }
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
