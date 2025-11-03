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

  bool _isFlashChanging = false;
  bool _isTakingPicture = false;

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

  Future<void> _toggleFlash() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isFlashChanging) {
      return;
    }

    await _initializeControllerFuture;

    setState(() {
      _isFlashChanging = true;
      if (_flashMode == FlashMode.off) {
        _flashMode = FlashMode.torch;
      } else {
        _flashMode = FlashMode.off;
      }
    });

    try {
      await _controller!.setFlashMode(_flashMode);
    } catch (e) {
      NotificationService.showError(
        L10nService.l10n.notificationFlashlightError,
      );
      setState(() => _flashMode = FlashMode.off);
    } finally {
      setState(() {
        _isFlashChanging = false;
      });
    }
  }

  IconData _getFlashIcon() {
    if (_flashMode == FlashMode.torch) {
      return Icons.flash_on;
    } else {
      return Icons.flash_off;
    }
  }

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    await _initializeControllerFuture;

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final image = await _controller!.takePicture();
      if (!mounted) return;
      Navigator.of(context).pop(image.path);
    } catch (e) {
      NotificationService.showError(
        L10nService.l10n.notificationErrorTakingPicture,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  Future<void> _safeShutdown() async {
    if (_isFlashChanging || _isTakingPicture) {
      return;
    }

    try {
      if (_flashMode == FlashMode.torch && _controller != null) {
        await _controller!.setFlashMode(FlashMode.off);
      }
    } catch (e) {
      NotificationService.showError(
        L10nService.l10n.notificationFlashlightError,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBusy = _isFlashChanging || _isTakingPicture;
    final bool canPopNow = !isBusy && _flashMode == FlashMode.off;

    return PopScope(
      canPop: canPopNow,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        if (didPop) return;
        if (isBusy) return;

        await _safeShutdown();

        if (context.mounted) {
          Navigator.of(context).pop();
        }
      },

      child: Scaffold(
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
                          onPressed: _isFlashChanging ? null : _toggleFlash,
                        ),
                        FloatingActionButton(
                          onPressed: _isTakingPicture ? null : _takePicture,
                          child: const Icon(Icons.camera_alt),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 30,
                          ),
                          tooltip: context.l10n.commonCancel,
                          onPressed: () async {
                            await _safeShutdown();
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
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
      ),
    );
  }
}
