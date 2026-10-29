# Auto Keybind untuk MoonLoader PC

[AutoKeybind-1.0.2.lua](../AutoKeybind-1.0.2.lua) merupakan file distribusi obfuscated untuk pengulangan satu tombol yang dipilih melalui panel `/autokey`.
Target runtime adalah GTA San Andreas PC dengan SA-MP, bukan MonetLoader Android.
Versi script saat ini adalah **1.0.2**.

## Pemasangan

Lihat [README setupSamp](../../README.md) untuk daftar bahan yang sudah tersedia, pilihan varian SAMPFUNCS, prasyarat CLEO/ASI Loader, dan link unduhan bahan yang belum disertakan dalam repository.

1. Siapkan GTA San Andreas, SA-MP, MoonLoader 0.26 atau versi yang kompatibel, dan SAMPFUNCS yang cocok dengan versi SA-MP.
2. Tutup game, lalu unduh **`mimgui-v1.7.1.zip`** dari [rilis resmi mimgui](https://github.com/THE-FYP/mimgui/releases/tag/v1.7.1). Ekstrak folder `mimgui` dari paket tersebut ke `moonloader/lib/`. Gunakan paket binary ini agar `cimguidx9.dll` ikut terpasang. Library `vkeys` tersedia dalam paket MoonLoader, sedangkan `bit` merupakan modul LuaJIT.
3. Salin `AutoKeybind-1.0.2.lua` ke folder `moonloader/` di direktori game. Pasang satu versi Auto Keybind agar perintah tidak didaftarkan oleh beberapa salinan sekaligus.
4. Jalankan game dan masuk ke server. Pesan `[AutoKey] Siap` menandakan perintah telah didaftarkan.

Jika panel tidak terbuka, periksa `moonloader/moonloader.log`, khususnya pesan tentang modul yang hilang atau SAMPFUNCS yang tidak kompatibel.

Pada instalasi game di `C:\samp`, susunan file yang diperlukan adalah:

```text
C:\samp\
  SAMPFUNCS.asi
  moonloader\
    AutoKeybind-1.0.2.lua
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

Error `module 'mimgui' not found` berarti script berhenti sebelum perintah `/autokey` didaftarkan. Nama file dan nomor baris pada log mengikuti file distribusi yang dipasang. Pastikan `moonloader/lib/mimgui/init.lua` tersedia, bukan berada di folder tambahan seperti `moonloader/lib/mimgui-v1.7.1/mimgui/init.lua`. Setelah library dipasang, tutup dan jalankan ulang game agar script dimuat lagi. Bila error berubah, periksa log dari sesi terbaru untuk mengetahui dependensi atau masalah berikutnya.

## Penggunaan

1. Ketik `/autokey` untuk membuka panel.
2. Pilih **Y**, **ALT**, **F**, **H**, **SPC (Spasi)**, atau **N**. Pilihan awal adalah Y; hanya satu tombol diulang dalam satu waktu.
3. Atur delay melalui slider atau kolom angka. Nilai awal **500 ms**, dengan rentang **50 sampai 60000 ms**. Nilai di luar rentang dibatasi otomatis.
4. Klik **Mulai** setelah karakter spawn. Tombol yang dipilih langsung ditekan dan panel tetap terbuka. Jika chat, dialog, atau kondisi jeda lain masih aktif, input menunggu kondisi tersebut berakhir.
5. Klik **Berhenti** pada panel atau tekan **F10** untuk menghentikan pengulangan. Jika panel ditutup, buka kembali melalui `/autokey` untuk mengakses tombol Berhenti.

Tekanan pertama dikirim saat **Mulai** diklik, tanpa menunggu delay. Setiap tekanan berlangsung sedikitnya **50 ms**, lalu tombol dilepas. Delay adalah jeda **setelah pelepasan** hingga tekanan berikutnya, bukan durasi menahan tombol. Contoh: pada delay 500 ms, jarak antartekanan sekitar 550 ms. Pemrosesan mengikuti frame game sehingga waktu nyata dapat lebih panjang pada FPS rendah.

## Perilaku dan batasan

- Panel tetap terbuka setelah Mulai diklik. Membuka atau menutup panel tidak melepas tombol, menjeda pengulangan, maupun mengatur ulang jadwal tekanan.
- Mengubah pilihan melepas tombol lama dan menjadwalkan tombol baru setelah delay yang dipilih. Saat script belum berjalan, pilihan tersebut akan digunakan pada klik Mulai berikutnya.
- Menutup panel melalui X, Escape, atau `/autokey` hanya menyembunyikan panel. Klik **Berhenti** atau gunakan F10 untuk mematikan pengulangan.
- Pengulangan dijeda saat chat, dialog SA-MP, scoreboard, menu pause aktif, atau jendela game kehilangan fokus. Kursor SA-MP menjadi kondisi jeda ketika panel Auto Keybind tertutup; saat panel terbuka, kursor tidak memblokir pengulangan. Setelah kondisi jeda berakhir, script menunggu delay sebelum menekan lagi.
- Saat mengetik `/autokey`, chat masih dapat memicu jeda. Panel yang terbuka setelah perintah dijalankan tidak menambah kondisi jeda tersendiri.
- Status panel menampilkan **berjalan**, **dijeda**, atau **berhenti** sesuai keadaan pengulangan.
- Bagian bawah panel menampilkan **Author: Arvin_Inc**, setelah petunjuk delay dan pintasan. Tinggi panel 410 piksel menyediakan ruang untuk teks author.
- Disconnect, belum spawn, atau karakter mati menghentikan pengulangan. Pengguna harus memulai ulang setelah spawn.
- Saat script dihentikan atau dimuat ulang, tombol yang dipegang script dilepas.
- Pilihan dan delay hanya tersimpan selama script berjalan; tidak ada file konfigurasi yang ditulis.
- Panel mengikuti susunan referensi: daftar vertikal, pengaturan delay, lalu tombol aksi. Warna navy mengikuti permintaan pengguna. Font bawaan ImGui dipakai untuk keterbacaan dan agar tidak memerlukan aset font tambahan. Tombol aksi dan baris terpilih memakai aksen biru untuk menunjukkan aksi dan pilihan aktif, tanpa animasi dekoratif.
- Navigasi keyboard ImGui diaktifkan. Tab/Shift+Tab memindahkan fokus, panah menavigasi kontrol, Enter/Space mengaktifkan tombol, dan Escape menutup panel.
- Input memakai [API MoonLoader `setVirtualKeyDown`](https://gist.github.com/THE-FYP/abc6f8bea87f4cb42331fc6dd7a84576). Fungsi tombol tetap mengikuti pengaturan kontrol game dan perilaku server. Efek di server harus diperiksa langsung.

## Kontrak implementasi

- Perintah lokal: `sampRegisterChatCommand('autokey', callback)`, tanpa argumen.
- UI: `mimgui.OnInitialize` untuk tema dan navigasi, `mimgui.OnFrame` untuk panel dan kursor. `panel.LockPlayer = false` menjaga agar panel tidak meminta penguncian kontrol karakter.
- Callback Mulai mengirim tekanan pertama melalui `setVirtualKeyDown` saat itu juga, selama tidak ada kondisi jeda aktif. Penjadwalan berikutnya memakai `localClock()` dan loop `wait(0)` agar penghentian dan pelepasan tombol diperiksa setiap frame, termasuk ketika delay panjang. Callback `/autokey` hanya mengganti visibilitas panel.
- Tombol virtual: Y `0x59`, ALT `0x12`, F `0x46`, H `0x48`, spasi `0x20`, N `0x4E`; F10 `0x79` menghentikan pengulangan.
- Tidak ada perubahan API jaringan, database, atau penyimpanan eksternal.

## Verifikasi

Pengujian pengembangan dilakukan pada source lokal sebelum obfuscation, menggunakan stub MoonLoader/mimgui untuk memeriksa alur kontrol dan input. Hasil tersebut tidak membuktikan file obfuscated berhasil dimuat, rendering DirectX, interaksi fisik keyboard, atau respons server. File distribusi obfuscated belum diuji melalui game.

Source `monetloader/autoKeybind.lua` dan folder `monetloader/tests/` diabaikan oleh Git dan tidak disertakan dalam distribusi. Pengembang yang memiliki file lokal tersebut dapat menjalankan pengujian berikut dari folder `monetloader/`, tanpa memasang dependensi ke folder game:

```powershell
npx --yes --package fengari-node-cli@0.1.0 fengari tests/autoKeybind.spec.lua
```

Hasil verifikasi source pengembangan sebelum obfuscation:

| Pemeriksaan | Hasil dan bukti |
| --- | --- |
| Sintaks | PASS: source dan pengujian berhasil diparse sebagai Lua 5.1. Eksekusi stub memakai Fengari, bukan runtime LuaJIT game. |
| Kontrol UI | PASS melalui stub: `/autokey` membuka/menutup tanpa mengubah jadwal pengulangan, enam pilihan mengganti tombol, slider/input mengubah delay, Mulai langsung menekan sambil mempertahankan panel, Berhenti/F10 mematikan, dan X/Escape menutup panel. Status berjalan/dijeda diperiksa. |
| Pengulangan | PASS melalui stub: tekanan pertama langsung, tekanan 50 ms, jeda berikutnya, batas 50/60000 ms, panel tetap terbuka tanpa jeda, kursor panel/eksternal, kondisi jeda saat Mulai, pergantian pilihan, penghentian saat mati/disconnect, pelepasan saat terminate, dan frame lambat. Total 14 kelompok pengujian lulus. |
| Kontras | PASS dari nilai warna source: teks utama terhadap seluruh permukaan navy memiliki rasio minimal 5,48:1. |
| Referensi | Link distribusi mengarah ke file obfuscated dan README. Path tes hanya ditulis sebagai petunjuk pengembangan lokal karena tes tidak disertakan dalam Git. |

Review desain berdasarkan sumber dan stub:

- Hard Gate PASS: setiap kontrol memiliki perilaku yang diperiksa; tidak ada aset, statistik, testimoni, atau klaim buatan. Fokus keyboard dan Escape dikonfigurasi. Rendering native serta navigasi fisik memerlukan pemeriksaan di game.
- Purpose Gate PASS: navy berasal dari permintaan pengguna; font bawaan menghindari dependensi aset; aksen biru menandai pilihan dan aksi. Tidak ada gradien, glow, ilustrasi, atau animasi dekoratif.
- Liveliness PASS: ENERGY 1 / RHYTHM 1 / MOTION 1 mengikuti panel utilitas referensi. Daftar tombol, jeda, lalu Mulai menjadi urutan visual dan penggunaan.
- Craftsmanship PASS dalam cakupan sumber/stub: aksi, status berjalan/berhenti/dijeda, pembatasan delay, dan kegagalan memulai sebelum spawn memiliki alur yang jelas. Klaim kecocokan visual dan respons server ditunda sampai pengujian native.

Pemeriksaan langsung yang masih diperlukan di game:

- Buka `/autokey`, cek warna navy, enam pilihan, slider, input angka, dan tata letak pada resolusi game yang digunakan.
- Klik Mulai pada masing-masing pilihan: tekanan pertama harus langsung terjadi dan panel tetap terbuka. Periksa pengulangan dengan delay berbeda, lalu hentikan melalui F10 dan tombol Berhenti.
- Periksa bahwa membuka/menutup panel tidak mengganggu pengulangan, serta bahwa chat, dialog, scoreboard, pause, kursor SA-MP eksternal saat panel tertutup, dan perpindahan fokus tetap menjeda input.
- Periksa bahwa tombol dilepas saat berhenti, mati, disconnect, dan reload script.
- Coba Tab/Shift+Tab, panah, Enter/Space, Escape, dan tombol X pada panel.
