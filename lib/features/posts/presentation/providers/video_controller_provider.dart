import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_player/video_player.dart';

final videoControllerProvider = StateNotifierProvider.family<
    VideoControllerNotifier,
    AsyncValue<VideoPlayerController>,
    String>((ref, videoUrl) {
  return VideoControllerNotifier(videoUrl);
});

class VideoControllerNotifier
    extends StateNotifier<AsyncValue<VideoPlayerController>> {
  final String videoUrl;
  late VideoPlayerController _controller;

  VideoControllerNotifier(this.videoUrl) : super(const AsyncValue.loading()) {
    _initializeController();
  }

  Future<void> _initializeController() async {
    try {
      final Uri videoUri = Uri.parse(videoUrl);
      _controller = VideoPlayerController.networkUrl(
        videoUri,
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
      );

      // Set up error handling
      _controller.addListener(() {
        if (_controller.value.hasError) {
          state = AsyncValue.error(
            _controller.value.errorDescription ?? 'Video playback error',
            StackTrace.current,
          );
        }
      });

      await _controller.initialize();

      // Set initial volume and looping
      await _controller.setVolume(1.0);
      await _controller.setLooping(true);

      state = AsyncValue.data(_controller);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void togglePlay() {
    state.whenData((controller) {
      if (controller.value.isPlaying) {
        controller.pause();
      } else {
        controller.play();
      }
    });
  }

  Future<void> dispose() async {
    await state.whenData((controller) => controller.dispose());
    super.dispose();
  }
}
