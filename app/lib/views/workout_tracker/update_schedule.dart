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

class UpdateScheduleView extends StatelessWidget {
  final DateTime date;
  final MyWorkoutModel workout;

  const UpdateScheduleView(
      {super.key, required this.date, required this.workout});

  @override
  Widget build(BuildContext context) {
    // Provide the WorkoutBloc to the AddScheduleView
    return BlocProvider<WorkoutBloc>(
      create: (context) =>
          WorkoutBloc(workoutRepository: FirebaseWorkoutRepository()),
      child: _UpdateScheduleViewStateful(date: date, workout: workout),
    );
  }
}

class _UpdateScheduleViewStateful extends StatefulWidget {
  final DateTime date;
  final MyWorkoutModel workout;
  const _UpdateScheduleViewStateful(
      {required this.date, required this.workout});

  @override
  State<_UpdateScheduleViewStateful> createState() =>
      _UpdateScheduleViewState();
}

class _UpdateScheduleViewState extends State<_UpdateScheduleViewStateful> {
  // Create TextEditingControllers for the text fields
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController kcalController = TextEditingController();
  final TextEditingController customRepsController = TextEditingController();
  final TextEditingController customWeightsController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController videoController = TextEditingController();
  final TextEditingController numberOfExercisesController =
      TextEditingController();
  final TextEditingController itemsNeededController = TextEditingController();
  final List<WorkoutSet> sets = [];

  // Create FocusNodes for each text field
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode kcalFocusNode = FocusNode();
  final FocusNode customRepsFocusNode = FocusNode();
  final FocusNode customWeightsFocusNode = FocusNode();
  final FocusNode durationFocusNode = FocusNode();
  final FocusNode videoFocusNode = FocusNode();
  final FocusNode numberOfExercisesFocusNode = FocusNode();
  final FocusNode itemsNeededFocusNode = FocusNode();
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

  void _updateWorkout() async {
    debugPrint(
        "UID to set in Firestore: ${FirebaseAuth.instance.currentUser!.uid}");
    try {
      // Upload the image only if _imageFile is not null
      String? imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      } else {
        imageUrl = widget.workout.image;
      }

      final workout = widget.workout.copyWith(
        id: widget.workout.id,
        description: descriptionController.text.isNotEmpty
            ? descriptionController.text
            : widget.workout.description,
        image: imageUrl,
        kcal: kcalController.text.isNotEmpty
            ? double.tryParse(kcalController.text)
            : widget.workout.kcal,
        time: Timestamp.fromDate(selectedTime),
        duration: durationController.text.isNotEmpty
            ? durationController.text
            : widget.workout.duration,
        progress: progress,
        difficultyLevel: difficulty,
        customReps: customRepsController.text.isNotEmpty
            ? int.tryParse(customRepsController.text)
            : widget.workout.customReps,
        customWeights: customWeightsController.text.isNotEmpty
            ? double.tryParse(customWeightsController.text)
            : widget.workout.customWeights,
        date: widget.date,
        video: videoController.text.isNotEmpty
            ? videoController.text
            : widget.workout.video,
        numberOfExercises: int.tryParse(numberOfExercisesController.text) ??
            widget.workout.numberOfExercises,
        itemsNeeded: itemsNeededController.text.isNotEmpty
            ? itemsNeededController.text
                .split(',')
                .map((e) => e.trim())
                .toList()
            : widget.workout.itemsNeeded,
        sets: sets.isNotEmpty ? sets : widget.workout.sets,
      );

      // Ensure the widget is still mounted before updating the UI
      if (!mounted) return;
      BlocProvider.of<WorkoutBloc>(context).add(UpdateWorkout(workout));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Workout updated successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update workout: ${e.toString()}")),
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

  void _addSet() {
    setState(() {
      sets.add(
          WorkoutSet(title: 'Set ${sets.length + 1}', exercises: const []));
    });
  }

  void _addExercise(int index) {
    // Prompt for Exercise details
    showDialog(
      context: context,
      builder: (context) {
        TextEditingController nameController = TextEditingController();
        TextEditingController durationController = TextEditingController();
        TextEditingController repetitionsController = TextEditingController();

        return AlertDialog(
          backgroundColor: TColor.lightGrey,
          title: const Text('Add Exercise'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: Colors.black54, // Set the color of the hint text
                    fontSize: 14, // Set the font style of the hint text
                  ),
                ),
              ),
              TextField(
                controller: durationController,
                decoration: const InputDecoration(
                  hintText: "Duration",
                  hintStyle: TextStyle(
                    color: Colors.black54, // Set the color of the hint text
                    fontSize: 14, // Set the font style of the hint text
                  ),
                ),
              ),
              TextField(
                controller: repetitionsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Repetitions",
                  hintStyle: TextStyle(
                    color: Colors.black54, // Set the color of the hint text
                    fontSize: 14, // Set the font style of the hint text
                  ),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                foregroundColor:
                    TColor.white, //change background color of button
                backgroundColor: const Color.fromARGB(
                    255, 204, 38, 26), //change text color of button
                textStyle: TextStyle(color: TColor.white), // Set the text color
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: TColor
                      .white, //change background color of button//change background color of button
                  backgroundColor: TColor.primaryColor1,
                  textStyle:
                      TextStyle(color: TColor.white), // Set the text color
                ),
                child: const Text('Add'),
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      durationController.text.isNotEmpty &&
                      repetitionsController.text.isNotEmpty) {
                    Navigator.of(context).pop();
                    setState(() {
                      // Create a new mutable list from the existing exercises
                      List<Exercise> newExercises =
                          List<Exercise>.from(sets[index].exercises);
                      newExercises.add(Exercise(
                        name: nameController.text,
                        duration: durationController.text,
                        image: 'assets/images/training/default.png',
                        repetitions: int.tryParse(repetitionsController.text),
                      ));
                      // Replace the old exercises list with the new list
                      sets[index] =
                          sets[index].copyWith(exercises: newExercises);
                    });
                  }
                }),
          ],
        );
      },
    );
  }

  Widget _buildSetList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sets.length,
      itemBuilder: (context, index) {
        return Card(
          color: TColor.lightGrey,
          child: ExpansionTile(
            title: Text('Set ${index + 1}',
                style: TextStyle(
                    color: TColor.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            children: sets[index]
                .exercises
                .map((exercise) => Container(
                      color: TColor.lightGrey,
                      child: ListTile(
                        title: Text(exercise.name),
                        subtitle: Text(
                            'Duration: ${exercise.duration}, Repetitions: ${exercise.repetitions}'),
                      ),
                    ))
                .toList()
              ..add(Container(
                color: TColor.lightGrey,
                child: ListTile(
                  leading: const Icon(Icons.add),
                  title: const Text('Add Exercise',
                      style: TextStyle(
                          color: Color.fromARGB(255, 121, 135, 142),
                          fontSize: 13)),
                  onTap: () => _addExercise(index),
                ),
              )),
          ),
        );
      },
    );
  }

  Widget _buildAddSetButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
          onPressed: _addSet,
          style: ElevatedButton.styleFrom(
            foregroundColor: TColor
                .white, //change background color of button//change background color of button
            backgroundColor: TColor.primaryColor1,
            textStyle: TextStyle(color: TColor.white), // Set the text color
          ),
          child: const Text('Add Set')),
    );
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
          "Update ${widget.workout.name} Schedule",
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
            height: 110, // Fixed height for the date picker
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
              backgroundColor:
                  const Color.fromARGB(255, 207, 216, 253), // Background color
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
          IconTitleNextRow(
            icon: "assets/images/icons/swap.png",
            title: "Number of Exercises",
            textEditingController: numberOfExercisesController,
            focusNode: numberOfExercisesFocusNode,
            color: TColor.lightGrey,
            onPressed: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          IconTitleNextRow(
            icon: "assets/images/icons/swap.png",
            title: "Items Needed(comma separated)",
            textEditingController: itemsNeededController,
            focusNode: itemsNeededFocusNode,
            color: TColor.lightGrey,
            onPressed: () {},
          ),
          const SizedBox(
            height: 10,
          ),
          _buildSetList(),
          _buildAddSetButton(),
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
                  .lightGrey, // Color for the remaining track to be traveled
              thumbColor: TColor.primaryColor1, // Color of the slider thumb
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
                  .lightGrey, // Color for the remaining track to be traveled
              thumbColor: TColor.primaryColor1, // Color of the slider thumb
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
            title: "Update",
            onPressed: _updateWorkout,
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
