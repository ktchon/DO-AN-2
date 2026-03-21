import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/search/search_controller.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CSearchController());
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: const Icon(Iconsax.arrow_left_2)),
            Expanded(
              child: TextFormField(
                controller: controller.searchTextController,
                onChanged: controller.onSearchChanged,
                onFieldSubmitted: controller.searchKeyword,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.search_normal),
                  hintText: "Tìm quần áo, điện thoại...",
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.searchTextController.clear();
                      controller.suggestions.clear();
                    },
                    icon: const Icon(Icons.cancel_rounded),
                  ),
                  fillColor: dark ? TColors.dark : TColors.lightGrey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        // HIỂN THỊ SUGGESTIONS KHI GÕ
        if (controller.searchTextController.text.isNotEmpty) {
          return _buildSuggestionsList(controller);
        }

        // HIỂN THỊ RECENT & TRENDING KHI TRỐNG
        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.recentSearches.isNotEmpty) ...[
                _buildHeader("Tìm kiếm gần đây", onClear: () => controller.clearRecent()),
                Wrap(
                  spacing: 8,
                  children: controller.recentSearches
                      .map(
                        (e) => ActionChip(
                          label: Text(e, style: const TextStyle(fontSize: 12)),
                          onPressed: () => controller.searchKeyword(e),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
              ],

              _buildHeader("Xu hướng tìm kiếm", showClear: false),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.trendingSearches.length,
                itemBuilder: (_, index) => ListTile(
                  leading: Text(
                    "${index + 1}",
                    style: TextStyle(
                      color: index < 3 ? Colors.red : Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  title: Text(controller.trendingSearches[index]),
                  onTap: () => controller.searchKeyword(controller.trendingSearches[index]),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHeader(String title, {VoidCallback? onClear, bool showClear = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        if (showClear)
          TextButton(
            onPressed: onClear,
            child: const Text("Xóa", style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildSuggestionsList(CSearchController controller) {
    return ListView.builder(
      itemCount: controller.suggestions.length,
      itemBuilder: (_, index) {
        final product = controller.suggestions[index];
        final query = controller.searchTextController.text;

        return ListTile(
          leading: const Icon(Iconsax.search_status),
          title: RichText(
            text: TextSpan(
              style: const TextStyle(color: Colors.black), // Màu mặc định
              children: _highlightText(product.title, query),
            ),
          ),
          onTap: () => controller.navigateToProductDetail(product),
        );
      },
    );
  }

  // Hàm bổ trợ bôi đậm từ khóa
  List<TextSpan> _highlightText(String fullText, String query) {
    List<TextSpan> spans = [];
    if (query.isEmpty || !fullText.toLowerCase().contains(query.toLowerCase())) {
      spans.add(TextSpan(text: fullText));
      return spans;
    }

    // Logic đơn giản để tách và bôi đậm phần khớp
    // Bạn có thể dùng Regex để làm chuyên sâu hơn
    spans.add(
      TextSpan(
        text: fullText,
        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
      ),
    );
    return spans;
  }
}
