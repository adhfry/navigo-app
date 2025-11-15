import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:navi_go/app/config/theme.dart';

class ActivityView extends GetView {
  const ActivityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: CustomScrollView(
        slivers: [
          // App Bar - Same style as Home
          SliverAppBar(
            expandedHeight: 100,
            floating: false,
            pinned: false,
            backgroundColor: const Color(0xFF0c4a6e),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Gradient Background
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Color(0xFF0c4a6e),
                          Color(0xFF0e5a8a),
                          Color(0xFF075985),
                        ],
                      ),
                    ),
                  ),

                  // Gold Decorative Circles
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
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Icon(
                                  Icons.receipt_long,
                                  color: Color(0xFFFFDE59),
                                  size: 28,
                                ),
                              ),
                              const SizedBox(width: 16),
                              const Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Aktivitas Saya',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Riwayat transaksi Anda',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white70,
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
                ],
              ),
            ),
          ),

          // Tab Filters
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('Semua', true),
                    const SizedBox(width: 8),
                    _buildFilterChip('Tiket Kapal', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Jastip', false),
                    const SizedBox(width: 8),
                    _buildFilterChip('Selesai', false),
                  ],
                ),
              ),
            ),
          ),

          // Content
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Booking Activities
                _buildActivityCard(
                  type: 'BOOKING',
                  icon: Icons.directions_boat,
                  iconBg: Colors.blue.shade50,
                  iconColor: Colors.blue.shade700,
                  title: 'Tiket Kapal ke Kangean',
                  subtitle: 'KM. Dharma Kartika III',
                  date: 'Hari ini, 14:30',
                  status: 'CONFIRMED',
                  statusColor: Colors.green,
                  amount: 75000,
                  onTap: () {
                    Get.toNamed('/activity-detail', arguments: {
                      'id': '1',
                      'type': 'BOOKING',
                      'data': {
                        'title': 'Tiket Kapal ke Kangean',
                        'subtitle': 'KM. Dharma Kartika III',
                        'date': 'Hari ini, 14:30',
                        'status': 'CONFIRMED',
                        'amount': 75000,
                      },
                    });
                  },
                ),
                const SizedBox(height: 12),

                _buildActivityCard(
                  type: 'JASTIP',
                  icon: Icons.local_shipping,
                  iconBg: Colors.orange.shade50,
                  iconColor: Colors.orange.shade700,
                  title: 'Jastip Dokumen Penting',
                  subtitle: 'Untuk Ahmad Fauzi',
                  date: 'Kemarin, 10:15',
                  status: 'IN_TRANSIT',
                  statusColor: Colors.blue,
                  amount: 50000,
                  onTap: () {
                    Get.toNamed('/activity-detail', arguments: {
                      'id': '2',
                      'type': 'JASTIP',
                      'data': {
                        'title': 'Jastip Dokumen Penting',
                        'subtitle': 'Untuk Ahmad Fauzi',
                        'date': 'Kemarin, 10:15',
                        'status': 'IN_TRANSIT',
                        'amount': 50000,
                      },
                    });
                  },
                ),
                const SizedBox(height: 12),

                _buildActivityCard(
                  type: 'BOOKING',
                  icon: Icons.directions_boat,
                  iconBg: Colors.blue.shade50,
                  iconColor: Colors.blue.shade700,
                  title: 'Tiket Kapal ke Sapeken',
                  subtitle: 'KM. Sabuk Nusantara 99',
                  date: '12 Nov 2025, 08:00',
                  status: 'COMPLETED',
                  statusColor: Colors.grey,
                  amount: 85000,
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                _buildActivityCard(
                  type: 'JASTIP',
                  icon: Icons.inventory_2,
                  iconBg: Colors.purple.shade50,
                  iconColor: Colors.purple.shade700,
                  title: 'Jastip Obat-obatan',
                  subtitle: 'Untuk Siti Aminah',
                  date: '10 Nov 2025, 15:20',
                  status: 'COMPLETED',
                  statusColor: Colors.grey,
                  amount: 30000,
                  onTap: () {},
                ),
                const SizedBox(height: 12),

                _buildActivityCard(
                  type: 'BOOKING',
                  icon: Icons.directions_boat,
                  iconBg: Colors.blue.shade50,
                  iconColor: Colors.blue.shade700,
                  title: 'Tiket Kapal ke Pagerungan',
                  subtitle: 'KM. Express Bahari 17',
                  date: '8 Nov 2025, 11:45',
                  status: 'CANCELLED',
                  statusColor: Colors.red,
                  amount: 65000,
                  onTap: () {},
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFF0c4a6e) : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? const Color(0xFF0c4a6e) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey.shade700,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildActivityCard({
    required String type,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String date,
    required String status,
    required Color statusColor,
    required double amount,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Icon
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: iconColor, size: 24),
                    ),
                    const SizedBox(width: 12),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0c4a6e),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Status Badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: statusColor, width: 1),
                      ),
                      child: Text(
                        _getStatusLabel(status),
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Divider
                Divider(color: Colors.grey.shade200, height: 1),

                const SizedBox(height: 12),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Date
                    Row(
                      children: [
                        Icon(
                          Icons.access_time,
                          size: 16,
                          color: Colors.grey.shade600,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                    // Amount
                    Text(
                      'Rp ${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0c4a6e),
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

  String _getStatusLabel(String status) {
    switch (status) {
      case 'CONFIRMED':
        return 'Dikonfirmasi';
      case 'PENDING_PAYMENT':
        return 'Menunggu';
      case 'IN_TRANSIT':
        return 'Dalam Perjalanan';
      case 'COMPLETED':
        return 'Selesai';
      case 'CANCELLED':
        return 'Dibatalkan';
      default:
        return status;
    }
  }
}
