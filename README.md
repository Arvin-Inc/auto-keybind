# Setup SA-MP dan Script

Panduan untuk pemain GTA San Andreas PC yang ingin menjalankan [Auto Keybind 1.0.2](monetloader/AutoKeybind-1.0.2.lua) melalui MoonLoader. Script membuka panel `/autokey` untuk mengulang tombol Y, ALT, F, H, SPC (spasi), atau N dengan delay yang dipilih.

Script ditujukan untuk Lua 5.1/LuaJIT bawaan MoonLoader. File distribusi `AutoKeybind-1.0.2.lua` telah diobfuscate oleh pembuat script. Nama folder `monetloader/` di repository merupakan lokasi penyimpanan file distribusi; pemasangannya tetap ke folder `moonloader/` milik game PC.

## Bahan yang sudah tersedia

Inventaris ini mengikuti isi folder `setupSamp` yang diperiksa pada 29 Oktober 2026. File yang terpasang di folder game komputer pembuat tidak otomatis termasuk dalam repository ini.

| Bahan | File di repository | Pemakaian |
| --- | --- | --- |
| Installer Client Samp 0.3.7 R1|[2.sa-mp-0.3.7-R1-install.exe](2.sa-mp-0.3.7-R1-install.exe)|Instal file ini lalu jalankan dan arahkan ke folder tempat anda menyimpan GTA anda|
| Installer MoonLoader 0.26 | [setup-moonloader-026.exe](setup-moonloader-026.exe) | Jalankan dan arahkan ke folder GTA San Andreas. |
| Installer client SA-MP R1 | [2.sa-mp-0.3.7-R1-install.exe](2.sa-mp-0.3.7-R1-install.exe) | Installer yang tersedia bernama R1; cocokkan versi client dengan server dan SAMPFUNCS. |
| Script Auto Keybind obfuscated | [monetloader/AutoKeybind-1.0.2.lua](monetloader/AutoKeybind-1.0.2.lua) | Salin ke `moonloader/` pada folder game. |
| SAMPFUNCS 5.7.1 untuk SA-MP 0.3.7-R3-1 | [SAMPFUNCS.asi varian R3-1](SAMPFUNCS-5.7.1/SA-MP%200.3.7-R3-1/SAMPFUNCS.asi) | Gunakan hanya untuk client yang sesuai. |
| SAMPFUNCS 5.7.1 untuk SA-MP 0.3.7-R5 | [SAMPFUNCS.asi varian R5](SAMPFUNCS-5.7.1/SA-MP%200.3.7-R5/SAMPFUNCS.asi) | Gunakan hanya untuk client yang sesuai. |
| SAMPFUNCS 5.7.1 untuk SA-MP 0.3.DL | [SAMPFUNCS.asi varian 0.3.DL](SAMPFUNCS-5.7.1/SA-MP%200.3.DL/SAMPFUNCS.asi) | Gunakan hanya untuk client yang sesuai. |
| Petunjuk SAMPFUNCS | [SAMPFUNCS Readme.txt](SAMPFUNCS-5.7.1/SAMPFUNCS%20Readme.txt) | Memuat prasyarat CLEO 4.1 atau lebih baru dan ASI Loader. |
| Paket voice opsional | [Plugin Voice R1 R2/](Plugin%20Voice%20R1%20R2/) | Berisi `sampvoice.asi`, `bass.dll`, `bass_fx.dll`, `vorbisFile.dll`, dan `vorbisHooked.dll`. Auto Keybind dapat digunakan tanpa fitur voice. |

**Pilih satu `SAMPFUNCS.asi` yang sesuai versi client**, lalu salin ke folder yang sama dengan `gta_sa.exe`. Ketiga varian memiliki nama file tujuan yang sama, sehingga tidak perlu menyalin semuanya.

Walaupun README bawaan SAMPFUNCS menyebut dukungan R1, file varian **SA-MP 0.3.7-R1 belum ada dalam repository**. Nama folder paket voice menyebut R1/R2; kompatibilitas paket voice pada versi lain belum diverifikasi.

## Bahan yang perlu disiapkan atau diunduh

| Bahan | Ketersediaan di repository | Link dan petunjuk |
| --- | --- | --- |
| GTA San Andreas PC | Game tidak disertakan. | [Halaman produk Rockstar](https://store.rockstargames.com/game/buy-grand-theft-auto-the-trilogy). Gunakan instalasi game yang kompatibel dengan SA-MP dan MoonLoader; pembelian game saja belum memverifikasi kompatibilitas executable-nya. |
| Client SA-MP atau launcher selain installer R1 di atas | Installer versi lain belum tersedia. | [open.mp Launcher](https://open.mp/downloads/launcher) menyediakan launcher untuk server open.mp dan SA-MP. Pilih versi client sesuai kebutuhan server dan varian SAMPFUNCS. Kombinasi launcher, client, dan plugin tetap perlu diperiksa saat menjalankan game. |
| mimgui v1.7.1 | Paket ZIP dan folder library belum disertakan. | Unduh **`mimgui-v1.7.1.zip`** dari [rilis resmi mimgui](https://github.com/THE-FYP/mimgui/releases/tag/v1.7.1). Ekstrak folder `mimgui` ke `moonloader/lib/`. |
| CLEO 4.1 atau lebih baru | Tidak ada paket CLEO terpisah. | Periksa apakah CLEO sudah terpasang pada game. Bila belum, gunakan [rilis CLEO 4](https://github.com/cleolibrary/CLEO4/releases) sesuai petunjuk pembuatnya. |
| ASI Loader | Tidak ada paket loader mandiri. Paket voice memuat DLL hook. | Jika game belum memiliki ASI Loader, gunakan [Ultimate ASI Loader](https://github.com/ThirteenAG/Ultimate-ASI-Loader/releases) untuk game 32-bit dan ikuti petunjuk pemasangan GTA San Andreas dari pembuatnya. |
| SAMPFUNCS untuk SA-MP R1 atau versi lain yang belum tersedia | Varian lokal hanya R3-1, R5, dan 0.3.DL. | Gunakan [halaman SAMPFUNCS BlastHack](https://blast.hk/sampfuncs/), yang juga dirujuk README bawaan paket. Pilih file sesuai versi client. |

`vkeys.lua` berasal dari paket MoonLoader lengkap. LuaJIT beserta modul `bit` dan `ffi` disediakan runtime MoonLoader. Pemain tidak perlu memasang aplikasi Lua Player, interpreter Lua terpisah, Node.js, atau npm untuk menjalankan script ini. Script Lua lain dapat membutuhkan library tambahan sesuai `require` yang digunakan.

## Urutan pemasangan

1. Tutup game dan siapkan folder instalasi GTA San Andreas PC beserta client multiplayer yang digunakan server.
2. Pastikan prasyarat CLEO dan ASI Loader tersedia, mengikuti petunjuk paket masing-masing.
3. Jalankan [installer MoonLoader yang tersedia](setup-moonloader-026.exe) dan pilih folder game yang berisi `gta_sa.exe`.
4. Pilih salah satu varian SAMPFUNCS pada tabel di atas, kemudian salin `SAMPFUNCS.asi` ke folder game. Jika memakai client R1, unduh varian R1 melalui link yang disediakan.
5. Unduh paket binary `mimgui-v1.7.1.zip` dan ekstrak folder `mimgui` ke `moonloader/lib/`. Gunakan paket binary tersebut agar `cimguidx9.dll` ikut terpasang.
6. Salin [AutoKeybind-1.0.2.lua](monetloader/AutoKeybind-1.0.2.lua) ke `moonloader/`. Pasang satu versi Auto Keybind agar perintah `/autokey` tidak didaftarkan oleh beberapa salinan sekaligus. Folder dokumentasi tidak perlu disalin ke game.
7. Jalankan ulang game, masuk ke server, lalu cari pesan `[AutoKey] Siap` di chat.
8. Ketik `/autokey`, pilih tombol dan delay, lalu klik **Mulai**. Tombol yang dipilih langsung ditekan dan panel tetap terbuka. Gunakan **F10** atau tombol **Berhenti** untuk menghentikan pengulangan.

Contoh hasil pemasangan pada game di `C:\samp`:

```text
C:\samp\
  gta_sa.exe
  samp.dll
  MoonLoader.asi
  SAMPFUNCS.asi
  moonloader\
    AutoKeybind-1.0.2.lua
    lib\
      vkeys.lua
      mimgui\
        init.lua
        cdefs.lua
        imgui.lua
        dx9.lua
        win32.lua
        cimguidx9.dll
```

Contoh ini menampilkan file yang berkaitan dengan script. File bawaan game, CLEO, dan loader mengikuti paket yang dipasang.

## Jika `/autokey` tidak muncul

Buka `moonloader/moonloader.log` dari sesi game terbaru dan cari `Auto Keybind`.

| Pesan atau gejala | Pemeriksaan |
| --- | --- |
| `module 'mimgui' not found` | Pastikan `moonloader/lib/mimgui/init.lua` tersedia. Memasang SAMPFUNCS saja belum memasang mimgui. Hindari folder tambahan seperti `moonloader/lib/mimgui-v1.7.1/mimgui/`. |
| `module 'vkeys' not found` | Periksa kelengkapan library bawaan MoonLoader, lalu perbaiki instalasinya bila file tersebut hilang. |
| Pesan membutuhkan SA-MP dan SAMPFUNCS | Periksa apakah `SAMPFUNCS.asi` dimuat dan cocok dengan versi client SA-MP. File `moonloader/lib/sampfuncs.lua` tidak menggantikan plugin `.asi`. |
| `Script died due to an error` | Baca error dan stack trace tepat di atas pesan tersebut. Perintah belum tentu sempat didaftarkan. |

Setelah memperbaiki pemasangan, tutup dan jalankan ulang game agar script dimuat kembali.

## Panduan perilaku dan batas verifikasi

[Dokumentasi Auto Keybind](monetloader/docs/auto-keybind.md) menjelaskan delay, kondisi jeda, penghentian, dan pengujian. Tekanan pertama langsung dikirim saat Mulai diklik, lalu delay dihitung setelah tombol dilepas untuk pengulangan berikutnya. Panel dapat tetap terbuka selama pengulangan; chat dan dialog tetap menjeda input.

Inventaris file dan referensi path dapat diperiksa dari repository ini. Keberadaan file belum membuktikan plugin berhasil dimuat, UI tampil, atau tombol direspons server. File distribusi setelah obfuscation belum diuji melalui game. Kompatibilitas client/SAMPFUNCS, paket voice, serta perilaku langsung di game masih perlu diverifikasi pada instalasi pemain.

## File untuk Git

`monetloader/AutoKeybind-1.0.2.lua` merupakan file script yang disertakan dalam commit untuk distribusi. Source pengembangan `monetloader/autoKeybind.lua` dan folder `monetloader/tests/` disimpan secara lokal dan dikecualikan melalui [.gitignore](.gitignore).

Mengeluarkan source dan tes dari index Git mempertahankan file lokalnya. Aturan ini berlaku untuk commit berikutnya dan tidak menghapus salinan yang sudah ada di riwayat commit lama.
