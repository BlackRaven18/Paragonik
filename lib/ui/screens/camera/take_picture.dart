import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:paragonik/data/services/l10n_service.dart';
import 'package:paragonik/data/services/notifications/notification_service.dart';
import 'package:paragonik/extensions/localization_extensions.dart';

class TakePicture extends StatefulWidget {
  const TakePicture({super.key});

  @override
  State<TakePicture> createState() => _TakePictureState();
}

class _TakePictureState extends State<TakePicture> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  FlashMode _flashMode = FlashMode.off;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) Navigator.of(context).pop();
        return;
      }
      final firstCamera = cameras.first;

      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      _initializeControllerFuture = _controller!.initialize();
      if (mounted) setState(() {});
    } catch (e) {
      NotificationService.showError(
        L10nService.l10n.notificationErrorLoadingCamera,
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    if (_controller == null) return;

    setState(() {
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else {
        _flashMode = FlashMode.off;
      }
    });
    _controller!.setFlashMode(_flashMode);
  }

  IconData _getFlashIcon() {
    if (_flashMode == FlashMode.torch) {
      return Icons.flash_on;
    } else {
      return Icons.flash_off;
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    try {
      final image = await _controller!.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(image.path);
    } catch (e) {
      NotificationService.showError(
        L10nService.l10n.notificationErrorTakingPicture,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              _controller != null) {
            return Stack(
              fit: StackFit.expand,
              children: [
                CameraPreview(_controller!),
                Positioned(
                  bottom: 30,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        icon: Icon(
                          _getFlashIcon(),
                          color: Colors.white,
                          size: 30,
                        ),
                        tooltip: context.l10n.screensCameraFlashTooltip,
                        onPressed: _toggleFlash,
                      ),
                      FloatingActionButton(
                        onPressed: _takePicture,
                        child: const Icon(Icons.camera_alt),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 30,
                        ),
                        tooltip: context
                            .l10n
                            .commonCancel,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
