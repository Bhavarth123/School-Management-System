import 'dart:math';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:school_management/Widgets/AppBar.dart';
import 'package:school_management/Widgets/BouncingButton.dart';
import 'package:school_management/Widgets/Exams/SubjectCard.dart';
import 'package:school_management/Widgets/MainDrawer.dart';

class ExamResult extends StatefulWidget {
  @override
  _ExamResultState createState() => _ExamResultState();
}

class _ExamResultState extends State<ExamResult>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation;
  late AnimationController animationController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final Random random = Random();

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController, curve: Curves.fastOutSlowIn));

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.5, curve: Curves.fastOutSlowIn)));

    muchDelayedAnimation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.3, 0.5, curve: Curves.fastOutSlowIn),
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
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget? child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CommonAppBar(
            menuenabled: true,
            notificationenabled: false,
            title: "Exams",
            ontap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          drawer: Drawer(
            elevation: 0,
            child: MainDrawer(),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 5,
                horizontal: 15,
              ),
              child: Column(
                children: [
                  // 🔹 Header
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Transform(
                          transform: Matrix4.translationValues(
                              muchDelayedAnimation.value * width, 0, 0),
                          child: Text(
                            "Exam Name",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Transform(
                          transform: Matrix4.translationValues(
                              delayedAnimation.value * width, 0, 0),
                          child: Text(
                            "date-15/12/2020",
                            style: TextStyle(fontSize: 11),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: height * 0.02),

                  // 🔹 Dropdown (UPDATED)
                  Transform(
                    transform: Matrix4.translationValues(
                        muchDelayedAnimation.value * width, 0, 0),
                    child: DropdownSearch<String>(
                      items: const [
                        "Quarterly",
                        "Half yearly",
                        "First Revision",
                        "Second Revision",
                        "Third Revision",
                        "Annual Exam"
                      ],
                      onChanged: (value) {},
                      popupProps: PopupProps.menu(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Please Select",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: height * 0.05),

                  // 🔹 Subjects
                  SubjectCard(
                    subjectname: "Language(Tamil)",
                    chapter: "1-5",
                    date: "12/12/2020",
                    grade: "A+",
                    mark: "90",
                    time: "9.00Am-10AM",
                  ),

                  SizedBox(height: 10),

                  SubjectCard(
                    subjectname: "English",
                    chapter: "1-5",
                    date: "13/12/2020",
                    grade: "A+",
                    mark: "85",
                    time: "9.00Am-10AM",
                  ),

                  SizedBox(height: 10),

                  SubjectCard(
                    subjectname: "Maths",
                    chapter: "1-5",
                    date: "14/12/2020",
                    grade: "A+",
                    mark: "100",
                    time: "9.00Am-10AM",
                  ),

                  SizedBox(height: height * 0.05),

                  // 🔹 Total + Grade
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total Marks: 490/500",
                          style: TextStyle(fontSize: 15)),
                      Text("Overall Grade: A+",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                    ],
                  ),

                  SizedBox(height: 10),

                  // 🔹 Result
                  Row(
                    children: [
                      Text("Result: "),
                      Text(
                        "Pass",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  // 🔹 Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Bouncing(
                        onPress: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text("Save",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      Bouncing(
                        onPress: () {},
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text("Share",
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: height * 0.2),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
