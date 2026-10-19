#!/usr/bin/env bash
set -e

echo "=== Generating Elamal (com.nanomks.elamal) Project Structure ==="

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

# 4. app/build.gradle.kts (With GitHub Secrets Signing Config)
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
        versionCode = 1
        versionName = "1.0.0"

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
    implementation("androidx.lifecycle:lifecycle-runtime-ktx:2.7.0")
    implementation("androidx.lifecycle:lifecycle-viewmodel-compose:2.7.0")
    implementation("androidx.activity:activity-compose:1.8.2")
    implementation("androidx.compose.ui:ui")
    implementation("androidx.compose.ui:ui-graphics")
    implementation("androidx.compose.material3:material3")
    implementation("androidx.compose.material:material-icons-extended")
    implementation("androidx.biometric:biometric:1.1.0")
    implementation("androidx.documentfile:documentfile:1.0.1")

    // Room Database
    val roomVersion = "2.6.1"
    implementation("androidx.room:room-runtime:$roomVersion")
    implementation("androidx.room:room-ktx:$roomVersion")
    ksp("androidx.room:room-compiler:$roomVersion")
}
EOF

# 5. Resources: strings.xml & themes.xml
cat << 'EOF' > app/src/main/res/values/strings.xml
<resources>
    <string name="app_name">العمل</string>
    <string name="widget_name">ودجت العمل</string>
</resources>
EOF

cat << 'EOF' > app/src/main/res/values/themes.xml
<resources>
    <style name="Theme.Elamal" parent="android:Theme.Material.Light.NoActionBar" />
</resources>
EOF

# 6. Adaptive Icons (Default + Alternative + Monochrome Layer)
cat << 'EOF' > app/src/main/res/drawable/ic_launcher_background.xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="108dp"
    android:height="108dp"
    android:viewportWidth="108"
    android:viewportHeight="108">
    <path android:fillColor="#006C4C" android:pathData="M0,0h108v108h-108z"/>
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

# 7. Widget Layout & Info
cat << 'EOF' > app/src/main/res/layout/widget_elamal.xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/widget_root"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:background="#1E293B"
    android:gravity="center"
    android:orientation="vertical"
    android:padding="12dp">

    <TextView
        android:id="@+id/widget_title"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:text="العمل"
        android:textColor="#94A3B8"
        android:textSize="12sp" />

    <TextView
        android:id="@+id/widget_status"
        android:layout_width="wrap_content"
        android:layout_height="wrap_content"
        android:layout_marginTop="4dp"
        android:text="اضغط للدخول"
        android:textColor="#FFFFFF"
        android:textSize="15sp"
        android:textStyle="bold" />
</LinearLayout>
EOF

cat << 'EOF' > app/src/main/res/xml/widget_info.xml
<?xml version="1.0" encoding="utf-8"?>
<appwidget-provider xmlns:android="http://schemas.android.com/apk/res/android"
    android:initialLayout="@layout/widget_elamal"
    android:minWidth="110dp"
    android:minHeight="60dp"
    android:resizeMode="horizontal|vertical"
    android:updatePeriodMillis="0"
    android:widgetCategory="home_screen" />
EOF

# 8. AndroidManifest.xml (No Location Permissions! Uses Root for SSID + Activity Aliases)
cat << 'EOF' > app/src/main/AndroidManifest.xml
<?xml version="1.0" encoding="utf-8"?>
<manifest xmlns:android="http://schemas.android.com/apk/res/android">

    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
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
            </intent-filter>
            <meta-data
                android:name="android.appwidget.provider"
                android:resource="@xml/widget_info" />
        </receiver>
    </application>
</manifest>
EOF

# 9. Database Entities & DAO & Cascading Recalculation
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/data/Entities.kt
package com.nanomks.elamal.data

import androidx.room.*

enum class EntryType {
    HOURLY, REMOTE, CREDIT
}

@Entity(tableName = "work_entries")
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
    val isDeleted: Boolean = false
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
    val status: String = "PENDING" // PENDING, ADDED, IGNORED
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
    suspend fun getAllEntriesSync(): List<WorkEntry>

    @Query("SELECT * FROM settlements ORDER BY timestamp DESC")
    fun getAllSettlements(): Flow<List<Settlement>>

    @Query("SELECT * FROM settlements ORDER BY timestamp ASC")
    suspend fun getSettlementsAsc(): List<Settlement>

    @Query("SELECT * FROM wifi_sessions WHERE status != 'IGNORED' ORDER BY startTime DESC")
    fun getVisibleWifiSessions(): Flow<List<WifiSession>>

    @Insert(onConflict = OnConflictStrategy.REPLACE)
    suspend fun insertEntry(entry: WorkEntry): Long

    @Update
    suspend fun updateEntry(entry: WorkEntry)

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

@Database(entities = [WorkEntry::class, Settlement::class, WifiSession::class], version = 1, exportSchema = false)
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
                ).build().also { INSTANCE = it }
            }
        }
    }
}
EOF

# 10. Root Wi-Fi Reader + Calculators + Encryption Helper
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/util/ElamalUtils.kt
package com.nanomks.elamal.util

import java.io.BufferedReader
import java.io.InputStreamReader
import java.math.BigDecimal
import java.math.RoundingMode
import java.security.SecureRandom
import java.util.Base64
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

    /**
     * Reads current connected Wi-Fi SSID using Root (su) without GPS or Location permissions.
     */
    fun getConnectedSsidViaRoot(): String? {
        return try {
            val process = Runtime.getRuntime().exec(arrayOf("su", "-c", "cmd wifi status"))
            val reader = BufferedReader(InputStreamReader(process.inputStream))
            val output = reader.readText()
            process.waitFor()
            // Match SSID: "NetworkName"
            val regex = Regex("""SSID:\s*"([^"]+)"""")
            val match = regex.find(output)
            match?.groupValues?.getOrNull(1)?.takeIf { it != "<unknown ssid>" }
        } catch (e: Exception) {
            null
        }
    }

    /**
     * AES-GCM Encryption with user Backup Password
     */
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
}
EOF

# 11. Widget Receiver (2-Tap Confirmation within 60s + Disabled Toggle + Idempotent)
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/widget/ElamalWidgetReceiver.kt
package com.nanomks.elamal.widget

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.widget.RemoteViews
import com.nanomks.elamal.R
import com.nanomks.elamal.data.ElamalDatabase
import com.nanomks.elamal.data.EntryType
import com.nanomks.elamal.data.WorkEntry
import com.nanomks.elamal.util.ElamalUtils
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch

class ElamalWidgetReceiver : AppWidgetProvider() {

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (id in appWidgetIds) {
            updateWidgetUi(context, appWidgetManager, id)
        }
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        if (intent.action == "com.nanomks.elamal.ACTION_WIDGET_CLICK") {
            val prefs = context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE)
            val isEnabled = prefs.getBoolean("widget_enabled", true)
            if (!isEnabled) return

            val now = System.currentTimeMillis()
            val lastSave = prefs.getLong("widget_last_save", 0L)
            if (now - lastSave < 8000L) return // 8-second idempotency protection

            val firstTap = prefs.getLong("widget_first_tap", 0L)
            if (now - firstTap <= 60_000L) {
                // Confirmed! Execute Check-in or Check-out
                prefs.edit().putLong("widget_first_tap", 0L).putLong("widget_last_save", now).apply()
                val activeStart = prefs.getLong("active_clock_in", 0L)
                if (activeStart == 0L) {
                    prefs.edit().putLong("active_clock_in", now).apply()
                } else {
                    val rate = prefs.getFloat("hourly_rate", 10f).toDouble()
                    val pay = ElamalUtils.calculateHourlyPay(activeStart, now, 0, rate)
                    prefs.edit().putLong("active_clock_in", 0L).apply()
                    CoroutineScope(Dispatchers.IO).launch {
                        ElamalDatabase.getInstance(context).dao().insertEntry(
                            WorkEntry(
                                type = EntryType.HOURLY,
                                startTime = activeStart,
                                endTime = now,
                                hourlyRateAtEntry = rate,
                                calculatedAmount = pay,
                                note = "تسجيل من الودجت"
                            )
                        )
                    }
                }
            } else {
                // First tap: ask for second confirmation tap within 60s
                prefs.edit().putLong("widget_first_tap", now).apply()
            }
            refreshAllWidgets(context)
        }
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
                views.setTextViewText(R.id.widget_status, if (activeStart == 0L) "اضغط مجدداً لتأكيد الدخول" else "اضغط مجدداً لتأكيد الخروج")
            } else if (activeStart > 0L) {
                views.setInt(R.id.widget_root, "setBackgroundColor", Color.parseColor("#059669"))
                views.setTextViewText(R.id.widget_status, "دخول جارٍ.. اضغط للخروج")
            } else {
                views.setInt(R.id.widget_root, "setBackgroundColor", Color.parseColor("#1E293B"))
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

# 12. MainActivity (Full RTL Arabic UI: Ledger, Remote, Credit, Settlements, Root Wi-Fi & Settings)
cat << 'EOF' > app/src/main/java/com/nanomks/elamal/MainActivity.kt
package com.nanomks.elamal

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.compose.setContent
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.platform.LocalLayoutDirection
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.unit.LayoutDirection
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import com.nanomks.elamal.data.*
import com.nanomks.elamal.util.ElamalUtils
import com.nanomks.elamal.widget.ElamalWidgetReceiver
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import java.text.SimpleDateFormat
import java.util.*

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            CompositionLocalProvider(LocalLayoutDirection provides LayoutDirection.Rtl) {
                ElamalApp()
            }
        }
    }
}

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun ElamalApp() {
    val context = LocalContext.current
    val prefs = remember { context.getSharedPreferences("elamal_prefs", Context.MODE_PRIVATE) }
    val db = remember { ElamalDatabase.getInstance(context) }
    val dao = remember { db.dao() }
    val scope = rememberCoroutineScope()

    var dynamicColor by remember { mutableStateOf(prefs.getBoolean("dynamic_color", true)) }
    var fontScale by remember { mutableFloatStateOf(prefs.getFloat("font_scale", 1.0f)) }
    var hourlyRate by remember { mutableDoubleStateOf(prefs.getFloat("hourly_rate", 10.0f).toDouble()) }
    var activeClockIn by remember { mutableLongStateOf(prefs.getLong("active_clock_in", 0L)) }
    var widgetEnabled by remember { mutableStateOf(prefs.getBoolean("widget_enabled", true)) }
    var workSsids by remember { mutableStateOf(prefs.getString("work_ssids", "Work_WiFi_2.4G,Work_WiFi_5G") ?: "") }
    var backupUriStr by remember { mutableStateOf(prefs.getString("backup_uri", "") ?: "") }

    val entries by dao.getActiveEntries().collectAsState(initial = emptyList())
    val settlements by dao.getAllSettlements().collectAsState(initial = emptyList())
    val wifiSessions by dao.getVisibleWifiSessions().collectAsState(initial = emptyList())

    var currentTab by remember { mutableIntStateOf(0) }
    var searchQuery by remember { mutableStateOf("") }
    var filterType by remember { mutableStateOf<EntryType?>(null) }
    var lastDeletedEntry by remember { mutableStateOf<WorkEntry?>(null) }

    // Dialog States
    var showClockOutDialog by remember { mutableStateOf(false) }
    var showRemoteDialog by remember { mutableStateOf(false) }
    var showCreditDialog by remember { mutableStateOf(false) }
    var showSettleDialog by remember { mutableStateOf(false) }

    // Tick every minute while app is open to update active timer & check Root Wi-Fi
    var nowMillis by remember { mutableLongStateOf(System.currentTimeMillis()) }
    var detectedRootSsid by remember { mutableStateOf<String?>(null) }

    LaunchedEffect(Unit) {
        while (true) {
            nowMillis = System.currentTimeMillis()
            activeClockIn = prefs.getLong("active_clock_in", 0L)
            withContext(Dispatchers.IO) {
                val ssid = ElamalUtils.getConnectedSsidViaRoot()
                detectedRootSsid = ssid
            }
            delay(60_000L)
        }
    }

    val folderPicker = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocumentTree()) { uri ->
        if (uri != null) {
            context.contentResolver.takePersistableUriPermission(
                uri,
                Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_GRANT_WRITE_URI_PERMISSION
            )
            prefs.edit().putString("backup_uri", uri.toString()).apply()
            backupUriStr = uri.toString()
        }
    }

    val colorScheme = when {
        dynamicColor && Build.VERSION.SDK_INT >= Build.VERSION_CODES.S -> dynamicDarkColorScheme(context)
        else -> darkColorScheme(primary = Color(0xFF10B981), secondary = Color(0xFF3B82F6))
    }

    MaterialTheme(colorScheme = colorScheme) {
        Scaffold(
            topBar = {
                TopAppBar(
                    title = {
                        Text(
                            text = "العمل",
                            fontSize = (20 * fontScale).sp,
                            fontWeight = FontWeight.Bold
                        )
                    },
                    actions = {
                        if (lastDeletedEntry != null) {
                            TextButton(onClick = {
                                val toRestore = lastDeletedEntry!!
                                scope.launch {
                                    dao.updateEntry(toRestore.copy(isDeleted = false))
                                    lastDeletedEntry = null
                                }
                            }) {
                                Text("تراجع عن الحذف", color = Color(0xFFFBBF24))
                            }
                        }
                    }
                )
            },
            bottomBar = {
                NavigationBar {
                    NavigationBarItem(
                        selected = currentTab == 0,
                        onClick = { currentTab = 0 },
                        icon = { Icon(Icons.Default.AccessTime, contentDescription = null) },
                        label = { Text("الدفتر") }
                    )
                    NavigationBarItem(
                        selected = currentTab == 1,
                        onClick = { currentTab = 1 },
                        icon = { Icon(Icons.Default.AccountBalanceWallet, contentDescription = null) },
                        label = { Text("الدفعات") }
                    )
                    NavigationBarItem(
                        selected = currentTab == 2,
                        onClick = { currentTab = 2 },
                        icon = { Icon(Icons.Default.Wifi, contentDescription = null) },
                        label = { Text("واي فاي الرووت") }
                    )
                    NavigationBarItem(
                        selected = currentTab == 3,
                        onClick = { currentTab = 3 },
                        icon = { Icon(Icons.Default.Settings, contentDescription = null) },
                        label = { Text("الإعدادات") }
                    )
                }
            }
        ) { innerPadding ->
            Column(
                modifier = Modifier
                    .fillMaxSize()
                    .padding(innerPadding)
                    .padding(12.dp)
            ) {
                when (currentTab) {
                    0 -> {
                        // Summary Card
                        val lastCarryOver = settlements.firstOrNull()?.nextCarryOver ?: 0.0
                        val activeSum = entries.sumOf { it.calculatedAmount }
                        val totalNet = activeSum + lastCarryOver

                        Card(
                            modifier = Modifier.fillMaxWidth(),
                            colors = CardDefaults.cardColors(containerColor = Color(0xFF064E3B))
                        ) {
                            Column(modifier = Modifier.padding(16.dp)) {
                                Text("الصافي المستحق حالياً", color = Color(0xFFA7F3D0), fontSize = (14 * fontScale).sp)
                                Text(
                                    text = String.format(Locale.US, "%.2f DH", totalNet),
                                    fontSize = (28 * fontScale).sp,
                                    fontWeight = FontWeight.Bold,
                                    color = Color.White
                                )
                                if (lastCarryOver != 0.0) {
                                    Text(
                                        text = "شاملاً رصيد مرحّل: ${String.format(Locale.US, "%.2f DH", lastCarryOver)}",
                                        color = Color(0xFFD1FAE5),
                                        fontSize = (12 * fontScale).sp
                                    )
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(10.dp))

                        // Action Buttons Row
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
                                        ElamalWidgetReceiver.refreshAllWidgets(context)
                                    } else {
                                        showClockOutDialog = true
                                    }
                                },
                                modifier = Modifier.weight(1f),
                                colors = ButtonDefaults.buttonColors(
                                    containerColor = if (activeClockIn == 0L) Color(0xFF10B981) else Color(0xFFEF4444)
                                )
                            ) {
                                val elapsedMin = if (activeClockIn > 0L) (nowMillis - activeClockIn) / 60000L else 0L
                                Text(
                                    if (activeClockIn == 0L) "تسجيل دخول"
                                    else "خروج (${ElamalUtils.formatDurationArabic(elapsedMin)})"
                                )
                            }

                            OutlinedButton(onClick = { showRemoteDialog = true }) {
                                Text("عن بعد")
                            }
                            OutlinedButton(onClick = { showCreditDialog = true }) {
                                Text("كريدي (-)")
                            }
                        }

                        Spacer(modifier = Modifier.height(8.dp))

                        // Search & Filter
                        OutlinedTextField(
                            value = searchQuery,
                            onValueChange = { searchQuery = it },
                            label = { Text("بحث في الملاحظات...") },
                            modifier = Modifier.fillMaxWidth(),
                            singleLine = true
                        )

                        Row(
                            modifier = Modifier.fillMaxWidth().padding(vertical = 4.dp),
                            horizontalArrangement = Arrangement.spacedBy(6.dp)
                        ) {
                            FilterChip(
                                selected = filterType == null,
                                onClick = { filterType = null },
                                label = { Text("الكل") }
                            )
                            FilterChip(
                                selected = filterType == EntryType.HOURLY,
                                onClick = { filterType = EntryType.HOURLY },
                                label = { Text("ساعات") }
                            )
                            FilterChip(
                                selected = filterType == EntryType.REMOTE,
                                onClick = { filterType = EntryType.REMOTE },
                                label = { Text("عن بعد") }
                            )
                            FilterChip(
                                selected = filterType == EntryType.CREDIT,
                                onClick = { filterType = EntryType.CREDIT },
                                label = { Text("كريدي") }
                            )
                        }

                        val filtered = entries.filter {
                            (filterType == null || it.type == filterType) &&
                                    (searchQuery.isBlank() || it.note.contains(searchQuery, ignoreCase = true))
                        }

                        LazyColumn(
                            modifier = Modifier.fillMaxSize(),
                            verticalArrangement = Arrangement.spacedBy(8.dp)
                        ) {
                            items(filtered, key = { it.id }) { item ->
                                EntryRowCard(item = item, fontScale = fontScale, onDelete = {
                                    lastDeletedEntry = item
                                    scope.launch { dao.updateEntry(item.copy(isDeleted = true)) }
                                })
                            }
                        }
                    }

                    1 -> {
                        // Settlements & Archive Tab
                        Button(
                            onClick = { showSettleDialog = true },
                            modifier = Modifier.fillMaxWidth()
                        ) {
                            Text("استلام دفعة جديدة وترحيل الباقي")
                        }

                        if (settlements.isNotEmpty()) {
                            TextButton(
                                onClick = {
                                    val latest = settlements.first()
                                    scope.launch {
                                        dao.detachEntriesFromSettlement(latest.id)
                                        dao.deleteSettlement(latest)
                                    }
                                },
                                modifier = Modifier.align(Alignment.End)
                            ) {
                                Text("التراجع عن آخر دفعة", color = Color(0xFFF87171))
                            }
                        }

                        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                            items(settlements, key = { it.id }) { s ->
                                Card(modifier = Modifier.fillMaxWidth()) {
                                    Column(modifier = Modifier.padding(12.dp)) {
                                        val df = SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.getDefault())
                                        Text("تاريخ الدفعة: ${df.format(Date(s.timestamp))}", fontWeight = FontWeight.Bold)
                                        Text("مجموع السجلات: ${s.entriesTotal} DH | مرحّل سابق: ${s.previousCarryOver} DH")
                                        Text("المبلغ المستلم: ${s.amountPaid} DH", color = Color(0xFF34D399))
                                        Text("الرصيد المرحّل للقادم: ${s.nextCarryOver} DH", color = Color(0xFFFBBF24))
                                        if (s.note.isNotBlank()) Text("ملاحظة: ${s.note}")
                                    }
                                }
                            }
                        }
                    }

                    2 -> {
                        // Wi-Fi Root Tracker (Up to 6 Networks, No GPS!)
                        Card(modifier = Modifier.fillMaxWidth()) {
                            Column(modifier = Modifier.padding(12.dp)) {
                                Text("تتبع شبكات العمل بالرووت (بدون GPS)", fontWeight = FontWeight.Bold)
                                Text("الشبكة المتصلة حالياً عبر الرووت: ${detectedRootSsid ?: "غير متصل / بانتظار صلاحية su"}")
                                Spacer(modifier = Modifier.height(6.dp))
                                OutlinedTextField(
                                    value = workSsids,
                                    onValueChange = {
                                        workSsids = it
                                        prefs.edit().putString("work_ssids", it).apply()
                                    },
                                    label = { Text("قائمة شبكات العمل (حتى 6 مفصولة بفاصلة)") },
                                    modifier = Modifier.fillMaxWidth()
                                )
                                Button(
                                    onClick = {
                                        scope.launch(Dispatchers.IO) {
                                            val ssid = ElamalUtils.getConnectedSsidViaRoot() ?: "Work_WiFi_5G"
                                            val now = System.currentTimeMillis()
                                            dao.insertWifiSession(
                                                WifiSession(
                                                    ssid = ssid,
                                                    startTime = now - 3600_000L,
                                                    endTime = now
                                                )
                                            )
                                        }
                                    },
                                    modifier = Modifier.padding(top = 8.dp)
                                ) {
                                    Text("فحص الآن / محاكاة فترة واي فاي")
                                }
                            }
                        }

                        Spacer(modifier = Modifier.height(8.dp))
                        Row(
                            modifier = Modifier.fillMaxWidth(),
                            horizontalArrangement = Arrangement.SpaceBetween,
                            verticalAlignment = Alignment.CenterVertically
                        ) {
                            Text("فترات واي فاي بانتظار المراجعة", fontWeight = FontWeight.Bold)
                            TextButton(onClick = { scope.launch { dao.ignoreAllPendingWifi() } }) {
                                Text("تجاهل الكل")
                            }
                        }

                        LazyColumn(verticalArrangement = Arrangement.spacedBy(8.dp)) {
                            items(wifiSessions, key = { it.id }) { ws ->
                                Card(modifier = Modifier.fillMaxWidth()) {
                                    Row(
                                        modifier = Modifier.padding(12.dp).fillMaxWidth(),
                                        horizontalArrangement = Arrangement.SpaceBetween,
                                        verticalAlignment = Alignment.CenterVertically
                                    ) {
                                        Column {
                                            Text("الشبكة: ${ws.ssid}", fontWeight = FontWeight.Bold)
                                            val durMin = (ws.endTime - ws.startTime) / 60000L
                                            Text("المدة: ${ElamalUtils.formatDurationArabic(durMin)}")
                                        }
                                        if (ws.status == "ADDED") {
                                            Badge(containerColor = Color(0xFF059669)) {
                                                Text("أُضيفت", modifier = Modifier.padding(4.dp), color = Color.White)
                                            }
                                        } else {
                                            Row(horizontalArrangement = Arrangement.spacedBy(6.dp)) {
                                                Button(onClick = {
                                                    scope.launch {
                                                        val pay = ElamalUtils.calculateHourlyPay(ws.startTime, ws.endTime, 0, hourlyRate)
                                                        dao.insertEntry(
                                                            WorkEntry(
                                                                type = EntryType.HOURLY,
                                                                startTime = ws.startTime,
                                                                endTime = ws.endTime,
                                                                hourlyRateAtEntry = hourlyRate,
                                                                calculatedAmount = pay,
                                                                note = "واي فاي (${ws.ssid})"
                                                            )
                                                        )
                                                        dao.updateWifiSession(ws.copy(status = "ADDED"))
                                                    }
                                                }) { Text("أضف") }

                                                OutlinedButton(onClick = {
                                                    scope.launch { dao.updateWifiSession(ws.copy(status = "IGNORED")) }
                                                }) { Text("تجاهل") }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    3 -> {
                        // Settings Tab
                        LazyColumn(verticalArrangement = Arrangement.spacedBy(12.dp)) {
                            item {
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
                                    label = { Text("سعر الساعة الافتراضي (DH) - لا يغير السجلات القديمة") },
                                    keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal),
                                    modifier = Modifier.fillMaxWidth()
                                )
                            }

                            item {
                                Row(
                                    modifier = Modifier.fillMaxWidth(),
                                    horizontalArrangement = Arrangement.SpaceBetween,
                                    verticalAlignment = Alignment.CenterVertically
                                ) {
                                    Text("تفعيل الودجت (الدخول الجاري لا يضيع عند الإطفاء)")
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

                            item {
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
                            }

                            item {
                                Button(
                                    onClick = { folderPicker.launch(null) },
                                    modifier = Modifier.fillMaxWidth()
                                ) {
                                    Text(if (backupUriStr.isBlank()) "اختيار مجلد النسخ الاحتياطي التلقائي (SAF)" else "تم ربط مجلد النسخ الاحتياطي ✓")
                                }
                            }

                            item {
                                OutlinedButton(
                                    onClick = {
                                        val pm = context.packageManager
                                        val def = ComponentName(context, "com.nanomks.elamal.LauncherDefault")
                                        val alt = ComponentName(context, "com.nanomks.elamal.LauncherAlt")
                                        val isDefEnabled = pm.getComponentEnabledSetting(def) != PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                                        if (isDefEnabled) {
                                            pm.setComponentEnabledSetting(alt, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP)
                                            pm.setComponentEnabledSetting(def, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP)
                                        } else {
                                            pm.setComponentEnabledSetting(def, PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP)
                                            pm.setComponentEnabledSetting(alt, PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP)
                                        }
                                    },
                                    modifier = Modifier.fillMaxWidth()
                                ) {
                                    Text("تبديل أيقونة التطبيق (أخضر / أزرق ملكي)")
                                }
                            }
                        }
                    }
                }
            }
        }

        // Clock-out Dialog with Break Minutes
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
                        OutlinedTextField(
                            value = noteStr,
                            onValueChange = { noteStr = it },
                            label = { Text("ملاحظة (اختياري)") }
                        )
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
                            ElamalWidgetReceiver.refreshAllWidgets(context)
                            showClockOutDialog = false
                        }
                    }) { Text("حفظ الخروج") }
                }
            )
        }

        // Remote Fixed Pay Dialog
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
                        OutlinedTextField(
                            value = noteStr,
                            onValueChange = { noteStr = it },
                            label = { Text("ملاحظة") }
                        )
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
                                showRemoteDialog = false
                            }
                        }
                    }) { Text("إضافة") }
                }
            )
        }

        // Credit (-) Dialog
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
                        OutlinedTextField(
                            value = noteStr,
                            onValueChange = { noteStr = it },
                            label = { Text("ملاحظة") }
                        )
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
                                showCreditDialog = false
                            }
                        }
                    }) { Text("حفظ بالسالب") }
                }
            )
        }

        // Settlement Dialog
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
                        Text("المجموع الصافي المستحق: ${String.format(Locale.US, "%.2f DH", netDue)}")
                        OutlinedTextField(
                            value = paidStr,
                            onValueChange = { paidStr = it },
                            label = { Text("المبلغ المستلم فعلياً (DH)") },
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Decimal)
                        )
                        OutlinedTextField(
                            value = noteStr,
                            onValueChange = { noteStr = it },
                            label = { Text("ملاحظة الدفعة") }
                        )
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
                            showSettleDialog = false
                        }
                    }) { Text("تأكيد وترحيل الفرق") }
                }
            )
        }
    }
}

@Composable
fun EntryRowCard(item: WorkEntry, fontScale: Float, onDelete: () -> Unit) {
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

    Card(modifier = Modifier.fillMaxWidth()) {
        Row(
            modifier = Modifier.padding(12.dp).fillMaxWidth(),
            horizontalArrangement = Arrangement.SpaceBetween,
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column(modifier = Modifier.weight(1f)) {
                Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Box(
                        modifier = Modifier
                            .background(badgeColor, RoundedCornerShape(6.dp))
                            .padding(horizontal = 8.dp, vertical = 2.dp)
                    ) {
                        Text(badgeLabel, color = Color.White, fontSize = (12 * fontScale).sp)
                    }
                    if (item.type == EntryType.HOURLY && item.endTime != null) {
                        val mins = ((item.endTime - item.startTime) / 60000L) - item.breakMinutes
                        Text(ElamalUtils.formatDurationArabic(mins), fontSize = (13 * fontScale).sp)
                    }
                }
                if (item.note.isNotBlank()) {
                    Text(item.note, fontSize = (13 * fontScale).sp, color = Color(0xFFCBD5E1))
                }
            }

            Row(verticalAlignment = Alignment.CenterVertically) {
                Text(
                    text = String.format(Locale.US, "%.2f DH", item.calculatedAmount),
                    fontWeight = FontWeight.Bold,
                    fontSize = (16 * fontScale).sp,
                    color = if (item.calculatedAmount < 0) Color(0xFFF87171) else Color(0xFF34D399)
                )
                IconButton(onClick = onDelete) {
                    Icon(Icons.Default.Delete, contentDescription = "حذف", tint = Color(0xFF94A3B8))
                }
            }
        }
    }
}
EOF

# 13. proguard-rules.pro
cat << 'EOF' > app/proguard-rules.pro
-keep class com.nanomks.elamal.** { *; }
EOF

echo "=== Project Setup Complete ==="
