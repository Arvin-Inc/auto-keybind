# Auto Keybind untuk MoonLoader PC

[autoKeybind.lua](../autoKeybind.lua) mengulang satu tombol yang dipilih melalui panel `/autokey`.
Target runtime adalah GTA San Andreas PC dengan SA-MP, bukan MonetLoader Android.

## Pemasangan

1. Siapkan GTA San Andreas, SA-MP, MoonLoader 0.26 atau versi yang kompatibel, dan SAMPFUNCS yang cocok dengan versi SA-MP.
2. Tutup game, lalu unduh **`mimgui-v1.7.1.zip`** dari [rilis resmi mimgui](https://github.com/THE-FYP/mimgui/releases/tag/v1.7.1). Ekstrak folder `mimgui` dari paket tersebut ke `moonloader/lib/`. Gunakan paket binary ini agar `cimguidx9.dll` ikut terpasang. Library `vkeys` tersedia dalam paket MoonLoader, sedangkan `bit` merupakan modul LuaJIT.
3. Salin `autoKeybind.lua` ke folder `moonloader/` di direktori game.
4. Jalankan game dan masuk ke server. Pesan `[AutoKey] Siap` menandakan perintah telah didaftarkan.

Jika panel tidak terbuka, periksa `moonloader/moonloader.log`, khususnya pesan tentang modul yang hilang atau SAMPFUNCS yang tidak kompatibel.

Pada instalasi game di `C:\samp`, susunan file yang diperlukan adalah:

```text
C:\samp\
  SAMPFUNCS.asi
  moonloader\
    autoKeybind.lua
    lib\
      mimgui\
        init.lua
        cdefs.lua
        imgui.lua
        dx9.lua
        win32.lua
        cimguidx9.dll
```

SAMPFUNCS dan mimgui merupakan dua dependensi terpisah. File `moonloader/lib/sampfuncs.lua` tidak menggantikan plugin `SAMPFUNCS.asi`.

Error `autoKeybind.lua:5: module 'mimgui' not found` berarti script berhenti sebelum perintah `/autokey` didaftarkan. Pastikan `moonloader/lib/mimgui/init.lua` tersedia, bukan berada di folder tambahan seperti `moonloader/lib/mimgui-v1.7.1/mimgui/init.lua`. Setelah library dipasang, tutup dan jalankan ulang game agar script dimuat lagi. Bila error berubah, periksa log dari sesi terbaru untuk mengetahui dependensi atau masalah berikutnya.

## Penggunaan

1. Ketik `/autokey` untuk membuka panel.
2. Pilih **Y**, **ALT**, **F**, **H**, **SPC (Spasi)**, atau **N**. Pilihan awal adalah Y; hanya satu tombol diulang dalam satu waktu.
3. Atur delay melalui slider atau kolom angka. Nilai awal **500 ms**, dengan rentang **50 sampai 60000 ms**. Nilai di luar rentang dibatasi otomatis.
4. Klik **Mulai** setelah karakter spawn. Panel menutup agar kontrol kembali ke game. Tekanan pertama dikirim setelah delay yang dipilih.
5. Tekan **F10** untuk berhenti, atau buka kembali `/autokey` dan klik **Berhenti**.

Setiap tekanan berlangsung sedikitnya **50 ms**, lalu tombol dilepas. Delay adalah jeda **setelah pelepasan** hingga tekanan berikutnya, bukan durasi menahan tombol. Contoh: pada delay 500 ms, jarak antartekanan sekitar 550 ms. Pemrosesan mengikuti frame game sehingga waktu nyata dapat lebih panjang pada FPS rendah.

## Perilaku dan batasan

- Membuka panel menjeda pengulangan dan melepas tombol yang sedang ditekan. Mengubah pilihan mengganti tombol untuk pengulangan berikutnya.
- Menutup panel melalui X, Escape, atau `/autokey` melanjutkan pengulangan yang sebelumnya aktif. Klik **Berhenti** atau gunakan F10 untuk mematikannya.
- Pengulangan dijeda saat chat, dialog SA-MP, scoreboard, kursor SA-MP, menu pause aktif, atau jendela game kehilangan fokus. Setelah kondisi tersebut berakhir, script menunggu delay sebelum menekan lagi.
- Disconnect, belum spawn, atau karakter mati menghentikan pengulangan. Pengguna harus memulai ulang setelah spawn.
- Saat script dihentikan atau dimuat ulang, tombol yang dipegang script dilepas.
- Pilihan dan delay hanya tersimpan selama script berjalan; tidak ada file konfigurasi yang ditulis.
- Panel mengikuti susunan referensi: daftar vertikal, pengaturan delay, lalu tombol aksi. Warna navy mengikuti permintaan pengguna. Font bawaan ImGui dipakai untuk keterbacaan dan agar tidak memerlukan aset font tambahan. Tombol aksi dan baris terpilih memakai aksen biru untuk menunjukkan aksi dan pilihan aktif, tanpa animasi dekoratif.
- Navigasi keyboard ImGui diaktifkan. Tab/Shift+Tab memindahkan fokus, panah menavigasi kontrol, Enter/Space mengaktifkan tombol, dan Escape menutup panel.
- Input memakai [API MoonLoader `setVirtualKeyDown`](https://gist.github.com/THE-FYP/abc6f8bea87f4cb42331fc6dd7a84576). Fungsi tombol tetap mengikuti pengaturan kontrol game dan perilaku server. Efek di server harus diperiksa langsung.

## Kontrak implementasi

- Perintah lokal: `sampRegisterChatCommand('autokey', callback)`, tanpa argumen.
- UI: `mimgui.OnInitialize` untuk tema dan navigasi, `mimgui.OnFrame` untuk panel dan kursor. Kontrol karakter dikunci selama panel terlihat.
- Penjadwalan memakai `localClock()` dan loop `wait(0)` agar penghentian dan pelepasan tombol diperiksa setiap frame, termasuk ketika delay panjang.
- Tombol virtual: Y `0x59`, ALT `0x12`, F `0x46`, H `0x48`, spasi `0x20`, N `0x4E`; F10 `0x79` menghentikan pengulangan.
- Tidak ada perubahan API jaringan, database, atau penyimpanan eksternal.

## Verifikasi

Pengujian lokal menggunakan stub MoonLoader/mimgui untuk memeriksa alur kontrol dan input. Stub tidak membuktikan rendering DirectX, interaksi fisik keyboard, atau respons server.

[Pengujian regresi](../tests/autoKeybind.spec.lua) dapat dijalankan dari root proyek tanpa memasang dependensi ke folder game:

```powershell
npx --yes --package fengari-node-cli@0.1.0 fengari tests/autoKeybind.spec.lua
```

Hasil verifikasi lokal:

| Pemeriksaan | Hasil dan bukti |
| --- | --- |
| Sintaks | PASS: source dan pengujian berhasil diparse sebagai Lua 5.1. Eksekusi stub memakai Fengari, bukan runtime LuaJIT game. |
| Kontrol UI | PASS melalui stub: `/autokey` membuka/menutup, enam pilihan mengganti tombol, slider/input mengubah delay, Mulai menjalankan, Berhenti/F10 mematikan, dan X/Escape menutup panel. |
| Pengulangan | PASS melalui stub: tekanan 50 ms, jeda yang dipilih, batas 50/60000 ms, jeda input, pergantian pilihan, penghentian saat mati/disconnect, pelepasan saat terminate, dan frame lambat. Total 11 kelompok pengujian lulus. |
| Kontras | PASS dari nilai warna source: teks utama terhadap seluruh permukaan navy memiliki rasio minimal 5,48:1. |
| Referensi | PASS: link relatif menuju source/pengujian tersedia; referensi web mengarah ke repositori mimgui dan referensi MoonLoader pembuatnya. |

Review desain berdasarkan sumber dan stub:

- Hard Gate PASS: setiap kontrol memiliki perilaku yang diperiksa; tidak ada aset, statistik, testimoni, atau klaim buatan. Fokus keyboard dan Escape dikonfigurasi. Rendering native serta navigasi fisik memerlukan pemeriksaan di game.
- Purpose Gate PASS: navy berasal dari permintaan pengguna; font bawaan menghindari dependensi aset; aksen biru menandai pilihan dan aksi. Tidak ada gradien, glow, ilustrasi, atau animasi dekoratif.
- Liveliness PASS: ENERGY 1 / RHYTHM 1 / MOTION 1 mengikuti panel utilitas referensi. Daftar tombol, jeda, lalu Mulai menjadi urutan visual dan penggunaan.
- Craftsmanship PASS dalam cakupan sumber/stub: aksi, status berhenti/dijeda, pembatasan delay, dan kegagalan memulai sebelum spawn memiliki alur yang jelas. Klaim kecocokan visual dan respons server ditunda sampai pengujian native.

Pemeriksaan langsung yang masih diperlukan di game:

- Buka `/autokey`, cek warna navy, enam pilihan, slider, input angka, dan tata letak pada resolusi game yang digunakan.
- Jalankan masing-masing tombol dengan delay berbeda, lalu hentikan melalui F10 dan tombol Berhenti.
- Periksa jeda saat chat, dialog, scoreboard, pause, perpindahan fokus, dan pembukaan panel.
- Periksa bahwa tombol dilepas saat berhenti, mati, disconnect, dan reload script.
- Coba Tab/Shift+Tab, panah, Enter/Space, Escape, dan tombol X pada panel.
