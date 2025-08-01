
import 'package:animal_market/services/api_logs.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TikTokVideoPlayer extends StatefulWidget {
  const TikTokVideoPlayer({super.key, required this.videoUrl});

  final String videoUrl;

  @override
  State<TikTokVideoPlayer> createState() => _TikTokVideoPlayerState();
}

class _TikTokVideoPlayerState extends State<TikTokVideoPlayer> {
  late VideoPlayerController videoPlayerController;
  bool isMuted = false;
  bool isVideoInitialized = false;
  bool isPlaying = true;  // Track play/pause state
  bool showPlayPauseButton = false;  // Track whether the button should be shown

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
      ..initialize().then((value) {
        setState(() {
          isVideoInitialized = true;
        });
        videoPlayerController.play();
        videoPlayerController.setLooping(true);
      }).catchError((error) {
        Log.console("Error loading video: $error");
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  void toggleMute() {
    setState(() {
      isMuted = !isMuted;
      videoPlayerController.setVolume(isMuted ? 0.0 : 1.0);
    });
  }

  void togglePlayPause() {
    setState(() {
      if (isPlaying) {
        videoPlayerController.pause();
      } else {
        videoPlayerController.play();
      }
      isPlaying = !isPlaying;
    });
  }

  void showButtonTemporarily() {
    setState(() {
      showPlayPauseButton = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        showPlayPauseButton = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Stack(
        children: [
          if (!isVideoInitialized)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
          else
            GestureDetector(
              onTap: () {
                togglePlayPause();
                showButtonTemporarily();
              },
              child: Center(
                child: AspectRatio(
                  aspectRatio: videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(videoPlayerController),
                ),
              ),
            ),
          if (showPlayPauseButton)
            Center(
              child: IconButton(
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 50.0,
                ),
                onPressed: togglePlayPause,
              ),
            ),

          // Mute button
          Positioned(
            top: 20,
            right: 20,
            child: IconButton(
              icon: Icon(
                isMuted ? Icons.volume_off : Icons.volume_up,
                color: Colors.white,
              ),
              onPressed: toggleMute,
            ),
          ),
        ],
      ),
    );
  }
}