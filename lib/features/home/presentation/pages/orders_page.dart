import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/models/extra_models.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key, this.initialTabIndex = 0});

  final int initialTabIndex;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        if (state is HomeLoading || state is HomeInitial) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomeError) {
          return Center(child: Text('Error: ${state.message}'));
        }

        if (state is HomeLoaded) {
          final activeOrders = state.activeOrders
              .map((json) => OrderModel.fromJson(json))
              .toList();
          final completedOrders = state.completedOrders
              .map((json) => OrderModel.fromJson(json))
              .toList();

          return DefaultTabController(
            length: 2,
            initialIndex: initialTabIndex,
            child: Column(
              children: [
                // Status tabs
                Container(
                  margin: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
                  height: 44.h,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceOverlay,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: AppColors.textMuted,
                    labelStyle: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13.sp,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    dividerColor: Colors.transparent,
                    indicator: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    tabs: const [
                      Tab(text: 'Active'),
                      Tab(text: 'History'),
                    ],
                  ),
                ),

                // Order list
                Expanded(
                  child: TabBarView(
                    children: [
                      _buildOrdersList(activeOrders),
                      _buildOrdersList(completedOrders),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
      case 'preparing':
        return const Color(0xFFFFB347);
      case 'outfordelivery':
      case 'on the way':
        return const Color(0xFF667EEA);
      case 'delivered':
      case 'completed':
        return const Color(0xFF00C853);
      case 'cancelled':
        return const Color(0xFFE94560);
      default:
        return AppColors.textMuted;
    }
  }

  Widget _buildOrdersList(List<OrderModel> orders) {
    if (orders.isEmpty) {
      return _buildEmptyOrders('No orders yet');
    }

    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        final statusColor = _getStatusColor(order.status);

        return Container(
          margin: EdgeInsets.only(bottom: 14.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${_displayOrderNumber(order.id)}',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 4.h,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: statusColor.withValues(alpha: .3),
                      ),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12.h),
              ...order.items.map(
                (item) => Padding(
                  padding: EdgeInsets.only(bottom: 6.h),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6.w,
                            height: 6.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryStart,
                              borderRadius: BorderRadius.circular(3.r),
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Expanded(
                            child: Text(
                              '${item.quantity}x ${item.productName}',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.sp,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 2.h),
                      Row(
                        children: [
                          SizedBox(width: 16.w),
                          Expanded(
                            child: Text(
                              '\$${item.price.toStringAsFixed(2)} x ${item.quantity}',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 11.sp,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Divider(color: Colors.white.withValues(alpha: .05)),
              SizedBox(height: 8.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _formatOrderDateToMinute(order.orderDate),
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12.sp,
                    ),
                  ),
                  Text(
                    '\$${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: AppColors.primaryStart,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEmptyOrders(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 60.sp,
            color: AppColors.textMuted.withValues(alpha: .5),
          ),
          SizedBox(height: 14.h),
          Text(
            message,
            style: TextStyle(color: AppColors.textMuted, fontSize: 16.sp),
          ),
        ],
      ),
    );
  }

  String _displayOrderNumber(String rawId) {
    if (rawId.isEmpty) return '000000';

    var hash = 0;
    for (final code in rawId.codeUnits) {
      hash = (hash * 31 + code) & 0x7fffffff;
    }

    final displayNumber = hash % 1000000;
    return displayNumber.toString().padLeft(6, '0');
  }

  String _formatOrderDateToMinute(String rawDate) {
    if (rawDate.isEmpty) return rawDate;

    final parsed = DateTime.tryParse(rawDate);
    if (parsed == null) {
      return rawDate.length >= 16 ? rawDate.substring(0, 16) : rawDate;
    }

    final y = parsed.year.toString().padLeft(4, '0');
    final m = parsed.month.toString().padLeft(2, '0');
    final d = parsed.day.toString().padLeft(2, '0');
    final hour12 = parsed.hour % 12 == 0 ? 12 : parsed.hour % 12;
    final period = parsed.hour >= 12 ? 'PM' : 'AM';
    final hh = hour12.toString().padLeft(2, '0');
    final mm = parsed.minute.toString().padLeft(2, '0');

    return '$y-$m-$d $hh:$mm $period';
  }
}
