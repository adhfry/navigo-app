import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/faq_model.dart';

class HelpController extends GetxController {
  final searchController = TextEditingController();
  final searchQuery = ''.obs;
  final selectedCategoryId = RxnString();
  final expandedItemId = RxnString();
  
  final categories = <FAQCategory>[].obs;
  final searchResults = <SearchMatch>[].obs;
  final isSearching = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeFAQData();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  void _initializeFAQData() {
    categories.value = [
      FAQCategory(
        id: 'navigo',
        title: 'Tentang NaviGo',
        icon: '🚢',
        items: [
          FAQItem(
            id: 'navigo_1',
            question: 'Apa itu NaviGo?',
            answer: 'NaviGo adalah super-app maritim yang menyediakan tiga layanan utama:\n\n'
                '• NaviTICKET: Pemesanan tiket kapal online yang mudah dan cepat\n'
                '• NaviSEND: Layanan jastip (jasa titip) untuk pengiriman barang antar pulau\n'
                '• NaviSAFE: Fitur keamanan untuk memastikan perjalanan Anda aman\n\n'
                'NaviGo dirancang khusus untuk mempermudah mobilitas dan logistik maritim di Indonesia.',
            keywords: ['navigo', 'tentang', 'super app', 'maritim', 'layanan'],
            categoryId: 'navigo',
          ),
          FAQItem(
            id: 'navigo_2',
            question: 'Bagaimana cara mendaftar di NaviGo?',
            answer: 'Pendaftaran di NaviGo sangat mudah:\n\n'
                '1. Buka aplikasi NaviGo\n'
                '2. Pilih "Daftar" di halaman awal\n'
                '3. Isi data diri: Nama, Email, Nomor HP, dan Password\n'
                '4. Verifikasi email Anda melalui link yang dikirim\n'
                '5. Lengkapi profil Anda (Jenis Kelamin, Bio)\n\n'
                'Anda juga bisa daftar menggunakan akun Google untuk lebih cepat!',
            keywords: ['daftar', 'register', 'akun', 'signup', 'buat akun'],
            categoryId: 'navigo',
          ),
          FAQItem(
            id: 'navigo_3',
            question: 'Apakah NaviGo gratis?',
            answer: 'NaviGo gratis untuk diunduh dan digunakan. Anda tidak dikenakan biaya untuk:\n\n'
                '• Membuat akun\n'
                '• Mencari jadwal kapal\n'
                '• Browse layanan jastip\n'
                '• Menggunakan fitur keamanan dasar\n\n'
                'Biaya hanya dikenakan saat Anda melakukan transaksi seperti membeli tiket kapal atau menggunakan layanan jastip.',
            keywords: ['gratis', 'biaya', 'harga', 'bayar', 'free'],
            categoryId: 'navigo',
          ),
        ],
      ),
      FAQCategory(
        id: 'ticket',
        title: 'NaviTICKET',
        icon: '🎫',
        items: [
          FAQItem(
            id: 'ticket_1',
            question: 'Bagaimana cara memesan tiket kapal?',
            answer: 'Cara memesan tiket kapal di NaviGo:\n\n'
                '1. Buka aplikasi dan pilih "Tiket Kapal"\n'
                '2. Pilih rute perjalanan (Pelabuhan Asal → Pelabuhan Tujuan)\n'
                '3. Pilih tanggal keberangkatan\n'
                '4. Pilih jadwal kapal yang tersedia\n'
                '5. Isi data penumpang\n'
                '6. Pilih metode pembayaran (Midtrans: Transfer, E-wallet, dll)\n'
                '7. Selesaikan pembayaran\n'
                '8. E-ticket akan dikirim ke email dan tersimpan di aplikasi\n\n'
                'Tiket bisa langsung ditunjukkan saat boarding!',
            keywords: ['pesan', 'tiket', 'kapal', 'booking', 'beli tiket'],
            categoryId: 'ticket',
          ),
          FAQItem(
            id: 'ticket_2',
            question: 'Metode pembayaran apa saja yang tersedia?',
            answer: 'NaviGo bekerja sama dengan Midtrans untuk menyediakan berbagai metode pembayaran:\n\n'
                '• Transfer Bank (BCA, Mandiri, BNI, BRI, dll)\n'
                '• E-Wallet (GoPay, OVO, DANA, ShopeePay)\n'
                '• Kartu Kredit/Debit (Visa, Mastercard)\n'
                '• Minimarket (Indomaret, Alfamart)\n\n'
                'Semua transaksi aman dan terenkripsi!',
            keywords: ['bayar', 'pembayaran', 'transfer', 'gopay', 'ovo', 'dana', 'kartu kredit'],
            categoryId: 'ticket',
          ),
          FAQItem(
            id: 'ticket_3',
            question: 'Bagaimana cara membatalkan tiket?',
            answer: 'Untuk membatalkan tiket:\n\n'
                '1. Buka "Riwayat Pemesanan" di menu profil\n'
                '2. Pilih tiket yang ingin dibatalkan\n'
                '3. Klik tombol "Batalkan Pemesanan"\n'
                '4. Pilih alasan pembatalan\n'
                '5. Konfirmasi pembatalan\n\n'
                'Kebijakan Refund:\n'
                '• Pembatalan >7 hari sebelum keberangkatan: Refund 90%\n'
                '• Pembatalan 3-7 hari: Refund 50%\n'
                '• Pembatalan <3 hari: Refund 25%\n'
                '• Pembatalan <24 jam: Tidak dapat refund\n\n'
                'Proses refund 7-14 hari kerja.',
            keywords: ['batal', 'cancel', 'refund', 'kembalikan', 'uang kembali'],
            categoryId: 'ticket',
          ),
          FAQItem(
            id: 'ticket_4',
            question: 'Bagaimana jika terlambat boarding?',
            answer: 'Jika Anda terlambat boarding:\n\n'
                '• Datang minimal 30 menit sebelum keberangkatan\n'
                '• Jika terlambat, hubungi operator kapal langsung (nomor ada di tiket)\n'
                '• Tiket hangus jika kapal sudah berangkat\n'
                '• Reschedule tersedia dengan biaya tambahan (tergantung kebijakan operator)\n\n'
                'Tips: Set alarm pengingat 2 jam sebelum keberangkatan!',
            keywords: ['terlambat', 'telat', 'boarding', 'hangus', 'reschedule'],
            categoryId: 'ticket',
          ),
        ],
      ),
      FAQCategory(
        id: 'jastip',
        title: 'NaviSEND (Jastip)',
        icon: '📦',
        items: [
          FAQItem(
            id: 'jastip_1',
            question: 'Apa itu NaviSEND?',
            answer: 'NaviSEND adalah layanan jastip (jasa titip) untuk pengiriman barang antar pulau. Fitur:\n\n'
                '• Request Barang: Anda yang butuh barang dikirim\n'
                '• Offer Jastip: Traveler yang bisa bawakan barang\n'
                '• Escrow Payment: Uang aman hingga barang sampai\n'
                '• Rating System: Traveler terverifikasi & rating tinggi\n'
                '• Real-time Tracking: Pantau status pengiriman\n\n'
                'Lebih murah dan personal dibanding ekspedisi konvensional!',
            keywords: ['jastip', 'navisend', 'kirim barang', 'pengiriman', 'titip barang'],
            categoryId: 'jastip',
          ),
          FAQItem(
            id: 'jastip_2',
            question: 'Bagaimana cara request barang via jastip?',
            answer: 'Cara request barang di NaviSEND:\n\n'
                '1. Pilih menu "NaviSEND"\n'
                '2. Klik "Request Barang"\n'
                '3. Isi detail:\n'
                '   - Nama barang\n'
                '   - Berat & dimensi\n'
                '   - Lokasi pick-up & drop-off\n'
                '   - Tanggal dibutuhkan\n'
                '   - Budget maksimal\n'
                '4. Upload foto barang (opsional)\n'
                '5. Submit request\n'
                '6. Tunggu traveler yang tertarik offer\n'
                '7. Pilih traveler dengan rating terbaik\n'
                '8. Bayar ke escrow NaviGo\n'
                '9. Uang dilepas ke traveler setelah barang Anda terima',
            keywords: ['request', 'minta', 'kirim', 'barang', 'titip'],
            categoryId: 'jastip',
          ),
          FAQItem(
            id: 'jastip_3',
            question: 'Bagaimana cara jadi Traveler (pembawa jastip)?',
            answer: 'Cara menjadi Traveler di NaviSEND:\n\n'
                '1. Verifikasi akun dulu (Menu: Jadi Traveler)\n'
                '2. Upload KTP & Foto Selfie\n'
                '3. Tunggu verifikasi admin (1-3 hari kerja)\n'
                '4. Setelah terverifikasi:\n'
                '   - Browse request barang\n'
                '   - Offer jastip sesuai rute perjalanan Anda\n'
                '   - Tunggu konfirmasi dari requester\n'
                '   - Pickup barang\n'
                '   - Deliver ke tujuan\n'
                '   - Dapat bayaran!\n\n'
                'Keuntungan jadi Traveler:\n'
                '• Uang tambahan dari perjalanan\n'
                '• Rating & review meningkatkan kepercayaan\n'
                '• Flexible, bawa barang sesuai kapasitas',
            keywords: ['traveler', 'jadi', 'pembawa', 'offer', 'verifikasi'],
            categoryId: 'jastip',
          ),
          FAQItem(
            id: 'jastip_4',
            question: 'Apakah barang saya aman dengan jastip?',
            answer: 'NaviGo menjamin keamanan dengan:\n\n'
                '🔒 Traveler Terverifikasi:\n'
                '• Verifikasi KTP\n'
                '• Rating & review transparan\n'
                '• Riwayat pengiriman tercatat\n\n'
                '💰 Escrow Payment:\n'
                '• Uang ditahan NaviGo sampai barang sampai\n'
                '• Refund otomatis jika ada masalah\n\n'
                '📋 Asuransi NaviSAFE:\n'
                '• Kompensasi hingga 10 juta untuk barang hilang/rusak\n'
                '• Syarat: aktifkan NaviSAFE saat checkout\n\n'
                '📞 Customer Support 24/7:\n'
                '• Chat langsung jika ada masalah\n'
                '• Mediasi sengketa\n\n'
                'Tips: Selalu cek rating traveler & foto barang saat terima!',
            keywords: ['aman', 'keamanan', 'asuransi', 'escrow', 'garansi'],
            categoryId: 'jastip',
          ),
        ],
      ),
      FAQCategory(
        id: 'safety',
        title: 'NaviSAFE',
        icon: '🛡️',
        items: [
          FAQItem(
            id: 'safety_1',
            question: 'Apa itu NaviSAFE?',
            answer: 'NaviSAFE adalah fitur keamanan komprehensif NaviGo:\n\n'
                '🌊 Kondisi Cuaca Real-time:\n'
                '• Prakiraan cuaca rute pelayaran\n'
                '• Tinggi gelombang\n'
                '• Peringatan cuaca buruk\n\n'
                '🚨 Tombol Darurat (SOS):\n'
                '• Hubungi SAR & pihak berwenang\n'
                '• Share lokasi otomatis\n\n'
                '📍 Live Location Sharing:\n'
                '• Bagikan lokasi ke keluarga\n'
                '• Tracking perjalanan real-time\n\n'
                '🛡️ Asuransi Perjalanan:\n'
                '• Cover kecelakaan hingga 100 juta\n'
                '• Kompensasi barang hilang/rusak\n\n'
                'NaviSAFE: Perjalanan Aman, Hati Tenang!',
            keywords: ['navisafe', 'keamanan', 'safety', 'aman', 'asuransi'],
            categoryId: 'safety',
          ),
          FAQItem(
            id: 'safety_2',
            question: 'Bagaimana cara mengaktifkan NaviSAFE?',
            answer: 'Cara mengaktifkan NaviSAFE:\n\n'
                'Untuk Tiket Kapal:\n'
                '1. Saat checkout tiket, centang "Aktifkan NaviSAFE"\n'
                '2. Biaya tambahan Rp 10.000/orang\n'
                '3. Coverage: Asuransi kecelakaan + Tracking\n\n'
                'Untuk Jastip:\n'
                '1. Saat request barang, pilih "NaviSAFE Protection"\n'
                '2. Biaya 2% dari nilai barang (min Rp 5.000)\n'
                '3. Coverage: Kompensasi barang hilang/rusak hingga 10 juta\n\n'
                'Fitur Gratis (Semua User):\n'
                '• Cek kondisi cuaca\n'
                '• Peringatan cuaca buruk\n'
                '• Tombol SOS darurat',
            keywords: ['aktifkan', 'pasang', 'navisafe', 'asuransi', 'proteksi'],
            categoryId: 'safety',
          ),
          FAQItem(
            id: 'safety_3',
            question: 'Bagaimana cara menggunakan tombol SOS?',
            answer: 'Cara menggunakan tombol SOS darurat:\n\n'
                '1. Buka aplikasi NaviGo\n'
                '2. Di halaman utama, tekan tombol merah "SOS" (sidebar)\n'
                '3. Pilih jenis darurat:\n'
                '   - Kecelakaan kapal\n'
                '   - Kondisi medis\n'
                '   - Situasi berbahaya\n'
                '   - Lainnya\n'
                '4. Lokasi GPS otomatis terkirim\n'
                '5. Sistem akan:\n'
                '   - Hubungi SAR terdekat\n'
                '   - Notifikasi operator kapal\n'
                '   - Alert ke kontak darurat Anda\n'
                '   - Customer support siaga\n\n'
                '⚠️ PENTING:\n'
                '• Gunakan hanya untuk keadaan darurat nyata\n'
                '• Penyalahgunaan dapat dikenakan sanksi\n'
                '• Pastikan GPS aktif untuk lokasi akurat',
            keywords: ['sos', 'darurat', 'emergency', 'bantuan', 'panggil'],
            categoryId: 'safety',
          ),
        ],
      ),
      FAQCategory(
        id: 'account',
        title: 'Akun & Profil',
        icon: '👤',
        items: [
          FAQItem(
            id: 'account_1',
            question: 'Bagaimana cara mengganti password?',
            answer: 'Cara mengganti password:\n\n'
                '1. Login ke akun NaviGo\n'
                '2. Buka "Profil Saya"\n'
                '3. Pilih "Pengaturan Akun"\n'
                '4. Klik "Ubah Password"\n'
                '5. Masukkan password lama\n'
                '6. Masukkan password baru (min 8 karakter)\n'
                '7. Konfirmasi password baru\n'
                '8. Klik "Simpan"\n\n'
                'Jika lupa password lama:\n'
                '1. Logout dari akun\n'
                '2. Pilih "Lupa Password" di halaman login\n'
                '3. Masukkan email terdaftar\n'
                '4. Cek email untuk link reset password\n'
                '5. Buat password baru',
            keywords: ['password', 'ganti', 'ubah', 'lupa', 'reset'],
            categoryId: 'account',
          ),
          FAQItem(
            id: 'account_2',
            question: 'Bagaimana cara menghubungkan akun Google?',
            answer: 'Cara menghubungkan akun Google:\n\n'
                '1. Login ke akun NaviGo\n'
                '2. Buka "Profil Saya"\n'
                '3. Scroll ke bawah, cari card "Akun Google"\n'
                '4. Klik tombol "Sambungkan dengan Google"\n'
                '5. Pilih akun Google Anda\n'
                '6. Izinkan akses\n'
                '7. Selesai! Status akan berubah jadi "Tersambung"\n\n'
                'Keuntungan tersambung dengan Google:\n'
                '• Login lebih cepat (1 klik)\n'
                '• Tidak perlu ingat password\n'
                '• Lebih aman dengan 2FA Google\n'
                '• Sync foto profil otomatis\n\n'
                'Note: Email akun Google harus sama dengan email NaviGo',
            keywords: ['google', 'sambung', 'connect', 'link', 'hubungkan'],
            categoryId: 'account',
          ),
          FAQItem(
            id: 'account_3',
            question: 'Bagaimana cara menghapus akun?',
            answer: 'Cara menghapus akun NaviGo:\n\n'
                '⚠️ PERINGATAN: Penghapusan akun bersifat PERMANEN!\n\n'
                'Data yang akan terhapus:\n'
                '• Profil & info pribadi\n'
                '• Riwayat pemesanan (tiket & jastip)\n'
                '• Rating & review\n'
                '• Saldo & poin rewards\n\n'
                'Langkah penghapusan:\n'
                '1. Buka "Profil Saya"\n'
                '2. "Pengaturan Akun" → "Privasi & Keamanan"\n'
                '3. Scroll ke bawah, pilih "Hapus Akun"\n'
                '4. Baca disclaimer\n'
                '5. Masukkan password untuk konfirmasi\n'
                '6. Pilih alasan penghapusan (opsional)\n'
                '7. Klik "Hapus Akun Permanen"\n\n'
                'Akun akan dihapus dalam 7 hari. Anda bisa login kembali dalam periode ini untuk membatalkan penghapusan.',
            keywords: ['hapus', 'delete', 'tutup', 'akun', 'close'],
            categoryId: 'account',
          ),
        ],
      ),
      FAQCategory(
        id: 'payment',
        title: 'Pembayaran & Refund',
        icon: '💳',
        items: [
          FAQItem(
            id: 'payment_1',
            question: 'Bagaimana cara mendapatkan refund?',
            answer: 'Proses refund di NaviGo:\n\n'
                'Kasus yang bisa refund:\n'
                '• Pembatalan tiket sesuai kebijakan\n'
                '• Jadwal kapal dibatalkan operator\n'
                '• Barang jastip tidak sampai/rusak (NaviSAFE aktif)\n'
                '• Kesalahan sistem pembayaran\n\n'
                'Cara mengajukan refund:\n'
                '1. Buka "Riwayat Pemesanan"\n'
                '2. Pilih transaksi yang ingin direfund\n'
                '3. Klik "Ajukan Refund"\n'
                '4. Isi alasan & upload bukti (jika perlu)\n'
                '5. Submit\n\n'
                'Timeline refund:\n'
                '• Review pengajuan: 1-3 hari kerja\n'
                '• Proses refund: 7-14 hari kerja\n'
                '• Dana kembali ke metode pembayaran awal\n\n'
                'Status refund bisa dicek di menu "Riwayat Refund"',
            keywords: ['refund', 'kembalikan', 'uang', 'batal', 'dana'],
            categoryId: 'payment',
          ),
          FAQItem(
            id: 'payment_2',
            question: 'Pembayaran saya gagal, apa yang harus dilakukan?',
            answer: 'Jika pembayaran gagal:\n\n'
                'Penyebab umum:\n'
                '• Saldo/limit tidak cukup\n'
                '• Koneksi internet terputus\n'
                '• Kesalahan input data kartu\n'
                '• Bank menolak transaksi (fraud detection)\n\n'
                'Solusi:\n'
                '1. Cek notifikasi dari bank/e-wallet\n'
                '2. Pastikan saldo cukup\n'
                '3. Cek koneksi internet stabil\n'
                '4. Coba metode pembayaran lain\n'
                '5. Hubungi customer support jika tetap gagal\n\n'
                'Jika uang terpotong tapi tiket tidak terbit:\n'
                '• Tunggu 1-2 jam (kadang delay sistem)\n'
                '• Cek email konfirmasi\n'
                '• Cek menu "Riwayat Pemesanan"\n'
                '• Jika >24 jam belum ada, hubungi CS dengan bukti transfer\n'
                '• Refund otomatis 3-7 hari jika transaksi memang gagal',
            keywords: ['gagal', 'bayar', 'error', 'failed', 'pembayaran'],
            categoryId: 'payment',
          ),
        ],
      ),
      FAQCategory(
        id: 'technical',
        title: 'Teknis & Troubleshooting',
        icon: '⚙️',
        items: [
          FAQItem(
            id: 'tech_1',
            question: 'Aplikasi tidak bisa dibuka / crash',
            answer: 'Solusi aplikasi crash:\n\n'
                '1. Force close aplikasi:\n'
                '   - Android: Settings → Apps → NaviGo → Force Stop\n'
                '   - iOS: Swipe up untuk close\n\n'
                '2. Clear cache:\n'
                '   - Android: Settings → Apps → NaviGo → Clear Cache\n'
                '   - iOS: Uninstall & reinstall\n\n'
                '3. Pastikan aplikasi versi terbaru:\n'
                '   - Cek update di Play Store/App Store\n\n'
                '4. Restart handphone\n\n'
                '5. Cek storage cukup (min 500MB free)\n\n'
                '6. Pastikan OS minimal:\n'
                '   - Android 7.0\n'
                '   - iOS 12.0\n\n'
                'Jika masih crash, hubungi customer support dengan info:\n'
                '• Model HP\n'
                '• Versi OS\n'
                '• Screenshot error (jika ada)',
            keywords: ['crash', 'error', 'tidak bisa', 'rusak', 'masalah'],
            categoryId: 'technical',
          ),
          FAQItem(
            id: 'tech_2',
            question: 'Tidak bisa login / Lupa password',
            answer: 'Solusi masalah login:\n\n'
                'Lupa Password:\n'
                '1. Di halaman login, klik "Lupa Password"\n'
                '2. Masukkan email terdaftar\n'
                '3. Cek inbox email (juga folder spam)\n'
                '4. Klik link reset password (valid 1 jam)\n'
                '5. Buat password baru\n\n'
                'Email tidak terdaftar:\n'
                '• Coba email lain yang pernah Anda pakai\n'
                '• Cek typo (huruf besar/kecil)\n'
                '• Hubungi CS jika yakin pernah daftar\n\n'
                'Password salah terus:\n'
                '• Cek CAPS LOCK\n'
                '• Coba login via Google jika pernah link\n'
                '• Reset password jika lupa\n\n'
                'Akun terkunci:\n'
                '• Setelah 5x salah password, akun terkunci 30 menit\n'
                '• Tunggu atau reset password',
            keywords: ['login', 'lupa', 'password', 'masuk', 'akun'],
            categoryId: 'technical',
          ),
        ],
      ),
    ];
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    
    if (query.isEmpty) {
      isSearching.value = false;
      searchResults.clear();
      return;
    }

    isSearching.value = true;
    _performSearch(query);
  }

  void _performSearch(String query) {
    final results = <SearchMatch>[];
    final lowerQuery = query.toLowerCase();

    for (final category in categories) {
      for (final item in category.items) {
        if (item.matchesSearch(query)) {
          // Find matched phrases for highlighting
          final matchedPhrases = <String>[];
          
          // Split query into words
          final queryWords = lowerQuery.split(' ').where((w) => w.isNotEmpty).toList();
          
          for (final word in queryWords) {
            if (item.question.toLowerCase().contains(word)) {
              matchedPhrases.add(word);
            }
            if (item.answer.toLowerCase().contains(word)) {
              matchedPhrases.add(word);
            }
          }
          
          results.add(SearchMatch(
            item: item,
            matchedPhrases: matchedPhrases.toSet().toList(),
          ));
        }
      }
    }

    searchResults.value = results;
  }

  void selectCategory(String? categoryId) {
    selectedCategoryId.value = categoryId;
    expandedItemId.value = null;
  }

  void toggleExpand(String itemId) {
    if (expandedItemId.value == itemId) {
      expandedItemId.value = null;
    } else {
      expandedItemId.value = itemId;
    }
  }

  void clearSearch() {
    searchController.clear();
    searchQuery.value = '';
    isSearching.value = false;
    searchResults.clear();
  }

  List<FAQItem> get filteredItems {
    if (selectedCategoryId.value == null) {
      return categories.expand((c) => c.items).toList();
    }
    
    return categories
        .firstWhere((c) => c.id == selectedCategoryId.value)
        .items;
  }

  FAQCategory? getCategoryById(String categoryId) {
    try {
      return categories.firstWhere((c) => c.id == categoryId);
    } catch (e) {
      return null;
    }
  }
}
