#!/usr/bin/env bash
set -e

echo "=== Generating Redesigned & Fixed Elamal v4.0.0 (com.nanomks.elamal) ==="

mkdir -p app/src/main/java/com/nanomks/elamal/data
mkdir -p app/src/main/java/com/nanomks/elamal/util
mkdir -p app/src/main/java/com/nanomks/elamal/widget
mkdir -p app/src/main/java/com/nanomks/elamal/ui
mkdir -p app/src/main/res/values
mkdir -p app/src/main/res/xml
mkdir -p app/src/main/res/layout
mkdir -p app/src/main/res/drawable
mkdir -p app/src/main/res/mipmap-anydpi-v26

# 1. settings.gradle.kts
cat << 'EOF' > settings.gradle.kts
pluginManagement {
    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}
dependencyResolutionManagement {
    repositoriesMode.set(RepositoriesMode.FAIL_ON_PROJECT_REPOS)
    repositories {
        google()
        mavenCentral()
    }
}
rootProject.name = "Elamal"
include(":app")
EOF

# 2. root build.gradle.kts
cat << 'EOF' > build.gradle.kts
plugins {
    id("com.android.application") version "8.3.2" apply false
    id("org.jetbrains.kotlin.android") version "1.9.23" apply false
    id("com.google.devtools.ksp") version "1.9.23-1.0.20" apply false
}
EOF

# 3. gradle.properties
cat << 'EOF' > gradle.properties
org.gradle.jvmargs=-Xmx3072m -Dfile.encoding=UTF-8
android.useAndroidX=true
android.nonTransitiveRClass=true
kotlin.code.style=official
EOF

# 4. app/build.gradle.kts
cat << 'EOF' > app/build.gradle.kts
plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.devtools.ksp")
}

android {
    namespace = "com.nanomks.elamal"
    compileSdk = 34

    defaultConfig {
        applicationId = "com.nanomks.elamal"
        minSdk = 26
        targetSdk = 34
        versionCode = 4
        versionName = "4.0.0"

        vectorDrawables {
            useSupportLibrary = true
        }
    }

    signingConfigs {
        create("release") {
            val ksFile = System.getenv("KEYSTORE_FILE")
            if (!ksFile.isNullOrEmpty() && file(ksFile).exists()) {
                storeFile = file(ksFile)
                storePassword = System.getenv("KEYSTORE_PASSWORD")
                keyAlias = System.getenv("KEY_ALIAS")
                keyPassword = System.getenv("KEY_PASSWORD")
            }
        }
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            val ksFile = System.getenv("KEYSTORE_FILE")
            if (!ksFile.isNullOrEmpty() && file(ksFile).exists()) {
                signingConfig = signingConfigs.getByName("release")
            }
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        debug {
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    kotlinOptions {
        jvmTarget = "17"
    }
    buildFeatures {
        compose = true
    }
    composeOptions {
        kotlinCompilerExtensionVersion = "1.5.11"
    }
    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

dependencies {
    val composeBom = platform("androidx.compose:compose-bom:2024.04.01")
    implementation(composeBom)
    implementation("androidx.core:core-ktx:1.12.0")
    implementation("androidx.fragment:fragment-ktx:1.6.2")
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.biometric:biometric:1.1.0")
    implementation("androidx.documentfile:documentfile:1.0.1")

    val roomVersion = "2.6.1"
    implementation("androidx.room:room-runtime:$roomVersion")
    implementation("androidx.room:room-ktx:$roomVersion")
    ksp("androidx.room:room-compiler:$roomVersion")
}
EOF

# 5. Resources: strings.xml, themes.xml, file_paths.xml
cat << 'EOF' > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">العمل</string>
    <string name="widget_name">ودجت العمل</string>
</resources>
EOF

cat << 'EOF' > app/src/main/res/values/themes.xml
<resources>
    <style name="Theme.Elamal" parent="android:Theme.Material.Light.NoActionBar">
        <item name="android:statusBarColor">#0F172A</item>
    </style>
</resources>
EOF

cat << 'EOF' > app/src/main/res/xml/file_paths.xml
<?xml version="1.0" encoding="utf-8"?>
<paths>
    <cache-path name="shared_reports" path="reports/" />
    <files-path name="internal_files" path="." />
</paths>
EOF

# 6. Adaptive Icons
cat << 'EOF' > app/src/main/res/drawable/ic_launcher_background.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path android:fillColor="#059669" android:pathData="M0,0h108v108h-108z"/>
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher_background_alt.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path android:fillColor="#1E3A8A" android:pathData="M0,0h108v108h-108z"/>
</vector>
EOF

cat << 'EOF' > app/src/main/res/drawable/ic_launcher_foreground.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M54,28A26,26 0,1 0,80 54A26,26 0,0 0,54 28ZM54,74A20,20 0,1 1,74 54A20,20 0,0 1,54 74ZM56,40H51V56L64,63L66.5,59L56,53.2V40Z"/>
</vector>
EOF

cat << 'EOF' > app/src/main/res/mipmap-anydpi-v26/ic_launcher.xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
    <monochrome android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
EOF

cat << 'EOF' > app/src/main/res/mipmap-anydpi-v26/ic_launcher_alt.xml
<?xml version="1.0" encoding="utf-8"?>
<adaptive-icon xmlns:android="http://schemas.android.com/apk/res/android">
    <background android:drawable="@drawable/ic_launcher_background_alt"/>
    <foreground android:drawable="@drawable/ic_launcher_foreground"/>
    <monochrome android:drawable="@drawable/ic_launcher_foreground"/>
</adaptive-icon>
EOF

# 7. Widget Rounded Background & Layout
cat << 'EOF' > app/src/main/res/drawable/widget_bg_ready.xml
<?xml version="1.0" encoding="utf-8"?>
<shape xmlns:android="http://schemas.android.com/apk/res/android" android:shape="rectangle">
    <solid android:color="#0F172A" />
    <corners android:radius="16dp" />
</shape>
EOF

cat << 'EOF' > app/src/main/res/layout/widget_elamal.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="@drawable/widget_bg_ready"
    android:gravity="center"
    android:orientation="vertical"
    android:padding="12dp">

    <TextView
        android:id="@+id/widget_title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="العمل • تتبع الساعات"
        android:textColor="#94A3B8"
        android:textSize="11sp" />

    <TextView
        android:id="@+id/widget_status"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="4dp"
        android:gravity="center"
        android:text="اضغط لتسجيل الدخول"
        android:textColor="#FFFFFF"
        android:textSize="14sp"
        android:textStyle="bold" />
</LinearLayout>
EOF

cat << 'EOF' > app/src/main/res/xml/widget_info.xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/widget_elamal"
    android:minWidth="130dp"
    android:minHeight="60dp"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />
EOF

# 8. AndroidManifest.xml
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
    <uses-permission android:name="android.permission.USE_BIOMETRIC" />

    <application
        android:allowBackup="true"
        android:icon="@mipmap/ic_launcher"
        android:label="@string/app_name"
        android:roundIcon="@mipmap/ic_launcher"
        android:supportsRtl="true"
        android:theme="@style/Theme.Elamal">

        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:theme="@style/Theme.Elamal">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
            </intent-filter>
        </activity>

        <activity-alias
            android:name=".LauncherDefault"
            android:enabled="true"
            android:exported="true"
            android:icon="@mipmap/ic_launcher"
            android:label="@string/app_name"
            android:targetActivity=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity-alias>

        <activity-alias
            android:name=".LauncherAlt"
            android:enabled="false"
            android:exported="true"
            android:icon="@mipmap/ic_launcher_alt"
            android:label="@string/app_name"
            android:targetActivity=".MainActivity">
            <intent-filter>
                <action android:name="android.intent.action.MAIN" />
                <category android:name="android.intent.category.LAUNCHER" />
            </intent-filter>
        </activity-alias>

        <receiver
            android:name=".widget.ElamalWidgetReceiver"
            android:exported="true">
            <intent-filter>
                <action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
                <action android:name="com.nanomks.elamal.ACTION_WIDGET_CLICK" />
                <action android:name="com.nanomks.elamal.ACTION_WIDGET_RESET_TAP" />
                <action android:name="com.nanomks.elamal.ACTION_FORGOT_CLOCK_OUT" />
                <action android:name="com.nanomks.elamal.ACTION_WIFI_DISCONNECT_TIMEOUT" />
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_info" />
        </receiver>

        <provider
            android:name="androidx.core.content.FileProvider"
            android:authorities="${applicationId}.fileprovider"
            android:exported="false"
            android:grantUriPermissions="true">
            <meta-data
                android:name="android.support.FILE_PROVIDER_PATHS"
                android:resource="@xml/file_paths" />
        </provider>
    </application>
</manifest>
EOF

# 9. Database Entities & DAO
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/data/Entities.kt
package com.nanomks.elamal.data

import androidx.room.*

enum class EntryType {
    HOURLY, REMOTE, CREDIT
}

@Entity(tableName = "work_entries", indices = [Index(value = ["eventUuid"], unique = true)])
data class WorkEntry(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val type: EntryType,
    val startTime: Long,
    val endTime: Long?,
    val breakMinutes: Int = 0,
    val hourlyRateAtEntry: Double = 10.0,
    val calculatedAmount: Double = 0.0,
    val note: String = "",
    val settlementId: Long? = null,
    val isDeleted: Boolean = false,
    val eventUuid: String? = null
)

@Entity(tableName = "settlements")
data class Settlement(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val timestamp: Long,
    val entriesTotal: Double,
    val previousCarryOver: Double,
    val amountPaid: Double,
    val nextCarryOver: Double,
    val note: String = ""
)

@Entity(tableName = "wifi_sessions")
data class WifiSession(
    @PrimaryKey(autoGenerate = true) val id: Long = 0,
    val ssid: String,
    val startTime: Long,
    val endTime: Long,
    val status: String = "PENDING", // PENDING, ADDED, IGNORED
    val isOpen: Boolean = false
)
EOF

cat << 'EOF' > app/src/main/java/com/nanomks/elamal/data/ElamalDao.kt
package com.nanomks.elamal.data

import androidx.room.*
import kotlinx.coroutines.flow.Flow
import java.math.BigDecimal
import java.math.RoundingMode

@Dao
interface ElamalDao {
    @Query("SELECT * FROM work_entries WHERE isDeleted = 0 AND settlementId IS NULL ORDER BY startTime DESC")
    fun getActiveEntries(): Flow<List<WorkEntry>>

    @Query("SELECT * FROM work_entries WHERE isDeleted = 0 ORDER BY startTime DESC")
    fun getAllNonDeletedEntriesFlow(): Flow<List<WorkEntry>>

    @Query("SELECT * FROM work_entries WHERE isDeleted = 0 ORDER BY startTime DESC")
    suspend fun getAllEntriesSync(): List<WorkEntry>

    @Query("SELECT * FROM work_entries WHERE eventUuid = :uuid LIMIT 1")
    suspend fun getEntryByUuid(uuid: String): WorkEntry?

    @Query("SELECT * FROM settlements ORDER BY timestamp DESC")
    fun getAllSettlements(): Flow<List<Settlement>>

    @Query("SELECT * FROM settlements ORDER BY timestamp ASC")
    suspend fun getSettlementsAsc(): List<Settlement>

    @Query("SELECT * FROM wifi_sessions WHERE status != 'IGNORED' ORDER BY startTime DESC")
    fun getVisibleWifiSessions(): Flow<List<WifiSession>>

    @Query("SELECT * FROM wifi_sessions ORDER BY endTime DESC LIMIT 1")
    suspend fun getLatestWifiSessionSync(): WifiSession?

    @Insert(onConflict = OnConflictStrategy.IGNORE)
    suspend fun insertEntry(entry: WorkEntry): Long

    @Update
    suspend fun updateEntry(entry: WorkEntry)

    @Query("DELETE FROM work_entries")
    suspend fun clearEntries()

    @Query("DELETE FROM settlements")
    suspend fun clearSettlements()

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertSettlement(settlement: Settlement): Long

    @Update
    suspend fun updateSettlement(settlement: Settlement)

    @Delete
    suspend fun deleteSettlement(settlement: Settlement)

    @Query("UPDATE work_entries SET settlementId = :settlementId WHERE isDeleted = 0 AND settlementId IS NULL AND endTime IS NOT NULL")
    suspend fun attachEntriesToSettlement(settlementId: Long)

    @Query("UPDATE work_entries SET settlementId = NULL WHERE settlementId = :settlementId")
    suspend fun detachEntriesFromSettlement(settlementId: Long)

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertWifiSession(session: WifiSession): Long

    @Update
    suspend fun updateWifiSession(session: WifiSession)

    @Query("UPDATE wifi_sessions SET status = 'IGNORED' WHERE status = 'PENDING'")
    suspend fun ignoreAllPendingWifi()

    @Transaction
    suspend fun recalculateSettlementsCascade() {
        val list = getSettlementsAsc()
        var runningCarry = 0.0
        for (s in list) {
            val netDue = roundMoney(s.entriesTotal + runningCarry)
            val nextCarry = roundMoney(netDue - s.amountPaid)
            if (s.previousCarryOver != runningCarry || s.nextCarryOver != nextCarry) {
                updateSettlement(s.copy(previousCarryOver = runningCarry, nextCarryOver = nextCarry))
            }
            runningCarry = nextCarry
        }
    }

    private fun roundMoney(value: Double): Double {
        return BigDecimal.valueOf(value).setScale(2, RoundingMode.HALF_UP).toDouble()
    }
}

@Database(entities = [WorkEntry::class, Settlement::class, WifiSession::class], version = 4, exportSchema = false)
abstract class ElamalDatabase : RoomDatabase() {
    abstract fun dao(): ElamalDao

    companion object {
        @Volatile
        private var INSTANCE: ElamalDatabase? = null

        fun getInstance(context: android.content.Context): ElamalDatabase {
            return INSTANCE ?: synchronized(this) {
                Room.databaseBuilder(
                    context.applicationContext,
                    ElamalDatabase::class.java,
                    "elamal_db"
                ).fallbackToDestructiveMigration().build().also { INSTANCE = it }
            }
        }
    }
}
EOF

# 10. ElamalUtils: Multi-Fallback Root Wi-Fi Reader (Magisk/KernelSU compatible), 10m Merger, AES-GCM, Formatters
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/util/ElamalUtils.kt
package com.nanomks.elamal.util

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import com.nanomks.elamal.data.ElamalDao
import com.nanomks.elamal.data.EntryType
import com.nanomks.elamal.data.WifiSession
import com.nanomks.elamal.data.WorkEntry
import com.nanomks.elamal.widget.ElamalWidgetReceiver
import kotlinx.coroutines.delay
import org.json.JSONArray
import java.io.BufferedReader
import java.io.DataOutputStream
import java.io.InputStreamReader
import java.math.BigDecimal
import java.math.RoundingMode
import java.security.SecureRandom
import java.text.SimpleDateFormat
import java.util.Base64
import java.util.Date
import java.util.Locale
import javax.crypto.Cipher
import javax.crypto.SecretKeyFactory
import javax.crypto.spec.GCMParameterSpec
import javax.crypto.spec.PBEKeySpec
import javax.crypto.spec.SecretKeySpec

object ElamalUtils {

    fun calculateHourlyPay(startMillis: Long, endMillis: Long, breakMinutes: Int, hourlyRate: Double): Double {
        val totalMinutes = ((endMillis - startMillis) / 60000L) - breakMinutes
        if (totalMinutes <= 0) return 0.0
        val raw = (totalMinutes.toDouble() / 60.0) * hourlyRate
        return BigDecimal.valueOf(raw).setScale(2, RoundingMode.HALF_UP).toDouble()
    }

    fun formatDurationArabic(minutesTotal: Long): String {
        val safeMin = minutesTotal.coerceAtLeast(0)
        val h = safeMin / 60
        val m = safeMin % 60
        return "${h} س ${m} د"
    }

    fun formatMoney(amount: Double): String {
        return String.format(Locale.US, "%.2f DH", amount)
    }

    /**
     * Multi-fallback Root Wi-Fi SSID reader:
     * Opens interactive `su` shell (triggers Magisk/KernelSU grant popup if needed)
     * and checks `cmd wifi status`, `dumpsys wifi`, `wpa_cli`, and `iw`.
     */
    fun getConnectedSsidViaRoot(): String? {
        return try {
            val process = Runtime.getRuntime().exec("su")
            val os = DataOutputStream(process.outputStream)
            os.writeBytes("cmd wifi status\n")
            os.writeBytes("dumpsys wifi | grep -E 'mWifiInfo|SSID'\n")
            os.writeBytes("iw dev wlan0 link | grep SSID\n")
            os.writeBytes("exit\n")
            os.flush()

            val output = BufferedReader(InputStreamReader(process.inputStream)).readText()
            process.waitFor()

            // Pattern 1: SSID: "MyNetwork"
            val p1 = Regex("""SSID:\s*"([^"]+)"""")
            p1.find(output)?.groupValues?.getOrNull(1)?.let {
                if (it.isNotBlank() && it != "<unknown ssid>" && it != "0x") return it.trim()
            }

            // Pattern 2: SSID: MyNetwork, BSSID: ...
            val p2 = Regex("""SSID:\s*([^,\n"]+)""")
            p2.find(output)?.groupValues?.getOrNull(1)?.let {
                val cleaned = it.trim()
                if (cleaned.isNotBlank() && cleaned != "<unknown ssid>" && cleaned != "null" && cleaned != "0x") {
                    return cleaned
                }
            }
            null
        } catch (e: Exception) {
            null
        }
    }

    suspend fun pollAndMergeRootWifi(context: Context, dao: ElamalDao): String? {
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
        val configuredList = (prefs.getString("work_ssids", "") ?: "")
            .split(",")
            .map { it.trim() }
            .filter { it.isNotEmpty() }
            .take(6)

        val currentSsid = getConnectedSsidViaRoot()
        val now = System.currentTimeMillis()
        val isWorkWifi = currentSsid != null && configuredList.any { it.equals(currentSsid, ignoreCase = true) }

        val latest = dao.getLatestWifiSessionSync()

        if (isWorkWifi && currentSsid != null) {
            cancelWifiDisconnectTimeout(context)

            if (latest != null && latest.status == "PENDING") {
                val gapMillis = now - latest.endTime
                if (latest.isOpen || gapMillis <= 10 * 60_000L) {
                    val mergedSsid = if (latest.ssid.split("+").any { it.equals(currentSsid, ignoreCase = true) }) {
                        latest.ssid
                    } else {
                        "${latest.ssid}+$currentSsid"
                    }
                    // Ensure at least 1 minute duration so user sees progress immediately
                    val safeEnd = maxOf(now, latest.startTime + 60_000L)
                    dao.updateWifiSession(latest.copy(ssid = mergedSsid, endTime = safeEnd, isOpen = true))
                    return currentSsid
                }
            }
            dao.insertWifiSession(
                WifiSession(
                    ssid = currentSsid,
                    startTime = now,
                    endTime = now + 60_000L,
                    status = "PENDING",
                    isOpen = true
                )
            )
        } else {
            if (latest != null && latest.isOpen) {
                if (now - latest.endTime >= 10 * 60_000L) {
                    dao.updateWifiSession(latest.copy(isOpen = false))
                } else {
                    scheduleWifiDisconnectTimeout(context, latest.endTime + 10 * 60_000L)
                }
            }
        }
        return currentSsid
    }

    private fun scheduleWifiDisconnectTimeout(context: Context, triggerAtMillis: Long) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ElamalWidgetReceiver::class.java).apply {
            action = "com.nanomks.elamal.ACTION_WIFI_DISCONNECT_TIMEOUT"
        }
        val pi = PendingIntent.getBroadcast(
            context, 303, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        am.set(AlarmManager.RTC, triggerAtMillis, pi)
    }

    private fun cancelWifiDisconnectTimeout(context: Context) {
        val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ElamalWidgetReceiver::class.java).apply {
            action = "com.nanomks.elamal.ACTION_WIFI_DISCONNECT_TIMEOUT"
        }
        val pi = PendingIntent.getBroadcast(
            context, 303, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        am.cancel(pi)
    }

    suspend fun processPendingWidgetEventsOnAppOpen(context: Context, dao: ElamalDao) {
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
        val queueJson = prefs.getString("widget_event_queue", "[]") ?: "[]"
        val arr = runCatching { JSONArray(queueJson) }.getOrNull() ?: return
        if (arr.length() == 0) return

        val savedUuids = mutableListOf<String>()
        for (i in 0 until arr.length()) {
            val o = arr.getJSONObject(i)
            val uuid = o.getString("uuid")
            val start = o.getLong("startTime")
            val end = o.getLong("endTime")
            val rate = o.getDouble("rate")
            val pay = calculateHourlyPay(start, end, 0, rate)

            if (dao.getEntryByUuid(uuid) == null) {
                dao.insertEntry(
                    WorkEntry(
                        type = EntryType.HOURLY,
                        startTime = start,
                        endTime = end,
                        hourlyRateAtEntry = rate,
                        calculatedAmount = pay,
                        note = "تسجيل تلقائي من الودجت",
                        eventUuid = uuid
                    )
                )
            }
            savedUuids.add(uuid)
        }

        delay(8000L)

        val currentJson = prefs.getString("widget_event_queue", "[]") ?: "[]"
        val currentArr = runCatching { JSONArray(currentJson) }.getOrNull() ?: JSONArray()
        val remainingArr = JSONArray()
        for (i in 0 until currentArr.length()) {
            val o = currentArr.getJSONObject(i)
            if (o.getString("uuid") !in savedUuids) {
                remainingArr.put(o)
            }
        }
        prefs.edit().putString("widget_event_queue", remainingArr.toString()).apply()
    }

    fun scheduleForgotClockOutAlarm(context: Context, startMillis: Long) {
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
        val limitHours = prefs.getInt("forgot_alarm_hours", 12).coerceIn(0, 48)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ElamalWidgetReceiver::class.java).apply {
            action = "com.nanomks.elamal.ACTION_FORGOT_CLOCK_OUT"
        }
        val pi = PendingIntent.getBroadcast(
            context, 202, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        if (limitHours == 0) {
            alarmManager.cancel(pi)
            return
        }
        val triggerAt = startMillis + (limitHours * 3600_000L)
        alarmManager.set(AlarmManager.RTC_WAKEUP, triggerAt, pi)
    }

    fun cancelForgotClockOutAlarm(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, ElamalWidgetReceiver::class.java).apply {
            action = "com.nanomks.elamal.ACTION_FORGOT_CLOCK_OUT"
        }
        val pi = PendingIntent.getBroadcast(
            context, 202, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pi)
    }

    fun encryptBackup(plainJson: String, password: String): String {
        if (password.isBlank()) return plainJson
        val salt = ByteArray(16).apply { SecureRandom().nextBytes(this) }
        val iv = ByteArray(12).apply { SecureRandom().nextBytes(this) }
        val spec = PBEKeySpec(password.toCharArray(), salt, 10000, 256)
        val secret = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).encoded
        val keySpec = SecretKeySpec(secret, "AES")
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.ENCRYPT_MODE, keySpec, GCMParameterSpec(128, iv))
        val encrypted = cipher.doFinal(plainJson.toByteArray(Charsets.UTF_8))
        val enc = Base64.getEncoder()
        return "ELAMAL_ENC_V1:" + enc.encodeToString(salt) + ":" + enc.encodeToString(iv) + ":" + enc.encodeToString(encrypted)
    }

    fun decryptBackup(payload: String, password: String): String {
        if (!payload.startsWith("ELAMAL_ENC_V1:")) return payload
        val parts = payload.split(":")
        require(parts.size == 4) { "ملف مشفر غير صالح" }
        val dec = Base64.getDecoder()
        val salt = dec.decode(parts[1])
        val iv = dec.decode(parts[2])
        val cipherBytes = dec.decode(parts[3])
        val spec = PBEKeySpec(password.toCharArray(), salt, 10000, 256)
        val secret = SecretKeyFactory.getInstance("PBKDF2WithHmacSHA256").generateSecret(spec).encoded
        val keySpec = SecretKeySpec(secret, "AES")
        val cipher = Cipher.getInstance("AES/GCM/NoPadding")
        cipher.init(Cipher.DECRYPT_MODE, keySpec, GCMParameterSpec(128, iv))
        return String(cipher.doFinal(cipherBytes), Charsets.UTF_8)
    }

    fun buildWhatsappFormattedText(entries: List<WorkEntry>, totalNet: Double, carryOver: Double): String {
        val df = SimpleDateFormat("yyyy-MM-dd", Locale.US)
        val sb = StringBuilder()
        sb.append("*📊 ملخص تطبيق «العمل»*\n")
        sb.append("━━━━━━━━━━━━━━\n")
        var totalMins = 0L
        if (entries.isEmpty()) {
            sb.append("لا توجد سجلات نشطة حالياً.\n")
        } else {
            for (e in entries) {
                val dateStr = df.format(Date(e.startTime))
                val typeStr = when (e.type) {
                    EntryType.HOURLY -> {
                        val m = if (e.endTime != null) ((e.endTime - e.startTime) / 60000L) - e.breakMinutes else 0L
                        totalMins += m.coerceAtLeast(0)
                        "ساعات (${formatDurationArabic(m)})"
                    }
                    EntryType.REMOTE -> "عمل عن بعد"
                    EntryType.CREDIT -> "كريدي (-)"
                }
                val notePart = if (e.note.isNotBlank()) " - ${e.note}" else ""
                sb.append("• $dateStr | $typeStr: *${formatMoney(e.calculatedAmount)}*$notePart\n")
            }
        }
        sb.append("━━━━━━━━━━━━━━\n")
        sb.append("⏱ *مجموع الساعات:* ${formatDurationArabic(totalMins)}\n")
        if (carryOver != 0.0) {
            sb.append("🔄 *رصيد مرحّل:* ${formatMoney(carryOver)}\n")
        }
        sb.append("💰 *الصافي المستحق:* *${formatMoney(totalNet)}*")
        return sb.toString()
    }
}
EOF

# 11. PDF & CSV Generator (Fixed Share Intent ClipData & NEW_TASK so it works on all Android devices)
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/util/PdfReportGenerator.kt
package com.nanomks.elamal.util

import android.content.ClipData
import android.content.Context
import android.content.Intent
import android.graphics.*
import android.graphics.pdf.PdfDocument
import android.widget.Toast
import androidx.core.content.FileProvider
import com.nanomks.elamal.data.EntryType
import com.nanomks.elamal.data.Settlement
import com.nanomks.elamal.data.WorkEntry
import java.io.File
import java.io.FileOutputStream
import java.text.SimpleDateFormat
import java.util.*

object PdfReportGenerator {

    fun generateAndSharePdf(
        context: Context,
        reportTitle: String,
        entries: List<WorkEntry>,
        settlements: List<Settlement>,
        isDarkMode: Boolean
    ) {
        try {
            val doc = PdfDocument()
            val pageWidth = 595
            val pageHeight = 842

            val bgColor = if (isDarkMode) Color.parseColor("#0F172A") else Color.parseColor("#FFFFFF")
            val textColor = if (isDarkMode) Color.parseColor("#F8FAFC") else Color.parseColor("#0F172A")
            val subTextColor = if (isDarkMode) Color.parseColor("#94A3B8") else Color.parseColor("#475569")
            val gridColor = if (isDarkMode) Color.parseColor("#334155") else Color.parseColor("#CBD5E1")
            val headerBg = if (isDarkMode) Color.parseColor("#1E293B") else Color.parseColor("#F1F5F9")

            val paint = Paint(Paint.ANTI_ALIAS_FLAG)
            val dfDateTime = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US)
            val dfDate = SimpleDateFormat("yyyy-MM-dd", Locale.US)

            var totalHourlyMinutes = 0L
            var totalRemote = 0.0
            var totalCredit = 0.0
            var netTotal = 0.0
            for (e in entries) {
                netTotal += e.calculatedAmount
                when (e.type) {
                    EntryType.HOURLY -> {
                        if (e.endTime != null) {
                            totalHourlyMinutes += (((e.endTime - e.startTime) / 60000L) - e.breakMinutes).coerceAtLeast(0)
                        }
                    }
                    EntryType.REMOTE -> totalRemote += e.calculatedAmount
                    EntryType.CREDIT -> totalCredit += e.calculatedAmount
                }
            }

            val chunks = if (entries.isEmpty()) listOf(emptyList()) else entries.chunked(20)

            chunks.forEachIndexed { pageIndex, pageEntries ->
                val pageInfo = PdfDocument.PageInfo.Builder(pageWidth, pageHeight, pageIndex + 1).create()
                val page = doc.startPage(pageInfo)
                val canvas = page.canvas
                canvas.drawColor(bgColor)

                paint.style = Paint.Style.FILL
                paint.color = textColor
                paint.textSize = 18f
                paint.typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
                paint.textAlign = Paint.Align.RIGHT
                canvas.drawText(
                    "تقرير «العمل» - $reportTitle (${pageIndex + 1}/${chunks.size})",
                    (pageWidth - 36).toFloat(),
                    46f,
                    paint
                )

                var y = 68f
                if (pageIndex == 0) {
                    val cardTop = 65f
                    val cardBottom = 130f
                    val cardW = 165f

                    // Card 1: Net Total
                    paint.color = if (isDarkMode) Color.parseColor("#064E3B") else Color.parseColor("#D1FAE5")
                    canvas.drawRoundRect(RectF(pageWidth - 36f - cardW, cardTop, pageWidth - 36f, cardBottom), 10f, 10f, paint)
                    paint.color = if (isDarkMode) Color.parseColor("#34D399") else Color.parseColor("#065F46")
                    paint.textSize = 11f
                    canvas.drawText("الصافي الإجمالي", pageWidth - 48f, cardTop + 24f, paint)
                    paint.textSize = 15f
                    canvas.drawText(ElamalUtils.formatMoney(netTotal), pageWidth - 48f, cardTop + 48f, paint)

                    // Card 2: Total Hours («23 س 58 د»)
                    val c2Right = pageWidth - 36f - cardW - 14f
                    paint.color = if (isDarkMode) Color.parseColor("#1E3A8A") else Color.parseColor("#DBEAFE")
                    canvas.drawRoundRect(RectF(c2Right - cardW, cardTop, c2Right, cardBottom), 10f, 10f, paint)
                    paint.color = if (isDarkMode) Color.parseColor("#60A5FA") else Color.parseColor("#1E40AF")
                    paint.textSize = 11f
                    canvas.drawText("مجموع الساعات", c2Right - 12f, cardTop + 24f, paint)
                    paint.textSize = 15f
                    canvas.drawText(ElamalUtils.formatDurationArabic(totalHourlyMinutes), c2Right - 12f, cardTop + 48f, paint)

                    // Card 3: Credit & Remote
                    val c3Right = c2Right - cardW - 14f
                    paint.color = if (isDarkMode) Color.parseColor("#7F1D1D") else Color.parseColor("#FEE2E2")
                    canvas.drawRoundRect(RectF(36f, cardTop, c3Right, cardBottom), 10f, 10f, paint)
                    paint.color = if (isDarkMode) Color.parseColor("#F87171") else Color.parseColor("#991B1B")
                    paint.textSize = 11f
                    canvas.drawText("الكريدي / عن بعد", c3Right - 12f, cardTop + 24f, paint)
                    paint.textSize = 13f
                    canvas.drawText("${String.format(Locale.US, "%.1f", totalCredit)} / +${String.format(Locale.US, "%.1f", totalRemote)}", c3Right - 12f, cardTop + 48f, paint)

                    y = 152f
                }

                val leftX = 36f
                val rightX = pageWidth - 36f
                val rowH = 26f
                val col1 = rightX - 95f
                val col2 = col1 - 80f
                val col3 = col2 - 95f
                val col4 = col3 - 150f

                // Table Header
                paint.style = Paint.Style.FILL
                paint.color = headerBg
                canvas.drawRect(leftX, y, rightX, y + rowH, paint)
                paint.color = gridColor
                paint.style = Paint.Style.STROKE
                paint.strokeWidth = 1f
                canvas.drawRect(leftX, y, rightX, y + rowH, paint)
                canvas.drawLine(col1, y, col1, y + rowH, paint)
                canvas.drawLine(col2, y, col2, y + rowH, paint)
                canvas.drawLine(col3, y, col3, y + rowH, paint)
                canvas.drawLine(col4, y, col4, y + rowH, paint)

                paint.style = Paint.Style.FILL
                paint.color = textColor
                paint.textSize = 11f
                canvas.drawText("التاريخ", rightX - 8f, y + 17f, paint)
                canvas.drawText("النوع", col1 - 8f, y + 17f, paint)
                canvas.drawText("المدة", col2 - 8f, y + 17f, paint)
                canvas.drawText("الملاحظة", col3 - 8f, y + 17f, paint)
                canvas.drawText("الأجرة", col4 - 8f, y + 17f, paint)
                y += rowH

                for (e in pageEntries) {
                    paint.style = Paint.Style.STROKE
                    paint.color = gridColor
                    canvas.drawRect(leftX, y, rightX, y + rowH, paint)
                    canvas.drawLine(col1, y, col1, y + rowH, paint)
                    canvas.drawLine(col2, y, col2, y + rowH, paint)
                    canvas.drawLine(col3, y, col3, y + rowH, paint)
                    canvas.drawLine(col4, y, col4, y + rowH, paint)

                    paint.style = Paint.Style.FILL
                    paint.color = textColor
                    paint.typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
                    canvas.drawText(dfDate.format(Date(e.startTime)), rightX - 8f, y + 17f, paint)

                    val badgeBg = when (e.type) {
                        EntryType.HOURLY -> Color.parseColor("#059669")
                        EntryType.REMOTE -> Color.parseColor("#2563EB")
                        EntryType.CREDIT -> Color.parseColor("#DC2626")
                    }
                    val badgeTxt = when (e.type) {
                        EntryType.HOURLY -> "ساعات"
                        EntryType.REMOTE -> "عن بعد"
                        EntryType.CREDIT -> "كريدي"
                    }
                    paint.color = badgeBg
                    canvas.drawRoundRect(RectF(col2 + 8f, y + 4f, col1 - 8f, y + rowH - 4f), 6f, 6f, paint)
                    paint.color = Color.WHITE
                    paint.textSize = 10f
                    canvas.drawText(badgeTxt, col1 - 14f, y + 17f, paint)

                    paint.color = textColor
                    paint.textSize = 10f
                    val durStr = if (e.type == EntryType.HOURLY && e.endTime != null) {
                        val mins = ((e.endTime - e.startTime) / 60000L) - e.breakMinutes
                        ElamalUtils.formatDurationArabic(mins)
                    } else "-"
                    canvas.drawText(durStr, col2 - 8f, y + 17f, paint)

                    canvas.drawText(e.note.take(22), col3 - 8f, y + 17f, paint)

                    paint.typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
                    paint.color = if (e.calculatedAmount < 0) Color.parseColor("#EF4444") else textColor
                    canvas.drawText(ElamalUtils.formatMoney(e.calculatedAmount), col4 - 8f, y + 17f, paint)

                    y += rowH
                }

                if (pageIndex == chunks.lastIndex) {
                    paint.style = Paint.Style.FILL
                    paint.color = headerBg
                    canvas.drawRect(leftX, y, rightX, y + rowH, paint)
                    paint.style = Paint.Style.STROKE
                    paint.color = gridColor
                    canvas.drawRect(leftX, y, rightX, y + rowH, paint)

                    paint.style = Paint.Style.FILL
                    paint.color = textColor
                    paint.typeface = Typeface.create(Typeface.DEFAULT, Typeface.BOLD)
                    paint.textSize = 11f
                    canvas.drawText("المجموع النهائي", rightX - 8f, y + 17f, paint)
                    canvas.drawText(ElamalUtils.formatDurationArabic(totalHourlyMinutes), col2 - 8f, y + 17f, paint)
                    canvas.drawText(ElamalUtils.formatMoney(netTotal), col4 - 8f, y + 17f, paint)
                }

                paint.color = subTextColor
                paint.textSize = 10f
                paint.typeface = Typeface.create(Typeface.DEFAULT, Typeface.NORMAL)
                canvas.drawText(
                    "تطبيق «العمل» (com.nanomks.elamal) - تاريخ الإنشاء: ${dfDateTime.format(Date())}",
                    rightX,
                    pageHeight - 28f,
                    paint
                )

                doc.finishPage(page)
            }

            val reportsDir = File(context.cacheDir, "reports").apply { mkdirs() }
            val pdfFile = File(reportsDir, "Elamal_Report_${System.currentTimeMillis()}.pdf")
            FileOutputStream(pdfFile).use { doc.writeTo(it) }
            doc.close()

            val uri = FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", pdfFile)
            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                type = "application/pdf"
                putExtra(Intent.EXTRA_STREAM, uri)
                clipData = ClipData.newRawUri("PDF Report", uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            val chooser = Intent.createChooser(shareIntent, "مشاركة تقرير PDF").apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(chooser)
        } catch (e: Exception) {
            Toast.makeText(context, "خطأ أثناء إنشاء PDF: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }

    fun exportAndShareCsv(context: Context, entries: List<WorkEntry>) {
        try {
            val reportsDir = File(context.cacheDir, "reports").apply { mkdirs() }
            val csvFile = File(reportsDir, "Elamal_Export_${System.currentTimeMillis()}.csv")
            val df = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US)

            FileOutputStream(csvFile).use { fos ->
                fos.write(byteArrayOf(0xEF.toByte(), 0xBB.toByte(), 0xBF.toByte()))
                val sb = StringBuilder()
                sb.append("المعرف,النوع,البداية,النهاية,الاستراحة(د),المدة,الأجرة(DH),الملاحظة\n")
                for (e in entries) {
                    val mins = if (e.endTime != null) ((e.endTime - e.startTime) / 60000L) - e.breakMinutes else 0L
                    val dur = if (e.type == EntryType.HOURLY) ElamalUtils.formatDurationArabic(mins) else "-"
                    val endStr = e.endTime?.let { df.format(Date(it)) } ?: ""
                    val cleanNote = e.note.replace(",", " ")
                    sb.append("${e.id},${e.type},${df.format(Date(e.startTime))},$endStr,${e.breakMinutes},$dur,${e.calculatedAmount},$cleanNote\n")
                }
                fos.write(sb.toString().toByteArray(Charsets.UTF_8))
            }

            val uri = FileProvider.getUriForFile(context, "${context.packageName}.fileprovider", csvFile)
            val shareIntent = Intent(Intent.ACTION_SEND).apply {
                type = "text/csv"
                putExtra(Intent.EXTRA_STREAM, uri)
                clipData = ClipData.newRawUri("CSV Export", uri)
                addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            val chooser = Intent.createChooser(shareIntent, "تصدير CSV").apply {
                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            }
            context.startActivity(chooser)
        } catch (e: Exception) {
            Toast.makeText(context, "خطأ أثناء تصدير CSV: ${e.message}", Toast.LENGTH_LONG).show()
        }
    }
}
EOF

# 12. Smart SAF Backup Manager
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/util/BackupSafManager.kt
package com.nanomks.elamal.util

import android.content.Context
import android.net.Uri
import androidx.documentfile.provider.DocumentFile
import com.nanomks.elamal.data.*
import org.json.JSONArray
import org.json.JSONObject

object BackupSafManager {

    suspend fun performSmartBackup(
        context: Context,
        dao: ElamalDao,
        isManual: Boolean = false
    ): String {
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
        val uriStr = prefs.getString("backup_uri", "") ?: ""
        if (uriStr.isBlank()) return "اختر مجلد النسخ الاحتياطي من الإعدادات لحفظ نسخك تلقائياً"

        val treeUri = Uri.parse(uriStr)
        val dir = DocumentFile.fromTreeUri(context, treeUri) ?: return "تعذر الوصول إلى مجلد النسخ"

        val entries = dao.getAllEntriesSync()
        val settlements = dao.getSettlementsAsc()
        val activeClockIn = prefs.getLong("active_clock_in", 0L)

        val prevEntriesCount = prefs.getInt("last_backup_entries_count", 0)
        val prevSettlementsCount = prefs.getInt("last_backup_settlements_count", 0)
        val prevHadClockIn = prefs.getBoolean("last_backup_had_clockin", false)

        if (entries.isEmpty() && settlements.isEmpty() && activeClockIn == 0L && (prevEntriesCount > 0 || prevSettlementsCount > 0)) {
            return "حماية تلقائية: تم منع الكتابة بنسخة فارغة فوق نسخة تحتوي على بيانات!"
        }

        val dataDecreased = (entries.size < prevEntriesCount) ||
                (settlements.size < prevSettlementsCount) ||
                (prevHadClockIn && activeClockIn == 0L && entries.size <= prevEntriesCount)

        val mainFile = dir.findFile("elamal_auto_backup.json")
        if (!isManual && dataDecreased && mainFile != null) {
            val prevContent = readUriText(context, mainFile.uri)
            if (prevContent.isNotBlank()) {
                val slot = (prefs.getInt("safety_slot_index", 0) % 5) + 1
                prefs.edit().putInt("safety_slot_index", slot).apply()
                val safetyName = "elamal_safety_slot_${slot}.json"
                writeToDocumentFile(context, dir, safetyName, prevContent)
            }
        }

        val root = JSONObject()
        root.put("version", 4)
        root.put("timestamp", System.currentTimeMillis())
        root.put("activeClockIn", activeClockIn)
        root.put("hourlyRate", prefs.getFloat("hourly_rate", 10f).toDouble())

        val entriesArr = JSONArray()
        for (e in entries) {
            val obj = JSONObject().apply {
                put("id", e.id)
                put("type", e.type.name)
                put("startTime", e.startTime)
                put("endTime", e.endTime ?: -1L)
                put("breakMinutes", e.breakMinutes)
                put("hourlyRateAtEntry", e.hourlyRateAtEntry)
                put("calculatedAmount", e.calculatedAmount)
                put("note", e.note)
                put("settlementId", e.settlementId ?: -1L)
            }
            entriesArr.put(obj)
        }
        root.put("entries", entriesArr)

        val settlementsArr = JSONArray()
        for (s in settlements) {
            val obj = JSONObject().apply {
                put("id", s.id)
                put("timestamp", s.timestamp)
                put("entriesTotal", s.entriesTotal)
                put("previousCarryOver", s.previousCarryOver)
                put("amountPaid", s.amountPaid)
                put("nextCarryOver", s.nextCarryOver)
                put("note", s.note)
            }
            settlementsArr.put(obj)
        }
        root.put("settlements", settlementsArr)

        val rawJson = root.toString(2)
        val encEnabled = prefs.getBoolean("backup_encrypt_enabled", false)
        val encPass = prefs.getString("backup_password", "") ?: ""
        val finalPayload = if (encEnabled && encPass.isNotBlank()) {
            ElamalUtils.encryptBackup(rawJson, encPass)
        } else {
            rawJson
        }

        val targetFileName = if (isManual) {
            "elamal_manual_${System.currentTimeMillis()}.json"
        } else {
            "elamal_auto_backup.json"
        }

        val writtenUri = writeToDocumentFile(context, dir, targetFileName, finalPayload)
            ?: return "فشل إنشاء ملف النسخة الاحتياطية"

        val verifyRead = readUriText(context, writtenUri)
        if (verifyRead != finalPayload) {
            return "تحذير: فشل التحقق من سلامة الملف بعد الكتابة!"
        }

        prefs.edit()
            .putInt("last_backup_entries_count", entries.size)
            .putInt("last_backup_settlements_count", settlements.size)
            .putBoolean("last_backup_had_clockin", activeClockIn > 0L)
            .putLong("last_backup_time", System.currentTimeMillis())
            .apply()

        return if (dataDecreased && !isManual) {
            "تم الحفظ وتدوير نسخة أمان (بسبب رصد نقص بيانات) ✓"
        } else {
            "تم النسخ الاحتياطي والتحقق من سلامته بنجاح ✓"
        }
    }

    suspend fun restoreFromBackup(context: Context, dao: ElamalDao, fileName: String = "elamal_auto_backup.json"): String {
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
        val uriStr = prefs.getString("backup_uri", "") ?: ""
        if (uriStr.isBlank()) return "اختر مجلد النسخ أولاً"
        val dir = DocumentFile.fromTreeUri(context, Uri.parse(uriStr)) ?: return "المجلد غير متاح"
        val target = dir.findFile(fileName) ?: return "الملف $fileName غير موجود"

        performSmartBackup(context, dao, isManual = true)

        val content = readUriText(context, target.uri)
        val pass = prefs.getString("backup_password", "") ?: ""
        val jsonStr = try {
            ElamalUtils.decryptBackup(content, pass)
        } catch (e: Exception) {
            return "فشل فك التشفير: تأكد من كلمة مرور النسخ الاحتياطي"
        }

        return try {
            val root = JSONObject(jsonStr)
            dao.clearEntries()
            dao.clearSettlements()

            val entriesArr = root.getJSONArray("entries")
            for (i in 0 until entriesArr.length()) {
                val o = entriesArr.getJSONObject(i)
                val endT = o.getLong("endTime").let { if (it == -1L) null else it }
                val setId = o.getLong("settlementId").let { if (it == -1L) null else it }
                dao.insertEntry(
                    WorkEntry(
                        id = o.getLong("id"),
                        type = EntryType.valueOf(o.getString("type")),
                        startTime = o.getLong("startTime"),
                        endTime = endT,
                        breakMinutes = o.getInt("breakMinutes"),
                        hourlyRateAtEntry = o.getDouble("hourlyRateAtEntry"),
                        calculatedAmount = o.getDouble("calculatedAmount"),
                        note = o.getString("note"),
                        settlementId = setId
                    )
                )
            }

            val settlementsArr = root.getJSONArray("settlements")
            for (i in 0 until settlementsArr.length()) {
                val o = settlementsArr.getJSONObject(i)
                dao.insertSettlement(
                    Settlement(
                        id = o.getLong("id"),
                        timestamp = o.getLong("timestamp"),
                        entriesTotal = o.getDouble("entriesTotal"),
                        previousCarryOver = o.getDouble("previousCarryOver"),
                        amountPaid = o.getDouble("amountPaid"),
                        nextCarryOver = o.getDouble("nextCarryOver"),
                        note = o.getString("note")
                    )
                )
            }
            "تمت الاستعادة بنجاح (مع حفظ نسخة أمان قبل الاستعادة) ✓"
        } catch (e: Exception) {
            "خطأ أثناء قراءة بيانات النسخة: ${e.message}"
        }
    }

    fun listAvailableBackups(context: Context): List<String> {
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
        val uriStr = prefs.getString("backup_uri", "") ?: return emptyList()
        if (uriStr.isBlank()) return emptyList()
        val dir = DocumentFile.fromTreeUri(context, Uri.parse(uriStr)) ?: return emptyList()
        return dir.listFiles().mapNotNull { it.name }.filter { it.startsWith("elamal_") }.sortedDescending()
    }

    private fun writeToDocumentFile(context: Context, dir: DocumentFile, name: String, content: String): Uri? {
        dir.findFile(name)?.delete()
        val doc = dir.createFile("application/json", name) ?: return null
        context.contentResolver.openOutputStream(doc.uri)?.use {
            it.write(content.toByteArray(Charsets.UTF_8))
        }
        return doc.uri
    }

    private fun readUriText(context: Context, uri: Uri): String {
        return context.contentResolver.openInputStream(uri)?.bufferedReader(Charsets.UTF_8)?.use { it.readText() } ?: ""
    }
}
EOF

# 13. Widget Receiver
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/widget/ElamalWidgetReceiver.kt
package com.nanomks.elamal.widget

import android.app.AlarmManager
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import com.nanomks.elamal.R
import com.nanomks.elamal.data.ElamalDatabase
import com.nanomks.elamal.util.ElamalUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import org.json.JSONArray
import org.json.JSONObject
import java.util.UUID

class ElamalWidgetReceiver : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            updateWidgetUi(context, appWidgetManager, id)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)

        when (intent.action) {
            "com.nanomks.elamal.ACTION_WIDGET_RESET_TAP" -> {
                refreshAllWidgets(context)
            }
            "com.nanomks.elamal.ACTION_FORGOT_CLOCK_OUT" -> {
                val activeStart = prefs.getLong("active_clock_in", 0L)
                if (activeStart > 0L) {
                    showForgotClockOutNotification(context)
                }
            }
            "com.nanomks.elamal.ACTION_WIFI_DISCONNECT_TIMEOUT" -> {
                CoroutineScope(Dispatchers.IO).launch {
                    val dao = ElamalDatabase.getInstance(context).dao()
                    ElamalUtils.pollAndMergeRootWifi(context, dao)
                }
            }
            "com.nanomks.elamal.ACTION_WIDGET_CLICK" -> {
                val isEnabled = prefs.getBoolean("widget_enabled", true)
                if (!isEnabled) return

                val now = System.currentTimeMillis()
                val lastSave = prefs.getLong("widget_last_save", 0L)
                if (now - lastSave < 8000L) return

                val firstTap = prefs.getLong("widget_first_tap", 0L)
                if (now - firstTap <= 60_000L) {
                    prefs.edit().putLong("widget_first_tap", 0L).putLong("widget_last_save", now).apply()
                    val activeStart = prefs.getLong("active_clock_in", 0L)
                    if (activeStart == 0L) {
                        prefs.edit().putLong("active_clock_in", now).apply()
                        ElamalUtils.scheduleForgotClockOutAlarm(context, now)
                    } else {
                        val rate = prefs.getFloat("hourly_rate", 10f).toDouble()
                        prefs.edit().putLong("active_clock_in", 0L).apply()
                        ElamalUtils.cancelForgotClockOutAlarm(context)

                        val queueJson = prefs.getString("widget_event_queue", "[]") ?: "[]"
                        val arr = runCatching { JSONArray(queueJson) }.getOrDefault(JSONArray())
                        val ev = JSONObject().apply {
                            put("uuid", UUID.randomUUID().toString())
                            put("startTime", activeStart)
                            put("endTime", now)
                            put("rate", rate)
                        }
                        arr.put(ev)
                        prefs.edit().putString("widget_event_queue", arr.toString()).apply()
                    }
                } else {
                    prefs.edit().putLong("widget_first_tap", now).apply()
                    val am = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                    val resetIntent = Intent(context, ElamalWidgetReceiver::class.java).apply {
                        action = "com.nanomks.elamal.ACTION_WIDGET_RESET_TAP"
                    }
                    val pi = PendingIntent.getBroadcast(
                        context, 101, resetIntent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )
                    am.set(AlarmManager.RTC, now + 61_000L, pi)
                }
                refreshAllWidgets(context)
            }
        }
    }

    private fun showForgotClockOutNotification(context: Context) {
        val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        val channelId = "elamal_alerts"
        val channel = NotificationChannel(channelId, "تنبيهات العمل", NotificationManager.IMPORTANCE_HIGH)
        nm.createNotificationChannel(channel)
        val notif = NotificationCompat.Builder(context, channelId)
            .setSmallIcon(android.R.drawable.ic_lock_idle_alarm)
            .setContentTitle("تنبيه نسيان الخروج - العمل")
            .setContentText("لديك جلسة عمل جارية تجاوزت الحد المحدد! افتح التطبيق لتسجيل الخروج.")
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .build()
        nm.notify(901, notif)
    }

    companion object {
        fun refreshAllWidgets(context: Context) {
            val mgr = AppWidgetManager.getInstance(context)
            val ids = mgr.getAppWidgetIds(ComponentName(context, ElamalWidgetReceiver::class.java))
            for (id in ids) {
                updateWidgetUi(context, mgr, id)
            }
        }

        fun updateWidgetUi(context: Context, mgr: AppWidgetManager, appWidgetId: Int) {
            val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
            val enabled = prefs.getBoolean("widget_enabled", true)
            val activeStart = prefs.getLong("active_clock_in", 0L)
            val firstTap = prefs.getLong("widget_first_tap", 0L)
            val now = System.currentTimeMillis()

            val views = RemoteViews(context.packageName, R.layout.widget_elamal)
            if (!enabled) {
                views.setInt(R.id.widget_root, "setBackgroundColor", Color.parseColor("#64748B"))
                views.setTextViewText(R.id.widget_status, "معطّل")
            } else if (now - firstTap <= 60_000L) {
                views.setInt(R.id.widget_root, "setBackgroundColor", Color.parseColor("#D97706"))
                views.setTextViewText(R.id.widget_status, if (activeStart == 0L) "اضغط مجدداً لتأكيد الدخول (60ث)" else "اضغط مجدداً لتأكيد الخروج (60ث)")
            } else if (activeStart > 0L) {
                views.setInt(R.id.widget_root, "setBackgroundColor", Color.parseColor("#059669"))
                views.setTextViewText(R.id.widget_status, "دخول جارٍ.. اضغط للخروج")
            } else {
                views.setInt(R.id.widget_root, "setBackgroundColor", Color.parseColor("#0F172A"))
                views.setTextViewText(R.id.widget_status, "اضغط لتسجيل الدخول")
            }

            val clickIntent = Intent(context, ElamalWidgetReceiver::class.java).apply {
                action = "com.nanomks.elamal.ACTION_WIDGET_CLICK"
            }
            val pi = PendingIntent.getBroadcast(
                context, 0, clickIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.widget_root, pi)
            mgr.updateAppWidget(appWidgetId, views)
        }
    }
}
EOF

# 14. MainActivity (Redesigned Modern UI, 4 Bottom Tabs, Wi-Fi Settings inside Settings, Pending Wi-Fi Card on Home)
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/MainActivity.kt
package com.nanomks.elamal

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import android.net.NetworkRequest
import android.os.Build
import android.os.Bundle
import android.widget.Toast
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.biometric.BiometricPrompt
import androidx.compose.foundation.BorderStroke
import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.CornerRadius
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.geometry.Size
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.platform.LocalView
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.core.content.ContextCompat
import androidx.fragment.app.FragmentActivity
import com.nanomks.elamal.data.*
import com.nanomks.elamal.util.BackupSafManager
import com.nanomks.elamal.util.ElamalUtils
import com.nanomks.elamal.util.PdfReportGenerator
import com.nanomks.elamal.widget.ElamalWidgetReceiver
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : FragmentActivity() {

    private var networkCallback: ConnectivityManager.NetworkCallback? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        registerEconomicalWifiCallback()
        setContent {
            CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
                ElamalRootScreen(activity = this)
            }
        }
    }

    private fun registerEconomicalWifiCallback() {
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val dao = ElamalDatabase.getInstance(this).dao()
        val req = NetworkRequest.Builder()
            .addTransportType(NetworkCapabilities.TRANSPORT_WIFI)
            .build()

        val cb = object : ConnectivityManager.NetworkCallback() {
            override fun onAvailable(network: Network) {
                CoroutineScope(Dispatchers.IO).launch {
                    ElamalUtils.pollAndMergeRootWifi(applicationContext, dao)
                }
            }

            override fun onLost(network: Network) {
                CoroutineScope(Dispatchers.IO).launch {
                    ElamalUtils.pollAndMergeRootWifi(applicationContext, dao)
                }
            }
        }
        networkCallback = cb
        runCatching { cm.registerNetworkCallback(req, cb) }
    }

    override fun onDestroy() {
        super.onDestroy()
        val cm = getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        networkCallback?.let { runCatching { cm.unregisterNetworkCallback(it) } }
    }
}

@OptIn(ExperimentalMaterial3Api::class, ExperimentalLayoutApi::class)
@Composable
fun ElamalRootScreen(activity: FragmentActivity) {
    val context = LocalContext.current
    val view = LocalView.current
    val prefs = remember { context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE) }
    val db = remember { ElamalDatabase.getInstance(context) }
    val dao = remember { db.dao() }
    val scope = rememberCoroutineScope()

    val sysDark = isSystemInDarkTheme()
    var themeMode by remember { mutableIntStateOf(prefs.getInt("theme_mode", 0)) }
    val isDark = when (themeMode) {
        1 -> false
        2 -> true
        else -> sysDark
    }
    var dynamicColor by remember { mutableStateOf(prefs.getBoolean("dynamic_color", false)) }
    var appColorHex by remember { mutableStateOf(prefs.getString("app_color_hex", "#059669") ?: "#059669") }
    var fontScale by remember { mutableFloatStateOf(prefs.getFloat("font_scale", 1.0f)) }

    var hourlyRate by remember { mutableDoubleStateOf(prefs.getFloat("hourly_rate", 10.0f).toDouble()) }
    var activeClockIn by remember { mutableLongStateOf(prefs.getLong("active_clock_in", 0L)) }
    var widgetEnabled by remember { mutableStateOf(prefs.getBoolean("widget_enabled", true)) }
    var searchFilterEnabled by remember { mutableStateOf(prefs.getBoolean("search_filter_enabled", true)) }
    var forgotAlarmHours by remember { mutableIntStateOf(prefs.getInt("forgot_alarm_hours", 12)) }
    var workSsids by remember { mutableStateOf(prefs.getString("work_ssids", "") ?: "") }
    var backupUriStr by remember { mutableStateOf(prefs.getString("backup_uri", "") ?: "") }
    var firstRunDone by remember { mutableStateOf(prefs.getBoolean("first_run_done", false)) }

    var savedPin by remember { mutableStateOf(prefs.getString("security_pin", "") ?: "") }
    var isUnlocked by remember { mutableStateOf(savedPin.isBlank()) }
    var failedPinAttempts by remember { mutableIntStateOf(prefs.getInt("failed_pin_attempts", 0)) }
    var lockoutUntil by remember { mutableLongStateOf(prefs.getLong("lockout_until", 0L)) }

    val primaryCustom = runCatching { Color(android.graphics.Color.parseColor(appColorHex)) }.getOrDefault(Color(0xFF059669))

    // Rich, clean, high-contrast Light & Dark Color Schemes (Eliminates muddy olive/beige defaults!)
    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> {
            if (isDark) dynamicDarkColorScheme(context) else dynamicLightColorScheme(context)
        }
        isDark -> darkColorScheme(
            primary = primaryCustom,
            onPrimary = Color.White,
            secondary = Color(0xFF3B82F6),
            background = Color(0xFF0B1120),
            surface = Color(0xFF1E293B),
            surfaceVariant = Color(0xFF1E293B),
            onBackground = Color(0xFFF8FAFC),
            onSurface = Color(0xFFF8FAFC),
            onSurfaceVariant = Color(0xFFCBD5E1)
        )
        else -> lightColorScheme(
            primary = primaryCustom,
            onPrimary = Color.White,
            secondary = Color(0xFF2563EB),
            background = Color(0xFFF1F5F9),
            surface = Color(0xFFFFFFFF),
            surfaceVariant = Color(0xFFFFFFFF),
            onBackground = Color(0xFF0F172A),
            onSurface = Color(0xFF0F172A),
            onSurfaceVariant = Color(0xFF475569)
        )
    }

    LaunchedEffect(isDark, primaryCustom) {
        activity.window.statusBarColor = if (isDark) Color(0xFF0B1120).toArgb() else primaryCustom.toArgb()
    }

    val folderPicker = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
        if (uri != null) {
            context.contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )
            prefs.edit().putString("backup_uri", uri.toString()).putBoolean("first_run_done", true).apply()
            backupUriStr = uri.toString()
            firstRunDone = true
            Toast.makeText(context, "تم ربط مجلد النسخ الاحتياطي بنجاح ✓", Toast.LENGTH_SHORT).show()
        }
    }

    MaterialTheme(colorScheme = colorScheme) {
        // Security Lock Screen
        if (!isUnlocked) {
            var pinInput by remember { mutableStateOf("") }
            var pinError by remember { mutableStateOf("") }

            Surface(modifier = Modifier.fillMaxSize(), color = colorScheme.background) {
                Column(
                    modifier = Modifier.fillMaxSize().padding(28.dp),
                    verticalArrangement = Arrangement.Center,
                    horizontalAlignment = Alignment.CenterHorizontally
                ) {
                    Box(
                        modifier = Modifier.size(80.dp).background(primaryCustom.copy(alpha = 0.15f), CircleShape),
                        contentAlignment = Alignment.Center
                    ) {
                        Icon(Icons.Default.Lock, contentDescription = null, modifier = Modifier.size(42.dp), tint = primaryCustom)
                    }
                    Spacer(modifier = Modifier.height(16.dp))
                    Text("تطبيق «العمل» مقفل", fontSize = (22 * fontScale).sp, fontWeight = FontWeight.Bold)
                    Spacer(modifier = Modifier.height(20.dp))

                    OutlinedTextField(
                        value = pinInput,
                        onValueChange = { if (it.length <= 8 && it.all { c -> c.isDigit() }) pinInput = it },
                        label = { Text("رمز القفل (4 إلى 8 أرقام)") },
                        visualTransformation = PasswordVisualTransformation(),
                        keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.NumberPassword),
                        singleLine = true,
                        shape = RoundedCornerShape(14.dp)
                    )
                    if (pinError.isNotBlank()) {
                        Text(pinError, color = Color(0xFFEF4444), modifier = Modifier.padding(top = 8.dp))
                    }
                    Spacer(modifier = Modifier.height(20.dp))

                    Row(horizontalArrangement = Arrangement.spacedBy(12.dp)) {
                        Button(
                            onClick = {
                                val now = System.currentTimeMillis()
                                if (now < lockoutUntil) {
                                    val remSec = (lockoutUntil - now) / 1000L
                                    pinError = "تم تجاوز 7 محاولات! انتظر $remSec ثانية."
                                    return@Button
                                }
                                if (pinInput == savedPin) {
                                    failedPinAttempts = 0
                                    prefs.edit().putInt("failed_pin_attempts", 0).apply()
                                    isUnlocked = true
                                } else {
                                    failedPinAttempts += 1
                                    prefs.edit().putInt("failed_pin_attempts", failedPinAttempts).apply()
                                    if (failedPinAttempts >= 7) {
                                        lockoutUntil = now + 30_000L
                                        prefs.edit().putLong("lockout_until", lockoutUntil).apply()
                                        pinError = "7 محاولات خاطئة! تم تأخير الفتح 30 ثانية."
                                    } else {
                                        pinError = "رمز خاطئ ($failedPinAttempts / 7)"
                                    }
                                }
                            },
                            shape = RoundedCornerShape(12.dp)
                        ) { Text("فتح القفل") }

                        OutlinedButton(
                            onClick = {
                                val executor = ContextCompat.getMainExecutor(context)
                                val prompt = BiometricPrompt(activity, executor, object : BiometricPrompt.AuthenticationCallback() {
                                    override fun onAuthenticationSucceeded(result: BiometricPrompt.AuthenticationResult) {
                                        isUnlocked = true
                                    }
                                })
                                val info = BiometricPrompt.PromptInfo.Builder()
                                    .setTitle("فتح تطبيق العمل بالبصمة")
                                    .setSubtitle("استخدم البصمة كاختصار لفتح القفل")
                                    .setNegativeButtonText("إلغاء")
                                    .build()
                                prompt.authenticate(info)
                            },
                            shape = RoundedCornerShape(12.dp)
                        ) {
                            Icon(Icons.Default.Fingerprint, contentDescription = null)
                            Spacer(modifier = Modifier.width(6.dp))
                            Text("البصمة")
                        }
                    }
                }
            }
            return@MaterialTheme
        }

        // First Run Onboarding Dialog
        if (!firstRunDone) {
            AlertDialog(
                onDismissRequest = {},
                title = { Text("مرحباً بك في «العمل» 👋", fontWeight = FontWeight.Bold) },
                text = {
                    Text("لحماية ساعات عملك ودفعاتك تلقائياً، اختر مجلداً على هاتفك لحفظ النسخ الاحتياطية التلقائية (عبر SAF).")
                },
                confirmButton = {
                    Button(onClick = { folderPicker.launch(null) }) {
                        Text("اختيار مجلد النسخ الآن")
                    }
                },
                dismissButton = {
                    TextButton(onClick = {
                        prefs.edit().putBoolean("first_run_done", true).apply()
                        firstRunDone = true
                    }) { Text("لاحقاً من الإعدادات") }
                }
            )
        }

        val entries by dao.getActiveEntries().collectAsState(initial = emptyList())
        val allEntries by dao.getAllNonDeletedEntriesFlow().collectAsState(initial = emptyList())
        val settlements by dao.getAllSettlements().collectAsState(initial = emptyList())
        val wifiSessions by dao.getVisibleWifiSessions().collectAsState(initial = emptyList())
        val pendingWifiList = wifiSessions.filter { it.status == "PENDING" }

        // 4 Clean Bottom Tabs ONLY (Wi-Fi removed from Bottom Bar and integrated into Home Card + Settings!)
        var currentTab by remember { mutableIntStateOf(0) }
        var searchQuery by remember { mutableStateOf("") }
        var filterType by remember { mutableStateOf<EntryType?>(null) }
        var lastDeletedEntry by remember { mutableStateOf<WorkEntry?>(null) }
        var statusBanner by remember { mutableStateOf("") }

        // Dialog States
        var showClockOutDialog by remember { mutableStateOf(false) }
        var showRemoteDialog by remember { mutableStateOf(false) }
        var showCreditDialog by remember { mutableStateOf(false) }
        var showSettleDialog by remember { mutableStateOf(false) }
        var showCustomPeriodPdfDialog by remember { mutableStateOf(false) }
        var editingEntry by remember { mutableStateOf<WorkEntry?>(null) }
        var editingSettlement by remember { mutableStateOf<Settlement?>(null) }
        var confirmIgnoreAllWifi by remember { mutableStateOf(false) }

        var nowMillis by remember { mutableLongStateOf(System.currentTimeMillis()) }
        var detectedRootSsid by remember { mutableStateOf<String?>(null) }

        // Minute Ticker + Auto Widget Queue Sync on App Open
        LaunchedEffect(Unit) {
            withContext(Dispatchers.IO) {
                ElamalUtils.processPendingWidgetEventsOnAppOpen(context, dao)
            }
            while (true) {
                nowMillis = System.currentTimeMillis()
                activeClockIn = prefs.getLong("active_clock_in", 0L)
                withContext(Dispatchers.IO) {
                    detectedRootSsid = ElamalUtils.pollAndMergeRootWifi(context, dao)
                }
                delay(60_000L)
            }
        }

        Scaffold(
            containerColor = colorScheme.background,
            topBar = {
                TopAppBar(
                    colors = TopAppBarDefaults.topAppBarColors(
                        containerColor = colorScheme.surface,
                        titleContentColor = colorScheme.onSurface
                    ),
                    title = {
                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(10.dp)) {
                            Box(
                                modifier = Modifier
                                    .size(36.dp)
                                    .clip(RoundedCornerShape(10.dp))
                                    .background(primaryCustom),
                                contentAlignment = Alignment.Center
                            ) {
                                Icon(Icons.Default.AccessTime, contentDescription = null, tint = Color.White, modifier = Modifier.size(20.dp))
                            }
                            Column {
                                Text("العمل", fontSize = (19 * fontScale).sp, fontWeight = FontWeight.ExtraBold)
                                if (statusBanner.isNotBlank()) {
                                    Text(statusBanner, fontSize = 11.sp, color = primaryCustom)
                                }
                            }
                        }
                    },
                    actions = {
                        if (lastDeletedEntry != null) {
                            FilledTonalButton(
                                onClick = {
                                    val toRestore = lastDeletedEntry!!
                                    scope.launch {
                                        dao.updateEntry(toRestore.copy(isDeleted = false))
                                        lastDeletedEntry = null
                                        Toast.makeText(context, "تم التراجع عن الحذف ✓", Toast.LENGTH_SHORT).show()
                                    }
                                },
                                modifier = Modifier.padding(end = 8.dp)
                            ) {
                                Icon(Icons.Default.Undo, contentDescription = null, modifier = Modifier.size(16.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text("تراجع عن الحذف")
                            }
                        }
                    }
                )
            },
            bottomBar = {
                NavigationBar(
                    containerColor = colorScheme.surface,
                    tonalElevation = 8.dp
                ) {
                    NavigationBarItem(
                        selected = currentTab == 0,
                        onClick = { currentTab = 0 },
                        icon = { Icon(Icons.Default.AccessTime, contentDescription = null) },
                        label = { Text("الدفتر", fontWeight = if (currentTab == 0) FontWeight.Bold else FontWeight.Normal) }
                    )
                    NavigationBarItem(
                        selected = currentTab == 1,
                        onClick = { currentTab = 1 },
                        icon = { Icon(Icons.Default.AccountBalanceWallet, contentDescription = null) },
                        label = { Text("الدفعات", fontWeight = if (currentTab == 1) FontWeight.Bold else FontWeight.Normal) }
                    )
                    NavigationBarItem(
                        selected = currentTab == 2,
                        onClick = { currentTab = 2 },
                        icon = { Icon(Icons.Default.Assessment, contentDescription = null) },
                        label = { Text("التقارير", fontWeight = if (currentTab == 2) FontWeight.Bold else FontWeight.Normal) }
                    )
                    NavigationBarItem(
                        selected = currentTab == 3,
                        onClick = { currentTab = 3 },
                        icon = { Icon(Icons.Default.Settings, contentDescription = null) },
                        label = { Text("الإعدادات", fontWeight = if (currentTab == 3) FontWeight.Bold else FontWeight.Normal) }
                    )
                }
            }
        ) { innerPadding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding)
                    .padding(horizontal = 14.dp, vertical = 10.dp)
            ) {
                when (currentTab) {
                    0 -> {
                        // TAB 0: HOME & LEDGER
                        val lastCarryOver = settlements.firstOrNull()?.nextCarryOver ?: 0.0
                        val activeSum = entries.sumOf { it.calculatedAmount }
                        val totalNet = activeSum + lastCarryOver
                        val totalMinutesActive = entries.filter { it.type == EntryType.HOURLY && it.endTime != null }
                            .sumOf { (((it.endTime!! - it.startTime) / 60000L) - it.breakMinutes).coerceAtLeast(0) }

                        // Hero Financial Dashboard Card
                        Box(
                            modifier = Modifier
                                .fillMaxWidth()
                                .clip(RoundedCornerShape(20.dp))
                                .background(
                                    Brush.horizontalGradient(
                                        colors = listOf(primaryCustom, Color(0xFF047857))
                                    )
                                )
                                .padding(18.dp)
                        ) {
                            Column(modifier = Modifier.fillMaxWidth()) {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text("الصافي المستحق حالياً", color = Color.White.copy(alpha = 0.85f), fontSize = (14 * fontScale).sp)
                                    Surface(
                                        color = Color.White.copy(alpha = 0.2f),
                                        shape = RoundedCornerShape(20.dp)
                                    ) {
                                        Text(
                                            text = "⏱ ${ElamalUtils.formatDurationArabic(totalMinutesActive)}",
                                            color = Color.White,
                                            fontSize = (12 * fontScale).sp,
                                            fontWeight = FontWeight.Bold,
                                            modifier = Modifier.padding(horizontal = 10.dp, vertical = 4.dp)
                                        )
                                    }
                                }
                                Spacer(modifier = Modifier.height(6.dp))
                                CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Ltr) {
                                    Text(
                                        text = ElamalUtils.formatMoney(totalNet),
                                        fontSize = (32 * fontScale).sp,
                                        fontWeight = FontWeight.ExtraBold,
                                        color = Color.White
                                    )
                                }
                                if (lastCarryOver != 0.0) {
                                    Spacer(modifier = Modifier.height(4.dp))
                                    Text(
                                        text = "يشمل رصيداً مرحّلاً من الدفعة السابقة: ${ElamalUtils.formatMoney(lastCarryOver)}",
                                        color = Color.White.copy(alpha = 0.9f),
                                        fontSize = (12 * fontScale).sp
                                    )
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(12.dp))

                        // Main Action Buttons (Clock-In/Out + Remote + Credit)
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            Button(
                                onClick = {
                                    if (activeClockIn == 0L) {
                                        val now = System.currentTimeMillis()
                                        prefs.edit().putLong("active_clock_in", now).apply()
                                        activeClockIn = now
                                        ElamalUtils.scheduleForgotClockOutAlarm(context, now)
                                        ElamalWidgetReceiver.refreshAllWidgets(context)
                                        Toast.makeText(context, "بدأ حساب ساعات العمل ✓", Toast.LENGTH_SHORT).show()
                                    } else {
                                        showClockOutDialog = true
                                    }
                                },
                                modifier = Modifier.weight(1.3f).height(48.dp),
                                shape = RoundedCornerShape(14.dp),
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = if (activeClockIn == 0L) primaryCustom else Color(0xFFDC2626)
                                )
                            ) {
                                Icon(
                                    if (activeClockIn == 0L) Icons.Default.PlayArrow else Icons.Default.Stop,
                                    contentDescription = null,
                                    modifier = Modifier.size(18.dp)
                                )
                                Spacer(modifier = Modifier.width(6.dp))
                                val elapsedMin = if (activeClockIn > 0L) (nowMillis - activeClockIn) / 60000L else 0L
                                Text(
                                    text = if (activeClockIn == 0L) "تسجيل دخول" else "خروج (${ElamalUtils.formatDurationArabic(elapsedMin)})",
                                    fontWeight = FontWeight.Bold
                                )
                            }

                            FilledTonalButton(
                                onClick = { showRemoteDialog = true },
                                modifier = Modifier.height(48.dp),
                                shape = RoundedCornerShape(14.dp)
                            ) {
                                Icon(Icons.Default.Computer, contentDescription = null, modifier = Modifier.size(16.dp))
                                Spacer(modifier = Modifier.width(4.dp))
                                Text("عن بعد")
                            }

                            FilledTonalButton(
                                onClick = { showCreditDialog = true },
                                modifier = Modifier.height(48.dp),
                                shape = RoundedCornerShape(14.dp),
                                colors = ButtonDefaults.filledTonalButtonColors(
                                    containerColor = Color(0xFFFEE2E2),
                                    contentColor = Color(0xFF991B1B)
                                )
                            ) {
                                Text("كريدي (-)", fontWeight = FontWeight.Bold)
                            }
                        }

                        // Wi-Fi Sessions Pending Review Card right on the Home Screen!
                        if (wifiSessions.isNotEmpty()) {
                            Spacer(modifier = Modifier.height(12.dp))
                            ElevatedCard(
                                modifier = Modifier.fillMaxWidth(),
                                shape = RoundedCornerShape(16.dp),
                                colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                            ) {
                                Column(modifier = Modifier.padding(12.dp)) {
                                    Row(
                                        modifier = Modifier.fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                            Icon(Icons.Default.Wifi, contentDescription = null, tint = Color(0xFF2563EB))
                                            Text(
                                                "فترات واي فاي بانتظار المراجعة (${pendingWifiList.size})",
                                                fontWeight = FontWeight.Bold,
                                                fontSize = (14 * fontScale).sp
                                            )
                                        }
                                        if (pendingWifiList.isNotEmpty()) {
                                            TextButton(onClick = { confirmIgnoreAllWifi = true }) {
                                                Text("تجاهل الكل", color = Color(0xFFEF4444), fontSize = 12.sp)
                                            }
                                        }
                                    }

                                    wifiSessions.take(3).forEach { ws ->
                                        HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp), color = colorScheme.onSurface.copy(alpha = 0.08f))
                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Column {
                                                Text(ws.ssid, fontWeight = FontWeight.Bold, fontSize = 13.sp)
                                                val durMin = ((ws.endTime - ws.startTime) / 60000L).coerceAtLeast(1L)
                                                Text("المدة المقترحة: ${ElamalUtils.formatDurationArabic(durMin)}", fontSize = 12.sp, color = colorScheme.onSurfaceVariant)
                                            }
                                            if (ws.status == "ADDED") {
                                                Surface(color = Color(0xFFD1FAE5), shape = RoundedCornerShape(8.dp)) {
                                                    Text("أُضيفت ✓", color = Color(0xFF065F46), fontSize = 12.sp, fontWeight = FontWeight.Bold, modifier = Modifier.padding(horizontal = 8.dp, vertical = 4.dp))
                                                }
                                            } else {
                                                Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                                    Button(
                                                        onClick = {
                                                            scope.launch {
                                                                val pay = ElamalUtils.calculateHourlyPay(ws.startTime, ws.endTime, 0, hourlyRate)
                                                                dao.insertEntry(
                                                                    WorkEntry(
                                                                        type = EntryType.HOURLY,
                                                                        startTime = ws.startTime,
                                                                        endTime = ws.endTime,
                                                                        hourlyRateAtEntry = hourlyRate,
                                                                        calculatedAmount = pay,
                                                                        note = "حضور واي فاي (${ws.ssid})"
                                                                    )
                                                                )
                                                                dao.updateWifiSession(ws.copy(status = "ADDED"))
                                                            }
                                                        },
                                                        contentPadding = PaddingValues(horizontal = 12.dp, vertical = 4.dp),
                                                        shape = RoundedCornerShape(10.dp)
                                                    ) { Text("أضف", fontSize = 12.sp) }

                                                    OutlinedButton(
                                                        onClick = { scope.launch { dao.updateWifiSession(ws.copy(status = "IGNORED")) } },
                                                        contentPadding = PaddingValues(horizontal = 10.dp, vertical = 4.dp),
                                                        shape = RoundedCornerShape(10.dp)
                                                    ) { Text("تجاهل", fontSize = 12.sp) }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }

                        if (searchFilterEnabled) {
                            Spacer(modifier = Modifier.height(10.dp))
                            OutlinedTextField(
                                value = searchQuery,
                                onValueChange = { searchQuery = it },
                                placeholder = { Text("ابحث في الملاحظات...") },
                                leadingIcon = { Icon(Icons.Default.Search, contentDescription = null) },
                                trailingIcon = {
                                    if (searchQuery.isNotBlank()) {
                                        IconButton(onClick = { searchQuery = "" }) {
                                            Icon(Icons.Default.Clear, contentDescription = null)
                                        }
                                    }
                                },
                                modifier = Modifier.fillMaxWidth(),
                                singleLine = true,
                                shape = RoundedCornerShape(14.dp)
                            )
                            Row(
                                modifier = Modifier.fillMaxWidth().padding(vertical = 6.dp),
                                horizontalArrangement = Arrangement.spacedBy(6.dp)
                            ) {
                                FilterChip(selected = filterType == null, onClick = { filterType = null }, label = { Text("الكل (${entries.size})") })
                                FilterChip(selected = filterType == EntryType.HOURLY, onClick = { filterType = EntryType.HOURLY }, label = { Text("ساعات") })
                                FilterChip(selected = filterType == EntryType.REMOTE, onClick = { filterType = EntryType.REMOTE }, label = { Text("عن بعد") })
                                FilterChip(selected = filterType == EntryType.CREDIT, onClick = { filterType = EntryType.CREDIT }, label = { Text("كريدي") })
                            }
                        }

                        val filtered = entries.filter {
                            (!searchFilterEnabled || filterType == null || it.type == filterType) &&
                                    (!searchFilterEnabled || searchQuery.isBlank() || it.note.contains(searchQuery, ignoreCase = true))
                        }

                        if (filtered.isEmpty()) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                    Icon(Icons.Default.EventNote, contentDescription = null, modifier = Modifier.size(54.dp), tint = colorScheme.onSurfaceVariant.copy(alpha = 0.4f))
                                    Spacer(modifier = Modifier.height(8.dp))
                                    Text("لا توجد سجلات عمل في الدفتر حالياً", fontWeight = FontWeight.Bold, color = colorScheme.onSurfaceVariant)
                                    Text("اضغط على «تسجيل دخول» أو «عن بعد» أو «كريدي» للبدء", fontSize = 12.sp, color = colorScheme.onSurfaceVariant.copy(alpha = 0.7f))
                                }
                            }
                        } else {
                            LazyColumn(
                                modifier = Modifier.fillMaxSize(),
                                verticalArrangement = Arrangement.spacedBy(8.dp)
                            ) {
                                items(filtered, key = { it.id }) { item ->
                                    EntryRowCard(
                                        item = item,
                                        fontScale = fontScale,
                                        onEdit = { editingEntry = item },
                                        onDelete = {
                                            lastDeletedEntry = item
                                            scope.launch {
                                                dao.updateEntry(item.copy(isDeleted = true))
                                                statusBanner = BackupSafManager.performSmartBackup(context, dao)
                                            }
                                        }
                                    )
                                }
                            }
                        }
                    }

                    1 -> {
                        // TAB 1: SETTLEMENTS & ARCHIVE
                        val prevCarry = settlements.firstOrNull()?.nextCarryOver ?: 0.0
                        val entriesSum = entries.sumOf { it.calculatedAmount }
                        val netDue = entriesSum + prevCarry

                        ElevatedCard(
                            modifier = Modifier.fillMaxWidth(),
                            shape = RoundedCornerShape(18.dp),
                            colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                        ) {
                            Column(modifier = Modifier.padding(16.dp)) {
                                Text("الرصيد الجاهز للاستلام والأرشفة", fontSize = 13.sp, color = colorScheme.onSurfaceVariant)
                                Spacer(modifier = Modifier.height(4.dp))
                                Text(ElamalUtils.formatMoney(netDue), fontSize = 24.sp, fontWeight = FontWeight.ExtraBold, color = primaryCustom)
                                Spacer(modifier = Modifier.height(10.dp))
                                Button(
                                    onClick = { showSettleDialog = true },
                                    modifier = Modifier.fillMaxWidth().height(48.dp),
                                    shape = RoundedCornerShape(12.dp)
                                ) {
                                    Icon(Icons.Default.Payments, contentDescription = null)
                                    Spacer(modifier = Modifier.width(8.dp))
                                    Text("استلام دفعة جديدة وترحيل الفرق", fontWeight = FontWeight.Bold)
                                }
                                if (settlements.isNotEmpty()) {
                                    TextButton(
                                        onClick = {
                                            val latest = settlements.first()
                                            scope.launch {
                                                dao.detachEntriesFromSettlement(latest.id)
                                                dao.deleteSettlement(latest)
                                                dao.recalculateSettlementsCascade()
                                                statusBanner = BackupSafManager.performSmartBackup(context, dao)
                                                Toast.makeText(context, "تم التراجع عن آخر دفعة وإعادة السجلات للدفتر ✓", Toast.LENGTH_SHORT).show()
                                            }
                                        },
                                        modifier = Modifier.align(Alignment.End)
                                    ) {
                                        Icon(Icons.Default.Undo, contentDescription = null, modifier = Modifier.size(16.dp), tint = Color(0xFFEF4444))
                                        Spacer(modifier = Modifier.width(4.dp))
                                        Text("التراجع عن آخر دفعة", color = Color(0xFFEF4444))
                                    }
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(12.dp))
                        Text("أرشيف الدفعات السابقة (${settlements.size})", fontWeight = FontWeight.Bold, fontSize = (15 * fontScale).sp)
                        Spacer(modifier = Modifier.height(8.dp))

                        if (settlements.isEmpty()) {
                            Box(modifier = Modifier.fillMaxSize(), contentAlignment = Alignment.Center) {
                                Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                    Icon(Icons.Default.Inventory2, contentDescription = null, modifier = Modifier.size(54.dp), tint = colorScheme.onSurfaceVariant.copy(alpha = 0.4f))
                                    Spacer(modifier = Modifier.height(8.dp))
                                    Text("الأرشيف فارغ حالياً", fontWeight = FontWeight.Bold, color = colorScheme.onSurfaceVariant)
                                    Text("عند استلام دفعة، ستنتقل سجلاتها إلى هنا مع حفظ الرصيد المرحّل", fontSize = 12.sp, color = colorScheme.onSurfaceVariant.copy(alpha = 0.7f), textAlign = TextAlign.Center)
                                }
                            }
                        } else {
                            LazyColumn(verticalArrangement = Arrangement.spacedBy(10.dp)) {
                                items(settlements, key = { it.id }) { s ->
                                    ElevatedCard(
                                        modifier = Modifier.fillMaxWidth(),
                                        shape = RoundedCornerShape(16.dp),
                                        colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                    ) {
                                        Column(modifier = Modifier.padding(14.dp)) {
                                            val df = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US)
                                            Row(
                                                modifier = Modifier.fillMaxWidth(),
                                                horizontalArrangement = Arrangement.SpaceBetween,
                                                verticalAlignment = Alignment.CenterVertically
                                            ) {
                                                Text("دفعة ${df.format(Date(s.timestamp))}", fontWeight = FontWeight.Bold, fontSize = 15.sp)
                                                Row {
                                                    IconButton(onClick = {
                                                        val sEntries = allEntries.filter { it.settlementId == s.id }
                                                        PdfReportGenerator.generateAndSharePdf(context, "دفعة ${df.format(Date(s.timestamp))}", sEntries, listOf(s), isDark)
                                                    }) {
                                                        Icon(Icons.Default.PictureAsPdf, contentDescription = "PDF", tint = primaryCustom)
                                                    }
                                                    IconButton(onClick = { editingSettlement = s }) {
                                                        Icon(Icons.Default.Edit, contentDescription = "تعديل")
                                                    }
                                                }
                                            }
                                            HorizontalDivider(modifier = Modifier.padding(vertical = 6.dp), color = colorScheme.onSurface.copy(alpha = 0.08f))
                                            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                                                Text("مجموع السجلات: ${ElamalUtils.formatMoney(s.entriesTotal)}", fontSize = 13.sp)
                                                Text("مرحّل سابق: ${ElamalUtils.formatMoney(s.previousCarryOver)}", fontSize = 13.sp)
                                            }
                                            Spacer(modifier = Modifier.height(4.dp))
                                            Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                                                Text("المستلم: ${ElamalUtils.formatMoney(s.amountPaid)}", color = Color(0xFF059669), fontWeight = FontWeight.Bold)
                                                Text("المرحّل للقادم: ${ElamalUtils.formatMoney(s.nextCarryOver)}", color = Color(0xFFD97706), fontWeight = FontWeight.Bold)
                                            }
                                            if (s.note.isNotBlank()) {
                                                Spacer(modifier = Modifier.height(4.dp))
                                                Text("📝 ${s.note}", fontSize = 12.sp, color = colorScheme.onSurfaceVariant)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    2 -> {
                        // TAB 2: REPORTS, CHARTS & CALENDAR
                        val lastCarryOver = settlements.firstOrNull()?.nextCarryOver ?: 0.0
                        val activeSum = entries.sumOf { it.calculatedAmount }
                        val totalNet = activeSum + lastCarryOver

                        LazyColumn(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            item {
                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                            Icon(Icons.Default.PictureAsPdf, contentDescription = null, tint = primaryCustom)
                                            Text("تصدير ومشاركة تقارير PDF (${if (isDark) "وضع داكن" else "وضع فاتح"})", fontWeight = FontWeight.Bold)
                                        }
                                        val now = System.currentTimeMillis()
                                        val weekAgo = now - 7 * 86400_000L
                                        val monthAgo = now - 30 * 86400_000L

                                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Button(
                                                onClick = {
                                                    PdfReportGenerator.generateAndSharePdf(context, "تقرير أسبوع", allEntries.filter { it.startTime >= weekAgo }, settlements, isDark)
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("أسبوع") }

                                            Button(
                                                onClick = {
                                                    PdfReportGenerator.generateAndSharePdf(context, "تقرير شهري", allEntries.filter { it.startTime >= monthAgo }, settlements, isDark)
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("شهري") }

                                            Button(
                                                onClick = {
                                                    PdfReportGenerator.generateAndSharePdf(context, "الملخص النشط", entries, settlements, isDark)
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("الملخص") }
                                        }

                                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            OutlinedButton(
                                                onClick = {
                                                    val latestS = settlements.firstOrNull()
                                                    val sEntries = if (latestS != null) allEntries.filter { it.settlementId == latestS.id } else entries
                                                    PdfReportGenerator.generateAndSharePdf(context, "تقرير آخر دفعة", sEntries, settlements, isDark)
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("دفعة") }

                                            OutlinedButton(
                                                onClick = {
                                                    PdfReportGenerator.generateAndSharePdf(context, "كل الدفعات", allEntries.filter { it.settlementId != null }, settlements, isDark)
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("كل الدفعات") }

                                            OutlinedButton(
                                                onClick = { showCustomPeriodPdfDialog = true },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("فترة") }
                                        }

                                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Button(
                                                onClick = {
                                                    val txt = ElamalUtils.buildWhatsappFormattedText(entries, totalNet, lastCarryOver)
                                                    val sendIntent = Intent(Intent.ACTION_SEND).apply {
                                                        type = "text/plain"
                                                        putExtra(Intent.EXTRA_TEXT, txt)
                                                        addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                                                    }
                                                    context.startActivity(Intent.createChooser(sendIntent, "مشاركة لواتساب").apply { addFlags(Intent.FLAG_ACTIVITY_NEW_TASK) })
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp),
                                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF10B981))
                                            ) {
                                                Icon(Icons.Default.Share, contentDescription = null, modifier = Modifier.size(16.dp))
                                                Spacer(modifier = Modifier.width(6.dp))
                                                Text("نص لواتساب")
                                            }

                                            OutlinedButton(
                                                onClick = { PdfReportGenerator.exportAndShareCsv(context, allEntries) },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) {
                                                Icon(Icons.Default.TableView, contentDescription = null, modifier = Modifier.size(16.dp))
                                                Spacer(modifier = Modifier.width(6.dp))
                                                Text("تصدير CSV")
                                            }
                                        }
                                    }
                                }
                            }

                            item {
                                val hourlySum = allEntries.filter { it.type == EntryType.HOURLY }.sumOf { it.calculatedAmount }
                                val remoteSum = allEntries.filter { it.type == EntryType.REMOTE }.sumOf { it.calculatedAmount }
                                val creditSum = kotlin.math.abs(allEntries.filter { it.type == EntryType.CREDIT }.sumOf { it.calculatedAmount })
                                val maxVal = maxOf(hourlySum, remoteSum, creditSum, 10.0)

                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp)) {
                                        Text("الرسم البياني للأجور والكريدي", fontWeight = FontWeight.Bold)
                                        Spacer(modifier = Modifier.height(12.dp))
                                        Canvas(modifier = Modifier.fillMaxWidth().height(110.dp)) {
                                            val w = size.width
                                            val h = size.height
                                            val barW = w / 5.5f
                                            // Minimum visible bar height 8dp even when 0 so chart never looks broken/empty!
                                            val h1 = maxOf(((hourlySum / maxVal) * (h - 16f)).toFloat(), 12f)
                                            val h2 = maxOf(((remoteSum / maxVal) * (h - 16f)).toFloat(), 12f)
                                            val h3 = maxOf(((creditSum / maxVal) * (h - 16f)).toFloat(), 12f)

                                            drawRoundRect(Color(0xFF059669), topLeft = Offset(barW * 0.6f, h - h1), size = Size(barW, h1), cornerRadius = CornerRadius(12f, 12f))
                                            drawRoundRect(Color(0xFF2563EB), topLeft = Offset(barW * 2.25f, h - h2), size = Size(barW, h2), cornerRadius = CornerRadius(12f, 12f))
                                            drawRoundRect(Color(0xFFDC2626), topLeft = Offset(barW * 3.9f, h - h3), size = Size(barW, h3), cornerRadius = CornerRadius(12f, 12f))
                                        }
                                        Spacer(modifier = Modifier.height(8.dp))
                                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceAround) {
                                            Text("ساعات: ${ElamalUtils.formatMoney(hourlySum)}", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = Color(0xFF059669))
                                            Text("عن بعد: ${ElamalUtils.formatMoney(remoteSum)}", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = Color(0xFF2563EB))
                                            Text("كريدي: -${ElamalUtils.formatMoney(creditSum)}", fontSize = 12.sp, fontWeight = FontWeight.Bold, color = Color(0xFFDC2626))
                                        }
                                    }
                                }
                            }

                            item {
                                val cal = Calendar.getInstance()
                                val currentMonth = cal.get(Calendar.MONTH)
                                val currentYear = cal.get(Calendar.YEAR)
                                val daysInMonth = cal.getActualMaximum(Calendar.DAY_OF_MONTH)

                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp)) {
                                        Text("التقويم الشهري (${currentYear}/${currentMonth + 1})", fontWeight = FontWeight.Bold)
                                        Spacer(modifier = Modifier.height(10.dp))
                                        for (weekRow in 0 until ((daysInMonth + 6) / 7)) {
                                            Row(
                                                modifier = Modifier.fillMaxWidth().padding(vertical = 3.dp),
                                                horizontalArrangement = Arrangement.spacedBy(5.dp)
                                            ) {
                                                for (col in 1..7) {
                                                    val dayNum = weekRow * 7 + col
                                                    if (dayNum <= daysInMonth) {
                                                        val daySum = allEntries.filter {
                                                            val c = Calendar.getInstance().apply { timeInMillis = it.startTime }
                                                            c.get(Calendar.YEAR) == currentYear &&
                                                                    c.get(Calendar.MONTH) == currentMonth &&
                                                                    c.get(Calendar.DAY_OF_MONTH) == dayNum
                                                        }.sumOf { it.calculatedAmount }

                                                        val boxBg = when {
                                                            daySum > 0 -> Color(0xFF059669)
                                                            daySum < 0 -> Color(0xFFDC2626)
                                                            isDark -> Color(0xFF334155)
                                                            else -> Color(0xFFE2E8F0)
                                                        }
                                                        val txtCol = if (daySum != 0.0 || isDark) Color.White else Color(0xFF1E293B)

                                                        Box(
                                                            modifier = Modifier
                                                                .weight(1f)
                                                                .height(42.dp)
                                                                .clip(RoundedCornerShape(8.dp))
                                                                .background(boxBg),
                                                            contentAlignment = Alignment.Center
                                                        ) {
                                                            Column(horizontalAlignment = Alignment.CenterHorizontally) {
                                                                Text("$dayNum", fontSize = 12.sp, color = txtCol, fontWeight = FontWeight.Bold)
                                                                if (daySum != 0.0) {
                                                                    Text("${daySum.toInt()}", fontSize = 9.sp, color = Color.White.copy(alpha = 0.9f))
                                                                }
                                                            }
                                                        }
                                                    } else {
                                                        Spacer(modifier = Modifier.weight(1f))
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    3 -> {
                        // TAB 3: SETTINGS (Includes Root Wi-Fi 6 Networks Config, Appearance, Security & Smart SAF Backups)
                        val lastBackupMillis = prefs.getLong("last_backup_time", 0L)
                        val backupAgeHours = if (lastBackupMillis > 0L) (System.currentTimeMillis() - lastBackupMillis) / 3600_000L else -1L
                        var backupFilesList by remember { mutableStateOf(BackupSafManager.listAvailableBackups(context)) }
                        var encEnabled by remember { mutableStateOf(prefs.getBoolean("backup_encrypt_enabled", false)) }
                        var backupPass by remember { mutableStateOf(prefs.getString("backup_password", "") ?: "") }
                        var pinSetting by remember { mutableStateOf(savedPin) }
                        var newSsidInput by remember { mutableStateOf("") }

                        val ssidList = workSsids.split(",").map { it.trim() }.filter { it.isNotEmpty() }

                        LazyColumn(verticalArrangement = Arrangement.spacedBy(14.dp)) {
                            // Section 1: Root Wi-Fi Tracking inside Settings!
                            item {
                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(8.dp)) {
                                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Icon(Icons.Default.Wifi, contentDescription = null, tint = primaryCustom)
                                            Text("تتبع شبكات العمل بالرووت (بدون GPS)", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                                        }
                                        Text(
                                            text = "الشبكة المقروءة بالرووت الآن: ${detectedRootSsid ?: "اضغط فحص لطلب صلاحية الرووت (su)"}",
                                            fontSize = 13.sp,
                                            color = if (detectedRootSsid != null) Color(0xFF059669) else colorScheme.onSurfaceVariant,
                                            fontWeight = FontWeight.SemiBold
                                        )

                                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Button(
                                                onClick = {
                                                    scope.launch {
                                                        val ssid = withContext(Dispatchers.IO) {
                                                            ElamalUtils.pollAndMergeRootWifi(context, dao)
                                                        }
                                                        detectedRootSsid = ssid
                                                        if (ssid != null) {
                                                            Toast.makeText(context, "تم قراءة الشبكة عبر الرووت: $ssid ✓", Toast.LENGTH_SHORT).show()
                                                        } else {
                                                            Toast.makeText(context, "تأكد من منح صلاحية الرووت للتطبيق في Magisk/KernelSU", Toast.LENGTH_LONG).show()
                                                        }
                                                    }
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) {
                                                Text("فحص بالرووت الآن")
                                            }

                                            OutlinedButton(
                                                onClick = {
                                                    val current = detectedRootSsid
                                                    if (current != null && ssidList.size < 6 && !ssidList.contains(current)) {
                                                        val updated = (ssidList + current).joinToString(",")
                                                        workSsids = updated
                                                        prefs.edit().putString("work_ssids", updated).apply()
                                                        scope.launch(Dispatchers.IO) { ElamalUtils.pollAndMergeRootWifi(context, dao) }
                                                    } else {
                                                        Toast.makeText(context, "افحص الشبكة بالرووت أولاً أو أضف اسمها بالأسفل", Toast.LENGTH_SHORT).show()
                                                    }
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) {
                                                Text("إضافة الشبكة الحالية")
                                            }
                                        }

                                        Text("قائمة شبكات العمل (${ssidList.size} / 6 شبكات لدعم الترددين 2.4G و 5G):", fontSize = 12.sp, color = colorScheme.onSurfaceVariant)

                                        FlowRow(
                                            horizontalArrangement = Arrangement.spacedBy(6.dp),
                                            verticalArrangement = Arrangement.spacedBy(6.dp)
                                        ) {
                                            ssidList.forEach { itemSsid ->
                                                InputChip(
                                                    selected = true,
                                                    onClick = {
                                                        val updated = ssidList.filter { it != itemSsid }.joinToString(",")
                                                        workSsids = updated
                                                        prefs.edit().putString("work_ssids", updated).apply()
                                                    },
                                                    label = { Text(itemSsid) },
                                                    trailingIcon = { Icon(Icons.Default.Close, contentDescription = "حذف", modifier = Modifier.size(15.dp)) }
                                                )
                                            }
                                        }

                                        if (ssidList.size < 6) {
                                            Row(
                                                modifier = Modifier.fillMaxWidth(),
                                                verticalAlignment = Alignment.CenterVertically,
                                                horizontalArrangement = Arrangement.spacedBy(8.dp)
                                            ) {
                                                OutlinedTextField(
                                                    value = newSsidInput,
                                                    onValueChange = { newSsidInput = it },
                                                    label = { Text("أضف اسم شبكة عمل يدوياً (SSID)") },
                                                    modifier = Modifier.weight(1f),
                                                    singleLine = true,
                                                    shape = RoundedCornerShape(12.dp)
                                                )
                                                Button(
                                                    onClick = {
                                                        val clean = newSsidInput.trim()
                                                        if (clean.isNotEmpty() && ssidList.size < 6 && !ssidList.contains(clean)) {
                                                            val updated = (ssidList + clean).joinToString(",")
                                                            workSsids = updated
                                                            prefs.edit().putString("work_ssids", updated).apply()
                                                            newSsidInput = ""
                                                        }
                                                    },
                                                    shape = RoundedCornerShape(12.dp)
                                                ) { Text("إضافة") }
                                            }
                                        }
                                    }
                                }
                            }

                            // Section 2: Calculation & Widget Settings
                            item {
                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Icon(Icons.Default.Calculate, contentDescription = null, tint = primaryCustom)
                                            Text("الحساب، التنبيهات، والودجت", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                                        }

                                        var rateInput by remember { mutableStateOf(hourlyRate.toString()) }
                                        OutlinedTextField(
                                            value = rateInput,
                                            onValueChange = {
                                                rateInput = it
                                                it.toDoubleOrNull()?.let { r ->
                                                    hourlyRate = r
                                                    prefs.edit().putFloat("hourly_rate", r.toFloat()).apply()
                                                }
                                            },
                                            label = { Text("سعر الساعة الافتراضي (DH) - لا يغير الأرشيف") },
                                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                                            modifier = Modifier.fillMaxWidth(),
                                            singleLine = true,
                                            shape = RoundedCornerShape(12.dp)
                                        )

                                        Text("تنبيه نسيان الخروج: بعد $forgotAlarmHours ساعة (من 0 إلى 48)", fontWeight = FontWeight.Medium)
                                        Slider(
                                            value = forgotAlarmHours.toFloat(),
                                            onValueChange = {
                                                forgotAlarmHours = it.toInt()
                                                prefs.edit().putInt("forgot_alarm_hours", forgotAlarmHours).apply()
                                            },
                                            valueRange = 0f..48f
                                        )

                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Text("إظهار البحث والفلتر في الدفتر")
                                            Switch(
                                                checked = searchFilterEnabled,
                                                onCheckedChange = {
                                                    searchFilterEnabled = it
                                                    prefs.edit().putBoolean("search_filter_enabled", it).apply()
                                                }
                                            )
                                        }

                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Text("تفعيل الودجت (الدخول الجاري لا يضيع)")
                                            Switch(
                                                checked = widgetEnabled,
                                                onCheckedChange = {
                                                    widgetEnabled = it
                                                    prefs.edit().putBoolean("widget_enabled", it).apply()
                                                    ElamalWidgetReceiver.refreshAllWidgets(context)
                                                }
                                            )
                                        }
                                    }
                                }
                            }

                            // Section 3: Appearance, Colors & Icon
                            item {
                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Icon(Icons.Default.Palette, contentDescription = null, tint = primaryCustom)
                                            Text("المظهر، الخط، وأيقونة التطبيق", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                                        }

                                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            FilterChip(selected = themeMode == 0, onClick = { themeMode = 0; prefs.edit().putInt("theme_mode", 0).apply() }, label = { Text("تلقائي") })
                                            FilterChip(selected = themeMode == 1, onClick = { themeMode = 1; prefs.edit().putInt("theme_mode", 1).apply() }, label = { Text("فاتح (للـ PDF)") })
                                            FilterChip(selected = themeMode == 2, onClick = { themeMode = 2; prefs.edit().putInt("theme_mode", 2).apply() }, label = { Text("داكن (للـ PDF)") })
                                        }

                                        Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Button(
                                                onClick = { appColorHex = "#059669"; prefs.edit().putString("app_color_hex", "#059669").apply() },
                                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF059669)),
                                                modifier = Modifier.weight(1f)
                                            ) { Text("زمردي") }

                                            Button(
                                                onClick = { appColorHex = "#2563EB"; prefs.edit().putString("app_color_hex", "#2563EB").apply() },
                                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF2563EB)),
                                                modifier = Modifier.weight(1f)
                                            ) { Text("ملكي") }

                                            Button(
                                                onClick = { appColorHex = "#7C3AED"; prefs.edit().putString("app_color_hex", "#7C3AED").apply() },
                                                colors = ButtonDefaults.buttonColors(containerColor = Color(0xFF7C3AED)),
                                                modifier = Modifier.weight(1f)
                                            ) { Text("بنفسجي") }
                                        }

                                        Text("حجم الخط: ${String.format(Locale.US, "%.1fx", fontScale)}")
                                        Slider(
                                            value = fontScale,
                                            onValueChange = {
                                                fontScale = it
                                                prefs.edit().putFloat("font_scale", it).apply()
                                            },
                                            valueRange = 0.85f..1.35f
                                        )

                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Text("ألوان النظام (Material You)")
                                            Switch(
                                                checked = dynamicColor,
                                                onCheckedChange = {
                                                    dynamicColor = it
                                                    prefs.edit().putBoolean("dynamic_color", it).apply()
                                                }
                                            )
                                        }

                                        OutlinedButton(
                                            onClick = {
                                                val pm = context.packageManager
                                                val def = ComponentName(context, "com.nanomks.elamal.LauncherDefault")
                                                val alt = ComponentName(context, "com.nanomks.elamal.LauncherAlt")
                                                val isDefEnabled = pm.getComponentEnabledSetting(def) != PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                                                if (isDefEnabled) {
                                                    pm.setComponentEnabledSetting(alt, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP)
                                                    pm.setComponentEnabledSetting(def, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP)
                                                    Toast.makeText(context, "تم التبديل إلى الأيقونة الزرقاء ✓", Toast.LENGTH_SHORT).show()
                                                } else {
                                                    pm.setComponentEnabledSetting(def, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP)
                                                    pm.setComponentEnabledSetting(alt, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP)
                                                    Toast.makeText(context, "تم التبديل إلى الأيقونة الخضراء ✓", Toast.LENGTH_SHORT).show()
                                                }
                                            },
                                            modifier = Modifier.fillMaxWidth(),
                                            shape = RoundedCornerShape(12.dp)
                                        ) {
                                            Text("تبديل أيقونة التطبيق (أخضر / أزرق)")
                                        }
                                    }
                                }
                            }

                            // Section 4: Security & 5 Rotating Backups
                            item {
                                ElevatedCard(
                                    modifier = Modifier.fillMaxWidth(),
                                    shape = RoundedCornerShape(16.dp),
                                    colors = CardDefaults.elevatedCardColors(containerColor = colorScheme.surface)
                                ) {
                                    Column(modifier = Modifier.padding(14.dp), verticalArrangement = Arrangement.spacedBy(10.dp)) {
                                        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            Icon(Icons.Default.Security, contentDescription = null, tint = primaryCustom)
                                            Text("الأمان والنسخ الاحتياطي الذكي (5 نسخ دوارة)", fontWeight = FontWeight.Bold, fontSize = 16.sp)
                                        }

                                        OutlinedTextField(
                                            value = pinSetting,
                                            onValueChange = {
                                                if (it.length <= 8 && it.all { c -> c.isDigit() }) {
                                                    pinSetting = it
                                                    if (it.isEmpty() || it.length >= 4) {
                                                        savedPin = it
                                                        prefs.edit().putString("security_pin", it).apply()
                                                    }
                                                }
                                            },
                                            label = { Text("رمز القفل (4 إلى 8 أرقام - اتركه فارغاً للإلغاء)") },
                                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.NumberPassword),
                                            modifier = Modifier.fillMaxWidth(),
                                            singleLine = true,
                                            shape = RoundedCornerShape(12.dp)
                                        )

                                        Row(
                                            modifier = Modifier.fillMaxWidth(),
                                            horizontalArrangement = Arrangement.SpaceBetween,
                                            verticalAlignment = Alignment.CenterVertically
                                        ) {
                                            Text("تشفير النسخ الاحتياطية بكلمة مرور")
                                            Switch(
                                                checked = encEnabled,
                                                onCheckedChange = {
                                                    encEnabled = it
                                                    prefs.edit().putBoolean("backup_encrypt_enabled", it).apply()
                                                }
                                            )
                                        }

                                        if (encEnabled) {
                                            OutlinedTextField(
                                                value = backupPass,
                                                onValueChange = {
                                                    backupPass = it
                                                    prefs.edit().putString("backup_password", it).apply()
                                                },
                                                label = { Text("كلمة مرور تشفير النسخ الاحتياطية") },
                                                modifier = Modifier.fillMaxWidth(),
                                                singleLine = true,
                                                shape = RoundedCornerShape(12.dp)
                                            )
                                        }

                                        Text(
                                            text = if (backupAgeHours >= 0) "⏱ عمر آخر نسخة احتياطية: منذ $backupAgeHours ساعة"
                                            else "⚠️ تذكير: لم يتم أخذ نسخة احتياطية بعد!",
                                            fontSize = 13.sp,
                                            color = if (backupAgeHours >= 0) Color(0xFF059669) else Color(0xFFD97706)
                                        )

                                        Button(
                                            onClick = { folderPicker.launch(null) },
                                            modifier = Modifier.fillMaxWidth(),
                                            shape = RoundedCornerShape(12.dp)
                                        ) {
                                            Icon(Icons.Default.FolderOpen, contentDescription = null)
                                            Spacer(modifier = Modifier.width(8.dp))
                                            Text(if (backupUriStr.isBlank()) "اختيار مجلد النسخ الاحتياطي (SAF)" else "تغيير مجلد النسخ الاحتياطي ✓")
                                        }

                                        Row(modifier = Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                                            FilledTonalButton(
                                                onClick = {
                                                    scope.launch {
                                                        val msg = BackupSafManager.performSmartBackup(context, dao, isManual = true)
                                                        statusBanner = msg
                                                        backupFilesList = BackupSafManager.listAvailableBackups(context)
                                                        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show()
                                                    }
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("نسخ يدوي الآن") }

                                            OutlinedButton(
                                                onClick = {
                                                    scope.launch {
                                                        val msg = BackupSafManager.restoreFromBackup(context, dao)
                                                        statusBanner = msg
                                                        backupFilesList = BackupSafManager.listAvailableBackups(context)
                                                        Toast.makeText(context, msg, Toast.LENGTH_SHORT).show()
                                                    }
                                                },
                                                modifier = Modifier.weight(1f),
                                                shape = RoundedCornerShape(10.dp)
                                            ) { Text("استعادة التلقائية") }
                                        }

                                        if (backupFilesList.isNotEmpty()) {
                                            Text("النسخ المتوفرة في المجلد (${backupFilesList.size}):", fontWeight = FontWeight.Bold, fontSize = 13.sp)
                                            for (bf in backupFilesList.take(8)) {
                                                Row(
                                                    modifier = Modifier.fillMaxWidth(),
                                                    horizontalArrangement = Arrangement.SpaceBetween,
                                                    verticalAlignment = Alignment.CenterVertically
                                                ) {
                                                    Text(bf, fontSize = 12.sp)
                                                    TextButton(onClick = {
                                                        scope.launch {
                                                            val msg = BackupSafManager.restoreFromBackup(context, dao, bf)
                                                            statusBanner = msg
                                                            Toast.makeText(context, msg, Toast.LENGTH_SHORT).show()
                                                        }
                                                    }) { Text("استعادة") }
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Custom Date Range PDF Dialog
        if (showCustomPeriodPdfDialog) {
            val df = SimpleDateFormat("yyyy-MM-dd", Locale.US)
            var fromDateStr by remember { mutableStateOf(df.format(Date(System.currentTimeMillis() - 14 * 86400_000L))) }
            var toDateStr by remember { mutableStateOf(df.format(Date())) }

            AlertDialog(
                onDismissRequest = { showCustomPeriodPdfDialog = false },
                title = { Text("تقرير PDF لفترة مخصصة") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedTextField(value = fromDateStr, onValueChange = { fromDateStr = it }, label = { Text("من تاريخ (yyyy-MM-dd)") })
                        OutlinedTextField(value = toDateStr, onValueChange = { toDateStr = it }, label = { Text("إلى تاريخ (yyyy-MM-dd)") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val startT = runCatching { df.parse(fromDateStr)?.time }.getOrNull() ?: 0L
                        val endT = (runCatching { df.parse(toDateStr)?.time }.getOrNull() ?: System.currentTimeMillis()) + 86399_000L
                        val rangeEntries = allEntries.filter { it.startTime in startT..endT }
                        PdfReportGenerator.generateAndSharePdf(context, "فترة $fromDateStr إلى $toDateStr", rangeEntries, settlements, isDark)
                        showCustomPeriodPdfDialog = false
                    }) { Text("تصدير ومشاركة PDF") }
                }
            )
        }

        // Edit Existing Entry Dialog
        if (editingEntry != null) {
            val target = editingEntry!!
            var noteStr by remember { mutableStateOf(target.note) }
            var breakStr by remember { mutableStateOf(target.breakMinutes.toString()) }
            var amountStr by remember { mutableStateOf(kotlin.math.abs(target.calculatedAmount).toString()) }

            AlertDialog(
                onDismissRequest = { editingEntry = null },
                title = { Text("تعديل السجل") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        if (target.type == EntryType.HOURLY) {
                            OutlinedTextField(
                                value = breakStr,
                                onValueChange = { breakStr = it },
                                label = { Text("الاستراحة (دقائق)") },
                                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
                            )
                        } else {
                            OutlinedTextField(
                                value = amountStr,
                                onValueChange = { amountStr = it },
                                label = { Text("المبلغ (DH)") },
                                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                            )
                        }
                        OutlinedTextField(value = noteStr, onValueChange = { noteStr = it }, label = { Text("الملاحظة") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        scope.launch {
                            val updated = if (target.type == EntryType.HOURLY && target.endTime != null) {
                                val brk = breakStr.toIntOrNull() ?: target.breakMinutes
                                val recalc = ElamalUtils.calculateHourlyPay(target.startTime, target.endTime, brk, target.hourlyRateAtEntry)
                                target.copy(breakMinutes = brk, calculatedAmount = recalc, note = noteStr)
                            } else {
                                val rawAmt = kotlin.math.abs(amountStr.toDoubleOrNull() ?: target.calculatedAmount)
                                val signedAmt = if (target.type == EntryType.CREDIT) -rawAmt else rawAmt
                                target.copy(calculatedAmount = signedAmt, note = noteStr)
                            }
                            dao.updateEntry(updated)
                            statusBanner = BackupSafManager.performSmartBackup(context, dao)
                            editingEntry = null
                        }
                    }) { Text("حفظ التعديل") }
                }
            )
        }

        if (confirmIgnoreAllWifi) {
            AlertDialog(
                onDismissRequest = { confirmIgnoreAllWifi = false },
                title = { Text("تأكيد تجاهل الكل") },
                text = { Text("هل أنت متأكد من تجاهل جميع فترات الواي فاي المقترحة؟") },
                confirmButton = {
                    Button(onClick = {
                        scope.launch {
                            dao.ignoreAllPendingWifi()
                            confirmIgnoreAllWifi = false
                        }
                    }) { Text("نعم، تجاهل الكل") }
                },
                dismissButton = {
                    TextButton(onClick = { confirmIgnoreAllWifi = false }) { Text("إلغاء") }
                }
            )
        }

        if (editingSettlement != null) {
            val target = editingSettlement!!
            var paidInput by remember { mutableStateOf(target.amountPaid.toString()) }
            var noteInput by remember { mutableStateOf(target.note) }
            val df = SimpleDateFormat("yyyy-MM-dd", Locale.US)
            var dateInput by remember { mutableStateOf(df.format(Date(target.timestamp))) }

            AlertDialog(
                onDismissRequest = { editingSettlement = null },
                title = { Text("تعديل دفعة قديمة (مع تحديث المرحّل لاحقاً)") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedTextField(value = dateInput, onValueChange = { dateInput = it }, label = { Text("التاريخ (yyyy-MM-dd)") })
                        OutlinedTextField(
                            value = paidInput,
                            onValueChange = { paidInput = it },
                            label = { Text("المبلغ المستلم (DH)") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                        )
                        OutlinedTextField(value = noteInput, onValueChange = { noteInput = it }, label = { Text("الملاحظة") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val newPaid = paidInput.toDoubleOrNull() ?: target.amountPaid
                        val parsedTime = runCatching { df.parse(dateInput)?.time }.getOrNull() ?: target.timestamp
                        scope.launch {
                            dao.updateSettlement(target.copy(timestamp = parsedTime, amountPaid = newPaid, note = noteInput))
                            dao.recalculateSettlementsCascade()
                            statusBanner = BackupSafManager.performSmartBackup(context, dao)
                            editingSettlement = null
                        }
                    }) { Text("حفظ وإعادة حساب المرحّل") }
                }
            )
        }

        if (showClockOutDialog) {
            var breakMinStr by remember { mutableStateOf("0") }
            var noteStr by remember { mutableStateOf("") }
            AlertDialog(
                onDismissRequest = { showClockOutDialog = false },
                title = { Text("تسجيل الخروج") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedTextField(
                            value = breakMinStr,
                            onValueChange = { breakMinStr = it },
                            label = { Text("مدة الاستراحة (بالدقائق)") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number)
                        )
                        OutlinedTextField(value = noteStr, onValueChange = { noteStr = it }, label = { Text("ملاحظة (اختياري)") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val end = System.currentTimeMillis()
                        val brk = breakMinStr.toIntOrNull() ?: 0
                        val pay = ElamalUtils.calculateHourlyPay(activeClockIn, end, brk, hourlyRate)
                        scope.launch {
                            dao.insertEntry(
                                WorkEntry(
                                    type = EntryType.HOURLY,
                                    startTime = activeClockIn,
                                    endTime = end,
                                    breakMinutes = brk,
                                    hourlyRateAtEntry = hourlyRate,
                                    calculatedAmount = pay,
                                    note = noteStr
                                )
                            )
                            prefs.edit().putLong("active_clock_in", 0L).apply()
                            activeClockIn = 0L
                            ElamalUtils.cancelForgotClockOutAlarm(context)
                            ElamalWidgetReceiver.refreshAllWidgets(context)
                            statusBanner = BackupSafManager.performSmartBackup(context, dao)
                            showClockOutDialog = false
                        }
                    }) { Text("حفظ الخروج") }
                }
            )
        }

        if (showRemoteDialog) {
            var amountStr by remember { mutableStateOf("") }
            var noteStr by remember { mutableStateOf("") }
            AlertDialog(
                onDismissRequest = { showRemoteDialog = false },
                title = { Text("إضافة عمل عن بعد (أجرة ثابتة)") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedTextField(
                            value = amountStr,
                            onValueChange = { amountStr = it },
                            label = { Text("المبلغ الثابت (DH)") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                        )
                        OutlinedTextField(value = noteStr, onValueChange = { noteStr = it }, label = { Text("ملاحظة") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val amt = amountStr.toDoubleOrNull() ?: 0.0
                        if (amt > 0) {
                            val now = System.currentTimeMillis()
                            scope.launch {
                                dao.insertEntry(
                                    WorkEntry(
                                        type = EntryType.REMOTE,
                                        startTime = now,
                                        endTime = now,
                                        hourlyRateAtEntry = hourlyRate,
                                        calculatedAmount = amt,
                                        note = noteStr
                                    )
                                )
                                statusBanner = BackupSafManager.performSmartBackup(context, dao)
                                showRemoteDialog = false
                            }
                        }
                    }) { Text("إضافة") }
                }
            )
        }

        if (showCreditDialog) {
            var creditStr by remember { mutableStateOf("") }
            var noteStr by remember { mutableStateOf("") }
            AlertDialog(
                onDismissRequest = { showCreditDialog = false },
                title = { Text("إضافة كريدي (يُسجل بالسالب)") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        OutlinedTextField(
                            value = creditStr,
                            onValueChange = { creditStr = it },
                            label = { Text("قيمة الكريدي (DH)") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                        )
                        OutlinedTextField(value = noteStr, onValueChange = { noteStr = it }, label = { Text("ملاحظة") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val amt = kotlin.math.abs(creditStr.toDoubleOrNull() ?: 0.0)
                        if (amt > 0) {
                            val now = System.currentTimeMillis()
                            scope.launch {
                                dao.insertEntry(
                                    WorkEntry(
                                        type = EntryType.CREDIT,
                                        startTime = now,
                                        endTime = now,
                                        hourlyRateAtEntry = hourlyRate,
                                        calculatedAmount = -amt,
                                        note = noteStr
                                    )
                                )
                                statusBanner = BackupSafManager.performSmartBackup(context, dao)
                                showCreditDialog = false
                            }
                        }
                    }) { Text("حفظ بالسالب") }
                }
            )
        }

        if (showSettleDialog) {
            val prevCarry = settlements.firstOrNull()?.nextCarryOver ?: 0.0
            val entriesSum = entries.sumOf { it.calculatedAmount }
            val netDue = entriesSum + prevCarry
            var paidStr by remember { mutableStateOf(netDue.toString()) }
            var noteStr by remember { mutableStateOf("") }

            AlertDialog(
                onDismissRequest = { showSettleDialog = false },
                title = { Text("استلام دفعة وأرشفة السجلات") },
                text = {
                    Column(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                        Text("المجموع الصافي المستحق: ${ElamalUtils.formatMoney(netDue)}", fontWeight = FontWeight.Bold)
                        OutlinedTextField(
                            value = paidStr,
                            onValueChange = { paidStr = it },
                            label = { Text("المبلغ المستلم فعلياً (DH)") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                        )
                        OutlinedTextField(value = noteStr, onValueChange = { noteStr = it }, label = { Text("ملاحظة الدفعة") })
                    }
                },
                confirmButton = {
                    Button(onClick = {
                        val paid = paidStr.toDoubleOrNull() ?: 0.0
                        val nextCarry = netDue - paid
                        scope.launch {
                            val sId = dao.insertSettlement(
                                Settlement(
                                    timestamp = System.currentTimeMillis(),
                                    entriesTotal = entriesSum,
                                    previousCarryOver = prevCarry,
                                    amountPaid = paid,
                                    nextCarryOver = nextCarry,
                                    note = noteStr
                                )
                            )
                            dao.attachEntriesToSettlement(sId)
                            dao.recalculateSettlementsCascade()
                            statusBanner = BackupSafManager.performSmartBackup(context, dao)
                            showSettleDialog = false
                        }
                    }) { Text("تأكيد وترحيل الفرق") }
                }
            )
        }
    }
}

@Composable
fun EntryRowCard(item: WorkEntry, fontScale: Float, onEdit: () -> Unit, onDelete: () -> Unit) {
    val badgeColor = when (item.type) {
        EntryType.HOURLY -> Color(0xFF059669)
        EntryType.REMOTE -> Color(0xFF2563EB)
        EntryType.CREDIT -> Color(0xFFDC2626)
    }
    val badgeLabel = when (item.type) {
        EntryType.HOURLY -> "ساعات"
        EntryType.REMOTE -> "عن بعد"
        EntryType.CREDIT -> "كريدي"
    }
    val df = remember { SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.US) }

    ElevatedCard(
        modifier = Modifier.fillMaxWidth().clickable { onEdit() },
        shape = RoundedCornerShape(14.dp),
        colors = CardDefaults.elevatedCardColors(containerColor = MaterialTheme.colorScheme.surface)
    ) {
        Row(
            modifier = Modifier.padding(14.dp).fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f), verticalArrangement = Arrangement.spacedBy(4.dp)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Box(
                        modifier = Modifier
                            .background(badgeColor, RoundedCornerShape(6.dp))
                            .padding(horizontal = 8.dp, vertical = 2.dp)
                    ) {
                        Text(badgeLabel, color = Color.White, fontSize = (11 * fontScale).sp, fontWeight = FontWeight.Bold)
                    }
                    if (item.type == EntryType.HOURLY && item.endTime != null) {
                        val mins = ((item.endTime - item.startTime) / 60000L) - item.breakMinutes
                        Text(ElamalUtils.formatDurationArabic(mins), fontSize = (13 * fontScale).sp, fontWeight = FontWeight.Bold)
                    }
                    Text(df.format(Date(item.startTime)), fontSize = 11.sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
                if (item.note.isNotBlank()) {
                    Text(item.note, fontSize = (13 * fontScale).sp, color = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }

            Row(verticalAlignment = Alignment.CenterVertically) {
                CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Ltr) {
                    Text(
                        text = ElamalUtils.formatMoney(item.calculatedAmount),
                        fontWeight = FontWeight.ExtraBold,
                        fontSize = (16 * fontScale).sp,
                        color = if (item.calculatedAmount < 0) Color(0xFFDC2626) else Color(0xFF059669)
                    )
                }
                IconButton(onClick = onDelete) {
                    Icon(Icons.Default.DeleteOutline, contentDescription = "حذف", tint = MaterialTheme.colorScheme.onSurfaceVariant)
                }
            }
        }
    }
}
EOF

# 15. proguard-rules.pro
cat << 'EOF' > app/proguard-rules.pro
-keep class com.nanomks.elamal.** { *; }
EOF

echo "=== Redesigned Elamal v4.0.0 Project Setup Finished ==="
