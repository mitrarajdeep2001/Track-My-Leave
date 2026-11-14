package com.example.holiday_tracker

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.ClipData
import android.content.Intent
import android.content.pm.PackageManager
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.os.Build
import android.provider.ContactsContract
import android.provider.OpenableColumns
import androidx.core.content.FileProvider
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.io.File

class MainActivity : FlutterActivity() {
    private var pendingPick: MethodChannel.Result? = null
    private var pendingBackupPick: MethodChannel.Result? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        MethodChannel(messenger, CONTACTS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "pickPhone" -> pickPhone(result)
                else -> result.notImplemented()
            }
        }
        MethodChannel(messenger, BACKUP_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "listStorageApps" -> listStorageApps(result)
                "saveToApp" -> saveToApp(
                    call.argument<String>("package"),
                    call.argument<String>("fileName"),
                    call.argument<ByteArray>("bytes"),
                    result,
                )
                "pickFile" -> pickBackupFile(call.argument<String>("package"), result)
                else -> result.notImplemented()
            }
        }
    }

    // ---- Contacts ------------------------------------------------------------

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

    // ---- Backup storage apps -------------------------------------------------

    private fun query(intent: Intent): List<ResolveInfo> =
        if (Build.VERSION.SDK_INT >= 33) {
            packageManager.queryIntentActivities(intent, PackageManager.ResolveInfoFlags.of(0))
        } else {
            @Suppress("DEPRECATION")
            packageManager.queryIntentActivities(intent, 0)
        }

    private fun getContentIntent() = Intent(Intent.ACTION_GET_CONTENT).apply {
        addCategory(Intent.CATEGORY_OPENABLE)
        type = JSON
    }

    /**
     * Storage apps are apps that can both receive a file (ACTION_SEND) and
     * hand one back (ACTION_GET_CONTENT): Google Drive, OneDrive, JioCloud,
     * Dropbox and so on. Requiring both leaves out chat and email apps, so
     * the same list works for saving and restoring.
     */
    private fun listStorageApps(result: MethodChannel.Result) {
        Thread {
            try {
                val excluded = setOf(packageName, "com.google.android.documentsui", "com.android.documentsui")
                val pickers = query(getContentIntent()).map { it.activityInfo.packageName }.toSet()
                val senders = query(Intent(Intent.ACTION_SEND).apply { type = JSON })
                val apps = senders
                    .map { it.activityInfo.packageName }
                    .distinct()
                    .filter { it in pickers && it !in excluded }
                    .map { pkg ->
                        val info = packageManager.getApplicationInfo(pkg, 0)
                        mapOf(
                            "package" to pkg,
                            "label" to packageManager.getApplicationLabel(info).toString(),
                            "icon" to iconPng(pkg),
                        )
                    }
                    .sortedBy { (it["label"] as String).lowercase() }
                runOnUiThread { result.success(apps) }
            } catch (e: Exception) {
                runOnUiThread { result.error("list_failed", "Could not list storage apps", null) }
            }
        }.start()
    }

    private fun iconPng(pkg: String): ByteArray? = try {
        val d = packageManager.getApplicationIcon(pkg)
        val size = 96
        val bmp = Bitmap.createBitmap(size, size, Bitmap.Config.ARGB_8888)
        d.setBounds(0, 0, size, size)
        d.draw(Canvas(bmp))
        ByteArrayOutputStream().also { bmp.compress(Bitmap.CompressFormat.PNG, 100, it) }.toByteArray()
    } catch (e: Exception) {
        null
    }

    /** Sends the backup file straight to one storage app's upload screen. */
    private fun saveToApp(pkg: String?, fileName: String?, bytes: ByteArray?, result: MethodChannel.Result) {
        if (pkg == null || !SAFE_PACKAGE.matches(pkg) ||
            fileName == null || !SAFE_NAME.matches(fileName) || bytes == null
        ) {
            result.error("bad_args", "Invalid backup file", null)
            return
        }
        try {
            val dir = File(cacheDir, "shared").apply { mkdirs() }
            // Keep only the file being saved.
            dir.listFiles()?.forEach { it.delete() }
            val file = File(dir, fileName).apply { writeBytes(bytes) }
            val uri = FileProvider.getUriForFile(this, "$packageName.backupfiles", file)
            val send = Intent(Intent.ACTION_SEND).apply {
                type = JSON
                setPackage(pkg)
                putExtra(Intent.EXTRA_STREAM, uri)
                putExtra(Intent.EXTRA_SUBJECT, fileName)
                putExtra(Intent.EXTRA_TITLE, fileName)
                clipData = ClipData.newRawUri(fileName, uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            startActivity(send)
            result.success(true)
        } catch (e: ActivityNotFoundException) {
            result.error("unavailable", "That app can no longer receive files", null)
        } catch (e: Exception) {
            result.error("save_failed", "Could not hand the backup to that app", null)
        }
    }

    /**
     * Opens a backup file, filtered to JSON so only backup files are offered
     * where the storage app supports filtering. With [pkg], that app's own
     * picker opens; without it, the system file picker for this phone.
     */
    private fun pickBackupFile(pkg: String?, result: MethodChannel.Result) {
        if (pendingBackupPick != null) {
            result.error("busy", "The file picker is already open", null)
            return
        }
        if (pkg != null && !SAFE_PACKAGE.matches(pkg)) {
            result.error("bad_args", "Invalid app", null)
            return
        }
        val intent = if (pkg == null) {
            Intent(Intent.ACTION_OPEN_DOCUMENT).apply {
                addCategory(Intent.CATEGORY_OPENABLE)
                type = JSON
            }
        } else {
            getContentIntent().apply { setPackage(pkg) }
        }
        pendingBackupPick = result
        try {
            startActivityForResult(intent, REQUEST_PICK_BACKUP)
        } catch (e: ActivityNotFoundException) {
            pendingBackupPick = null
            result.error("unavailable", "That app can no longer open files", null)
        }
    }

    // ---- Results -------------------------------------------------------------

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            REQUEST_PICK_PHONE -> onPhonePicked(resultCode, data)
            REQUEST_PICK_BACKUP -> onBackupPicked(resultCode, data)
        }
    }

    private fun onPhonePicked(resultCode: Int, data: Intent?) {
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

    private fun onBackupPicked(resultCode: Int, data: Intent?) {
        val result = pendingBackupPick ?: return
        pendingBackupPick = null

        val uri = data?.data
        if (resultCode != Activity.RESULT_OK || uri == null) {
            result.success(null)
            return
        }
        // Cloud apps may download the file first, so read off the UI thread.
        Thread {
            try {
                var name: String? = null
                contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)
                    ?.use { c -> if (c.moveToFirst()) name = c.getString(0) }

                val out = ByteArrayOutputStream()
                var tooLarge = false
                contentResolver.openInputStream(uri)?.use { input ->
                    val buf = ByteArray(64 * 1024)
                    while (true) {
                        val n = input.read(buf)
                        if (n < 0) break
                        out.write(buf, 0, n)
                        if (out.size() > MAX_BACKUP_BYTES) {
                            tooLarge = true
                            break
                        }
                    }
                } ?: throw IllegalStateException("no stream")

                runOnUiThread {
                    if (tooLarge) {
                        result.error("too_large", "That file is too large to be a TrackMyLeave backup.", null)
                    } else {
                        result.success(mapOf("name" to name, "bytes" to out.toByteArray()))
                    }
                }
            } catch (e: Exception) {
                runOnUiThread { result.error("read_failed", "Could not open that file", null) }
            }
        }.start()
    }

    companion object {
        private const val CONTACTS_CHANNEL = "trackmyleave/contacts"
        private const val BACKUP_CHANNEL = "trackmyleave/backup"
        private const val REQUEST_PICK_PHONE = 4711
        private const val REQUEST_PICK_BACKUP = 4712
        private const val MAX_BACKUP_BYTES = 5 * 1024 * 1024
        private const val JSON = "application/json"
        private val SAFE_NAME = Regex("^[A-Za-z0-9._-]{1,100}$")
        private val SAFE_PACKAGE = Regex("^[A-Za-z0-9_.]{1,200}$")
    }
}
