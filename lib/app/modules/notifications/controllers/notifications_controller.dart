import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class NotificationsController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  
  final notifications = <NotificationItem>[].obs;
  final isLoading = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }
  
  void loadNotifications() {
    isLoading.value = true;
    
    // Generate welcome and system notifications
    final List<NotificationItem> systemNotifications = [];
    
    final user = _authService.currentUser.value;
    if (user != null) {
      // Welcome notification
      systemNotifications.add(
        NotificationItem(
          id: 'welcome',
          title: 'Selamat Datang di NaviGo! 🎉',
          message: 'Halo ${user.fullName.split(' ').first}! Kami sangat senang Anda bergabung. '
              'Jelajahi fitur NaviTICKET untuk pesan tiket, NaviSEND untuk jastip, dan NaviSAFE untuk keamanan perjalanan Anda.',
          type: NotificationType.welcome,
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isRead: false,
        ),
      );
      
      // Google connection notification (if connected)
      final isGoogleConnected = user.profilePictureUrl != null &&
          user.profilePictureUrl!.contains('googleusercontent');
      
      if (isGoogleConnected) {
        systemNotifications.add(
          NotificationItem(
            id: 'google_connected',
            title: 'Akun Google Terhubung ✓',
            message: 'Selamat! Akun NaviGo Anda (${user.email}) berhasil terhubung dengan Google. '
                'Sekarang Anda bisa login lebih cepat dan aman menggunakan akun Google.',
            type: NotificationType.success,
            timestamp: DateTime.now().subtract(const Duration(hours: 2)),
            isRead: false,
          ),
        );
      }
      
      // Sample notifications (untuk demo)
      systemNotifications.addAll([
        NotificationItem(
          id: 'promo_1',
          title: 'Diskon 50% Tiket Kapal 🚢',
          message: 'Dapatkan diskon hingga 50% untuk pemesanan tiket kapal rute Sumenep-Kangean. Berlaku hingga 31 Desember 2025.',
          type: NotificationType.promo,
          timestamp: DateTime.now().subtract(const Duration(hours: 5)),
          isRead: false,
        ),
        NotificationItem(
          id: 'info_1',
          title: 'Tips Aman Menggunakan Jastip',
          message: 'Pastikan selalu cek rating dan ulasan traveler sebelum memesan jastip. Gunakan fitur NaviSAFE untuk keamanan maksimal.',
          type: NotificationType.info,
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isRead: true,
        ),
      ]);
    }
    
    notifications.value = systemNotifications;
    isLoading.value = false;
  }
  
  void markAsRead(String id) {
    final index = notifications.indexWhere((n) => n.id == id);
    if (index != -1) {
      notifications[index] = notifications[index].copyWith(isRead: true);
      notifications.refresh();
    }
  }
  
  void markAllAsRead() {
    notifications.value = notifications.map((n) => n.copyWith(isRead: true)).toList();
  }
  
  void deleteNotification(String id) {
    notifications.removeWhere((n) => n.id == id);
  }
  
  int get unreadCount => notifications.where((n) => !n.isRead).length;
}

enum NotificationType {
  welcome,
  success,
  promo,
  info,
  warning,
  booking,
  jastip,
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final DateTime timestamp;
  final bool isRead;
  
  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    this.isRead = false,
  });
  
  NotificationItem copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    DateTime? timestamp,
    bool? isRead,
  }) {
    return NotificationItem(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
  
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inDays > 7) {
      final day = timestamp.day.toString().padLeft(2, '0');
      final month = _getMonthName(timestamp.month);
      final year = timestamp.year;
      return '$day $month $year';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} hari lalu';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} jam lalu';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} menit lalu';
    } else {
      return 'Baru saja';
    }
  }
  
  String _getMonthName(int month) {
    const months = [
      '', 'Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun',
      'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'
    ];
    return months[month];
  }
}
