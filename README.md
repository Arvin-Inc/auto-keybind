# 🛠️ AutoKeybind.lua

Selamat datang di repository **auto-keybind**! 

Repository ini menyediakan kumpulan file *client* SA-MP, installer pendukung, serta plugin/modifikasi opsional untuk mengoptimalkan pengalaman bermain GTA San Andreas Multiplayer.

---

## 📖 Panduan Lengkap & Pemasangan

Untuk petunjuk langkah demi langkah mengenai cara unduh, pemasangan game dasar, konfigurasi **MoonLoader**, **SAMPFUNCS**, hingga **Plugin Voice**, silakan kunjungi halaman dokumentasi resmi kami:

👉 **[Buka Wiki Panduan Pemasangan](https://github.com/Arvin-Inc/auto-keybind/wiki/Documentation-AutoKeybind)**

---

### 📦 File yang harus tersedia

File berikut tidak disediakan langsung di repo ini. Unduh dari situs resmi masing-masing agar mendapatkan versi terbaru:

* 🔵 **MoonLoader:** `setup-moonloader-026.exe` (v0.26) — unduh di [situs resmi MoonLoader](https://www.blast.hk/moonloader/download.php)
* 🟡 **SAMPFUNCS:** Varian 5.7.1 untuk berbagai versi client
* 🟢 **mimgui:** Library untuk GUI MoonLoader — unduh di [repo resmi mimgui](https://github.com/THE-FYP/mimgui/tags)
* ⚡ **Script terbaru:** [AutoKeybind-1.1.0.lua](monetloader/AutoKeybind-1.1.0.lua), file obfuscated dari AutoKeybindV dengan pengulangan melalui paket sinkronisasi SA-MP. Lihat [panduan Auto Keybind 1.1.0](https://github.com/Arvin-Inc/auto-keybind/wiki/Documentation-AutoKeybind).

Gunakan `1.1.0` untuk engine paket dari AutoKeybind 1.1.0 dan pasang hanya satu versi di folder `moonloader/`.

Untuk mendapatkan source di atas anda bisa kunjungin [Release](https://github.com/Arvin-Inc/sampSetupIndonesia/releases)

### AutoKeybindV dengan engine Autokeybind

Source lokal `monetloader/AutoKeybindV.lua` memakai GUI navy dari Auto Keybind,
dibuka dengan `/autokey`, dan langsung mengirim paket pertama saat Mulai.
Pengulangan memakai paket sinkronisasi SA-MP dan worker `wait(delay)`;
membuka chat/panel tidak mengatur ulang jadwal. Author pada varian ini Arvin_Inc,
dengan asal engine Autokeybind dicatat dalam dokumentasi. Delay 50 sampai 10000 ms.
File distribusinya adalah [AutoKeybind-1.1.0.lua](monetloader/AutoKeybind-1.1.0.lua).
Pasang satu varian `/autokey` agar tidak berbenturan dengan 1.0.3.
Source varian ini dan folder tes tetap diabaikan Git. Versi dinaikkan ke `1.1.0`
karena perubahan engine input dari tombol virtual menjadi paket sinkronisasi.

Lihat [panduan Auto Keybind 1.1.0 dan perbandingan input](https://github.com/Arvin-Inc/auto-keybind/wiki/Documentation-AutoKeybind)
untuk dependensi, asal pemulihan, perubahan GUI, pemetaan paket, serta hasil
14 kelompok tes stub yang lulus pada source dan file obfuscated. Penerimaan aksi
server dan rendering di game belum diverifikasi.

> 💡 *Daftar file di atas beserta syarat prasyarat seperti CLEO, ASI Loader, dan mimgui dibahas secara detail di [Wiki](https://github.com/Arvin-Inc/sampSetupIndonesia/wiki).*
