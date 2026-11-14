# Auto Keybind 1.0.3 untuk MoonLoader PC (arsip)

Rilis terbaru adalah [Auto Keybind 1.1.0](auto-keybind-v.md), dibangun dari
`AutoKeybindV.lua` dengan engine paket sinkronisasi SA-MP. Dokumen ini tetap
menjelaskan engine tombol virtual 1.0.3; pemetaan input, delay, dan hasil tesnya
tidak berlaku untuk engine paket 1.1.0.

[AutoKeybind-1.0.3.lua](../AutoKeybind-1.0.3.lua) merupakan file distribusi obfuscated untuk pengulangan satu tombol yang dipilih melalui panel `/autokey`. Versi ini menghapus jeda otomatis akibat chat, dialog, scoreboard, kursor, panel, fokus, dan menu pause. Tekanan pertama tetap dikirim pada frame game pertama setelah Mulai. Perubahan source berikutnya perlu diobfuscate ulang sebelum dirilis.
Target runtime adalah GTA San Andreas PC dengan SA-MP, bukan MonetLoader Android.
Versi yang dibahas pada arsip dokumentasi ini adalah **1.0.3**. Versi `1.0.2` mendahului perbaikan ini; file tersebut tidak tersedia dalam checkout saat ini.

## Pemasangan

Lihat [README setupSamp](../../README.md) untuk daftar bahan yang sudah tersedia, pilihan varian SAMPFUNCS, prasyarat CLEO/ASI Loader, dan link unduhan bahan yang belum disertakan dalam repository.

1. Siapkan GTA San Andreas, SA-MP, MoonLoader 0.26 atau versi yang kompatibel, dan SAMPFUNCS yang cocok dengan versi SA-MP.
2. Tutup game, lalu unduh **`mimgui-v1.7.1.zip`** dari [rilis resmi mimgui](https://github.com/THE-FYP/mimgui/releases/tag/v1.7.1). Ekstrak folder `mimgui` dari paket tersebut ke `moonloader/lib/`. Gunakan paket binary ini agar `cimguidx9.dll` ikut terpasang. Library `vkeys` tersedia dalam paket MoonLoader, sedangkan `bit` merupakan modul LuaJIT.
3. Pindahkan salinan Auto Keybind lama keluar dari folder `moonloader/`, lalu salin `AutoKeybind-1.0.3.lua` ke folder tersebut. Pasang satu versi Auto Keybind agar perintah tidak didaftarkan oleh beberapa salinan sekaligus. Gunakan file distribusi obfuscated, bukan source lokal `autoKeybind.lua`.
4. Jalankan game dan masuk ke server. Pesan `[AutoKey] Siap` menandakan perintah telah didaftarkan.

Jika panel tidak terbuka, periksa `moonloader/moonloader.log`, khususnya pesan tentang modul yang hilang atau SAMPFUNCS yang tidak kompatibel.

Pada instalasi game di `C:\samp`, susunan file yang diperlukan adalah:

```text
C:\samp\
  SAMPFUNCS.asi
  moonloader\
    AutoKeybind-1.0.3.lua
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
4. Klik **Mulai** setelah karakter spawn. Tombol yang dipilih ditekan pada frame game berikutnya tanpa menunggu delay, dan panel tetap terbuka. Chat, dialog, scoreboard, serta kursor tidak menunda tekanan awal.
5. Klik **Berhenti** pada panel atau tekan **F10** untuk menghentikan pengulangan. Jika panel ditutup, buka kembali melalui `/autokey` untuk mengakses tombol Berhenti.

Klik **Mulai** menandai tekanan awal sebagai siap dikirim oleh loop game. Tekanan pertama tidak menunggu nilai delay: bahkan dengan delay 60000 ms, input dikirim pada frame game berikutnya. Setiap tekanan berlangsung sedikitnya **50 ms**, lalu tombol dilepas. Delay adalah jeda **setelah pelepasan** hingga tekanan berikutnya, bukan durasi menahan tombol. Contoh: pada delay 500 ms, jarak antartekanan sekitar 550 ms. Pemrosesan mengikuti frame game sehingga waktu nyata dapat lebih panjang pada FPS rendah.

## Perilaku dan batasan

- Panel tetap terbuka setelah Mulai diklik. Membuka atau menutup panel tidak melepas tombol, menjeda pengulangan, maupun mengatur ulang jadwal tekanan.
- Mengubah pilihan melepas tombol lama dan menjadwalkan tombol baru setelah delay yang dipilih. Saat script belum berjalan, pilihan tersebut akan digunakan pada klik Mulai berikutnya.
- Menutup panel melalui X, Escape, atau `/autokey` hanya menyembunyikan panel. Klik **Berhenti** atau gunakan F10 untuk mematikan pengulangan.
- Chat, dialog SA-MP, scoreboard, kursor, serta membuka atau menutup panel tidak menjeda timer, melepas tombol, maupun menggeser jadwal berikutnya. Fungsi `inputBlocked()` dan cabang jeda telah dihapus.
- Menu pause dan kehilangan fokus juga tidak menambah kondisi jeda di script. Loop tetap memproses jadwal selama MoonLoader mendapat frame eksekusi. Jika game menghentikan eksekusi script, input baru hanya bisa diproses setelah frame tersedia lagi; tidak ada pengiriman beruntun untuk mengejar frame yang terlewat.
- Input virtual tetap dikirim saat chat atau dialog terbuka. Script tidak menyaring huruf dari kolom chat atau menjamin bahwa server menerima aksi gameplay ketika UI SA-MP sedang aktif. Perilaku penerima input memerlukan pemeriksaan langsung di game.
- Berhenti atau F10 membatalkan tekanan awal yang belum terkirim, sehingga tekanan tersebut tidak muncul setelah script dihentikan.
- Status panel menampilkan **berjalan** selama pengulangan aktif dan **berhenti** setelah dihentikan. Tidak ada status dijeda.
- Bagian bawah panel menampilkan **Author: Arvin_Inc**, setelah petunjuk delay dan pintasan. Tinggi panel 410 piksel menyediakan ruang untuk teks author.
- Tombol Mulai tetap mensyaratkan karakter sudah spawn dan hidup. Setelah aktif, mati, disconnect, atau kehilangan status spawn tidak otomatis menghentikan loop. Gunakan Berhenti atau F10 untuk menghentikannya, termasuk sebelum berpindah server bila diperlukan.
- Saat script dihentikan atau dimuat ulang, tombol yang dipegang script dilepas.
- Pilihan dan delay hanya tersimpan selama script berjalan; tidak ada file konfigurasi yang ditulis.
- Panel mengikuti susunan referensi: daftar vertikal, pengaturan delay, lalu tombol aksi. Warna navy mengikuti permintaan pengguna. Font bawaan ImGui dipakai untuk keterbacaan dan agar tidak memerlukan aset font tambahan. Tombol aksi dan baris terpilih memakai aksen biru untuk menunjukkan aksi dan pilihan aktif, tanpa animasi dekoratif.
- Navigasi keyboard ImGui diaktifkan. Tab/Shift+Tab memindahkan fokus, panah menavigasi kontrol, Enter/Space mengaktifkan tombol, dan Escape menutup panel.
- Input memakai [API MoonLoader `setVirtualKeyDown`](https://gist.github.com/THE-FYP/abc6f8bea87f4cb42331fc6dd7a84576). Fungsi tombol tetap mengikuti pengaturan kontrol game dan perilaku server. Efek di server harus diperiksa langsung.

## Kontrak implementasi

- Perintah lokal: `sampRegisterChatCommand('autokey', callback)`, tanpa argumen.
- UI: `mimgui.OnInitialize` untuk tema dan navigasi, `mimgui.OnFrame` untuk panel dan kursor. `panel.LockPlayer = false` menjaga agar panel tidak meminta penguncian kontrol karakter.
- Callback Mulai mengaktifkan `firstPressPending`, tanpa menekan tombol dari callback render UI. Loop `main()` memprioritaskan tekanan awal di atas `nextPressAt` dan memanggil `pressKey()` pada frame game berikutnya. `pressKey()` dan `stop()` menghapus status tekanan awal tersebut. Penjadwalan memakai `localClock()` dan loop `wait(0)`; chat, panel, dan status karakter tidak diperiksa sebagai penghalang pengulangan. `nextPressAt` dijadwalkan setelah pelepasan tombol atau pemilihan tombol lain, bukan di-reset oleh UI SA-MP setiap frame. Callback `/autokey` hanya mengganti visibilitas panel.
- `stop()` hanya dipanggil oleh tombol Berhenti, F10, atau penghentian/reload script. Mengubah pilihan tombol tetap melepas tombol lama dan menjadwalkan pilihan baru sesuai delay.
- Tombol virtual: Y `0x59`, ALT `0x12`, F `0x46`, H `0x48`, spasi `0x20`, N `0x4E`; F10 `0x79` menghentikan pengulangan.
- Tidak ada perubahan API jaringan, database, atau penyimpanan eksternal.

## Verifikasi

Source lokal dan file obfuscated 1.0.3 masing-masing lulus **19 kelompok pengujian stub MoonLoader/mimgui** untuk memeriksa alur kontrol dan input. Hasil tersebut belum membuktikan pemuatan DLL dalam game, rendering DirectX, interaksi fisik keyboard, atau respons server. File distribusi obfuscated belum diuji melalui game.

Source `monetloader/autoKeybind.lua` dan folder `monetloader/tests/` diabaikan oleh Git dan tidak disertakan dalam distribusi. Pengembang yang memiliki file lokal tersebut dapat menjalankan pengujian berikut dari folder `monetloader/`, tanpa memasang dependensi ke folder game:

```powershell
npx --yes --package fengari-node-cli@0.1.0 fengari tests/autoKeybind.spec.lua
npx --yes --package fengari-node-cli@0.1.0 fengari tests/autoKeybind.spec.lua AutoKeybind-1.0.3.lua
```

Tes regresi mencakup 32 kombinasi chat/dialog/scoreboard/kursor dengan panel terbuka atau tertutup, toggle chat/panel berulang selama delay, tekanan pertama keenam tombol dengan delay 60000 ms dan UI SA-MP aktif, pelepasan 50 ms, serta Stop/F10. Waktu tekanan berikutnya tetap 550 ms dan 1100 ms pada delay 500 ms dalam simulasi, tanpa bergeser akibat toggle UI.

Hasil verifikasi source dan file distribusi obfuscated:

| Pemeriksaan | Hasil dan bukti |
| --- | --- |
| Sintaks | PASS: source dan file obfuscated berhasil diparse sebagai Lua 5.1. Eksekusi stub memakai Fengari, bukan runtime LuaJIT game. |
| Kontrol UI | PASS melalui stub: `/autokey` membuka/menutup tanpa mengubah jadwal pengulangan, enam pilihan mengganti tombol, slider/input mengubah delay, Mulai mengirim tekanan pada frame game pertama sambil mempertahankan panel, Berhenti/F10 mematikan, dan X/Escape menutup panel. Status berjalan/berhenti diperiksa. |
| Pengulangan | PASS melalui stub: semua key-down dijalankan dari loop game; delay 60000 ms tidak menunda tekanan awal; Berhenti/F10 membatalkan tekanan awal yang belum terkirim. Chat/dialog/scoreboard/kursor, panel, fokus/pause, serta mati/disconnect tidak menghentikan jadwal. Pelepasan 50 ms, batas delay, pergantian pilihan, terminate, dan frame lambat juga diperiksa. Total 19 kelompok pengujian lulus. |
| Kontras | PASS dari nilai warna source: teks utama terhadap seluruh permukaan navy memiliki rasio minimal 5,48:1. |
| Referensi | Link distribusi mengarah ke file obfuscated yang tersedia dan README. Path tes ditulis sebagai petunjuk pengembangan lokal karena tes tetap diabaikan Git. |

Review desain berdasarkan sumber dan stub:

- Hard Gate PASS: setiap kontrol memiliki perilaku yang diperiksa; tidak ada aset, statistik, testimoni, atau klaim buatan. Fokus keyboard dan Escape dikonfigurasi. Rendering native serta navigasi fisik memerlukan pemeriksaan di game.
- Purpose Gate PASS: navy berasal dari permintaan pengguna; font bawaan menghindari dependensi aset; aksen biru menandai pilihan dan aksi. Tidak ada gradien, glow, ilustrasi, atau animasi dekoratif.
- Liveliness PASS: ENERGY 1 / RHYTHM 1 / MOTION 1 mengikuti panel utilitas referensi. Daftar tombol, jeda, lalu Mulai menjadi urutan visual dan penggunaan.
- Craftsmanship PASS dalam cakupan sumber/stub: aksi, status berjalan/berhenti, pembatasan delay, dan kegagalan memulai sebelum spawn memiliki alur yang jelas. Klaim kecocokan visual dan respons server ditunda sampai pengujian native.

Pemeriksaan langsung yang masih diperlukan di game:

- Buka `/autokey`, cek warna navy, enam pilihan, slider, input angka, dan tata letak pada resolusi game yang digunakan.
- Klik Mulai pada masing-masing pilihan dengan delay 60000 ms: tekanan pertama harus terjadi pada frame game berikutnya dan panel tetap terbuka. Periksa pengulangan dengan delay berbeda, lalu hentikan melalui F10 dan tombol Berhenti.
- Buka/tutup chat, dialog, scoreboard, dan panel, termasuk ketika kursor SA-MP aktif. Periksa bahwa jadwal tidak di-reset, tekanan tetap berulang, dan status tetap berjalan. Periksa juga efek input terhadap teks chat dan kontrol gameplay.
- Periksa perilaku saat pause atau kehilangan fokus dengan memperhatikan ketersediaan frame MoonLoader. Script tidak menambah jeda, tetapi tidak dapat memaksa engine yang berhenti mengeksekusi frame.
- Periksa bahwa mati/disconnect tidak mengubah status berjalan, lalu hentikan melalui Berhenti atau F10. Periksa bahwa tombol dilepas saat berhenti dan reload script.
- Coba Tab/Shift+Tab, panah, Enter/Space, Escape, dan tombol X pada panel.

## Pembuatan file distribusi

Source asli tetap disimpan lokal sebagai `autoKeybind.lua`. File distribusi memakai nama `AutoKeybind-1.0.3.lua`, mengikuti metadata versi source. Source asli dan tes tetap diabaikan oleh `.gitignore`; file distribusi dapat dilacak Git. Perubahan rilis ini mengunggah file obfuscated, README, dan dokumentasi ini; source mentah, tes, alat build, serta dependensi pengembangan tidak ikut di-commit.

Build ini menggunakan [luamin 1.0.4](https://github.com/mathiasbynens/luamin/tree/v1.0.4) untuk pemadatan dan penggantian nama variabel lokal, serta penyamaran string berbasis angka. Sebanyak **36 string** dikodekan dan diperiksa agar hasil pembacaannya tetap sama. Fungsi global `main`, `onWindowMessage`, dan `onScriptTerminate` dipertahankan agar MoonLoader tetap menemukan callback-nya. Tidak ada loader `loadstring`, unduhan kode saat runtime, atau kebutuhan library tambahan dari proses obfuscation ini.

Alat pengembangan dipasang di folder sementara di luar repository: `fengari-node-cli@0.1.0` untuk tes simulasi, `luamin@1.0.4` untuk pemadatan, dan `luaparse@0.3.1` untuk pemeriksaan sintaks Lua 5.1 serta rentang literal string. Ketiganya bukan dependensi runtime game. Builder lokal membaca source, menyamarkan string, memadatkan hasil, memeriksa callback global, lalu menulis artefak baru tanpa mengubah source.

Header distribusi mencatat versi, author `Arvin_Inc`, dan SHA256 source yang dipakai. Hash source build ini adalah `253b16cd7cae3093cbbee5e36a50e5d8ac74bb3179671a7336aa458bc7bd2769`. Source tidak diubah saat file distribusi dibuat.

Sebelum push, jalankan tes terhadap source dan artefak, pastikan keduanya lulus, lalu periksa `git diff --cached --name-only`. Daftar perubahan rilis harus hanya berisi artefak obfuscated dan dokumentasi yang terkait. Pastikan `git check-ignore monetloader/autoKeybind.lua monetloader/tests/autoKeybind.spec.lua` masih mengenali kedua path tersebut sebagai file lokal.

Obfuscation mempersulit pembacaan langsung, tetapi kode dan string tetap dapat dianalisis atau dipulihkan oleh pihak yang memiliki file. Source di riwayat commit lama tetap ada. Artefak perlu dibuat ulang setelah source diperbaiki, lalu diperiksa dengan pengujian yang sama sebelum didistribusikan. Pasang satu versi Auto Keybind pada folder game agar callback dan perintah `/autokey` tidak berjalan ganda.
