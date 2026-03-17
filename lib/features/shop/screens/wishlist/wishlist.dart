import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/widgets/icons/cart_counter_icon.dart';
import 'package:shop_app/common/widgets/icons/circular_icon.dart';
import 'package:shop_app/common/widgets/layouts/grid_layout.dart';
import 'package:shop_app/common/widgets/loaders/animation_loader.dart';
import 'package:shop_app/common/widgets/products/product_card_vartical.dart';
import 'package:shop_app/common/widgets/shimmer/vertical_product_shimmer.dart';
import 'package:shop_app/features/shop/controllers/products/favourites_controller.dart';
import 'package:shop_app/features/shop/screens/cart/cart.dart';
import 'package:shop_app/navigation_menu.dart';
import 'package:shop_app/utils/constants/colors.dart';
import 'package:shop_app/utils/helpers/cloud_helper_functions.dart';

class FavouriteScrenn extends StatelessWidget {
  const FavouriteScrenn({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = FavouritesController.instance;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        actionsIconTheme: IconThemeData(color: Colors.white),
        backgroundColor: TColors.primary,
        title: Text(
          'Wishlist',
          style: Theme.of(context).textTheme.headlineMedium!.apply(color: Colors.white),
        ),
        actions: [
          CartCounterIcon(onPressed: () => Get.to(() => CartItemScreen())),
          CircularIcon(
            backgroundColor: TColors.primary,
            icon: Icons.add,
            onPressed: () => Get.offAll(() => NavigationMenu()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Obx(
            () => FutureBuilder(
              future: controller.favoriteProducts(),
              builder: (context, snapshot) {
                /// Widget hiển thị khi không tìm thấy dữ liệu (Nothing Found Widget)
                final emptyWidget = CAnimationLoaderWidget(
                  text: 'Danh sách yêu thích đang trống...',
                  animation: 'assets/logo/Loading.json',
                  showAction: true,
                  actionText: 'Hãy thêm một vài sản phẩm',
                  onActionPressed: () => Get.offAll(() => const NavigationMenu()),
                ); // TAnimationLoaderWidget

                // Hiệu ứng chờ (Shimmer) khi đang tải dữ liệu
                const loader = CVerticalProductShimmer(itemCount: 6);

                // Sử dụng hàm tiện ích để kiểm tra trạng thái của snapshot (đang tải, lỗi, hay trống)
                final widget = CloudHelperFunctions.checkMultiRecordState(
                  snapshot: snapshot,
                  loader: loader,
                  nothingFound: emptyWidget,
                );

                // Nếu widget trả về không null (nghĩa là đang load hoặc trống) thì hiển thị widget đó
                if (widget != null) return widget;

                // Khi đã có dữ liệu thành công
                final products = snapshot.data!;

                // Hiển thị danh sách sản phẩm dưới dạng lưới (Grid)
                return GridLayout(
                  itemCount: products.length,
                  itemBuilder: (_, index) => ProductCardVartical(product: products[index]),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
