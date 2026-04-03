import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'edit_student.dart';

class StudentList extends StatelessWidget {
  const StudentList({Key? key}) : super(key: key);

  Future<void> deleteStudent(String docId, BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(docId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student deleted")),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error deleting student")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Students List"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          // 🔄 Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // ❌ Error
          if (snapshot.hasError) {
            return Center(child: Text("Something went wrong"));
          }

          var docs = snapshot.data!.docs;

          // 🔍 Filter only students
          var students = docs
              .where((doc) => doc['role'].toString().toLowerCase() == 'student')
              .toList();

          if (students.isEmpty) {
            return Center(child: Text("No students found"));
          }

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              var data = students[index];

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(data['name'] ?? "No Name"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Email: ${data['email']}"),
                      Text("Class: ${data['class']}"),
                      Text("Section: ${data['section']}"),
                    ],
                  ),

                  // 🔹 ACTION BUTTONS
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✏️ EDIT
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditStudent(
                                docId: data.id,
                                data: data,
                              ),
                            ),
                          );
                        },
                      ),

                      // ❌ DELETE
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: Text("Delete Student"),
                              content: Text(
                                  "Are you sure you want to delete this student?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                    deleteStudent(data.id, context);
                                  },
                                  child: Text("Delete"),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
