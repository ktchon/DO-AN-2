import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/helper_functions.dart';
import '../../controllers/search/search_controller.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late final CSearchController controller;

  @override
  void initState() {
    super.initState();

    // Đảm bảo controller chỉ được tạo 1 lần
    if (!Get.isRegistered<CSearchController>()) {
      controller = Get.put(CSearchController());
    } else {
      controller = Get.find<CSearchController>();
    }

    // Reset khi vào trang
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.searchTextController.clear();
      controller.suggestions.clear();
      controller.searchTextController.addListener(_onTextChanged);
    });
  }

  void _onTextChanged() {
    final text = controller.searchTextController.text;
    controller.searchQuery.value = text;
    controller.onSearchChanged(text);
  }

  @override
  void dispose() {
    controller.searchQuery.value = '';
    controller.searchTextController.removeListener(_onTextChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back)),
            Expanded(
              child: TextFormField(
                controller: controller.searchTextController,
                onFieldSubmitted: controller.searchKeyword,
                autofocus: true,
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                  prefixIcon: const Icon(Iconsax.search_status_1_copy),
                  hintText: "Tìm quần áo, điện thoại...",
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.searchTextController.clear();
                      controller.suggestions.clear();
                    },
                    icon: const Icon(Icons.cancel_rounded),
                  ),
                  fillColor: dark ? TColors.grey : TColors.lightGrey,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Obx(() {
        final query = controller.searchQuery.value.trim();

        if (query.isNotEmpty) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.suggestions.isEmpty) {
            return const Center(child: Text("Không tìm thấy sản phẩm"));
          }

          return _buildSuggestionsList();
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (controller.recentSearches.isNotEmpty) ...[
                _buildHeader("Tìm kiếm gần đây", onClear: controller.clearRecent),
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
        if (showClear && onClear != null)
          TextButton(
            onPressed: onClear,
            child: const Text("Xóa", style: TextStyle(fontSize: 12)),
          ),
      ],
    );
  }

  Widget _buildSuggestionsList() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator.adaptive());
      }

      if (controller.suggestions.isEmpty) {
        return const Center(
          child: Padding(
            padding: EdgeInsets.all(40),
            child: Text(
              "Không tìm thấy sản phẩm phù hợp",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        );
      }

      return ListView.builder(
        itemCount: controller.suggestions.length,
        itemBuilder: (_, index) {
          final product = controller.suggestions[index];
          return ListTile(
            dense: true,
            leading: const Icon(Iconsax.search_status, size: 22),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black87, fontSize: 15),
                children: _highlightText(product.title, controller.searchTextController.text),
              ),
            ),
            onTap: () => controller.navigateToProductDetail(product),
          );
        },
      );
    });
  }

  List<TextSpan> _highlightText(String fullText, String query) {
    if (query.isEmpty) return [TextSpan(text: fullText)];

    final lowerFull = THelperFunctions.removeDiacritics(fullText.toLowerCase());
    final lowerQuery = THelperFunctions.removeDiacritics(query.toLowerCase());

    List<TextSpan> spans = [];
    int start = 0;

    while (true) {
      final idx = lowerFull.indexOf(lowerQuery, start);
      if (idx == -1) {
        spans.add(TextSpan(text: fullText.substring(start)));
        break;
      }
      if (idx > start) spans.add(TextSpan(text: fullText.substring(start, idx)));
      spans.add(
        TextSpan(
          text: fullText.substring(idx, idx + query.length),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
        ),
      );
      start = idx + query.length;
    }
    return spans;
  }
}
