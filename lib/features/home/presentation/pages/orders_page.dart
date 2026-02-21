import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          // Status tabs
          Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.surfaceOverlay,
              borderRadius: BorderRadius.circular(14),
            ),
            child: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: AppColors.textMuted,
              labelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              dividerColor: Colors.transparent,
              indicator: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(14),
              ),
              tabs: const [
                Tab(text: 'Active'),
                Tab(text: 'Completed'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),

          // Order list
          Expanded(
            child: TabBarView(
              children: [
                _buildOrdersList(_activeOrders),
                _buildOrdersList(_completedOrders),
                _buildEmptyOrders('No cancelled orders'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrdersList(List<_OrderItem> orders) {
    if (orders.isEmpty) {
      return _buildEmptyOrders('No orders yet');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceOverlay,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: .05)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order #${order.id}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: order.statusColor.withValues(alpha: .15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: order.statusColor.withValues(alpha: .3),
                      ),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(
                        color: order.statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ...order.items.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.primaryStart,
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        item,
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withValues(alpha: .05)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    order.date,
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    order.total,
                    style: const TextStyle(
                      color: AppColors.primaryStart,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
            size: 60,
            color: AppColors.textMuted.withValues(alpha: .5),
          ),
          const SizedBox(height: 14),
          Text(
            message,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
        ],
      ),
    );
  }

  static final _activeOrders = [
    _OrderItem(
      id: '1024',
      status: 'Preparing',
      statusColor: const Color(0xFFFFB347),
      items: ['1x Margherita Pizza', '2x Matcha Latte', '1x Tiramisu'],
      total: '\$38.96',
      date: 'Today, 10:30 AM',
    ),
    _OrderItem(
      id: '1023',
      status: 'On the way',
      statusColor: const Color(0xFF667EEA),
      items: ['2x Chicken Burger', '1x Pad Thai'],
      total: '\$32.47',
      date: 'Today, 9:15 AM',
    ),
  ];

  static final _completedOrders = [
    _OrderItem(
      id: '1022',
      status: 'Delivered',
      statusColor: const Color(0xFF00C853),
      items: ['1x Sushi Platter', '1x Caesar Salad'],
      total: '\$28.48',
      date: 'Yesterday, 7:45 PM',
    ),
    _OrderItem(
      id: '1021',
      status: 'Delivered',
      statusColor: const Color(0xFF00C853),
      items: ['1x Family Combo'],
      total: '\$29.99',
      date: 'Feb 18, 12:30 PM',
    ),
  ];
}

class _OrderItem {
  final String id;
  final String status;
  final Color statusColor;
  final List<String> items;
  final String total;
  final String date;

  _OrderItem({
    required this.id,
    required this.status,
    required this.statusColor,
    required this.items,
    required this.total,
    required this.date,
  });
}
