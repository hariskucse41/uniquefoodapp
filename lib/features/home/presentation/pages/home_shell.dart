import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../widgets/app_drawer.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'orders_page.dart';
import 'profile_page.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _currentIndex = 0;
  int? _menuSelectedCategoryId;
  int _menuSelectionVersion = 0;

  @override
  void initState() {
    super.initState();
    context.read<HomeBloc>().add(LoadHomeDataEvent());
  }

  void _openMenu({int? categoryId}) {
    setState(() {
      _currentIndex = 1;
      _menuSelectedCategoryId = categoryId;
      _menuSelectionVersion++;
    });
  }

  List<Widget> get _pages => [
    HomePage(
      onHeroActionTap: () => _openMenu(),
      onCategoryTap: (categoryId) => _openMenu(categoryId: categoryId),
    ),
    MenuPage(
      selectedCategoryId: _menuSelectedCategoryId,
      selectionVersion: _menuSelectionVersion,
    ),
    const OrdersPage(),
    const ProfilePage(),
  ];

  final List<String> _titles = const [
    'Unique Food',
    'Our Menu',
    'My Orders',
    'Profile',
  ];

  void _onLogout() {
    context.read<AuthBloc>().add(LogoutEvent());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(_titles[_currentIndex]),
        backgroundColor: AppColors.surfaceLight,
        elevation: 0,
        actions: [
          if (_currentIndex == 0) ...[
            IconButton(
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              icon: Stack(
                children: [
                  const Icon(Icons.notifications_outlined, color: Colors.white),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: const BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ],
      ),
      drawer: AppDrawer(
        onLogout: _onLogout,
        onNavigate: (index) {
          setState(() {
            _currentIndex = index;
          });
          Navigator.pop(context); // close drawer
        },
      ),
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: .3),
              blurRadius: 20.r,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, 'Home', 0),
                _buildNavItem(Icons.restaurant_menu, 'Menu', 1),
                _buildNavItem(Icons.receipt_long, 'Orders', 2),
                _buildNavItem(Icons.person, 'Profile', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _currentIndex == index;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      width: isActive ? 118.w : 58.w,
      height: 46.h,
      decoration: BoxDecoration(
        gradient: isActive ? AppColors.primaryGradient : null,
        color: isActive ? null : Colors.transparent,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isActive
              ? Colors.white.withValues(alpha: .18)
              : Colors.white.withValues(alpha: .06),
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: AppColors.primaryStart.withValues(alpha: .32),
                  blurRadius: 16.r,
                  offset: const Offset(0, 7),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () => setState(() => _currentIndex = index),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 260),
                  curve: Curves.easeOutCubic,
                  width: isActive ? 26.w : 22.w,
                  height: isActive ? 26.h : 22.h,
                  decoration: BoxDecoration(
                    color: isActive
                        ? Colors.white.withValues(alpha: .2)
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: isActive ? 18.sp : 20.sp,
                    color: isActive ? Colors.white : AppColors.textMuted,
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: SizeTransition(
                        axis: Axis.horizontal,
                        sizeFactor: animation,
                        child: child,
                      ),
                    );
                  },
                  child: isActive
                      ? Padding(
                          key: ValueKey<String>(label),
                          padding: EdgeInsets.only(left: 8.w, top: 10.h),
                          child: Text(
                            label,
                            maxLines: 1,
                            overflow: TextOverflow.fade,
                            softWrap: false,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13.sp,
                              letterSpacing: .1,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(key: ValueKey<String>('empty')),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
