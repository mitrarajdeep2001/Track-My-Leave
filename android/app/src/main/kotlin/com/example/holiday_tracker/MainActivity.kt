package com.example.holiday_tracker

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Intent
import android.provider.ContactsContract
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private var pendingPick: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CONTACTS_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "pickPhone" -> pickPhone(result)
                    else -> result.notImplemented()
                }
            }
    }

    /**
     * Opens the system contact picker for phone numbers. The picker grants
     * temporary read access to the chosen entry only, so no READ_CONTACTS
     * permission is needed.
     */
    private fun pickPhone(result: MethodChannel.Result) {
        if (pendingPick != null) {
            result.error("busy", "The contact picker is already open", null)
            return
        }
        val intent = Intent(Intent.ACTION_PICK, ContactsContract.CommonDataKinds.Phone.CONTENT_URI)
        pendingPick = result
        try {
            startActivityForResult(intent, REQUEST_PICK_PHONE)
        } catch (e: ActivityNotFoundException) {
            pendingPick = null
            result.error("unavailable", "No contacts app found on this phone", null)
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if (requestCode != REQUEST_PICK_PHONE) return
        val result = pendingPick ?: return
        pendingPick = null

        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return
        }
        try {
            val projection = arrayOf(
                ContactsContract.CommonDataKinds.Phone.NUMBER,
                ContactsContract.CommonDataKinds.Phone.DISPLAY_NAME,
            )
            contentResolver.query(uri, projection, null, null, null)?.use { c ->
                if (c.moveToFirst()) {
                    result.success(mapOf("number" to c.getString(0), "name" to c.getString(1)))
                    return
                }
            }
            result.success(null)
        } catch (e: Exception) {
            result.error("read_failed", "Could not read that contact", null)
        }
    }

    companion object {
        private const val CONTACTS_CHANNEL = "trackmyleave/contacts"
        private const val REQUEST_PICK_PHONE = 4711
    }
}
