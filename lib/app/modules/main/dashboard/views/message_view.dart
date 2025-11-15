import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:navi_go/app/config/theme.dart';
import '../controllers/message_controller.dart';

class MessageView extends GetView<MessageController> {
  const MessageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Header with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0c4a6e), Color(0xFF0e5a8a), Color(0xFF075985)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.chat_bubble_rounded, color: Color(0xFFFFDE59), size: 28),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Pesan', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                              SizedBox(height: 4),
                              Text('Chat dengan pengguna lain', style: TextStyle(fontSize: 14, color: Colors.white70)),
                            ],
                          ),
                        ),
                        Obx(() => IconButton(
                          icon: Icon(controller.isSearching.value ? Icons.close : Icons.search, color: Colors.white),
                          onPressed: controller.toggleSearch,
                        )),
                      ],
                    ),
                  ),
                  
                  // Search bar
                  Obx(() => controller.isSearching.value
                      ? Container(
                          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: controller.searchController,
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Cari nama kontak...',
                              border: InputBorder.none,
                              icon: Icon(Icons.search, color: Color(0xFF0c4a6e)),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                ],
              ),
            ),
          ),
          
          // Messages List
          Expanded(
            child: Obx(() {
              final messages = controller.filteredMessages;
              
              if (messages.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text('Tidak ada kontak ditemukan', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                );
              }
              
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final message = messages[index];
                  return _buildMessageCard(
                    name: message['name'],
                    avatar: message['avatar'],
                    avatarUrl: message['avatarUrl'],
                    lastMessage: message['lastMessage'],
                    time: message['time'],
                    unreadCount: message['unreadCount'],
                    isOnline: message['isOnline'],
                    type: message['type'],
                    onTap: () => controller.openChat(message),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar(
            'Pesan Baru',
            'Fitur pesan baru akan segera hadir',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color(0xFF0c4a6e),
            colorText: Colors.white,
            margin: const EdgeInsets.all(16),
            borderRadius: 12,
            icon: const Icon(Icons.message, color: Colors.white),
          );
        },
        backgroundColor: const Color(0xFFFFDE59),
        child: const Icon(Icons.add_comment, color: Color(0xFF0c4a6e)),
      ),
    );
  }

  Widget _buildMessageCard({
    required String name,
    required String avatar,
    required String avatarUrl,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required bool isOnline,
    required String type,
    required VoidCallback onTap,
  }) {
    IconData typeIcon;
    Color typeColor;
    
    switch (type) {
      case 'JASTIP':
        typeIcon = Icons.local_shipping;
        typeColor = Colors.orange;
        break;
      case 'BOOKING':
        typeIcon = Icons.directions_boat;
        typeColor = Colors.blue;
        break;
      case 'SUPPORT':
        typeIcon = Icons.support_agent;
        typeColor = Colors.green;
        break;
      case 'NOTIFICATION':
        typeIcon = Icons.notifications;
        typeColor = Colors.purple;
        break;
      default:
        typeIcon = Icons.message;
        typeColor = Colors.grey;
    }
    
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
            padding: const EdgeInsets.all(14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar with online indicator
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0c4a6e), Color(0xFF0369a1)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              avatar,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF0c4a6e), Color(0xFF0369a1)],
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              avatar,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isOnline)
                      Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                
                // Message Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              name,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF0c4a6e),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: typeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Icon(typeIcon, size: 14, color: typeColor),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lastMessage,
                        style: TextStyle(
                          fontSize: 13,
                          color: unreadCount > 0 ? Colors.grey.shade800 : Colors.grey.shade600,
                          fontWeight: unreadCount > 0 ? FontWeight.w600 : FontWeight.normal,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 14, color: Colors.grey.shade500),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              time,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                          ),
                          if (unreadCount > 0)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFDE59),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                unreadCount.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF0c4a6e),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
