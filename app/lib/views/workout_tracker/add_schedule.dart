import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/utils/common.dart';
import 'package:flutter_application_1/widgets/icon_title_next_row.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/workout_bloc/workout_bloc.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:workout_repository/workout_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_io/io.dart';

class AddScheduleView extends StatelessWidget {
  final DateTime date;

  const AddScheduleView({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    // Provide the WorkoutBloc to the AddScheduleView
    return BlocProvider<WorkoutBloc>(
      create: (context) =>
          WorkoutBloc(workoutRepository: FirebaseWorkoutRepository()),
      child: _AddScheduleViewStateful(date: date),
    );
  }
}

class _AddScheduleViewStateful extends StatefulWidget {
  final DateTime date;
  const _AddScheduleViewStateful({required this.date});

  @override
  State<_AddScheduleViewStateful> createState() => _AddScheduleViewState();
}

class _AddScheduleViewState extends State<_AddScheduleViewStateful> {
  // Create TextEditingControllers for the text fields
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();
  final TextEditingController customRepsController = TextEditingController();
  final TextEditingController customWeightsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController videoController = TextEditingController();

  // Create FocusNodes for each text field
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode kcalFocusNode = FocusNode();
  final FocusNode customRepsFocusNode = FocusNode();
  final FocusNode customWeightsFocusNode = FocusNode();
  final FocusNode durationFocusNode = FocusNode();
  final FocusNode videoFocusNode = FocusNode();

  // Variables for non-text fields
  // Image picker instance
  final ImagePicker _picker = ImagePicker();
  // For image paths
  XFile? _imageFile;
  DateTime selectedTime = DateTime.now();
  double progress = 0; // For progress slider value
  double difficulty = 0; // For difficulty slider value

  // Method to pick an image
  Future<void> _pickImage() async {
    try {
      final pickedImage = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedImage != null) {
        setState(() {
          _imageFile = pickedImage;
        });
      }
    } catch (e) {
      // If you need to handle any exceptions, do it here.
    }
  }

  void _saveWorkout() async {
    try {
      final String imageUrl = await _uploadImage(_imageFile!);

      final workout = MyWorkoutModel(
        id: '',
        userId: FirebaseAuth.instance.currentUser!.uid,
        name: nameController.text,
        description: descriptionController.text,
        image: imageUrl,
        kcal: double.tryParse(kcalController.text),
        time: Timestamp.fromDate(selectedTime),
        duration: durationController.text,
        progress: progress,
        difficultyLevel: difficulty,
        customReps: int.tryParse(customRepsController.text),
        customWeights: double.tryParse(customWeightsController.text),
        date: widget.date,
        video: videoController.text.isNotEmpty ? videoController.text : null,
      );

      // Ensure the widget is still mounted before updating the UI
      if (!mounted) return;

      BlocProvider.of<WorkoutBloc>(context).add(AddWorkout(workout));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workout saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to save workout: ${e.toString()}")),
      );
    }
  }

  Future<String> _uploadImage(XFile file) async {
    try {
      // Unique file name for the image
      String fileName =
          'workouts/${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch.toString()}';
      // Reference to the Firebase Storage bucket
      var reference = FirebaseStorage.instance.ref().child(fileName);

      // Upload process
      TaskSnapshot uploadTask = await reference.putFile(File(file.path));

      // Once the image is uploaded, retrieve its URL
      String imageUrl = await uploadTask.ref.getDownloadURL();
      return imageUrl;
    } catch (e) {
      debugPrint(
          e.toString()); // You might want to handle the error differently
      return Future.error('Image upload failed');
    }
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
        title: Text(
          "Add Schedule",
          style: TextStyle(
              color: TColor.black, fontSize: 16, fontWeight: FontWeight.w700),
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
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            children: [
              Image.asset(
                "assets/images/icons/calender.png",
                width: 20,
                height: 20,
              ),
              const SizedBox(
                width: 8,
              ),
              Text(
                dateToString(widget.date, formatStr: "E, dd MMMM yyyy"),
                style: TextStyle(color: TColor.grey, fontSize: 14),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Time",
            style: TextStyle(
                color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(
            height: 120, // Fixed height for the date picker
            //height: media.width * 0.35,
            child: CupertinoDatePicker(
              onDateTimeChanged: (newTime) {
                setState(() {
                  // Combine the new time with the existing date
                  selectedTime = DateTime(
                    widget.date.year,
                    widget.date.month,
                    widget.date.day,
                    newTime.hour,
                    newTime.minute,
                  );
                });
              },
              initialDateTime: selectedTime,
              use24hFormat: false,
              minuteInterval: 1,
              mode: CupertinoDatePickerMode.time,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            "Details",
            style: TextStyle(
                color: TColor.black, fontSize: 14, fontWeight: FontWeight.w500),
          ),
          const SizedBox(
            height: 8,
          ),
          IconTitleNextRow(
              icon: "assets/images/icons/choose_workout.png",
              title: "Workout",
              color: TColor.lightGrey,
              textEditingController: nameController,
              focusNode: nameFocusNode,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
            icon: "assets/images/icons/swap.png",
            title: "Description",
            textEditingController: descriptionController,
            focusNode: descriptionFocusNode,
            color: TColor.lightGrey,
            onPressed: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            "Progress",
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: TColor
                  .primaryColor1, // Color for the track that has been traveled already
              inactiveTrackColor: TColor
                  .secondaryColor1, // Color for the remaining track to be traveled
              thumbColor: TColor.primaryColor1, // Color of the slider thumb
              overlayColor: TColor
                  .secondaryColor1, // Color of the overlay shown when the slider thumb is touched
              activeTickMarkColor: TColor.primaryColor1,
              inactiveTickMarkColor: TColor.primaryColor2,
            ),
            child: Slider(
              value: progress,
              min: 0,
              max: 5,
              divisions: 5,
              label: '${progress.round()}',
              onChanged: (double value) {
                setState(() {
                  progress = value;
                });
              },
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Difficulty",
            style: TextStyle(
              color: TColor.black,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: TColor
                  .primaryColor1, // Color for the track that has been traveled already
              inactiveTrackColor: TColor
                  .secondaryColor1, // Color for the remaining track to be traveled
              thumbColor: TColor.primaryColor1, // Color of the slider thumb
              overlayColor: TColor
                  .secondaryColor1, // Color of the overlay shown when the slider thumb is touched
              activeTickMarkColor: TColor.primaryColor1,
              inactiveTickMarkColor: TColor.primaryColor2,
            ),
            child: Slider(
              value: difficulty,
              min: 0,
              max: 5,
              divisions: 5,
              label: '${difficulty.round()}',
              onChanged: (double value) {
                setState(() {
                  difficulty = value;
                });
              },
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
              icon: "assets/images/icons/weight.png",
              title: "Custom Repetitions",
              color: TColor.lightGrey,
              textEditingController: customRepsController,
              focusNode: customRepsFocusNode,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
              icon: "assets/images/icons/weight.png",
              title: "Custom Weights(KG)",
              color: TColor.lightGrey,
              textEditingController: customWeightsController,
              focusNode: customWeightsFocusNode,
              onPressed: () {}),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
            icon: "assets/images/icons/swap.png",
            title: "Duration",
            textEditingController: durationController,
            focusNode: durationFocusNode,
            color: TColor.lightGrey,
            onPressed: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
            icon: "assets/images/icons/swap.png",
            title: "Kcal",
            textEditingController: kcalController,
            focusNode: kcalFocusNode,
            color: TColor.lightGrey,
            onPressed: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
            icon: "assets/images/icons/swap.png",
            title: "Video URL",
            textEditingController: videoController,
            focusNode: videoFocusNode,
            color: TColor.lightGrey,
            onPressed: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: Text(
              _imageFile != null ? _imageFile!.name : 'Tap to select image',
              style: TextStyle(
                color: TColor.grey, // Light grey color
                fontSize: 12, // Smaller text size
              ),
            ),
            onTap: _pickImage, // Call the image picker method
          ),
          const SizedBox(
            height: 20,
          ),
          RoundButton(
            title: "Save",
            onPressed: _saveWorkout,
            elevation: 0.0,
          ),
          const SizedBox(
            height: 20,
          ),
        ]),
      ),
    );
  }
}
