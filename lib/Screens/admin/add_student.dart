import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class AddStudent extends StatefulWidget {
  @override
  _AddStudentState createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();

  String name = "";
  String email = "";
  String password = "";
  String studentClass = "";
  String section = "";

  bool isLoading = false;

  Future<void> addStudent() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => isLoading = true);

    try {
      // 🔥 Create secondary Firebase app (IMPORTANT)
      FirebaseApp tempApp = await Firebase.initializeApp(
        name: 'tempApp',
        options: Firebase.app().options,
      );

      FirebaseAuth tempAuth = FirebaseAuth.instanceFor(app: tempApp);

      // 🔹 Create student account WITHOUT logging out admin
      UserCredential userCredential =
          await tempAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // 🔹 Store in Firestore
      await FirebaseFirestore.instance.collection('users').add({
        'email': email.trim(),
        'name': name,
        'class': studentClass,
        'section': section,
        'role': 'student',
        'uid': userCredential.user!.uid,
      });

      // 🔥 Sign out from temp app (IMPORTANT)
      await tempAuth.signOut();
      await tempApp.delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Student added successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error adding student")),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Student")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Name"),
                validator: (val) => val!.isEmpty ? "Enter name" : null,
                onSaved: (val) => name = val!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                validator: (val) => val!.isEmpty ? "Enter email" : null,
                onSaved: (val) => email = val!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                validator: (val) => val!.length < 6 ? "Min 6 characters" : null,
                onSaved: (val) => password = val!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "Class"),
                onSaved: (val) => studentClass = val!,
              ),
              SizedBox(height: 15),
              TextFormField(
                decoration: InputDecoration(labelText: "Section"),
                onSaved: (val) => section = val!,
              ),
              SizedBox(height: 25),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: addStudent,
                      child: Text("Add Student"),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
