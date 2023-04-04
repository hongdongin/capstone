import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';
import 'package:tiktok_clone/features/image/image_screen.dart';
import 'package:tiktok_clone/features/videos/video_preview_screen.dart';
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

class VideoRecordingScreen extends StatefulWidget {
  static const String routeName = 'postVideo';
  static const String routeUrl = '/upload';
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen>
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

  late final AnimationController _buttonAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 200),
  );

  late final Animation<double> _buttonAnimation =
      Tween(begin: 1.0, end: 1.3).animate(_buttonAnimationController);

  late final AnimationController _progressAnimationController =
      AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
    lowerBound: 0.0,
    upperBound: 1.0,
  );

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
    _progressAnimationController.addListener(() {
      setState(() {});
    });
    _progressAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _stopRecording();
      }
    });
  }

  @override
  void dispose() {
    _progressAnimationController.dispose();
    _buttonAnimationController.dispose();
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

    await _cameraController.prepareForVideoRecording();

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
    final micPermission = await Permission.microphone.request();

    final cameraPermanentlyDenied = cameraPermission.isPermanentlyDenied;
    final micPermanentlyDenied = micPermission.isPermanentlyDenied;

    final cameraDenied =
        cameraPermission.isDenied || cameraPermission.isPermanentlyDenied;
    final micDenied =
        micPermission.isDenied || micPermission.isPermanentlyDenied;

    if (cameraPermanentlyDenied || micPermanentlyDenied) {
      openAppSettings();
    } else {
      if (!cameraDenied && !micDenied) {
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

  Future<void> _startRecording(TapDownDetails _) async {
    if (_cameraController.value.isRecordingVideo) return;
    if (!_noCamera) {
      await _cameraController.initialize();
      await _cameraController.startVideoRecording();
    }
    _buttonAnimationController.forward();
    _progressAnimationController.forward();
  }

  Future<void> _stopRecording() async {
    if (!_cameraController.value.isRecordingVideo) return;

    _buttonAnimationController.reverse();
    _progressAnimationController.reset();

    final video = await _cameraController.stopVideoRecording();

    if (!_noCamera) {
      await _cameraController.initialize();
    }

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: false,
        ),
      ),
    );
  }

  Future<void> _onPickVideoPressed() async {
    final video = await ImagePicker().pickVideo(
      source: ImageSource.gallery,
    );
    if (video == null) return;

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoPreviewScreen(
          video: video,
          isPicked: true,
        ),
      ),
    );
  }

  Future<void> _onCameraPressed() async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ImageScreen(),
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
                    title: const Text("카메라와 마이크 권한을 확인해 주세요."),
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
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onCameraPressed,
                              icon: const FaIcon(
                                FontAwesomeIcons.camera,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onPanUpdate: _changeCameraZoom,
                          onTapDown: _startRecording,
                          onTapUp: (details) => _stopRecording(),
                          child: ScaleTransition(
                            scale: _buttonAnimation,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  width: Sizes.size80 + Sizes.size14,
                                  height: Sizes.size80 + Sizes.size14,
                                  child: CircularProgressIndicator(
                                    color: Colors.red.shade400,
                                    strokeWidth: Sizes.size6,
                                    value: _progressAnimationController.value,
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
                        ),
                        Expanded(
                          child: Container(
                            alignment: Alignment.center,
                            child: IconButton(
                              onPressed: _onPickVideoPressed,
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
