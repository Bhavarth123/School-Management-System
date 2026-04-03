import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

// ✅ Admin Screens
import 'package:school_management/Screens/admin/add_attendance.dart';
import 'package:school_management/Screens/Admin/add_student.dart';
import 'package:school_management/Screens/Admin/student_list.dart';
import 'package:school_management/Screens/Exam/Exam_Rseult.dart';
// ✅ Other Screens
import 'package:school_management/Screens/Fees/fees_screen.dart';
import 'package:school_management/Screens/LoginPage.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  // 🔥 Logout Function
  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => MyHomePage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => logout(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            // 🔹 Add Student
            _buildCard(
              context,
              "Add Student",
              Icons.person_add,
              Colors.blue,
              AddStudent(),
            ),

            // 🔹 View Students
            _buildCard(
              context,
              "View Students",
              Icons.people,
              Colors.green,
              const StudentList(),
            ),

            // 🔹 Generate Result
            _buildCard(
              context,
              "Generate Result",
              Icons.school,
              Colors.orange,
              ExamResult(),
            ),

            // 🔹 Fees
            _buildCard(
              context,
              "Fees Payment",
              Icons.payment,
              Colors.purple,
              FeesScreen(),
            ),

            //attendance
            _buildCard(
              context,
              "Add Attendance",
              Icons.check,
              Colors.teal,
              AddAttendance(),
            ),
          ],
        ),
      ),
    );
  }

  // 🔹 Dashboard Card Widget
  Widget _buildCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    Widget page,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
