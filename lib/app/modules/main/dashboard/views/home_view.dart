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
    {'icon': Icons.directions_boat_filled, 'label': 'Tiket Kapal', 'route': '/ticket'},
    {'icon': Icons.move_to_inbox, 'label': 'Jastip Antar', 'route': '/jastip'},
    {'icon': Icons.people, 'label': 'Jastip Jemput', 'route': '/jastip'},
    {'icon': Icons.security, 'label': 'NaviSAFE', 'route': '/navisafe'},
    {'icon': Icons.check, 'label': 'Jadi Traveler', 'route': '/traveler-verification'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9), // slate-100
      body: CustomScrollView(
        slivers: [
          // Premium Header (Indosat-style)
          _buildPremiumHeader(),

          // Carousel Section (menyatu dengan header seperti Telkomsel)
          SliverToBoxAdapter(child: _buildCarouselSection()),

          // Content
          SliverToBoxAdapter(
            child: Column(
              children: [
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

  // Premium Header (Telkomsel-Style with NaviGo Colors)
  Widget _buildPremiumHeader() {
    return SliverAppBar(
      expandedHeight: 178,
      floating: false,
      pinned: false, // Header tidak sticky, akan scroll ke atas
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
                    const Color(0xFF075985), // Medium-Dark Blue
                  ],
                ),
              ),
            ),

            // Gold Decorative Circles (Smaller & Subtle)
            Positioned(
              top: -30,
              right: -40,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFDE59).withValues(alpha: 0.08),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFFFFDE59).withValues(alpha: 0.06),
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
                              Obx(() {
                                print(
                                  '🔍 DEBUG userName: ${controller.userName.value}',
                                );
                                final fullName = controller.userName.value;
                                // Ambil nama depan saja
                                final firstName = fullName.split(' ').first;
                                return Text(
                                  firstName,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                );
                              }),
                            ],
                          ),
                        ),

                        // Notification & Help
                        Row(
                          children: [
                            // Notification Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () => Get.toNamed('/notifications'),
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
                            const SizedBox(width: 8),
                            // Help Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () => Get.toNamed('/help'),
                                icon: const Icon(
                                  Icons.help_outline,
                                  color: Colors.white,
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
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Carousel Promo Section (Menyatu dengan header - Telkomsel style)
  Widget _buildCarouselSection() {
    return Container(
      transform: Matrix4.translationValues(
        0,
        0,
        0,
      ), // Tidak overlap, langsung sambung
      child: Column(
        children: [
          Container(
            height: 5, // Sedikit lebih tinggi untuk smooth
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter - const Alignment(0, -1.0),
                end: Alignment.bottomCenter - const Alignment(0, -0.3),
                colors: [
                  const Color.fromARGB(
                    255,
                    8,
                    89,
                    133,
                  ), // Start dari warna biru penuh
                  const Color(0xFF075985).withValues(alpha: 0.9),
                  const Color(0xFF075985).withValues(alpha: 0.7),
                  const Color(0xFF075985).withValues(alpha: 0.5),
                  const Color(0xFF075985).withValues(alpha: 0.3),
                  const Color(0xFF075985).withValues(alpha: 0.15),
                  const Color(0xFF075985).withValues(alpha: 0.05),
                  const Color(0xFFF1F5F9), // Background color putih penuh
                  const Color(0xFFF1F5F9), // Background color putih penuh
                ],
                stops: const [
                  0.0,
                  0.15,
                  0.3,
                  0.45,
                  0.6,
                  0.75,
                  0.9,
                  1.0,
                  1.0,
                ], // Smooth transition ke bawah
              ),
            ),
          ),

          // Carousel dan Card dalam satu area biru
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter + const Alignment(0, -3.3),
                end: Alignment.bottomCenter,
                colors: [const Color(0xFF075985), const Color(0xFF0c4a6e)],
              ),
            ),
            child: Column(
              children: [
                // Carousel Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section Title

                      // Container yang menyatukan Carousel dan Card (Telkomsel Style)
                      _buildUnifiedCarouselCard(),

                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Shade transition (static gradient from blue to white) - Start lebih ke bawah
          Container(
            height: 20, // Sedikit lebih tinggi untuk smooth
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter - const Alignment(0, -0.3),
                colors: [
                  const Color(
                    0xFF0c4a6e,
                  ).withValues(alpha: 0.8), // Start dengan alpha lebih rendah
                  const Color(0xFF0c4a6e).withValues(alpha: 0.6),
                  const Color(0xFF0c4a6e).withValues(alpha: 0.4),
                  const Color(0xFF0c4a6e).withValues(alpha: 0.25),
                  const Color(0xFF0c4a6e).withValues(alpha: 0.12),
                  const Color(0xFF0c4a6e).withValues(alpha: 0.05),
                  const Color(0xFFF1F5F9), // Background color putih penuh
                ],
                stops: const [
                  0.0,
                  0.2,
                  0.35,
                  0.5,
                  0.7,
                  0.85,
                  1.0,
                ], // Smooth transition
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Unified Carousel + Card (Telkomsel Style - Menyatu dalam 1 Container)
  Widget _buildUnifiedCarouselCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Carousel Section (bagian atas card)
          ClipRRect(
            child: SizedBox(
              height: 160,
              child: Stack(
                children: [
                  // Carousel
                  CarouselSlider.builder(
                    itemCount: imgList.length,
                    itemBuilder: (context, index, realIndex) {
                      final url = imgList[index];
                      return Stack(
                        children: [
                          // Image
                          CachedNetworkImage(
                            imageUrl: url,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 160,
                            placeholder: (context, url) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF0c4a6e),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey.shade300,
                              child: const Center(
                                child: Icon(Icons.error, color: Colors.red),
                              ),
                            ),
                          ),

                          // Gradient Overlay Atas (Smooth Putih dari atas)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.center,
                                colors: [
                                  Colors.white.withValues(
                                    alpha: 0.7,
                                  ), // Putih agak transparan
                                  Colors.white.withValues(alpha: 0.4),
                                  Colors.white.withValues(alpha: 0.2),
                                  Colors.white.withValues(alpha: 0.05),
                                  Colors.transparent, // Transparan di tengah
                                ],
                                stops: const [0.0, 0.15, 0.3, 0.5, 0.7],
                              ),
                            ),
                          ),

                          // Gradient Overlay Bawah (Gelap untuk text)
                          Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.center,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withValues(alpha: 0.3),
                                  Colors.black.withValues(alpha: 0.6),
                                ],
                                stops: const [0.0, 0.5, 1.0],
                              ),
                            ),
                          ),

                          // Content Overlay
                          Positioned(
                            bottom: 12,
                            left: 12,
                            right: 12,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFDE59),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text(
                                    'PROMO',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0c4a6e),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  'Diskon 50% Tiket Kapal',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Berlaku hingga 31 Des 2025',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.white70,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                    options: CarouselOptions(
                      height: 160,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 4),
                      autoPlayAnimationDuration: const Duration(
                        milliseconds: 800,
                      ),
                      autoPlayCurve: Curves.easeInOutCubic,
                      viewportFraction: 1.0, // Full width
                      onPageChanged: (index, reason) {
                        controller.onCarouselPageChanged(index);
                      },
                    ),
                  ),

                  // Carousel Indicators (Dots) - di atas carousel
                  Positioned(
                    bottom: 8,
                    left: 0,
                    right: 0,
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imgList.asMap().entries.map((entry) {
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width:
                                controller.currentCarouselPage.value ==
                                    entry.key
                                ? 20.0
                                : 6.0,
                            height: 6.0,
                            margin: const EdgeInsets.symmetric(horizontal: 3.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              color:
                                  controller.currentCarouselPage.value ==
                                      entry.key
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.5),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Card Content (bagian bawah - Perjalanan Berikutnya)
          Padding(
            padding: const EdgeInsets.all(16),
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
                              fontSize: 16,
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
                              color: const Color(
                                0xFFFFDE59,
                              ).withValues(alpha: 0.2),
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
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.waves,
                            color: Colors.green,
                            size: 28,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Tenang',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Button "Lihat Jadwal"
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate dengan parameter untuk melihat jadwal hari ini
                      Get.toNamed('/schedule-detail', arguments: {
                        'origin': 'Kalianget',
                        'destination': 'Kangean',
                        'date': DateTime.now(),
                        'passengers': 1,
                        'viewMode': 'today',
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0c4a6e),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.schedule, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Lihat Jadwal Hari Ini',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
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
          return InkWell(
            onTap: () {
              final route = service['route'];
              if (route != null) {
                Get.toNamed(route);
              }
            },
            borderRadius: BorderRadius.circular(16),
            child: Container(
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
            ),
          );
        },
      ),
    );
  }

  // --- WIDGET JASTIP MODERN ---
  Widget _buildRecentJastipSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        children: [
          // Header Section
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0c4a6e), Color(0xFF0369a1)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.local_shipping_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Jastip Terdekat',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0c4a6e),
                            ),
                          ),
                          Text(
                            'Bantu kiriman sekitar Anda',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => Get.toNamed('/jastip'),
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0c4a6e),
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Lihat Semua',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(width: 2),
                    Icon(Icons.arrow_forward_ios, size: 10),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Jastip Cards
          _buildModernJastipCard(
            id: 'jast-001',
            type: 'DELIVER',
            requester: 'Ahmad Fauzi',
            rating: 4.8,
            itemName: 'Dokumen Penting',
            itemDescription: 'Surat-surat berharga yang perlu diantar ke Kangean',
            origin: 'Kalianget',
            destination: 'Kangean',
            reward: 50000,
            status: 'OPEN',
            createdAt: DateTime.now().subtract(const Duration(hours: 2)),
          ),
          const SizedBox(height: 12),
          _buildModernJastipCard(
            id: 'jast-002',
            type: 'DELIVER',
            requester: 'Siti Aminah',
            rating: 4.9,
            itemName: 'Paket Obat-obatan',
            itemDescription: 'Obat untuk keluarga di Sapeken',
            origin: 'Kalianget',
            destination: 'Sapeken',
            reward: 75000,
            status: 'OPEN',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
          ),
        ],
      ),
    );
  }

  Widget _buildModernJastipCard({
    required String id,
    required String type,
    required String requester,
    required double rating,
    required String itemName,
    required String itemDescription,
    required String origin,
    required String destination,
    required double reward,
    required String status,
    required DateTime createdAt,
  }) {
    // Calculate time ago
    final timeDiff = DateTime.now().difference(createdAt);
    String timeAgo;
    if (timeDiff.inHours > 0) {
      timeAgo = '${timeDiff.inHours} jam lalu';
    } else if (timeDiff.inMinutes > 0) {
      timeAgo = '${timeDiff.inMinutes} menit lalu';
    } else {
      timeAgo = 'Baru saja';
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Get.toNamed('/jastip'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: User info & Status
                Row(
                  children: [
                    // User Avatar
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF0c4a6e).withValues(alpha: 0.8),
                            Color(0xFF0369a1).withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          requester.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            requester,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0c4a6e),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                size: 14,
                                color: Color(0xFFFFDE59),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '• $timeAgo',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: status == 'OPEN'
                            ? Colors.green.withValues(alpha: 0.1)
                            : Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: status == 'OPEN' ? Colors.green : Colors.orange,
                          width: 1,
                        ),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: status == 'OPEN' ? Colors.green : Colors.orange,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 14),
                
                // Item Info
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF0c4a6e).withValues(alpha: 0.03),
                        const Color(0xFF0369a1).withValues(alpha: 0.03),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF0c4a6e).withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFFDE59).withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.inventory_2_outlined,
                              color: Color(0xFF0c4a6e),
                              size: 18,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemName,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0c4a6e),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  itemDescription,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                    height: 1.3,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 14),
                
                // Route Info
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      // Origin
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Dari',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.blue.shade700,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    origin,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0c4a6e),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      
                      // Arrow
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFDE59).withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.arrow_forward,
                          color: Color(0xFF0c4a6e),
                          size: 16,
                        ),
                      ),
                      
                      // Destination
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Ke',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    destination,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF0c4a6e),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  Icons.location_on,
                                  size: 16,
                                  color: Colors.red.shade700,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 14),
                
                // Footer: Reward & Action
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Reward
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.green.shade50,
                            Colors.green.shade100,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.shade300,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            size: 18,
                            color: Colors.green.shade700,
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Upah',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Rp ${reward.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Action Button
                    ElevatedButton(
                      onPressed: () => Get.toNamed('/jastip'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0c4a6e),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.handshake, size: 18),
                          SizedBox(width: 8),
                          Text(
                            'Ambil',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
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
        ),
      ),
    );
  }
}
