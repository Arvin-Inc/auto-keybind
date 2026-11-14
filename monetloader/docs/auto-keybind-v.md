# Auto Keybind 1.1.0 dari AutoKeybindV

[AutoKeybind-1.1.0.lua](../AutoKeybind-1.1.0.lua) adalah file distribusi
obfuscated dari source lokal `monetloader/AutoKeybindV.lua`. Targetnya
MoonLoader PC dengan SA-MP dan SAMPFUNCS. Kompatibilitas MonetLoader Android
belum diverifikasi.

Versi naik dari 1.0.3 ke **1.1.0** karena engine input berubah dari tombol
virtual menjadi pengiriman paket sinkronisasi on-foot. Rilis ini mengemas
perubahan yang sudah ada di AutoKeybindV; proses obfuscation hanya menambahkan
metadata `script_version('1.1.0')` pada source, tanpa mengubah logika game.

## Perubahan dari 1.0.3

| Bagian | 1.0.3 | 1.1.0 |
| --- | --- | --- |
| Input | `setVirtualKeyDown` | `SendKey`, mengubah dan mengirim data on-foot |
| Tekanan awal | Frame game berikutnya | Paket pertama langsung dari callback Mulai |
| Pengulangan | Loop game dengan penekanan sedikitnya 50 ms | Worker `lua_thread` dengan `wait(delay[0])` antarpaket |
| Delay | 50 sampai 60000 ms | 50 sampai 10000 ms, awal 500 ms |
| Ganti pilihan | Melepas tombol dan menjadwalkan ulang | Pilihan baru digunakan pada paket berikutnya, tanpa reset waktu tunggu |
| Ganti delay | Dipakai saat menjadwalkan tekanan berikutnya | Waktu tunggu yang sedang berjalan selesai dahulu; delay baru dipakai pada putaran berikutnya |
| Mati, disconnect, atau gagal kirim | Loop tidak otomatis berhenti karena status karakter | Pengulangan berhenti saat pemeriksaan atau pengiriman berikutnya gagal |

Perintah `/autokey`, panel navy 400 x 410, enam pilihan, tombol Mulai/Berhenti,
F10, Escape, dan author `Arvin_Inc` tetap tersedia. Pola pengiriman on-foot
berasal dari source AutoOtot yang dipulihkan sebelumnya, dengan metadata
author `Aarmaaa28`; varian AutoKeybindV menggabungkannya dengan GUI Auto Keybind,
pemeriksaan status pemain, penanganan kegagalan, dan penghentian worker.
Lihat [arsip panduan 1.0.3](auto-keybind.md) untuk engine sebelumnya.

## Pemasangan dan penggunaan

1. Siapkan GTA San Andreas PC, SA-MP, MoonLoader, SAMPFUNCS, dan `mimgui`.
   Petunjuk bahan ada di [README](../../README.md) dan
   [panduan dependensi MoonLoader](auto-keybind.md#pemasangan).
   Dependensi Lua langsung tetap `mimgui`, `vkeys`, dan modul LuaJIT `bit`.
2. Pindahkan versi Auto Keybind lain keluar dari folder `moonloader/`, lalu
   pasang `AutoKeybind-1.1.0.lua`. Source dan file distribusi mendaftarkan
   perintah yang sama; pasang hanya satu salinan.
3. Jalankan game, tunggu SA-MP tersedia, lalu buka `/autokey`.
4. Pilih Y, ALT, F, H, SPC (Spasi), atau N, lalu atur delay 50 sampai 10000 ms.
5. Klik Mulai setelah karakter spawn dan hidup. Paket pertama langsung dikirim;
   panel tetap terbuka. Klik Berhenti atau tekan F10 untuk menghentikan worker.

Menutup panel melalui X, Escape, atau `/autokey` tidak menghentikan pengulangan.
Chat, dialog, scoreboard, kursor, dan visibilitas panel tidak diperiksa sebagai
penghalang di worker. Pause menyembunyikan panel, tetapi tidak menambahkan
cabang jeda pada worker; pengiriman tetap bergantung pada kesempatan eksekusi
MoonLoader. Tidak ada file konfigurasi yang ditulis.

## Kontrak engine paket

`SendKey(value, offset)` memeriksa ketersediaan SA-MP, status spawn/hidup, ID
pemain, serta hasil alokasi buffer 68 byte. Data disalin dengan
`sampStorePlayerOnfootData`, field diubah dengan `setStructElement`, kemudian
dikirim melalui `sampSendOnfootData`. Buffer dibebaskan setelah operasi
`pcall`, termasuk saat penyimpanan atau pengiriman memunculkan error Lua.

| Pilihan | Nilai | Offset byte | Lebar byte |
| --- | --- | --- | --- |
| Y | 64 | 36 | 1 |
| ALT | 1024 | 4 | 2 |
| F | 16 | 4 | 2 |
| H | 192 | 36 | 1 |
| SPC (Spasi) | 8 | 36 | 1 |
| N | 128 | 36 | 1 |

Mulai membatalkan worker lama sebelum mengirim paket pertama. Berhenti, F10,
dan penghentian script membatalkan worker. Jika pengiriman gagal di tengah
pengulangan, status berubah menjadi berhenti dan alasan ditampilkan melalui
chat bila SA-MP masih tersedia.

## Build obfuscated

- Source tetap terbaca sebagai `AutoKeybindV.lua`; file distribusi baru bernama
  `AutoKeybind-1.1.0.lua`. File 1.0.3 tidak ditimpa.
- Build menggunakan alat lokal sementara yang sudah tersedia: `luamin@1.0.4`
  untuk pemadatan/penggantian nama lokal, `luaparse@0.3.1` untuk parsing Lua 5.1,
  dan `fengari-node-cli@0.1.0` untuk pengujian stub. Tidak ada dependensi baru
  pada runtime game atau paket yang ditambahkan ke repository.
- Sebanyak **39 literal string** disamarkan menjadi tabel angka dengan decoder
  lokal. Hasil decoding masing-masing diperiksa terhadap byte string semula.
- Fungsi global `SendKey`, `main`, `onWindowMessage`, dan `onScriptTerminate`
  dipertahankan. Tidak ada loader `loadstring` atau unduhan kode saat runtime.
- Artefak berukuran **6749 byte**. Header mencatat versi, author, dan SHA256
  source: `1486c296d6641c37986eb3440530988c3690351c3b617bf74a111c354f86d4a1`.
- Source, backup, dan tes tetap diabaikan Git; artefak serta dokumentasi dapat
  dilacak Git. Setiap perubahan source memerlukan build dan pengujian ulang.

Obfuscation mempersulit pembacaan, tetapi tetap bisa dianalisis atau dipulihkan
oleh pemilik file. Source yang pernah dikomit tetap bisa ada di riwayat Git.

## Verifikasi

Source dan artefak masing-masing lulus **14 kelompok tes stub**
MoonLoader/mimgui/sinkronisasi. Pemeriksaan mencakup metadata versi/author,
keenam pemetaan paket, paket pertama langsung pada delay 10000 ms,
stop/restart, 32 kombinasi status UI dengan panel terbuka/tertutup, perubahan
pilihan/delay, pembatasan delay, kegagalan status pemain/alokasi/pengiriman,
pembebasan buffer, F10/Escape/X, terminate, dan dependensi SA-MP yang hilang.

Pengembang yang memiliki tes lokal dapat menjalankan dari folder `monetloader/`:

```powershell
npx --yes --package fengari-node-cli@0.1.0 fengari tests/autoOtot.spec.lua AutoKeybindV.lua
npx --yes --package fengari-node-cli@0.1.0 fengari tests/autoOtot.spec.lua AutoKeybind-1.1.0.lua
```

Sintaks source dan artefak juga lolos parsing Lua 5.1. Hash source cocok dengan
header artefak dan source tidak berubah selama build. Hasil ini belum
membuktikan pemuatan DLL, rendering DirectX, keyboard fisik, atau penerimaan
aksi oleh server. Pengujian langsung di game masih diperlukan.
