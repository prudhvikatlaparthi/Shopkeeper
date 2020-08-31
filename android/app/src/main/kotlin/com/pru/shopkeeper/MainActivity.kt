package com.pru.shopkeeper

import android.content.Intent
import android.net.Uri
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity : FlutterActivity() {
    private val CHANNEL = "sendSms"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "send") {
                val n = call.argument<String>("phone")
                val m = call.argument<String>("msg")
                sendSMS(n, m, result)
                result.success("success")
            } else {
                result.notImplemented()
            }

        }
    }

    fun sendSMS(phoneNo: String?, msg: String?, result: MethodChannel.Result) {
        try {
            /*val smsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(phoneNo, null, msg, null, null)*/
            /*val i = Intent(Intent.ACTION_VIEW)
            i.data = Uri.parse("smsto:")
            i.type = "vnd.android-dir/mms-sms"
            i.putExtra("address", phoneNo)
            i.putExtra("sms_body", msg)
            startActivity(Intent.createChooser(i, "Send sms via:"))*/
            val uri = Uri.parse("smsto:" + phoneNo)
            val intent = Intent(Intent.ACTION_SENDTO, uri)
            intent.putExtra("sms_body", msg)
            startActivity(intent)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    }
}
