import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../utils/color_extension.dart';

class YTView extends StatefulWidget {
  const YTView({super.key});

  @override
  State<YTView> createState() => _YTViewState();
}

class _YTViewState extends State<YTView> {
  YoutubePlayerController? _controller;

  Future<void> searchAndLoadVideo(String query) async {
    const String apiKey =
        'AIzaSyDd6_23wwBnLIhBKVD72Xxe49Qhc5L-xPw'; // Replace with your actual API key
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'].isNotEmpty) {
        final videoId = data['items'][0]['id']['videoId'];

        // Mobile: Initialize YoutubePlayerController
        initializePlayer(videoId);
      }
    } else {
      debugPrint('Failed to load video');
    }
  }

  void initializePlayer(String videoId) {
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        enableCaption: true,
        captionLanguage: 'en',
        loop: true,
        forceHD: false,
        controlsVisibleAtStart: true,
        hideThumbnail: false,
        hideControls: false,
        isLive: false,
        // Other flags...
      ),
    );

    // Set state to refresh the UI
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    searchAndLoadVideo("Ankle rehabilitation");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Top Video')),
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : YoutubePlayerBuilder(
              player: YoutubePlayer(
                controller: _controller!,
                aspectRatio: 16 / 9,
                showVideoProgressIndicator: true,
                progressIndicatorColor: TColor.primaryColor1,
                topActions: const <Widget>[
                  // Custom widgets or actions
                ],
                bottomActions: const <Widget>[
                  // Custom widgets or controls
                ],
                onReady: () {
                  debugPrint('Player is ready.');
                },
                onEnded: (data) {
                  // Handle video end
                },
              ),
              builder: (context, player) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [player],
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
