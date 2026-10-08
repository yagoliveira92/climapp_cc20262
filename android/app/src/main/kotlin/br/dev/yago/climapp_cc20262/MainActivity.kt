package br.dev.yago.climapp_cc20262

import android.content.Context
import android.telephony.TelephonyManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.Locale

class MainActivity : FlutterActivity() {
    private val CHANNEL = "br.dev.yago.climapp/device"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "getDeviceCountry" -> {
                    val country = getDeviceCountry()
                    result.success(country)
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun getDeviceCountry(): String {
        // Primeiro tenta obter o país configurado no Android.
        // Isso funciona melhor no emulador.
        val localeCountry = Locale.getDefault().country

        if (localeCountry.isNotBlank()) {
            return localeCountry.uppercase(Locale.ROOT)
        }

        // Caso o Locale não esteja disponível, tenta obter
        // o país do SIM do dispositivo.
        val tm = getSystemService(
            Context.TELEPHONY_SERVICE
        ) as? TelephonyManager

        val simCountry = tm?.simCountryIso

        if (!simCountry.isNullOrBlank()) {
            return simCountry.uppercase(Locale.ROOT)
        }

        return ""
    }
}