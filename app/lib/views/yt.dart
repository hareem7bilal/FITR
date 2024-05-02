import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../utils/color_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_bloc/user_bloc.dart';

class YTView extends StatefulWidget {
  const YTView({super.key});

  @override
  State<YTView> createState() => _YTViewState();
}

class _YTViewState extends State<YTView> {
  List<String> _videoIds = []; // Store video IDs here
  bool _isFetching = false;

  Future<void> searchAndLoadVideos(String query) async {
    if (_isFetching) return; // Prevent multiple fetches
    _isFetching = true;
    const String apiKey =
        'AIzaSyDO68wWUP2iFIOi2ayT8RBUu8c2K09xfLM'; // Replace with your actual API key
    final String apiUrl =
        'https://www.googleapis.com/youtube/v3/search?part=snippet&q=$query&type=video&maxResults=10&key=$apiKey';

    final response = await http.get(Uri.parse(apiUrl));
    debugPrint(
        'HTTP status code: ${response.statusCode}'); // Check HTTP status code
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      debugPrint(
          'YouTube API response data: $data'); // Print the full API response
      List<String> ids = [];
      for (var item in data['items']) {
        ids.add(item['id']['videoId']);
      }
      if (ids.isEmpty) {
        debugPrint('No video IDs found');
      }
      setState(() {
        _videoIds = ids;
      });
    } else {
      debugPrint(
          'Error response: ${response.body}'); // Print error response if any
    }
    _isFetching = false;
  }

  @override
  void initState() {
    super.initState();
    //Initially load videos with a default query
    //searchAndLoadVideos("rehabilitation exercises");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // This ensures the bloc is available and you can access the initial state.
      final userState = context.read<UserBloc>().state;
      if (userState.status == UserStatus.success && userState.user != null) {
        triggerVideoFetch(userState);
      }
    });
  }

  Widget _buildVideoGrid() {
    return GridView.builder(
      itemCount: _videoIds.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // Number of columns
        childAspectRatio: 16 / 9, // Aspect ratio of each item
        crossAxisSpacing: 10, // Horizontal space between items
        mainAxisSpacing: 10, // Vertical space between items
      ),
      itemBuilder: (context, index) {
        String videoId = _videoIds[index];
        double screenWidth = MediaQuery.of(context).size.width;

        return Card(
          elevation: 5,
          margin: const EdgeInsets.all(5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: InkWell(
            onTap: () {
              // Functionality when the card is tapped
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  content: YoutubePlayer(
                    controller: YoutubePlayerController(
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
                    ),
                    aspectRatio: 16 / 9,
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: TColor.primaryColor1,
                    onReady: () => debugPrint('Player is ready.'),
                    onEnded: (data) {
                      // Handle video end
                    },
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                'https://img.youtube.com/vi/$videoId/0.jpg',
                width: (screenWidth / 2) -
                    20, // Adjust width according to number of columns and padding
                height: ((screenWidth / 2) - 20) * 9 / 16,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout Gallery')),
      body: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state.status == UserStatus.success &&
              state.user != null &&
              !_isFetching) {
            triggerVideoFetch(state);
          }
        },
        child: _videoIds.isEmpty && !_isFetching
            ? const Center(
                child: Text(
                    'Waiting for user data...')) // Informative text when no videos are found or waiting for initial data
            : _videoIds.isEmpty && _isFetching
                ? const Center(
                    child:
                        CircularProgressIndicator()) // Show loading indicator while fetching
                : _buildVideoGrid(), // Display the list if videos are available
      ),
    );
  }

  void triggerVideoFetch(UserState state) {
    List<String?> queryParts = [
      state.user!.program,
      state.user!.gender == 'male' ? 'men' : 'women',
      _calculateAgeCategory(state.user!.dob),
      _calculateWeightCategory(state.user!.weight),
    ];
    String searchQuery = queryParts.where((s) => s != null).join(' ');
    searchAndLoadVideos(searchQuery);
  }

  String _calculateAgeCategory(DateTime? dob) {
    final currentDate = DateTime.now();
    int age = currentDate.year - dob!.year;
    if (currentDate.month < dob.month ||
        (currentDate.month == dob.month && currentDate.day < dob.day)) {
      age--;
    }
    return age < 18
        ? 'teen'
        : age <= 35
            ? 'young adult'
            : age <= 55
                ? 'adult'
                : 'senior';
  }

  String _calculateWeightCategory(double? weight) {
    return weight! < 70
        ? 'lightweight workouts'
        : weight <= 90
            ? 'standard workouts'
            : 'heavyweight workouts';
  }

  @override
  void dispose() {
    super.dispose();
  }
}
