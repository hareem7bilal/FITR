import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/round_button.dart';
import 'package:flutter_application_1/views/profile/complete_profile_view.dart';
import 'package:flutter_application_1/widgets/setting_row.dart';
import 'package:flutter_application_1/widgets/title_subtitle_cell.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:user_repository/user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:universal_io/io.dart' as uni;
import 'package:flutter/foundation.dart' show kIsWeb;

class ProfileView extends StatefulWidget {
  final String name;
  final String height;
  final String weight;
  final String age;
  final String profileImage;
  const ProfileView(
      {super.key,
      required this.name,
      required this.height,
      required this.weight,
      required this.age,
      required this.profileImage});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late String name;
  late String height;
  late String weight;
  late String age;
  late String profileImage;

  @override
  void initState() {
    super.initState();
    // Initialize your variables here from the widget if needed
    name = widget.name;
    height = widget.height;
    weight = widget.weight;
    age = widget.age;
    profileImage = widget.profileImage;
  }

  bool positive = false;

  void togglePositive() {
    setState(() {
      positive = !positive;
    });
  }

  Future<void> updateUserProfile(String imageUrl) async {
    final firebaseUser = FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      // Assuming user data is stored in Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data()!;
        final updatedUser = MyUserModel(
          id: firebaseUser.uid,
          email: userData['email'],
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          gender: userData['gender'],
          dob: userData['dob'] != null
              ? DateTime.tryParse(userData['dob'])
              : null,
          weight: userData['weight'],
          height: userData['height'],
          profileImage: imageUrl,
          // Add other user fields as necessary
        );

        if (!mounted) return;

        BlocProvider.of<UserBloc>(context).add(UpdateUser(updatedUser));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile picture updated successfully')),
        );
      }
    }
  }

  Widget buildAvatar(String? profileImage) {
    final ImagePicker picker = ImagePicker();

    return GestureDetector(
      onTap: () async {
        final XFile? image =
            await picker.pickImage(source: ImageSource.gallery);
        if (image != null) {
          try {
            // For web, we use bytes to upload because `File` from 'dart:io' is not available
            if (kIsWeb) {
              // Use `image.readAsBytes()` to get Uint8List for web
              final imageUrl = await uploadFileWeb(image);
              updateUserProfile(imageUrl);
            } else {
              // For mobile, convert path to a file and upload
              uni.File file = uni.File(image.path);
              final imageUrl = await uploadFileMobile(file);
              updateUserProfile(imageUrl);
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error uploading image: $e')),
              );
            }
          }
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: profileImage != null && profileImage.isNotEmpty
            ? Image.network(profileImage,
                width: 40, height: 40, fit: BoxFit.cover)
            : Container(
                padding:
                    const EdgeInsets.all(2), // Adjust the padding to fit your design
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.grey, // Color of the circle
                    width: 1, // Thickness of the circle border
                  ),
                ),
                child: CircleAvatar(
                  radius: 40, // Adjust the size as needed
                  backgroundColor: Colors
                      .transparent, // Ensures the container's decoration is visible
                  child: Image.asset(
                    "images/icons/profile.png",
                    width: 40,
                    height: 40,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
      ),
    );
  }

  Future<String> uploadFileMobile(uni.File file) async {
    String fileName =
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    TaskSnapshot snapshot =
        await FirebaseStorage.instance.ref(fileName).putFile(file);
    return await snapshot.ref.getDownloadURL();
  }

  Future<String> uploadFileWeb(XFile file) async {
    final bytes = await file.readAsBytes();
    String fileName =
        'profiles/${FirebaseAuth.instance.currentUser!.uid}/${DateTime.now().millisecondsSinceEpoch}.jpg';
    TaskSnapshot snapshot =
        await FirebaseStorage.instance.ref(fileName).putData(bytes);
    return await snapshot.ref.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: TColor.white,
          centerTitle: true,
          elevation: 0,
          leadingWidth: 0,
          title: Text(
            "Profile",
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
                  "images/buttons/more_btn.png",
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
            child: buildUserProfile(context, name, height, weight, age,
                profileImage, positive, togglePositive, buildAvatar)));
  }
}

// Utility function to calculate age from DOB.
String calculateAge(DateTime dob) {
  DateTime currentDate = DateTime.now();
  int age = currentDate.year - dob.year;
  if (currentDate.month < dob.month ||
      (currentDate.month == dob.month && currentDate.day < dob.day)) {
    age--;
  }
  return age.toString();
}

Widget buildUserProfile(
    BuildContext context,
    String name,
    String height,
    String weight,
    String age,
    String profileImage,
    bool positive,
    void Function() togglePositive,
    Widget Function(String?) buildAvatar) {
  List accountArr = [
    {"image": "images/icons/profile.png", "name": "Personal Data", "tag": "1"},
    {
      "image": "images/icons/achievement.png",
      "name": "Achievement",
      "tag": "2"
    },
    {
      "image": "images/icons/activity_history.png",
      "name": "Activity History",
      "tag": "3"
    },
    {
      "image": "images/icons/workout_progress.png",
      "name": "Workout Progress",
      "tag": "4"
    }
  ];

  List otherArr = [
    {"image": "images/icons/email.png", "name": "Contact Us", "tag": "5"},
    {
      "image": "images/icons/privacy_policy.png",
      "name": "Privacy Policy",
      "tag": "6"
    },
    {"image": "images/icons/settings.png", "name": "Settings", "tag": "7"},
  ];

  return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        Row(
          children: [
            buildAvatar(profileImage),
            const SizedBox(
              width: 15,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
                ),
                Text("Rehabilitation Program",
                    style: TextStyle(
                      color: TColor.grey,
                      fontSize: 12,
                    ))
              ],
            )),
            SizedBox(
              width: 70,
              height: 25,
              child: RoundButton(
                title: "Edit",
                type: RoundButtonType.bgGradient,
                fontSize: 12,
                fontWeight: FontWeight.w400,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CompleteProfileView(),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        Row(
          children: [
            Expanded(
                child: TitleSubtitleCell(title: height, subtitle: "Height")),
            const SizedBox(width: 15),
            Expanded(
                child: TitleSubtitleCell(title: weight, subtitle: "Weight")),
            const SizedBox(width: 15),
            Expanded(child: TitleSubtitleCell(title: age, subtitle: "Age")),
          ],
        ),
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Account",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: accountArr.length,
                  itemBuilder: (context, index) {
                    var iObj = accountArr[index] as Map? ?? {};
                    return SettingRow(
                        icon: iObj["image"].toString(),
                        title: iObj["name"].toString(),
                        onPressed: () {});
                  })
            ])),
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Notifications",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              SizedBox(
                height: 30,
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/icons/notification.png",
                        width: 15,
                        height: 15,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 25),
                      Expanded(
                        child: Text("Pop-up Notifications",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 12,
                            )),
                      ),
                      CustomAnimatedToggleSwitch<bool>(
                        current: positive,
                        values: const [false, true],
                        spacing: 0.0,
                        indicatorSize: const Size.square(30.0),
                        animationDuration: const Duration(milliseconds: 200),
                        animationCurve: Curves.linear,
                        onChanged: (b) => togglePositive(),
                        iconBuilder: (context, local, global) {
                          return const SizedBox();
                        },
                        cursors: const ToggleCursors(
                            defaultCursor: SystemMouseCursors.click),
                        onTap: (_) => togglePositive(),
                        iconsTappable: false,
                        wrapperBuilder: (context, global, child) {
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                  left: 10.0,
                                  right: 10.0,
                                  height: 30.0,
                                  child: DecoratedBox(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                          colors: TColor.secondaryG),
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(50.0)),
                                    ),
                                  )),
                              child,
                            ],
                          );
                        },
                        foregroundIndicatorBuilder: (context, global) {
                          return SizedBox.fromSize(
                            size: const Size(10, 10),
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                color: TColor.white,
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(50.0)),
                                boxShadow: const [
                                  BoxShadow(
                                      color: Colors.black38,
                                      spreadRadius: 0.05,
                                      blurRadius: 1.1,
                                      offset: Offset(0.0, 0.8))
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            ])),
        const SizedBox(height: 25),
        Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            decoration: BoxDecoration(
                color: TColor.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: const [
                  BoxShadow(color: Colors.black12, blurRadius: 2)
                ]),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Other",
                  style: TextStyle(
                      color: TColor.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: otherArr.length,
                  itemBuilder: (context, index) {
                    var iObj = otherArr[index] as Map? ?? {};
                    return SettingRow(
                        icon: iObj["image"].toString(),
                        title: iObj["name"].toString(),
                        onPressed: () {});
                  })
            ])),
      ]));
}