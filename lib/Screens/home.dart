import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:school_management/Screens/Exam/Exam_Rseult.dart';
import 'package:school_management/Widgets/AppBar.dart';
import 'package:school_management/Widgets/BouncingButton.dart';
import 'package:school_management/Widgets/DashboardCards.dart';
import 'package:school_management/Widgets/MainDrawer.dart';
import 'package:school_management/Widgets/UserDetailCard.dart';

import 'Attendance/student_attendance.dart';
import 'Leave_Apply/LeaveApply.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  late AnimationController animationController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    // ✅ FIX: new system UI method
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );

    delayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.8, 1.0, curve: Curves.fastOutSlowIn),
      ),
    );

    leftCurve = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.5, 1.0, curve: Curves.easeInOut),
      ),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: MainDrawer(),
          ),
          appBar: CommonAppBar(
            menuenabled: true,
            notificationenabled: true,
            title: "Dashboard",
            ontap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          body: ListView(
            children: [
              UserDetailCard(),

              // 🔹 Row 1
              _buildRow(
                width,
                DashboardCard(
                  name: "Attendance",
                  imgpath: "attendance.png",
                ),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StudentAttendance()),
                ),
                DashboardCard(
                  name: "Profile",
                  imgpath: "profile.png",
                ),
                () {},
              ),

              // 🔹 Row 2
              _buildRow(
                width,
                DashboardCard(
                  name: "Exam",
                  imgpath: "exam.png",
                ),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ExamResult()),
                ),
                DashboardCard(
                  name: "TimeTable",
                  imgpath: "calendar.png",
                ),
                () {},
              ),

              // 🔹 Row 3
              _buildRow(
                width,
                DashboardCard(
                  name: "Library",
                  imgpath: "library.png",
                ),
                () {},
                DashboardCard(
                  name: "Track Bus",
                  imgpath: "bus.png",
                ),
                () {},
              ),

              // 🔹 Row 4
              _buildRow(
                width,
                DashboardCard(
                  name: "Activity",
                  imgpath: "activity.png",
                ),
                () {},
                DashboardCard(
                  name: "Apply Leave",
                  imgpath: "leave_apply.png",
                ),
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => LeaveApply()),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // 🔥 Reusable Row Widget (clean code)
  Widget _buildRow(double width, Widget leftCard, VoidCallback leftTap,
      Widget rightCard, VoidCallback rightTap) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Transform(
            transform: Matrix4.translationValues(
                muchDelayedAnimation.value * width, 0, 0),
            child: Bouncing(onPress: leftTap, child: leftCard),
          ),
          Transform(
            transform:
                Matrix4.translationValues(delayedAnimation.value * width, 0, 0),
            child: Bouncing(onPress: rightTap, child: rightCard),
          ),
        ],
      ),
    );
  }
}
