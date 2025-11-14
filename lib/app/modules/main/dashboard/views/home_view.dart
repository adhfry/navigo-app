import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:navi_go/app/config/theme.dart';
import 'package:navi_go/app/modules/main/dashboard/controllers/dashboard_controller.dart';

class HomeView extends GetView<DashboardController> {
  const HomeView({super.key});
  final List<String> imgList = const [
    'https://picsum.photos/seed/navigo1/600/400',
    'https://picsum.photos/seed/navigo2/600/400',
    'https://picsum.photos/seed/navigo3/600/400',
  ];

  // Daftar menu layanan
  final List<Map<String, dynamic>> services = const [
    {'icon': Icons.directions_boat_filled, 'label': 'Tiket Kapal'},
    {'icon': Icons.move_to_inbox, 'label': 'Jastip Antar'},
    {'icon': Icons.people, 'label': 'Jastip Jemput'},
    {'icon': Icons.security, 'label': 'NaviSAFE'},
    {'icon': Icons.check, 'label': 'Jadi Traveler'},
    {'icon': Icons.support_agent, 'label': 'Bantuan'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // slate-100
      body: CustomScrollView(
        slivers: [
          // Premium Header (Indosat-style)
          _buildPremiumHeader(),
          
          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                // Menu layanan horizontal
                _buildServicesList(),

                // Daftar Jastip
                _buildRecentJastipSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Premium Header (Indosat-Style with NaviGo Colors)
  Widget _buildPremiumHeader() {
    return SliverAppBar(
      expandedHeight: 320,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF0c4a6e),
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Gradient Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF0c4a6e), // Navy Blue
                    const Color(0xFF0e5a8a), // Medium Blue
                    const Color(0xFF1e7fb8), // Light Blue
                  ],
                ),
              ),
            ),
            
            // Gold Decorative Circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFDE59).withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFDE59).withValues(alpha: 0.08),
                ),
              ),
            ),
            
            // Content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Welcome Text
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Halo, Traveler! 👋',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withValues(alpha: 0.9),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Obx(() => Text(
                                controller.userName.value.isNotEmpty 
                                    ? controller.userName.value 
                                    : 'Guest',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              )),
                            ],
                          ),
                        ),
                        
                        // Notification & Help
                        Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {},
                                icon: Stack(
                                  children: [
                                    const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                    ),
                                    Positioned(
                                      top: 0,
                                      right: 0,
                                      child: Container(
                                        width: 8,
                                        height: 8,
                                        decoration: const BoxDecoration(
                                          color: Colors.red,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Cari tiket, jastip, atau traveler...',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            color: Colors.grey.shade400,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ),
                    
                    const Spacer(),
                    
                    // Stacked Cards (Perjalanan Berikutnya)
                    _buildStackedTripCards(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Stacked Cards Effect
  Widget _buildStackedTripCards() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Back Card (Shadow/Stack effect) - Shifted right
        Positioned(
          right: -8,
          top: 8,
          child: Container(
            width: Get.width - 60,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.5),
                width: 1,
              ),
            ),
          ),
        ),
        
        // Middle Card - Slightly shifted
        Positioned(
          right: -4,
          top: 4,
          child: Container(
            width: Get.width - 50,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.7),
                width: 1,
              ),
            ),
          ),
        ),
        
        // Front Card (Main Content)
        Container(
          width: Get.width - 40,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.15),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Trip Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Perjalanan Berikutnya',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Sumenep → Kangean',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0c4a6e),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFDE59).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFFFFDE59),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.calendar_today,
                                size: 12,
                                color: Color(0xFF0c4a6e),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '29 Sep 2025, 09:00',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0c4a6e),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  // Weather Icon
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0c4a6e).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.waves,
                          color: Color(0xFF0c4a6e),
                          size: 28,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Tenang',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- WIDGET PROMO CAROUSEL (DIPERBARUI) ---
  Widget _buildPromoCarousel() {
    return CarouselSlider.builder(
      itemCount: imgList.length,
      itemBuilder: (context, index, realIndex) {
        final url = imgList[index];
        return CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          width: Get.width,
          placeholder: (context, url) => Container(color: Colors.grey.shade300),
          errorWidget: (context, url, error) => Container(
            color: Colors.grey.shade300,
            child: const Center(child: Icon(Icons.error, color: Colors.red)),
          ),
        );
      },
      options: CarouselOptions(
        height: 220.0, // Dibuat lebih tinggi
        autoPlay: true,
        viewportFraction: 1.0, // Lebar penuh
        onPageChanged: (index, reason) {
          controller.onCarouselPageChanged(index);
        },
      ),
    );
  }

  // --- WIDGET BARU: Gradien Fade ---
  Widget _buildCarouselFade() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      height: 80,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              const Color(0xFFF1F5F9).withValues(alpha: 1),
              const Color(0xFFF1F5F9).withValues(alpha: 0),
            ],
          ),
        ),
      ),
    );
  }

  // --- WIDGET BARU: Indikator Dots ---
  Widget _buildCarouselDots() {
    return Positioned(
      bottom: 50, // Posisikan di atas card
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: imgList.asMap().entries.map((entry) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: controller.currentCarouselPage.value == entry.key
                  ? 24.0
                  : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.white.withValues(alpha: 
                  controller.currentCarouselPage.value == entry.key ? 0.9 : 0.4,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  // --- WIDGET KARTU INFO (TIDAK BERUBAH, HANYA DIPANGGIL) ---
  Widget _buildSmartInfoCard() {
    return Container(
      height: 210, // Beri tinggi tetap
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white, // Latar belakang putih
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          // Konten card (Perjalanan Berikutnya & Cuaca)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Perjalanan Berikutnya:',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Tiket ke Kangean',
                      style: TextStyle(
                        color: AppTheme.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        child: Text(
                          '29 Sep 2025, 09:00',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // ... (Info Cuaca) ...
              Column(
                children: [
                  Text(
                    'Cuaca Laut',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.waves, color: AppTheme.primaryColor, size: 24),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Tenang',
                            style: TextStyle(
                              color: AppTheme.textColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '1.5 m',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const Spacer(), // Dorong tombol ke bawah
          // Tombol E-Tiket
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.secondaryColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Lihat Detail E-Tiket',
                style: TextStyle(
                  color: AppTheme.textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BARU: Menu Layanan (Horizontal List) ---
  Widget _buildServicesList() {
    return Container(
      height: 110, // Tinggi tetap untuk list horizontal
      padding: const EdgeInsets.only(top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: services.length,
        itemBuilder: (context, index) {
          final service = services[index];
          return Container(
            width: 80, // Lebar tetap untuk setiap item
            margin: const EdgeInsets.only(right: 8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(
                    service['icon'],
                    color: AppTheme.primaryColor,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  service['label'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET JASTIP (DIPINDAH) ---
  Widget _buildRecentJastipSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16), // Beri padding atas
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Jastip Terdekat',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextButton(onPressed: () {}, child: const Text('Lihat Semua')),
            ],
          ),
          const SizedBox(height: 8),
          _buildJastipItem(
            'Dokumen Penting',
            'Sumenep -> Kangean',
            'Rp50.000',
            'Dokumen',
          ),
          const SizedBox(height: 12),
          _buildJastipItem(
            'Paket Obat-obatan',
            'Kalianget -> Sapeken',
            'Rp75.000',
            'Obat',
          ),
        ],
      ),
    );
  }

  // ... (Widget _buildJastipItem tidak berubah) ...
  Widget _buildJastipItem(
    String title,
    String route,
    String price,
    String placeholder,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12.0),
          child: CachedNetworkImage(
            imageUrl: 'https://picsum.photos/seed/$placeholder/80/80',
            width: 64,
            height: 64,
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: Colors.grey.shade200),
            errorWidget: (context, url, error) => Container(
              color: Colors.grey.shade300,
              child: const Icon(Icons.error, color: Colors.red),
            ),
          ),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4.0),
          child: Text(
            route,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'Upah',
              style: TextStyle(color: Colors.grey, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  // ... (Widget _buildSearchAndNotification tidak berubah) ...
  Widget _buildSearchAndNotification() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari tiket, jastip...',
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: const Color(0xFFF1F5F9), // slate-100
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Stack(
          children: [
            const Icon(Icons.notifications, color: Colors.grey, size: 28),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

