import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userEmail = authState.userEmail ?? 'user@example.com';

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const SizedBox(height: 10),

          // Profile Avatar
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.primaryGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryStart.withValues(alpha: .3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const CircleAvatar(
              radius: 48,
              backgroundColor: AppColors.surfaceOverlay,
              child: Icon(
                Icons.person,
                size: 48,
                color: AppColors.primaryStart,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name and email
          const Text(
            'Food Lover',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            userEmail,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
          const SizedBox(height: 8),

          // Edit profile button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Edit Profile',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // Stats row
          Container(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: .05)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStat('12', 'Orders'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: .1),
                ),
                _buildStat('4', 'Favorites'),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.white.withValues(alpha: .1),
                ),
                _buildStat('\$142', 'Spent'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Menu items
          _buildMenuItem(
            Icons.receipt_long,
            'Order History',
            'View past orders',
            const Color(0xFF667EEA),
          ),
          _buildMenuItem(
            Icons.favorite,
            'Favorites',
            'Your saved dishes',
            const Color(0xFFE94560),
          ),
          _buildMenuItem(
            Icons.location_on,
            'Delivery Address',
            'Manage addresses',
            const Color(0xFF00C853),
          ),
          _buildMenuItem(
            Icons.credit_card,
            'Payment Methods',
            'Cards & wallets',
            const Color(0xFFFFB347),
          ),
          _buildMenuItem(
            Icons.notifications,
            'Notifications',
            'Alert preferences',
            const Color(0xFF764BA2),
          ),
          _buildMenuItem(
            Icons.settings,
            'Settings',
            'App preferences',
            const Color(0xFF6C7293),
          ),
          _buildMenuItem(
            Icons.help_outline,
            'Help & Support',
            'FAQs & contact',
            const Color(0xFF667EEA),
          ),

          const SizedBox(height: 16),

          // Logout button
          GestureDetector(
            onTap: () {
              context.read<AuthBloc>().add(LogoutEvent());
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE94560).withValues(alpha: .1),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFE94560).withValues(alpha: .2),
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: Color(0xFFE94560), size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Log Out',
                    style: TextStyle(
                      color: Color(0xFFE94560),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),

          // App version
          const Text(
            'Unique Food v1.0.0',
            style: TextStyle(color: AppColors.textMuted, fontSize: 12),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: AppColors.primaryStart,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withValues(alpha: .05)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20),
        ],
      ),
    );
  }
}
