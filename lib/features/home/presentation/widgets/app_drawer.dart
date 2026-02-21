import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({
    super.key,
    required this.onLogout,
    required this.onNavigate,
  });

  final VoidCallback onLogout;
  final ValueChanged<int> onNavigate;

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthBloc>().state;
    final userEmail = authState.userEmail ?? 'user@example.com';

    return Drawer(
      backgroundColor: AppColors.surface,
      child: Column(
        children: [
          // Drawer header with user info
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .5),
                      width: 2,
                    ),
                  ),
                  child: const CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 32, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Food Lover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Navigation items
          _buildDrawerItem(Icons.home_rounded, 'Home', () => onNavigate(0)),
          _buildDrawerItem(Icons.restaurant_menu, 'Menu', () => onNavigate(1)),
          _buildDrawerItem(Icons.receipt_long, 'Orders', () => onNavigate(2)),
          _buildDrawerItem(Icons.person, 'Profile', () => onNavigate(3)),

          Divider(
            color: Colors.white.withValues(alpha: .1),
            indent: 20,
            endIndent: 20,
          ),

          _buildDrawerItem(Icons.favorite, 'Favorites', () {}),
          _buildDrawerItem(Icons.local_offer, 'Promotions', () {}),
          _buildDrawerItem(Icons.settings, 'Settings', () {}),
          _buildDrawerItem(Icons.help_outline, 'Help & Support', () {}),

          const Spacer(),

          // Logout
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: GestureDetector(
              onTap: onLogout,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94560).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12),
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
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22),
      title: Text(
        label,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      hoverColor: AppColors.primaryStart.withValues(alpha: .1),
    );
  }
}
