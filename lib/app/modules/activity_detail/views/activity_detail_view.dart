import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/activity_detail_controller.dart';

class ActivityDetailView extends GetView<ActivityDetailController> {
  const ActivityDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = controller.activityData;
        final type = controller.activityType.value;

        return CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              expandedHeight: 110,
              floating: false,
              pinned: true,
              backgroundColor: const Color(0xFF0c4a6e),
              automaticallyImplyLeading: false,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: [
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
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Get.back(),
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                type == 'BOOKING' ? Icons.receipt_long : Icons.local_shipping,
                                color: const Color(0xFFFFDE59),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    type == 'BOOKING' ? 'Detail Tiket' : 'Detail Jastip',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  _buildStatusBadge(data['status'] ?? 'PENDING'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  if (type == 'BOOKING')
                    ..._buildBookingContent(data)
                  else
                    ..._buildJastipContent(data),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: _buildBottomActions(),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color statusColor;
    String statusLabel;

    switch (status) {
      case 'CONFIRMED':
        statusColor = Colors.green;
        statusLabel = 'Dikonfirmasi';
        break;
      case 'IN_TRANSIT':
        statusColor = Colors.blue;
        statusLabel = 'Dalam Perjalanan';
        break;
      case 'COMPLETED':
        statusColor = Colors.grey;
        statusLabel = 'Selesai';
        break;
      case 'CANCELLED':
        statusColor = Colors.red;
        statusLabel = 'Dibatalkan';
        break;
      default:
        statusColor = Colors.orange;
        statusLabel = 'Menunggu Pembayaran';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: statusColor, width: 1.5),
      ),
      child: Text(
        statusLabel,
        style: TextStyle(
          color: statusColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  List<Widget> _buildBookingContent(Map<String, dynamic> data) {
    return [
      _buildInfoCard(
        title: 'Informasi Tiket',
        icon: Icons.directions_boat,
        children: [
          _buildInfoRow(
            'Nama Kapal',
            data['subtitle'] ?? 'KM. Dharma Kartika III',
          ),
          _buildInfoRow('Rute', '${data['title'] ?? 'Sumenep - Kangean'}'),
          _buildInfoRow(
            'Tanggal Keberangkatan',
            data['date'] ?? 'Hari ini, 14:30',
          ),
          _buildInfoRow('Kelas', 'Ekonomi'),
          _buildInfoRow('Jumlah Penumpang', '2 Orang'),
        ],
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        title: 'Detail Penumpang',
        icon: Icons.people,
        children: [
          _buildInfoRow('Penumpang 1', 'Ahmad Fauzi'),
          _buildInfoRow('NIK', '3527xxxxxxxxxx'),
          const Divider(),
          _buildInfoRow('Penumpang 2', 'Siti Aminah'),
          _buildInfoRow('NIK', '3527xxxxxxxxxx'),
        ],
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        title: 'Detail Pembayaran',
        icon: Icons.payment,
        children: [
          _buildInfoRow(
            'Harga Tiket',
            'Rp ${_formatCurrency(data['amount'] ?? 75000)}',
          ),
          _buildInfoRow('Biaya Admin', 'Rp 2.500'),
          const Divider(),
          _buildInfoRow(
            'Total Pembayaran',
            'Rp ${_formatCurrency((data['amount'] ?? 75000) + 2500)}',
            isBold: true,
          ),
          _buildInfoRow('Metode Pembayaran', 'Transfer Bank BCA'),
          _buildInfoRow('Status Pembayaran', 'Lunas', valueColor: Colors.green),
        ],
      ),
    ];
  }

  List<Widget> _buildJastipContent(Map<String, dynamic> data) {
    return [
      _buildInfoCard(
        title: 'Informasi Jastip',
        icon: Icons.local_shipping,
        children: [
          _buildInfoRow('Jenis Barang', data['title'] ?? 'Dokumen Penting'),
          _buildInfoRow('Penerima', data['subtitle'] ?? 'Ahmad Fauzi'),
          _buildInfoRow('Tanggal', data['date'] ?? 'Hari ini, 10:15'),
          _buildInfoRow('Berat', '0.5 kg'),
          _buildInfoRow('Catatan', 'Harap dijaga dengan baik'),
        ],
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        title: 'Lokasi Pengambilan',
        icon: Icons.location_on,
        children: [
          _buildInfoRow('Alamat', 'Jl. Trunojoyo No. 45, Sumenep'),
          _buildInfoRow('Kontak', '+62 812-3456-7890'),
        ],
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        title: 'Lokasi Pengiriman',
        icon: Icons.place,
        children: [
          _buildInfoRow('Alamat', 'Jl. Merdeka No. 12, Kangean'),
          _buildInfoRow('Kontak', '+62 813-9876-5432'),
        ],
      ),
      const SizedBox(height: 16),
      _buildInfoCard(
        title: 'Detail Pembayaran',
        icon: Icons.payment,
        children: [
          _buildInfoRow(
            'Biaya Jastip',
            'Rp ${_formatCurrency(data['amount'] ?? 50000)}',
          ),
          _buildInfoRow('Biaya Admin', 'Rp 1.500'),
          const Divider(),
          _buildInfoRow(
            'Total Pembayaran',
            'Rp ${_formatCurrency((data['amount'] ?? 50000) + 1500)}',
            isBold: true,
          ),
          _buildInfoRow('Status Pembayaran', 'Lunas', valueColor: Colors.green),
        ],
      ),
    ];
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
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
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0c4a6e), Color(0xFF0369a1)],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0c4a6e),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
                color: valueColor ?? const Color(0xFF0c4a6e),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Bantuan',
                  'Hubungi customer service untuk bantuan',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.white,
                  colorText: const Color(0xFF0c4a6e),
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  icon: const Icon(
                    Icons.support_agent,
                    color: Color(0xFF0c4a6e),
                  ),
                );
              },
              icon: const Icon(Icons.help_outline),
              label: const Text('Bantuan'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0c4a6e),
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: Color(0xFF0c4a6e)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                Get.snackbar(
                  'Unduh E-Ticket',
                  'E-Ticket berhasil diunduh',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF0c4a6e),
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(16),
                  borderRadius: 12,
                  icon: const Icon(Icons.check_circle, color: Colors.white),
                );
              },
              icon: const Icon(Icons.download),
              label: const Text('Unduh'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0c4a6e),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatCurrency(dynamic amount) {
    final value = amount is int ? amount : (amount as double).toInt();
    return value.toString().replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
