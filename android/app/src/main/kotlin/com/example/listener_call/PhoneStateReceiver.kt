package com.example.listener_call

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.telephony.TelephonyManager
import io.flutter.plugin.common.EventChannel

class PhoneStateReceiver(private val events: EventChannel.EventSink?) : BroadcastReceiver() {

    private var callStart: Long = 0L

    override fun onReceive(context: Context?, intent: Intent?) {
        val state = intent?.getStringExtra(TelephonyManager.EXTRA_STATE)
        when (state) {
            TelephonyManager.EXTRA_STATE_OFFHOOK -> {
                callStart = System.currentTimeMillis()
                events?.success(mapOf("status" to "OFFHOOK", "duration" to 0))
            }
            TelephonyManager.EXTRA_STATE_IDLE -> {
                val duration = if (callStart > 0) ((System.currentTimeMillis() - callStart) / 1000).toInt() else 0
                callStart = 0
                events?.success(mapOf("status" to "IDLE", "duration" to duration))
            }
            TelephonyManager.EXTRA_STATE_RINGING -> {
                events?.success(mapOf("status" to "RINGING", "duration" to 0))
            }
        }
    }
}
