import 'package:flutter/material.dart';

class OverallAttendanceCard extends StatefulWidget {
  final String date;
  final String day;
  final bool firsthalf;
  final bool secondhalf;

  const OverallAttendanceCard({
    Key? key,
    required this.date,
    required this.day,
    required this.firsthalf,
    required this.secondhalf,
  }) : super(key: key);

  @override
  _OverallAttendanceCardState createState() => _OverallAttendanceCardState();
}

class _OverallAttendanceCardState extends State<OverallAttendanceCard>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation;
  late AnimationController animationController;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.6, curve: Curves.fastOutSlowIn),
      ),
    );

    animationController.forward(); // ✅ moved here
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
        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Transform(
            transform:
                Matrix4.translationValues(delayedAnimation.value * width, 0, 0),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    offset: Offset(0, 3),
                    blurRadius: 5,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 🔹 Date + Day
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        widget.date,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        widget.day,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  // 🔹 Labels
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Morning Half",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Afternoon Half",
                        style: TextStyle(fontSize: 13),
                      ),
                    ],
                  ),

                  // 🔹 First Half
                  _statusCircle(widget.firsthalf),

                  // 🔹 Second Half
                  _statusCircle(widget.secondhalf),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // 🔥 Reusable widget
  Widget _statusCircle(bool status) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status ? Colors.green : Colors.red,
      ),
      child: Text(
        status ? "P" : "A",
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
