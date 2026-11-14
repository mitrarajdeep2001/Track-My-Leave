package com.example.holiday_tracker

import androidx.core.content.FileProvider

/**
 * Shares backup files from the app cache with other apps (OneDrive, email…).
 * A subclass so it cannot clash with FileProviders declared by plugins.
 */
class BackupFileProvider : FileProvider()
