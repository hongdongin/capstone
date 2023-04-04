import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gallery_saver/gallery_saver.dart';

class ImagePreviewScreen extends StatefulWidget {
  final XFile image;
  final bool isPicked;

  const ImagePreviewScreen({
    super.key,
    required this.image,
    required this.isPicked,
  });

  @override
  State<ImagePreviewScreen> createState() => _ImagePreviewScreenState();
}

class _ImagePreviewScreenState extends State<ImagePreviewScreen> {
  late final Image _image;

  bool _savePhoto = false;

  Future<void> _initPhoto() async {
    _image = Image.file(
      File(widget.image.path),
    );

    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _initPhoto();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveToGallery() async {
    if (_savePhoto) return;

    await GallerySaver.saveImage(
      widget.image.path,
      albumName: "TikTok Clone!",
    );

    _savePhoto = true;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Preview Photo'),
        actions: [
          if (!widget.isPicked)
            IconButton(
              onPressed: _saveToGallery,
              icon: FaIcon(
                _savePhoto ? FontAwesomeIcons.check : FontAwesomeIcons.download,
              ),
            )
        ],
      ),
      body: _image,
    );
  }
}
