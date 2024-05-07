import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:http/http.dart' as http;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/widgets/step_detail_row.dart';
import 'dart:convert';

class ExercisesStepDetails extends StatefulWidget {
  final Map eObj;
  const ExercisesStepDetails({super.key, required this.eObj});

  @override
  State<ExercisesStepDetails> createState() => _ExercisesStepDetailsState();
}

class _ExercisesStepDetailsState extends State<ExercisesStepDetails> {

  YoutubePlayerController? _controller;
  String exerciseDescription = "Loading description..."; // Default text until data is fetched
  List<Map<String, String>> stepArr = []; // Initialize as empty list

   @override
  void initState() {
    super.initState();
    searchAndLoadVideo(widget.eObj["name"]);
    fetchExerciseInfo();  // Fetch description and steps
  }

  Future<void> searchAndLoadVideo(String query) async {
    const String apiKey =
        'AIzaSyDO68wWUP2iFIOi2ayT8RBUu8c2K09xfLM'; // Replace with your actual API key
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

  Future<void> fetchExerciseInfo() async {
    var url = Uri.parse(
        'https://openai-api-fb8x.onrender.com/get_exercise_info'); // Change to your actual server URL
    var response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(<String, String>{'exercise_name': widget.eObj["name"]}),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      var description = data['description'];
      var steps = List<String>.from(data['steps']);

      setState(() {
        exerciseDescription = description;
        stepArr = steps.map((step) {
          var parts = step.split(':');
          return {"title": parts[0].trim(), "detail": parts[1].trim()};
        }).toList();
      });
    } else {
      debugPrint('Failed to load exercise info: ${response.statusCode}');
    }
  }

 

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: TColor.white,
        centerTitle: true,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Container(
            margin: const EdgeInsets.all(8),
            height: 40,
            width: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: TColor.lightGrey,
                borderRadius: BorderRadius.circular(10)),
            child: Image.asset(
              "assets/images/icons/closed_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        actions: [
          InkWell(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(8),
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: TColor.lightGrey,
                  borderRadius: BorderRadius.circular(10)),
              child: Image.asset(
                "assets/images/buttons/more_btn.png",
                width: 15,
                height: 15,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _controller == null
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
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.eObj["name"],
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                "Easy | 390 Calories Burn",
                style: TextStyle(
                  color: TColor.grey,
                  fontSize: 12,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                "Description",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              ReadMoreText(
                exerciseDescription,
                trimLines: 4,
                colorClickableText: TColor.black,
                trimMode: TrimMode.Line,
                trimCollapsedText: ' Read More ...',
                trimExpandedText: ' Read Less',
                style: TextStyle(
                  color: TColor.grey,
                  fontSize: 12,
                ),
                moreStyle:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "How To Do It",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 16,
                        fontWeight: FontWeight.w700),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "${stepArr.length} Sets",
                      style: TextStyle(color: TColor.grey, fontSize: 12),
                    ),
                  )
                ],
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: stepArr.length,
                itemBuilder: ((context, index) {
                  var sObj = stepArr[index] as Map? ?? {};

                  return StepDetailRow(
                    sObj: sObj,
                    isLast: stepArr.last == sObj,
                  );
                }),
              ),
               const SizedBox(
                height: 15,
              ),
              Text(
                "Custom Repetitions",
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 150,
                child: CupertinoPicker.builder(
                  itemExtent: 40,
                  selectionOverlay: Container(
                    width: double.maxFinite,
                    height: 40,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                            color: TColor.grey.withOpacity(0.2), width: 1),
                        bottom: BorderSide(
                            color: TColor.grey.withOpacity(0.2), width: 1),
                      ),
                    ),
                  ),
                  onSelectedItemChanged: (index) {},
                  childCount: 60,
                  itemBuilder: (context, index) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/images/food/burn.png",
                          width: 15,
                          height: 15,
                          fit: BoxFit.contain,
                        ),
                        Text(
                          " ${(index + 1) * 15} Calories Burn",
                          style: TextStyle(color: TColor.grey, fontSize: 10),
                        ),
                        Text(
                          " ${index + 1} ",
                          style: TextStyle(
                              color: TColor.grey,
                              fontSize: 24,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          " times",
                          style: TextStyle(color: TColor.grey, fontSize: 16),
                        )
                      ],
                    );
                  },
                ),
              ),
              RoundButton(title: "Save", elevation: 0, onPressed: () {}),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
