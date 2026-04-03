import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditStudent extends StatefulWidget {
  final String docId;
  final dynamic data;

  EditStudent({required this.docId, required this.data});

  @override
  _EditStudentState createState() => _EditStudentState();
}

class _EditStudentState extends State<EditStudent> {
  late TextEditingController name;
  late TextEditingController className;
  late TextEditingController section;

  @override
  void initState() {
    super.initState();

    name = TextEditingController(text: widget.data['name']);
    className = TextEditingController(text: widget.data['class']);
    section = TextEditingController(text: widget.data['section']);
  }

  Future<void> updateStudent() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.docId)
        .update({
      'name': name.text,
      'class': className.text,
      'section': section.text,
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Student")),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          children: [
            TextField(controller: name),
            TextField(controller: className),
            TextField(controller: section),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: updateStudent,
              child: Text("Update"),
            )
          ],
        ),
      ),
    );
  }
}
