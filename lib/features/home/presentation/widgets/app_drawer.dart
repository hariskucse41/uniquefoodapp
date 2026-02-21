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
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Row(
                children: [
                  Container(
                    width: 60.w,
                    height: 60.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.primaryGradient,
                      border: Border.all(color: Colors.white24, width: 2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryStart.withValues(alpha: .3),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'FL', // Stands for Food Lover
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Food Lover',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          userEmail,
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12.sp,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Divider(color: Colors.white.withValues(alpha: .1)),
            ),

            SizedBox(height: 10.h),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildNavItem(
                    Icons.home_rounded,
                    'Home',
                    () => onNavigate(0),
                  ),
                  _buildNavItem(
                    Icons.restaurant_menu,
                    'Our Menu',
                    () => onNavigate(1),
                  ),
                  _buildNavItem(
                    Icons.receipt_long,
                    'My Orders',
                    () => onNavigate(2),
                  ),
                  _buildNavItem(
                    Icons.person_outline,
                    'Profile',
                    () => onNavigate(3),
                  ),

                  SizedBox(height: 16.h),
                  Divider(color: Colors.white.withValues(alpha: .1)),
                  SizedBox(height: 16.h),

                  _buildNavItem(Icons.favorite_border, 'Favorites', () {}),
                  _buildNavItem(
                    Icons.local_offer_outlined,
                    'Promotions',
                    () {},
                  ),
                  _buildNavItem(Icons.settings_outlined, 'Settings', () {}),
                  _buildNavItem(Icons.help_outline, 'Help & Support', () {}),
                ],
              ),
            ),

            // Logout button
            Container(
              padding: EdgeInsets.all(20.w),
              child: InkWell(
                onTap: onLogout,
                borderRadius: BorderRadius.circular(16.r),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94560).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: const Color(0xFFE94560).withValues(alpha: .3),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.logout,
                        color: const Color(0xFFE94560),
                        size: 22.sp,
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        'Log Out',
                        style: TextStyle(
                          color: const Color(0xFFE94560),
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      child: ListTile(
        onTap: () {
          // Close drawer before navigating
          // context.pop() could be used if we had standard routing
          onTap();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        leading: Icon(icon, color: AppColors.textSecondary, size: 24.sp),
        title: Text(
          title,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        tileColor: Colors.transparent,
        hoverColor: Colors.white.withValues(alpha: .05),
      ),
    );
  }
}
