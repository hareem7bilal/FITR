import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui;
import 'package:flutter/foundation.dart' show kIsWeb; // Platform check

class YTView extends StatefulWidget {
  const YTView({super.key});

  @override
  State<YTView> createState() => _YTViewState();
}

class _YTViewState extends State<YTView> {
  YoutubePlayerController? _controller;
  String? _videoUrl; // For the web video URL

  Future<void> searchAndLoadVideo(String query) async {
    const String apiKey = 'AIzaSyDd6_23wwBnLIhBKVD72Xxe49Qhc5L-xPw';
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['items'].isNotEmpty) {
        final videoId = data['items'][0]['id']['videoId'];
        final embedUrl = 'https://www.youtube.com/embed/$videoId';

        if (!kIsWeb) {
          // Mobile: Initialize YoutubePlayerController
          initializePlayer(videoId);
        } else {
          // Web: Set the iframe URL
          _videoUrl = embedUrl;
          // Ensure the UI is rebuilt to display the iframe
          setState(() {});
        }
      }
    } else {
      debugPrint('Failed to load video');
    }
  }

  void initializePlayer(String videoId) {
    // Existing mobile-specific initialization remains unchanged
    _controller = YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        // Other flags...
      ),
    );

    // Set state to refresh the UI
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    searchAndLoadVideo("Flutter Tutorial");
  }

  @override
  Widget build(BuildContext context) {
    // Platform-specific UI rendering
    if (kIsWeb && _videoUrl != null) {
      // For web: Use HtmlElementView to embed the iframe
      // Ensure you've registered the view factory in main.dart or similar
      const String viewType = 'youtube-video';
      // ignore: undefined_prefixed_name
      ui.platformViewRegistry.registerViewFactory(viewType, (int viewId) {
        final iframe = html.IFrameElement()
          ..src = _videoUrl
          ..style.border = 'none';
          
        // Make the iframe responsive
        iframe.style.width = '100%'; // Make width fit the screen width
        iframe.style.height =
            'calc(100vw * (9 / 16))'; // Maintain a 16:9 aspect ratio

        return iframe;
      });

      return Scaffold(
        appBar: AppBar(title: const Text('Top Video')),
        body: const HtmlElementView(viewType: viewType),
      );
    } else {
      // For mobile: Existing YoutubePlayerBuilder logic
      return Scaffold(
        appBar: AppBar(title: const Text('Top Video')),
        body: _controller == null
            ? const Center(child: CircularProgressIndicator())
            : YoutubePlayerBuilder(
                player: YoutubePlayer(controller: _controller!),
                builder: (context, player) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [player],
                  );
                },
              ),
      );
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
