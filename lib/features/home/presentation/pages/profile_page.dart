import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, homeState) {
        final authState = context.watch<AuthBloc>().state;
        final userEmail = authState.userEmail ?? 'user@example.com';

        String fullName = 'Food Lover';
        String ordersCount = '0';
        String favoritesCount = '0';
        String totalSpent = '\$0';
        String avatarUrl = '';

        if (homeState is HomeLoaded) {
          final profile = homeState.userProfile;
          if (profile != null) {
            fullName = profile['fullName'] ?? fullName;
            avatarUrl = profile['avatarUrl'] ?? '';
            final stats = profile['stats'] as Map<String, dynamic>?;
            if (stats != null) {
              ordersCount = stats['ordersCount']?.toString() ?? '0';
              favoritesCount = stats['favoritesCount']?.toString() ?? '0';
              totalSpent = '\$${stats['totalSpent'] ?? 0}';
            }
          } else {
            // fallback to local active orders just for UI feel if stats not back yet
            ordersCount = homeState.activeOrders.length.toString();
          }
        }

        return SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              SizedBox(height: 10.h),

              // Profile Avatar
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryStart.withValues(alpha: .3),
                      blurRadius: 15.r,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  radius: 48.r,
                  backgroundColor: AppColors.surfaceOverlay,
                  backgroundImage: avatarUrl.isNotEmpty
                      ? NetworkImage(avatarUrl)
                      : null,
                  child: avatarUrl.isEmpty
                      ? Icon(
                          Icons.person,
                          size: 48.sp,
                          color: AppColors.primaryStart,
                        )
                      : null,
                ),
              ),
              SizedBox(height: 16.h),

              // Name and email
              Text(
                fullName,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                userEmail,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14.sp),
              ),
              SizedBox(height: 8.h),

              // Edit profile button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Text(
                  'Edit Profile',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // Stats row
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
                decoration: BoxDecoration(
                  color: AppColors.surfaceOverlay,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: .05),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStat(ordersCount, 'Orders'),
                    Container(
                      width: 1.w,
                      height: 40.h,
                      color: Colors.white.withValues(alpha: .1),
                    ),
                    _buildStat(favoritesCount, 'Favorites'),
                    Container(
                      width: 1.w,
                      height: 40.h,
                      color: Colors.white.withValues(alpha: .1),
                    ),
                    _buildStat(totalSpent, 'Spent'),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

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

              SizedBox(height: 16.h),

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
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE94560).withValues(alpha: .1),
                    borderRadius: BorderRadius.circular(14.r),
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
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),

              // App version
              Text(
                'Unique Food v1.0.0',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: AppColors.primaryStart,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
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
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceOverlay,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.white.withValues(alpha: .05)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.w,
            height: 42.h,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: color, size: 22.sp),
          ),
          SizedBox(width: 14.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12.sp),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.textMuted, size: 20.sp),
        ],
      ),
    );
  }
}
