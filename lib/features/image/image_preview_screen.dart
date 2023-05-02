import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:tiktok_clone/features/image/view_models/upload_image_view_model.dart';

class ImagePreviewScreen extends ConsumerStatefulWidget {
  final XFile image;
  final bool isPicked;

  const ImagePreviewScreen({
    super.key,
    required this.image,
    required this.isPicked,
  });

  @override
  ConsumerState<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends ConsumerState<ImagePreviewScreen> {
  late final Image _image;

  bool _saveImage = false;

  Future<void> _initImage() async {
    _image = Image.file(
      File(widget.image.path),
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initImage();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (_saveImage) return;

    await GallerySaver.saveImage(
      widget.image.path,
      albumName: "TikTok Clone!",
    );

    _saveImage = true;

    setState(() {});
  }

  void _onUploadPressed() async {
    ref.read(uploadImageProvider.notifier).uploadImage(
          File(widget.image.path),
          context,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview image'),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _saveImage ? FontAwesomeIcons.check : FontAwesomeIcons.download,
              ),
            ),
          IconButton(
            onPressed: ref.watch(uploadImageProvider).isLoading
                ? () {}
                : _onUploadPressed,
            icon: ref.watch(uploadImageProvider).isLoading
                ? const CircularProgressIndicator()
                : const FaIcon(FontAwesomeIcons.cloudArrowUp),
          )
        ],
      ),
      body: Container(child: _image),
    );
  }
}
