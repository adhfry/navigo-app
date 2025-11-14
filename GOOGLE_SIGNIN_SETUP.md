# 🔑 Google Sign-In Setup Instructions

## ❌ MASALAH SAAT INI
Google Sign-In gagal karena **SHA-1 fingerprint belum terdaftar** di Google Cloud Console!

## ✅ SOLUSI: Configure Google Cloud Console

### 📋 Informasi Yang Dibutuhkan:

**Package Name:**
```
com.navigo.navi_go
```

**SHA-1 Fingerprint (Debug):**
```
E7:92:A3:76:CA:53:C8:0F:FF:43:65:47:B2:C7:73:F8:B3:86:81:48
```

**Client IDs:**
- Android: `241902729566-koi20ab1b1012nqa91kg8t8691ffh9oj.apps.googleusercontent.com`
- Web: `241902729566-e8ln8cggeivfmp4aogk3f1au4bhs7rlb.apps.googleusercontent.com`

---

## 🚀 LANGKAH-LANGKAH SETUP:

### 1. Buka Google Cloud Console
URL: https://console.cloud.google.com/

### 2. Pilih Project NaviGo
(Atau buat project baru jika belum ada)

### 3. Enable Google Sign-In API
1. Go to: **APIs & Services** → **Library**
2. Search: "Google Sign-In API" atau "Google+ API"
3. Click **Enable**

### 4. Configure OAuth Consent Screen
1. Go to: **APIs & Services** → **OAuth consent screen**
2. Pilih **External**
3. Isi:
   - App name: `NaviGo`
   - User support email: `ahda.creator@gmail.com`
   - Developer contact: `ahda.creator@gmail.com`
4. Save and Continue
5. **Scopes**: Add `email` dan `profile`
6. Save and Continue
7. **Test users**: Add your Gmail account
8. Save and Continue

### 5. Create/Update OAuth 2.0 Credentials

#### A. Android OAuth Client ID

1. Go to: **APIs & Services** → **Credentials**
2. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
3. Application type: **Android**
4. Isi:
   - **Name**: `NaviGo Android`
   - **Package name**: `com.navigo.navi_go`
   - **SHA-1 certificate fingerprint**: `E7:92:A3:76:CA:53:C8:0F:FF:43:65:47:B2:C7:73:F8:B3:86:81:48`
5. Click **Create**
6. Copy **Client ID** yang dihasilkan

#### B. Web OAuth Client ID (untuk backend)

1. Click **+ CREATE CREDENTIALS** → **OAuth client ID**
2. Application type: **Web application**
3. Isi:
   - **Name**: `NaviGo Web`
   - **Authorized JavaScript origins**: 
     - `http://localhost:3000`
     - `https://your-backend-url.com` (ganti dengan URL backend Anda)
   - **Authorized redirect URIs**:
     - `http://localhost:3000/auth/google/callback`
     - `https://your-backend-url.com/auth/google/callback`
4. Click **Create**
5. Copy **Client ID** dan **Client Secret**

### 6. Update Konfigurasi di Aplikasi

#### Update `strings.xml`:
File: `android/app/src/main/res/values/strings.xml`

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <string name="app_name">NaviGo</string>
    <string name="default_web_client_id">241902729566-e8ln8cggeivfmp4aogk3f1au4bhs7rlb.apps.googleusercontent.com</string>
</resources>
```

**GANTI** dengan Web Client ID yang baru dari step 5B!

#### Update Backend `.env`:
```env
GOOGLE_CLIENT_ID=241902729566-e8ln8cggeivfmp4aogk3f1au4bhs7rlb.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=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
```

**GANTI** dengan credentials baru!

---

## 🧪 TESTING

### 1. Build APK baru:
```bash
flutter clean
flutter build apk --debug
```

### 2. Install di device:
```bash
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

### 3. Test Google Sign-In:
- Buka app
- Klik "Masuk dengan Google"
- Pilih akun Google
- ✅ **HARUS BERHASIL LOGIN!**

### 4. Check logs:
```bash
adb logcat | findstr "flutter"
```

Expected logs:
```
🔍 Starting Google Sign-In...
🔍 Google Sign-In initialized
🔍 Attempting lightweight authentication...
🔍 Lightweight auth failed, starting full authentication...
🔍 Authenticate succeeded!
🔍 Google User authenticated: user@gmail.com
🔍 Getting authentication token...
🔍 Google Sign-In Response:
   Status: success
   needsPhone: true/false
```

---

## ⚠️ TROUBLESHOOTING

### Error: "Developer Error" atau "Sign-in failed"
**Cause:** SHA-1 fingerprint tidak match atau belum terdaftar

**Solution:**
1. Pastikan SHA-1 fingerprint sudah ditambahkan di Google Cloud Console
2. Wait 5-10 menit untuk propagasi
3. Rebuild APK dan test lagi

### Error: "Invalid Client ID"
**Cause:** Web Client ID salah atau belum di-update di `strings.xml`

**Solution:**
1. Check Web Client ID di Google Cloud Console
2. Update `strings.xml` dengan Client ID yang benar
3. Rebuild dan test lagi

### User cancel tapi tidak ada error
**Cause:** Ini behavior yang benar! User cancel = silent return

---

## 📚 REFERENSI

- Google Sign-In Flutter: https://pub.dev/packages/google_sign_in
- Google Cloud Console: https://console.cloud.google.com/
- SHA-1 Fingerprint Guide: https://developers.google.com/android/guides/client-auth

---

## ✅ CHECKLIST

- [ ] Google Sign-In API enabled
- [ ] OAuth consent screen configured
- [ ] Android OAuth Client ID created dengan SHA-1
- [ ] Web OAuth Client ID created
- [ ] `strings.xml` updated dengan Web Client ID
- [ ] Backend `.env` updated
- [ ] APK rebuilt dan installed
- [ ] Google Sign-In tested dan BERHASIL! 🎉

---

**Setelah semua step di atas, Google Sign-In PASTI AKAN BEKERJA!** 🚀
