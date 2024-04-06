import 'package:flutter_application_1/widgets/tab_button.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/views/home/blank_view.dart';
import 'package:flutter_application_1/views/home/home_view.dart';
import 'package:flutter_application_1/views/profile/profile_view.dart';
import "package:flutter/material.dart";

class MainTabView extends StatefulWidget {
  const MainTabView({super.key});

  @override
  State<MainTabView> createState() => _MainTabViewState();
}

class _MainTabViewState extends State<MainTabView> {
  int selectTab = 0;
  final PageStorageBucket pageBucket = PageStorageBucket();
  Widget currentTab = const HomeView();
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
      bottomNavigationBar: BottomAppBar(
        child: SizedBox(
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
                    currentTab = const ProfileView();
                    if (mounted) {
                      setState(() {});
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
