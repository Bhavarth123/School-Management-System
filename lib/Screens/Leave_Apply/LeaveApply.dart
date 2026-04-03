import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

import 'package:school_management/Widgets/AppBar.dart';
import 'package:school_management/Widgets/BouncingButton.dart';
import 'package:school_management/Widgets/LeaveApply/LeaveHistoryCard.dart';
import 'package:school_management/Widgets/LeaveApply/datepicker.dart';
import 'package:school_management/Widgets/MainDrawer.dart';

class LeaveApply extends StatefulWidget {
  @override
  _LeaveApplyState createState() => _LeaveApplyState();
}

class _LeaveApplyState extends State<LeaveApply>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation;
  late AnimationController animationController;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  final searchFieldController = TextEditingController();

  late TextEditingController _applyleavecontroller;
  late TextEditingController _fromcontroller;
  late TextEditingController _tocontroller;

  String _applyleavevalueChanged = '';
  String _fromvalueChanged = '';
  String _tovalueChanged = '';

  @override
  void initState() {
    super.initState();

    _applyleavecontroller =
        TextEditingController(text: DateTime.now().toString());
    _fromcontroller = TextEditingController(text: DateTime.now().toString());
    _tocontroller = TextEditingController(text: DateTime.now().toString());

    animationController =
        AnimationController(duration: Duration(seconds: 3), vsync: this);

    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.fastOutSlowIn),
    );

    delayedAnimation = Tween(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(0.2, 0.5, curve: Curves.fastOutSlowIn),
      ),
    );

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
    _applyleavecontroller.dispose();
    _fromcontroller.dispose();
    _tocontroller.dispose();
    searchFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Scaffold(
          key: _scaffoldKey,
          appBar: CommonAppBar(
            menuenabled: true,
            notificationenabled: false,
            title: "Apply Leave",
            ontap: () {
              _scaffoldKey.currentState?.openDrawer();
            },
          ),
          drawer: Drawer(
            child: MainDrawer(),
          ),
          body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Divider(color: Colors.black54),

                    SizedBox(height: height * 0.05),

                    // 🔹 Apply Leave Date
                    Text("Apply Leave Date",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    SizedBox(height: 10),

                    DateTimePicker(
                      type: DateTimePickerType.date,
                      controller: _applyleavecontroller,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                      onChanged: (val) =>
                          setState(() => _applyleavevalueChanged = val),
                    ),

                    SizedBox(height: height * 0.03),

                    // 🔹 Dropdown FIXED
                    DropdownSearch<String>(
                      items: const [
                        "Medical",
                        "Family",
                        "Sick",
                        "Function",
                        "Others"
                      ],
                      onChanged: (value) {},
                      popupProps: PopupProps.menu(),
                      dropdownDecoratorProps: DropDownDecoratorProps(
                        dropdownSearchDecoration: InputDecoration(
                          hintText: "Select Leave Type",
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    // 🔹 Date Range
                    Row(
                      children: [
                        Expanded(
                          child: CustomDatePicker(
                            controller: _fromcontroller,
                            title: "From",
                            onchanged: (val) =>
                                setState(() => _fromvalueChanged = val),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: CustomDatePicker(
                            controller: _tocontroller,
                            title: "To",
                            onchanged: (val) =>
                                setState(() => _tovalueChanged = val),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: height * 0.05),

                    // 🔹 Reason
                    Text("Reason",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    SizedBox(height: 10),

                    TextFormField(
                      controller: searchFieldController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Enter reason",
                      ),
                    ),

                    SizedBox(height: height * 0.05),

                    // 🔹 Button
                    Bouncing(
                      onPress: () {},
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Request Leave",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 20),

                    // 🔹 History
                    Text("Leave History",
                        style: TextStyle(fontWeight: FontWeight.bold)),

                    SizedBox(height: 10),

                    LeaveHistoryCard(
                      reason: "Sample reason",
                      enddate: "12.12.2020",
                      startdate: "11.12.2020",
                      status: "Approved",
                      adate: "05.12.2020",
                    ),

                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
