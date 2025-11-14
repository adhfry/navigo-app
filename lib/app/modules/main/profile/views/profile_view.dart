import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.user.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return CustomScrollView(
          slivers: [
            // Premium Header with Gradient Banner
            _buildHeader(context),
            
            // Profile Content
            SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                
                // Account Info Section
                _buildAccountInfoSection(),
                
                const SizedBox(height: 16),
                
                // Menu Items Section
                _buildMenuSection(),
                
                const SizedBox(height: 16),
                
                // Account Settings Section
                _buildSettingsSection(),
                
                const SizedBox(height: 16),
                
                // Logout Button
                _buildLogoutButton(),
                
                const SizedBox(height: 32),
              ]),
            ),
          ],
        );
      }),
    );
  }

  // Premium Header with Gradient Banner (Indosat-style)
  Widget _buildHeader(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 280,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF6366F1),
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
                    const Color(0xFF6366F1), // Indigo
                    const Color(0xFF8B5CF6), // Purple  
                    const Color(0xFFA855F7).withValues(alpha: 0.8), // Purple-400
                  ],
                ),
              ),
            ),
            
            // Decorative Circles
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: -30,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
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
                        // Logo/Title
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.account_circle,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Profil Saya',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        
                        // Action Buttons
                        Row(
                          children: [
                            // Notification Button
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                onPressed: () {
                                  // TODO: Navigate to notifications
                                },
                                icon: Stack(
                                  children: [
                                    const Icon(
                                      Icons.notifications_outlined,
                                      color: Colors.white,
                                    ),
                                    // Notification Badge
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
                                onPressed: () {
                                  // TODO: Navigate to help
                                },
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
                    
                    // User Info Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          // Profile Picture
                          Stack(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.2),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 35,
                                  backgroundColor: Colors.white,
                                  backgroundImage: controller.user.value!.profilePictureUrl != null
                                      ? NetworkImage(controller.user.value!.profilePictureUrl!)
                                      : null,
                                  child: controller.user.value!.profilePictureUrl == null
                                      ? Text(
                                          controller.user.value!.fullName[0].toUpperCase(),
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF6366F1),
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              
                              // Camera Icon
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: GestureDetector(
                                  onTap: controller.pickImage,
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.camera_alt,
                                      size: 14,
                                      color: Color(0xFF6366F1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // User Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Name with Verified Badge
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(
                                        controller.user.value!.fullName,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    if (controller.user.value!.isEmailVerified)
                                      Container(
                                        margin: const EdgeInsets.only(left: 6),
                                        padding: const EdgeInsets.all(2),
                                        decoration: const BoxDecoration(
                                          color: Colors.blue,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check,
                                          size: 12,
                                          color: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                                
                                const SizedBox(height: 4),
                                
                                // Email
                                Text(
                                  controller.user.value!.email,
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Status Chips
                                Row(
                                  children: [
                                    // Traveler Status
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: controller.user.value!.isTravelerVerified
                                            ? Colors.green.withValues(alpha: 0.3)
                                            : Colors.orange.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: controller.user.value!.isTravelerVerified
                                              ? Colors.green
                                              : Colors.orange,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            controller.user.value!.isTravelerVerified
                                                ? Icons.verified
                                                : Icons.schedule,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            controller.user.value!.isTravelerVerified
                                                ? 'Verified'
                                                : 'Unverified',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    
                                    const SizedBox(width: 8),
                                    
                                    // Rating
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withValues(alpha: 0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: Colors.amber,
                                          width: 1,
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            size: 12,
                                            color: Colors.white,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '${controller.user.value!.averageRating}',
                                            style: const TextStyle(
                                              fontSize: 11,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
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
                          
                          // Edit Button
                          Obx(() => Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: controller.toggleEdit,
                              icon: Icon(
                                controller.isEditing.value ? Icons.close : Icons.edit,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          )),
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
    );
  }

  // Account Info Section (Editable)
  Widget _buildAccountInfoSection() {
    return Obx(() => Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Informasi Akun',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (controller.isEditing.value)
                  TextButton(
                    onPressed: controller.updateProfile,
                    child: const Text('Simpan'),
                  ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Full Name
            TextFormField(
              controller: controller.fullNameController,
              enabled: controller.isEditing.value,
              decoration: InputDecoration(
                labelText: 'Nama Lengkap',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: !controller.isEditing.value,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nama lengkap tidak boleh kosong';
                }
                if (value.length < 3) {
                  return 'Nama minimal 3 karakter';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Email (Read Only)
            TextFormField(
              controller: controller.emailController,
              enabled: false,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey[50],
                suffixIcon: controller.user.value!.isEmailVerified
                    ? const Icon(Icons.verified, color: Colors.green)
                    : null,
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Phone Number
            TextFormField(
              controller: controller.phoneController,
              enabled: controller.isEditing.value,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: 'Nomor HP',
                prefixIcon: const Icon(Icons.phone_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: !controller.isEditing.value,
                fillColor: Colors.grey[50],
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Nomor HP tidak boleh kosong';
                }
                if (!value.startsWith('08') && !value.startsWith('+62')) {
                  return 'Nomor HP tidak valid';
                }
                if (value.length < 10) {
                  return 'Nomor HP minimal 10 digit';
                }
                return null;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Gender Selection
            const Text(
              'Jenis Kelamin',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Male
                Expanded(
                  child: GestureDetector(
                    onTap: controller.isEditing.value
                        ? () => controller.selectedGender.value = 'L'
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.selectedGender.value == 'L'
                            ? const Color(0xFF1E88E5)
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedGender.value == 'L'
                              ? const Color(0xFF1565C0)
                              : Colors.blue.shade100,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.male,
                            color: controller.selectedGender.value == 'L'
                                ? Colors.white
                                : const Color(0xFF1976D2),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Laki-laki',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: controller.selectedGender.value == 'L'
                                  ? Colors.white
                                  : const Color(0xFF1976D2),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                const SizedBox(width: 12),
                
                // Female
                Expanded(
                  child: GestureDetector(
                    onTap: controller.isEditing.value
                        ? () => controller.selectedGender.value = 'P'
                        : null,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: controller.selectedGender.value == 'P'
                            ? const Color(0xFFEC407A)
                            : const Color(0xFFFCE4EC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: controller.selectedGender.value == 'P'
                              ? const Color(0xFFD81B60)
                              : Colors.pink.shade100,
                          width: 2,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.female,
                            color: controller.selectedGender.value == 'P'
                                ? Colors.white
                                : const Color(0xFFD81B60),
                            size: 20,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Perempuan',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: controller.selectedGender.value == 'P'
                                  ? Colors.white
                                  : const Color(0xFFD81B60),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Bio
            TextFormField(
              controller: controller.bioController,
              enabled: controller.isEditing.value,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                labelText: 'Bio (Opsional)',
                prefixIcon: const Icon(Icons.note_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: !controller.isEditing.value,
                fillColor: Colors.grey[50],
                hintText: 'Ceritakan sedikit tentang diri Anda...',
              ),
            ),
          ],
        ),
      ),
    ));
  }

  // Menu Section
  Widget _buildMenuSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Menu',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          _buildMenuItem(
            icon: Icons.history,
            title: 'Riwayat Pemesanan',
            subtitle: 'Lihat semua pesanan Anda',
            onTap: () {},
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.favorite_outline,
            title: 'Favorit',
            subtitle: 'Destinasi & rute favorit',
            onTap: () {},
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.verified_user_outlined,
            title: 'Verifikasi Traveler',
            subtitle: controller.user.value!.isTravelerVerified
                ? 'Terverifikasi ✓'
                : 'Tingkatkan kepercayaan',
            onTap: () {},
            trailing: controller.user.value!.isTravelerVerified
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.star_outline,
            title: 'Rating & Review',
            subtitle: '${controller.user.value!.averageRating}/5.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  // Settings Section
  Widget _buildSettingsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Pengaturan Akun',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          
          // Connect Google Account (if not connected)
          if (controller.user.value!.profilePictureUrl == null ||
              !controller.user.value!.profilePictureUrl!.contains('googleusercontent'))
            Column(
              children: [
                _buildMenuItem(
                  icon: Icons.g_mobiledata,
                  iconColor: Colors.red,
                  title: 'Sambungkan ke Google',
                  subtitle: 'Login lebih cepat & aman',
                  onTap: controller.connectGoogleAccount,
                ),
                const Divider(height: 24),
              ],
            ),
          
          _buildMenuItem(
            icon: Icons.lock_outline,
            title: 'Ubah Password',
            subtitle: 'Perbarui password Anda',
            onTap: () {},
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.notifications_outlined,
            title: 'Notifikasi',
            subtitle: 'Atur preferensi notifikasi',
            onTap: () {},
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.privacy_tip_outlined,
            title: 'Privasi & Keamanan',
            subtitle: 'Kelola data pribadi Anda',
            onTap: () {},
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Bantuan & Pusat Informasi',
            subtitle: 'FAQ dan dukungan',
            onTap: () {},
          ),
          
          const Divider(height: 24),
          
          _buildMenuItem(
            icon: Icons.info_outline,
            title: 'Tentang NaviGo',
            subtitle: 'Versi 1.0.0',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? iconColor,
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconColor ?? const Color(0xFF6366F1)).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? const Color(0xFF6366F1),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            trailing ??
                Icon(
                  Icons.chevron_right,
                  color: Colors.grey[400],
                ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      width: double.infinity,
      child: OutlinedButton(
        onPressed: controller.logout,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.red, width: 2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Logout',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
