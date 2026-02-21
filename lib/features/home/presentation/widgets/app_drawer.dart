import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
            padding: EdgeInsets.fromLTRB(10.w, 30.h, 10.w, 12.h),
            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  padding: EdgeInsets.all(3.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white.withValues(alpha: .5),
                      width: 2.w,
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 32.r,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 32.sp, color: Colors.white),
                  ),
                ),
                SizedBox(height: 14.h),
                Text(
                  'Food Lover',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  userEmail,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: .7),
                    fontSize: 13.sp,
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8.h),

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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
            child: GestureDetector(
              onTap: onLogout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                decoration: BoxDecoration(
                  color: const Color(0xFFE94560).withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: const Color(0xFFE94560).withValues(alpha: .2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout,
                      color: const Color(0xFFE94560),
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Log Out',
                      style: TextStyle(
                        color: const Color(0xFFE94560),
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String label, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 22.sp),
      title: Text(
        label,
        style: TextStyle(
          color: AppColors.textPrimary,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      dense: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
      hoverColor: AppColors.primaryStart.withValues(alpha: .1),
    );
  }
}
