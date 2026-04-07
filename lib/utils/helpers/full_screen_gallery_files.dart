import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class FullScreenGalleryFiles extends StatefulWidget {
  final List<XFile> images;
  final int initialIndex;

  const FullScreenGalleryFiles({
    super.key,
    required this.images,
    required this.initialIndex,
  });

  @override
  State<FullScreenGalleryFiles> createState() => _FullScreenGalleryFilesState();
}

class _FullScreenGalleryFilesState extends State<FullScreenGalleryFiles> {
  late PageController controller;

  @override
  void initState() {
    controller = PageController(initialPage: widget.initialIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: PageView.builder(
        controller: controller,
        itemCount: widget.images.length,
        itemBuilder: (_, index) {
          return InteractiveViewer(
            child: Center(
              child: Image.file(File(widget.images[index].path)),
            ),
          );
        },
      ),
    );
  }
}