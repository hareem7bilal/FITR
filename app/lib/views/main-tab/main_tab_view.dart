import 'package:flutter_application_1/widgets/tab_button.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/home/blank_view.dart';
import 'package:flutter_application_1/views/home/home_view.dart';
import 'package:flutter_application_1/views/profile/profile_view.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/user_bloc/user_bloc.dart';
import 'package:flutter_application_1/views/login/login_view.dart';

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  @override
  void initState() {
    super.initState();
    fetchCurrentUserData();
  }

  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeView();

  void fetchCurrentUserData() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // If we have a user, fetch the user data using the UserBloc
      BlocProvider.of<UserBloc>(context).add(GetUser(userId: user.uid));
    } else {
      // If no user is signed in, navigate to the login screen
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      });
    }
  }

  Widget buildMainTab(String name, String height, String weight, String age,
      String profileImage) {
    return SizedBox(
      /*decoration: BoxDecoration(color: TColor.white, boxShadow: const [
            BoxShadow(
                color: Colors.black26, blurRadius: 2, offset: Offset(0, -2))
          ]),*/
      height: kToolbarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          TabButton(
              icon: "images/icons/home_tab.png",
              selectIcon: "images/icons/home_tab_select.png",
              isActive: selectTab == 0,
              onTap: () {
                selectTab = 0;
                currentTab = const HomeView();
                if (mounted) {
                  setState(() {});
                }
              }),
          TabButton(
              icon: "images/icons/activity_tab.png",
              selectIcon: "images/icons/activity_tab_select.png",
              isActive: selectTab == 1,
              onTap: () {
                selectTab = 1;
                currentTab = const BlankView();
                if (mounted) {
                  setState(() {});
                }
              }),
          const SizedBox(
            width: 40,
          ),
          TabButton(
              icon: "images/icons/camera_tab.png",
              selectIcon: "images/icons/camera_tab_select.png",
              isActive: selectTab == 2,
              onTap: () {
                selectTab = 2;
                currentTab = const BlankView();
                if (mounted) {
                  setState(() {});
                }
              }),
          TabButton(
              icon: "images/icons/profile_tab.png",
              selectIcon: "images/icons/profile_tab_select.png",
              isActive: selectTab == 3,
              onTap: () {
                selectTab = 3;
                currentTab = ProfileView(
                    name: name,
                    height: height,
                    weight: weight,
                    age: age,
                    profileImage: profileImage);
                if (mounted) {
                  setState(() {});
                }
              })
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColor.white,
      body: PageStorage(bucket: pageBucket, child: currentTab),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: SizedBox(
          width: 70,
          height: 70,
          child: InkWell(
              onTap: () {},
              child: Container(
                width: 65,
                height: 65,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: TColor.primaryG),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 2,
                          offset: Offset(2, 2))
                    ]),
                child: Icon(
                  Icons.search,
                  color: TColor.white,
                  size: 35,
                ),
              ))),
      bottomNavigationBar: BottomAppBar(child: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state.status == UserStatus.success && state.user != null) {
            final user = state.user!;
            // Convert each property to a string, using 'toString()' and ensure null safety with '??'
            final String name = "${user.firstName} ${user.lastName}";
            final String height = user.height?.toString() ?? "not specified";
            final String weight = user.weight?.toString() ?? "not specified";
            final String profileImage = user.profileImage?.toString() ?? '';
            String age = "not specified";

            // Check if dob is not null before calculating age.
            if (user.dob != null) {
              DateTime dob = user
                  .dob!; // Use the actual DOB field from your user model, now safely unwrapped.
              age = calculateAge(dob);
            }
            return buildMainTab(name, height, weight, age, profileImage);
          }
          return const Center(child: CircularProgressIndicator());
        },
      )),
    );
  }
}
