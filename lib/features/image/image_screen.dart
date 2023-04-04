import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/image/image_preview_screen.dart';
import 'package:tiktok_clone/features/videos/widgets/flash_button.dart';

final List<dynamic> flashButtons = [
  {
    "flashMode": FlashMode.off,
    "icon": const Icon(Icons.flash_off_rounded),
  },
  {
    "flashMode": FlashMode.always,
    "icon": const Icon(Icons.flash_on_rounded),
  },
  {
    "flashMode": FlashMode.auto,
    "icon": const Icon(Icons.flash_auto_rounded),
  },
  {
    "flashMode": FlashMode.torch,
    "icon": const Icon(Icons.flashlight_on_rounded),
  },
];

class ImageScreen extends StatefulWidget {
  static const String routeName = 'postImage';
  static const String routeUrl = '/upload/image';
  const ImageScreen({super.key});

  @override
  State<ImageScreen> createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  bool _hasPermission = false;
  bool _alertPermission = false;
  bool _isSelfiemode = true;

  late double _currentZoom;
  late double _maxZoom;
  late double _minZoom;

  final bool _noCamera = kDebugMode && Platform.isIOS;

  late FlashMode _flashMode;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    if (!_noCamera) {
      initPermissions();
    } else {
      setState(() {
        _hasPermission = true;
      });
    }
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    if (!_noCamera) {
      _cameraController.dispose();
    }
    super.dispose();
  }

  void _changeCameraZoom(DragUpdateDetails details) async {
    if (details.localPosition.dy >= 0) {
      if (_currentZoom + (-details.localPosition.dy * 0.05) < _minZoom) return;
      _cameraController
          .setZoomLevel(_currentZoom + (-details.localPosition.dy * 0.05));
    }
    if (details.localPosition.dy < 0) {
      if (_currentZoom + (-details.localPosition.dy * 0.005) > _maxZoom) return;
      _cameraController
          .setZoomLevel(_currentZoom + (-details.localPosition.dy * 0.005));
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_noCamera) return;
    if (!_hasPermission) return;
    if (!_cameraController.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      initCamera();
    }
  }

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[_isSelfiemode ? 0 : 1],
      ResolutionPreset.ultraHigh,
      enableAudio: false,
    );

    await _cameraController.initialize();

    _flashMode = _cameraController.value.flashMode;

    _maxZoom = await _cameraController.getMaxZoomLevel();
    _minZoom = await _cameraController.getMinZoomLevel();
    _currentZoom = (_maxZoom + _minZoom) / 5;

    setState(() {});
  }

  Future<void> initPermissions() async {
    _hasPermission = false;
    _alertPermission = false;

    final cameraPermission = await Permission.camera.request();

    final cameraPermanentlyDenied = cameraPermission.isPermanentlyDenied;

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;

    if (cameraPermanentlyDenied) {
      openAppSettings();
    } else {
      if (!cameraDenied) {
        _hasPermission = true;
        await initCamera();
        setState(() {});
      } else {
        _alertPermission = true;
        setState(() {});
      }
    }
  }

  Future<void> _toggleSelfieMode() async {
    _isSelfiemode = !_isSelfiemode;
    await initCamera();
    setState(() {});
  }

  Future<void> _setFlashMode(FlashMode newFlashMode) async {
    await _cameraController.setFlashMode(newFlashMode);
    _flashMode = newFlashMode;
    setState(() {});
  }

  Future<void> _onPhotoPressed() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (image == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          image: image,
          isPicked: true,
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final image = await _cameraController.takePicture();

    if (!_noCamera) {
      await _cameraController.initialize();
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImagePreviewScreen(
          image: image,
          isPicked: false,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission
            ? _alertPermission
                ? AlertDialog(
                    title: const Text("카메라 권한을 확인해 주세요."),
                    content: const Text("권한을 다시 설정해 주세요."),
                    actions: [
                      TextButton(
                        onPressed: () => initPermissions(),
                        child: const Text("again"),
                      )
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      Text(
                        "Initializing...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: Sizes.size20,
                        ),
                      ),
                      Gaps.v20,
                      CircularProgressIndicator.adaptive(),
                    ],
                  )
            : Stack(
                alignment: Alignment.center,
                children: [
                  if (!_noCamera && _cameraController.value.isInitialized)
                    CameraPreview(_cameraController),
                  const Positioned(
                    top: Sizes.size40,
                    left: Sizes.size20,
                    child: CloseButton(
                      color: Colors.white,
                    ),
                  ),
                  if (!_noCamera)
                    Positioned(
                      top: Sizes.size40,
                      right: Sizes.size20,
                      child: Column(
                        children: [
                          IconButton(
                            onPressed: _toggleSelfieMode,
                            icon: const Icon(
                              Icons.cameraswitch_rounded,
                              color: Colors.white,
                            ),
                          ),
                          for (var flashButton in flashButtons)
                            Row(
                              children: [
                                Gaps.v10,
                                FlashButton(
                                  flashMode: _flashMode,
                                  setFlashMode: _setFlashMode,
                                  newFlashMode: flashButton["flashMode"],
                                  icon: flashButton["icon"],
                                ),
                              ],
                            )
                        ],
                      ),
                    ),
                  Positioned(
                    bottom: Sizes.size40,
                    width: MediaQuery.of(context).size.width,
                    child: Row(
                      children: [
                        const Spacer(),
                        GestureDetector(
                          onPanUpdate: _changeCameraZoom,
                          onTap: _pickImage,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: Sizes.size80 + Sizes.size14,
                                height: Sizes.size80 + Sizes.size14,
                                child: CircleAvatar(
                                  foregroundColor: Colors.red.shade400,
                                  radius: Sizes.size6,
                                ),
                              ),
                              Container(
                                width: Sizes.size80,
                                height: Sizes.size80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPhotoPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.image,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
