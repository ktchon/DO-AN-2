import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/features/shop/controllers/notification/notification_controller.dart';
import 'package:shop_app/features/shop/screens/notification/widgets/notification_widgets.dart';
import 'package:shop_app/utils/constants/colors.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: _buildAppBar(context),
      body: Column(
        children: [
          // Tab bar
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const NotificationTabBar(),
          ),
          const Divider(height: 1),

          // List
          Expanded(child: _buildBody()),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // APP BAR - ĐÃ ĐƯỢC TỐI ƯU CHO NỀN XANH + CHỮ TRẮNG
  // ─────────────────────────────────────────────────────────────

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: TColors.primary,
      foregroundColor: Colors.white, // ← Quan trọng: chữ & icon trắng
      iconTheme: const IconThemeData(color: Colors.white),
      title: const Text(
        'Thông báo',
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      actions: [
        Obx(() {
          if (controller.isSelectMode.value) {
            return Row(
              children: [
                TextButton(
                  onPressed: controller.selectAll,
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: const Text('Chọn tất cả', style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: Colors.white, // ← Icon trắng
                  onPressed: () => _confirmDeleteSelected(context),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  color: Colors.white,
                  onPressed: controller.exitSelectMode,
                ),
              ],
            );
          }

          return Row(
            children: [
              // Mark all read
              if (controller.hasUnread)
                IconButton(
                  icon: const Icon(Icons.done_all_rounded),
                  color: Colors.white,
                  tooltip: 'Đánh dấu tất cả đã đọc',
                  onPressed: controller.markAllAsRead,
                ),
              // More menu
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                color: Colors.white, // Nền menu trắng
                onSelected: (value) {
                  if (value == 'select') controller.enterSelectMode();
                  if (value == 'delete_all') _confirmDeleteAll(context);
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                    value: 'select',
                    child: Row(
                      children: [
                        Icon(Icons.checklist_rounded, size: 20),
                        SizedBox(width: 12),
                        Text('Chọn thông báo'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete_all',
                    child: Row(
                      children: [
                        const Icon(Icons.delete_sweep_rounded, size: 20, color: Colors.red),
                        const SizedBox(width: 12),
                        Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // BODY (giữ nguyên)
  // ─────────────────────────────────────────────────────────────

  Widget _buildBody() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      final notifications = controller.filteredNotifications;

      if (notifications.isEmpty) {
        return NotificationEmptyState(tab: controller.selectedTab.value);
      }

      return RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(const Duration(milliseconds: 500));
        },
        child: ListView.separated(
          itemCount: notifications.length,
          separatorBuilder: (_, __) => Divider(height: 1, color: Colors.grey.shade200),
          itemBuilder: (_, index) {
            return NotificationTile(notification: notifications[index]);
          },
        ),
      );
    });
  }

  // ─────────────────────────────────────────────────────────────
  // DIALOGS (đã tối ưu nhẹ cho đẹp hơn)
  // ─────────────────────────────────────────────────────────────

  void _confirmDeleteSelected(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa thông báo'),
        content: Obx(() => Text('Xóa ${controller.selectedIds.length} thông báo đã chọn?')),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteSelected();
            },
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteAll(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Xóa tất cả thông báo'),
        content: const Text('Bạn có chắc muốn xóa toàn bộ thông báo không?'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Hủy')),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteAll();
            },
            child: const Text('Xóa tất cả', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
