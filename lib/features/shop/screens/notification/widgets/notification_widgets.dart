import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/notification/notification_controller.dart';
import 'package:shop_app/features/shop/models/notification/notification_model.dart';

// ─────────────────────────────────────────────────────────────
// NOTIFICATION BADGE (dùng ở icon tab bar)
// ─────────────────────────────────────────────────────────────

class NotificationBadge extends StatelessWidget {
  final Widget child;
  const NotificationBadge({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return Obx(() {
      final count = controller.unreadCount.value;
      return Stack(
        clipBehavior: Clip.none,
        children: [
          child,
          if (count > 0)
            Positioned(
              top: -4,
              right: -4,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(color: Color(0xFFFF3B30), shape: BoxShape.circle),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                child: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      );
    });
  }
}

// ─────────────────────────────────────────────────────────────
// TAB BAR (Tất cả / Đơn hàng / Khuyến mãi / ...)
// ─────────────────────────────────────────────────────────────

class NotificationTabBar extends StatelessWidget {
  const NotificationTabBar({super.key});

  static const _tabs = [
    {'key': 'all', 'label': 'Tất cả'},
    {'key': 'order', 'label': 'Đơn hàng'},
    {'key': 'promo', 'label': 'Khuyến mãi'},
    {'key': 'personal', 'label': 'Cho bạn'},
    {'key': 'review', 'label': 'Đánh giá'},
    {'key': 'chat', 'label': 'Tin nhắn'},
  ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final tab = _tabs[i];

          return Obx(() {
            final isActive = controller.selectedTab.value == tab['key'];

            return GestureDetector(
              onTap: () => controller.changeTab(tab['key']!),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isActive ? Theme.of(context).primaryColor : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  tab['label']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color: isActive ? Colors.white : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// NOTIFICATION TILE
// ─────────────────────────────────────────────────────────────

class NotificationTile extends StatelessWidget {
  final AppNotification notification;
  const NotificationTile({super.key, required this.notification});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();
    return Obx(() {
      final isSelected = controller.selectedIds.contains(notification.id);
      final isSelectMode = controller.isSelectMode.value;

      return Dismissible(
        key: Key(notification.id),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          color: Colors.red,
          child: const Icon(Icons.delete, color: Colors.white),
        ),
        onDismissed: (_) => controller.deleteNotification(notification.id),
        child: GestureDetector(
          onLongPress: () {
            controller.enterSelectMode();
            controller.toggleSelect(notification.id);
          },
          onTap: () {
            if (isSelectMode) {
              controller.toggleSelect(notification.id);
            } else {
              controller.handleNotificationTap(notification);
            }
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            color: isSelected
                ? Theme.of(context).primaryColor.withOpacity(0.08)
                : notification.isRead
                ? Colors.white
                : const Color(0xFFF0F7FF),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  if (isSelectMode) ...[
                    Checkbox(
                      value: isSelected,
                      onChanged: (_) => controller.toggleSelect(notification.id),
                    ),
                    const SizedBox(width: 8),
                  ],
                  _buildAvatar(context),
                  const SizedBox(width: 12),
                  Expanded(child: Text(notification.title)),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildAvatar(BuildContext context) {
    // Nếu có image thì hiển thị ảnh
    if (notification.image != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Image.network(
          notification.image!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildIconContainer(context),
        ),
      );
    }
    return _buildIconContainer(context);
  }

  Widget _buildIconContainer(BuildContext context) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.12),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Icon(_getTypeIcon(), color: _getTypeColor(), size: 24),
    );
  }

  Widget _buildTypeChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getTypeColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _getTypeLabel(),
        style: TextStyle(fontSize: 10, color: _getTypeColor(), fontWeight: FontWeight.w600),
      ),
    );
  }

  IconData _getTypeIcon() {
    switch (notification.type) {
      case NotificationType.order:
        return _getOrderIcon();
      case NotificationType.promo:
        return Icons.local_offer_rounded;
      case NotificationType.personal:
        return Icons.favorite_rounded;
      case NotificationType.review:
        return Icons.star_rounded;
      case NotificationType.chat:
        return Icons.chat_bubble_rounded;
      case NotificationType.system:
        return Icons.notifications_rounded;
    }
  }

  IconData _getOrderIcon() {
    switch (notification.subtype) {
      case 'placed':
        return Icons.check_circle_rounded;
      case 'confirmed':
        return Icons.verified_rounded;
      case 'packed':
        return Icons.inventory_2_rounded;
      case 'shipping':
        return Icons.local_shipping_rounded;
      case 'delivered':
        return Icons.done_all_rounded;
      case 'failed':
        return Icons.error_rounded;
      case 'returned':
        return Icons.assignment_return_rounded;
      case 'refunded':
        return Icons.price_check_rounded;
      default:
        return Icons.receipt_long_rounded;
    }
  }

  Color _getTypeColor() {
    switch (notification.type) {
      case NotificationType.order:
        return const Color(0xFF007AFF);
      case NotificationType.promo:
        return const Color(0xFFFF3B30);
      case NotificationType.personal:
        return const Color(0xFFFF2D55);
      case NotificationType.review:
        return const Color(0xFFFF9500);
      case NotificationType.chat:
        return const Color(0xFF34C759);
      case NotificationType.system:
        return const Color(0xFF8E8E93);
    }
  }

  String _getTypeLabel() {
    switch (notification.type) {
      case NotificationType.order:
        return 'Đơn hàng';
      case NotificationType.promo:
        return 'Khuyến mãi';
      case NotificationType.personal:
        return 'Dành cho bạn';
      case NotificationType.review:
        return 'Đánh giá';
      case NotificationType.chat:
        return 'Tin nhắn';
      case NotificationType.system:
        return 'Hệ thống';
    }
  }
}

// ─────────────────────────────────────────────────────────────
// EMPTY STATE
// ─────────────────────────────────────────────────────────────

class NotificationEmptyState extends StatelessWidget {
  final String tab;
  const NotificationEmptyState({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(_getIcon(), size: 72, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            _getTitle(),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getSubtitle(),
            style: TextStyle(fontSize: 13, color: Colors.grey.shade400),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  IconData _getIcon() {
    switch (tab) {
      case 'order':
        return Icons.local_shipping_outlined;
      case 'promo':
        return Icons.local_offer_outlined;
      case 'personal':
        return Icons.favorite_border_rounded;
      case 'review':
        return Icons.star_border_rounded;
      case 'chat':
        return Icons.chat_bubble_outline_rounded;
      default:
        return Icons.notifications_none_rounded;
    }
  }

  String _getTitle() {
    switch (tab) {
      case 'order':
        return 'Chưa có thông báo đơn hàng';
      case 'promo':
        return 'Chưa có khuyến mãi mới';
      case 'personal':
        return 'Chưa có gợi ý cho bạn';
      case 'review':
        return 'Chưa có đánh giá mới';
      case 'chat':
        return 'Chưa có tin nhắn mới';
      default:
        return 'Không có thông báo';
    }
  }

  String _getSubtitle() {
    switch (tab) {
      case 'order':
        return 'Đặt hàng ngay để theo dõi\ntrạng thái đơn hàng của bạn';
      case 'promo':
        return 'Các ưu đãi và flash sale\nsẽ xuất hiện ở đây';
      case 'personal':
        return 'Khám phá thêm sản phẩm\nđể nhận gợi ý phù hợp';
      default:
        return 'Thông báo mới sẽ xuất hiện ở đây';
    }
  }
}
