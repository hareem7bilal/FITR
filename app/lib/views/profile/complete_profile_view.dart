import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_textfield.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:user_repository/user_repository.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompleteProfileView extends StatefulWidget {

  const CompleteProfileView({super.key});
   

  @override
  State<CompleteProfileView> createState() => _CompleteProfileViewState();
}

class _CompleteProfileViewState extends State<CompleteProfileView> {
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtWeight = TextEditingController();
  final TextEditingController txtHeight = TextEditingController();
  String? selectedGender;
  String? selectedProgram;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        if (state.updateUserSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Your profile has been updated')),
          );
        } else if (state.updateUserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update your profile')),
          );
        }
      },
      child: Scaffold(
         appBar: AppBar(
          backgroundColor: TColor.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: TColor.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        backgroundColor: TColor.white,
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Image.asset(
                      "assets/images/signup_and_login/complete_profile.png",
                      width: media.width,
                      fit: BoxFit.fitWidth),
                  SizedBox(height: media.width * 0.05),
                  Text("Let's Update Your Profile",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  Text("It will help us know more about you!",
                      style: TextStyle(color: TColor.grey, fontSize: 12)),
                  SizedBox(height: media.width * 0.05),
                  _buildGenderDropdown(),
                  SizedBox(height: media.width * 0.04),
                  _buildDateOfBirthField(),
                  SizedBox(height: media.width * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: _buildWeightField(),
                      ),
                      const SizedBox(width: 8),
                      Container(
                          width: 45,
                          height: 45,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: TColor.primaryG),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text("KG",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12)))
                    ],
                  ),
                  SizedBox(height: media.width * 0.04),
                  Row(
                    children: [
                      Expanded(
                        child: _buildHeightField(),
                      ),
                      const SizedBox(width: 8),
                      Container(
                          width: 50,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: TColor.primaryG),
                              borderRadius: BorderRadius.circular(15)),
                          child: Text("CM",
                              style:
                                  TextStyle(color: TColor.white, fontSize: 12)))
                    ],
                  ),
                  SizedBox(height: media.width * 0.04),
                  _buildWorkoutProgramDropdown(),
                  SizedBox(height: media.width * 0.07),
                  RoundButton(title: "Save", onPressed: _saveUserProfile, elevation: 0.0,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutProgramDropdown() {
    // Mock list of workouts for the example
    const List<String> workoutPrograms = [
      'Bodybuilding',
      'Crossfit',
      'Yoga',
      'Pilates',
      'Cardio'
    ];

    return GestureDetector(
      onTap: () => _showWorkoutProgramBottomSheet(workoutPrograms),
      child: AbsorbPointer(
        child: RoundTextField(
          hintText: selectedProgram ?? "Select Workout Program",
          icon: "assets/images/workouts/workout2.png",
          controller: TextEditingController(text: selectedProgram),
        ),
      ),
    );
  }

  void _showWorkoutProgramBottomSheet(List<String> workoutPrograms) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: workoutPrograms.map((String program) {
              return ListTile(
                title: Text(program),
                onTap: () {
                  setState(() {
                    selectedProgram = program;
                    Navigator.pop(context);
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  // _buildGenderDropdown with GestureDetector for web compatibility
  Widget _buildGenderDropdown() {
    return GestureDetector(
      onTap: () => _showGenderBottomSheet(),
      child: AbsorbPointer(
        // Prevents the TextField from gaining focus
        child: RoundTextField(
          hintText: selectedGender ?? "Select Gender",
          icon: "assets/images/icons/gender.png",
          controller: TextEditingController(text: selectedGender),
        ),
      ),
    );
  }

// _buildDateOfBirthField adjusted for web
  Widget _buildDateOfBirthField() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: RoundTextField(
          controller: txtDate,
          hintText: "Date Of Birth",
          icon: "assets/images/icons/calender.png",
        ),
      ),
    );
  }

  Widget _buildWeightField() {
    return RoundTextField(
      controller: txtWeight,
      hintText: "Your Weight",
      icon: "assets/images/icons/weight-scale.png",
      keyboardType: TextInputType.number,
    );
  }

  Widget _buildHeightField() {
    return RoundTextField(
      controller: txtHeight,
      hintText: "Your Height",
      icon: "assets/images/icons/swap.png",
      keyboardType: TextInputType.number,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        txtDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showGenderBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <String>['Male', 'Female', 'Other'].map((String gender) {
              return ListTile(
                title: Text(gender),
                onTap: () {
                  setState(() {
                    selectedGender = gender;
                    Navigator.pop(context);
                  });
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  void _saveUserProfile() async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Assuming you're storing user details in Firestore
      // Fetch additional required details from Firestore or your user state
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Now create your updated user model with all required fields
      final updatedUser = MyUserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ??
            '', 
        firstName: userData['firstName'] ??
            '', 
        lastName: userData['lastName'] ?? '',
        profileImage: userData['profileImage'] ?? '',
        gender: selectedGender ?? userData['gender'],
        program: selectedProgram ?? userData['program'],
        dob: txtDate.text.isNotEmpty
            ? DateTime.parse(txtDate.text)
            : userData['dob'],
        weight: txtWeight.text.isNotEmpty
            ? double.parse(txtWeight.text)
            : userData['weight'],
        height: txtHeight.text.isNotEmpty
            ? double.parse(txtHeight.text)
            : userData['height'],
      );

      // Ensure the widget is still mounted before updating the UI
      if (!mounted) return;

      // Dispatch UpdateUser event
      BlocProvider.of<UserBloc>(context).add(UpdateUser(updatedUser));
    }
  }
}
