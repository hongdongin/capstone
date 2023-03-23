import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tiktok_clone/constants/gaps.dart';
import 'package:tiktok_clone/constants/sizes.dart';

class VideoRecordingScreen extends StatefulWidget {
  const VideoRecordingScreen({super.key});

  @override
  State<VideoRecordingScreen> createState() => _VideoRecordingScreenState();
}

class _VideoRecordingScreenState extends State<VideoRecordingScreen> {
  bool _hasPermission = false;
  bool _alertPermission = false;
  bool _isSelfimode = true;

  late CameraController _cameraController;

  Future<void> initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      return;
    }
    _cameraController = CameraController(
      cameras[_isSelfimode ? 1 : 0],
      ResolutionPreset.ultraHigh,
    );
    await _cameraController.initialize();
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

  Future<void> _toggleSelfiMode() async {
    _isSelfimode = !_isSelfimode;
    initCamera();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    initPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: !_hasPermission || !_cameraController.value.isInitialized
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
                  CameraPreview(_cameraController),
                  Positioned(
                    child: IconButton(
                      onPressed: _toggleSelfiMode,
                      icon: const FaIcon(
                        FontAwesomeIcons.cameraRotate,
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
