import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';
import 'dart:async';
import 'package:h_smart/features/posts/domain/entities/post.dart';
import 'package:h_smart/features/posts/presentation/providers/video_controller_provider.dart';
import 'package:h_smart/constant/SchimmerWidget.dart';

class Fullview extends StatefulWidget {
  final String imageUrl;
  final String doctorName;
  final String postText;
  final int likesCount;
  final int commentsCount;

  const Fullview({
    super.key,
    required this.imageUrl,
    required this.doctorName,
    required this.postText,
    required this.likesCount,
    required this.commentsCount,
  });

  @override
  State<Fullview> createState() => _FullviewState();
}

class _FullviewState extends State<Fullview> {
  double _dragOffset = 0;
  bool _isDragging = false;

  void _handleVerticalDrag(DragUpdateDetails details) {
    setState(() {
      _dragOffset += details.delta.dy;
      _isDragging = true;
    });
  }

  void _handleVerticalDragEnd(DragEndDetails details) {
    if (_dragOffset.abs() > 100) {
      Navigator.of(context).pop();
    } else {
      setState(() {
        _dragOffset = 0;
        _isDragging = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          GestureDetector(
            onVerticalDragUpdate: _handleVerticalDrag,
            onVerticalDragEnd: _handleVerticalDragEnd,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              transform: Matrix4.translationValues(0, _dragOffset, 0),
              child: Center(
                child: InteractiveViewer(
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: CachedNetworkImage(
                    imageUrl: widget.imageUrl,
                    fit: BoxFit.contain,
                    placeholder: (context, url) => const ShimmerWidget(
                      height: double.infinity,
                      width: double.infinity,
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.black54,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.white70,
                            size: 48,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Failed to load image',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class VideoPlayerWidget extends ConsumerStatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({
    super.key,
    required this.videoUrl,
  });

  @override
  ConsumerState<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends ConsumerState<VideoPlayerWidget> {
  bool _showControls = true;
  Timer? _hideControlsTimer;

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    _resetHideControlsTimer();
  }

  void _resetHideControlsTimer() {
    _hideControlsTimer?.cancel();
    if (_showControls) {
      _hideControlsTimer = Timer(const Duration(seconds: 3), () {
        if (mounted) {
          setState(() {
            _showControls = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoControllerAsync =
        ref.watch(videoControllerProvider(widget.videoUrl));

    return GestureDetector(
      onTap: _toggleControls,
      child: videoControllerAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.white,
                size: 48,
              ),
              const SizedBox(height: 16),
              Text(
                'Error playing video: ${error.toString()}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(videoControllerProvider(widget.videoUrl));
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (controller) => Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: VideoPlayer(controller),
            ),
            if (_showControls)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withOpacity(0.7),
                    ],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(height: 60), // Space for app bar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(
                            controller.value.isPlaying
                                ? Icons.pause
                                : Icons.play_arrow,
                            size: 50,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            ref
                                .read(videoControllerProvider(widget.videoUrl)
                                    .notifier)
                                .togglePlay();
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          ValueListenableBuilder(
                            valueListenable: controller,
                            builder: (context, value, child) {
                              return SliderTheme(
                                data: SliderThemeData(
                                  trackHeight: 2,
                                  thumbShape: const RoundSliderThumbShape(
                                    enabledThumbRadius: 6,
                                  ),
                                  overlayShape: const RoundSliderOverlayShape(
                                    overlayRadius: 12,
                                  ),
                                  activeTrackColor: Colors.white,
                                  inactiveTrackColor:
                                      Colors.white.withOpacity(0.3),
                                  thumbColor: Colors.white,
                                  overlayColor: Colors.white.withOpacity(0.2),
                                ),
                                child: Slider(
                                  value:
                                      value.position.inMilliseconds.toDouble(),
                                  min: 0,
                                  max: value.duration.inMilliseconds.toDouble(),
                                  onChanged: (newValue) {
                                    controller.seekTo(
                                      Duration(milliseconds: newValue.toInt()),
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ValueListenableBuilder(
                                  valueListenable: controller,
                                  builder: (context, value, child) {
                                    return Text(
                                      '${_formatDuration(value.position)} / ${_formatDuration(value.duration)}',
                                      style:
                                          const TextStyle(color: Colors.white),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
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

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
