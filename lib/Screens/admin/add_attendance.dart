import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddAttendance extends StatefulWidget {
  @override
  _AddAttendanceState createState() => _AddAttendanceState();
}

class _AddAttendanceState extends State<AddAttendance> {
  String selectedClass = "10";
  String selectedDivision = "A";
  String selectedSubject = "Maths";

  List<DocumentSnapshot> students = [];
  Map<String, bool> attendance = {};

  final List<String> classes = ["10", "11", "12"];
  final List<String> divisions = ["A", "B", "C"];
  final List<String> subjects = ["Maths", "Science", "English"];

  // 🔥 Fetch Students
  Future<void> fetchStudents() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('class', isEqualTo: selectedClass)
        .where('section', isEqualTo: selectedDivision)
        .get();

    students = snapshot.docs;

    attendance.clear();
    for (var doc in students) {
      attendance[doc.id] = false; // default absent
    }

    setState(() {});
  }

  // 🔥 Toggle Present/Absent
  void toggleAttendance(String uid) {
    setState(() {
      attendance[uid] = !(attendance[uid] ?? false);
    });
  }

  // 🔥 Save Attendance (ONLY when button clicked)
  Future<void> saveAttendance() async {
    String today = DateTime.now().toString().split(" ")[0];

    for (var doc in students) {
      await FirebaseFirestore.instance
          .collection('attendance')
          .doc(today)
          .collection('students')
          .doc(doc.id)
          .set({
        'name': doc['name'],
        'status': attendance[doc.id]! ? "present" : "absent",
        'class': selectedClass,
        'division': selectedDivision,
        'subject': selectedSubject, // 🔥 NEW
        'date': today,
      });
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Attendance Submitted ✅")),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Attendance")),
      body: Column(
        children: [
          // 🔹 FILTER SECTION
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedClass,
                        items: classes
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          selectedClass = val.toString();
                          fetchStudents();
                        },
                        decoration: InputDecoration(labelText: "Class"),
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: DropdownButtonFormField(
                        value: selectedDivision,
                        items: divisions
                            .map((e) =>
                                DropdownMenuItem(value: e, child: Text(e)))
                            .toList(),
                        onChanged: (val) {
                          selectedDivision = val.toString();
                          fetchStudents();
                        },
                        decoration: InputDecoration(labelText: "Division"),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 10),

                // 🔥 SUBJECT DROPDOWN
                DropdownButtonFormField(
                  value: selectedSubject,
                  items: subjects
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) {
                    selectedSubject = val.toString();
                  },
                  decoration: InputDecoration(labelText: "Subject"),
                ),
              ],
            ),
          ),

          // 🔹 STUDENT LIST
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                var student = students[index];
                bool isPresent = attendance[student.id] ?? false;

                return GestureDetector(
                  onTap: () => toggleAttendance(student.id),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: isPresent ? Colors.green : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          student['name'],
                          style: TextStyle(
                            color: isPresent ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          isPresent ? Icons.check : Icons.close,
                          color: isPresent ? Colors.white : Colors.black,
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 🔥 SUBMIT BUTTON
          Padding(
            padding: const EdgeInsets.all(10),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.blue,
              ),
              onPressed: saveAttendance,
              child: Text(
                "Submit Attendance",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}
