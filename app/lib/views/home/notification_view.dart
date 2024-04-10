import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/color_extension.dart';
import 'package:flutter_application_1/widgets/notification_row.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({super.key});

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  List notificationArr = [
    {"image": "assets/images/workouts/workout1.png", "title": "Hey, it’s time for lunch", "time": "About 1 minutes ago"},
    {"image": "assets/images/workouts/workout2.png", "title": "Don’t miss your lowerbody workout", "time": "About 3 hours ago"},
    {"image": "assets/images/workouts/workout3.png", "title": "Hey, let’s add some meals for your b", "time": "About 3 hours ago"},
    {"image": "assets/images/workouts/workout1.png", "title": "Congratulations, You have finished A..", "time": "29 May"},
    {"image": "assets/images/workouts/workout2.png", "title": "Hey, it’s time for lunch", "time": "8 April"},
    {"image": "assets/images/workouts/workout3.png", "title": "Ups, You have missed your Lowerbo...", "time": "8 April"},
  ];

  @override
  Widget build(BuildContext context) {
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
              "assets/images/buttons/back_btn.png",
              width: 15,
              height: 15,
              fit: BoxFit.contain,
            ),
          ),
        ),
        title: Text(
          "Notifications",
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
                width: 12,
                height: 12,
                fit: BoxFit.contain,
              ),
            ),
          )
        ],
      ),
      backgroundColor: TColor.white,
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        itemBuilder: ((context, index) {
          var nObj = notificationArr[index] as Map? ?? {};
          return NotificationRow(nObj: nObj);
      }), separatorBuilder: (context, index){
        return Divider(color: TColor.grey.withOpacity(0.5), height: 1, );
      }, itemCount: notificationArr.length),
    );
  }
}