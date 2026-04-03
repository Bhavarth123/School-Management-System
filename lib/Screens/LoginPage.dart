import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fzregex/utils/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:school_management/Screens/home.dart';
import 'package:school_management/Screens/admin/admin_dashboard.dart';
import 'package:school_management/Widgets/BouncingButton.dart';

// ✅ FIXED IMPORTS
import 'package:school_management/Screens/ForgetPassword.dart';
import 'package:school_management/Screens/RequestLogin.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _autoValidate = false;
  bool passshow = false;

  String? _email;
  String? _pass;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 2), vsync: this);
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  // 🔥 FINAL LOGIN FUNCTION (UID BASED)
  Future<void> _login() async {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();

      try {
        // 🔹 Firebase Login
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: _email!.trim(),
          password: _pass!.trim(),
        );

        User? user = userCredential.user;

        print("UID: ${user!.uid}");

        // 🔥 FETCH USER USING UID (BEST METHOD)
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user!.email)
            .get();

        if (snapshot.docs.isEmpty) {
          throw Exception("User not found");
        }

        var data = snapshot.docs[0].data();

        print("USER DATA: $data");

        String role = data['role'].toString().toLowerCase();

        // 🔹 REDIRECT BASED ON ROLE
        if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminDashboard()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Home()),
          );
        }
      } on FirebaseAuthException catch (e) {
        String message = "Login failed";

        if (e.code == 'user-not-found') {
          message = "User not found";
        } else if (e.code == 'wrong-password') {
          message = "Wrong password";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        print("ERROR: $e");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User data not found")),
        );
      }
    } else {
      setState(() {
        _autoValidate = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          SizedBox(height: 50),

          Center(
            child: Text(
              "Login",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),

          SizedBox(height: 30),

          Form(
            key: _formkey,
            autovalidateMode: _autoValidate
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                // 🔹 EMAIL
                TextFormField(
                  validator: (value) {
                    if (value == null ||
                        !Fzregex.hasMatch(value, FzPattern.email)) {
                      return "Enter valid email";
                    }
                    return null;
                  },
                  onSaved: (value) => _email = value,
                  decoration: InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),

                // 🔹 PASSWORD
                TextFormField(
                  obscureText: !passshow,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Enter password";
                    }
                    return null;
                  },
                  onSaved: (value) => _pass = value,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                          passshow ? Icons.visibility : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passshow = !passshow;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 20),

          // 🔹 FORGOT PASSWORD
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              child: Text("Forgot password?"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ForgetPassword()),
                );
              },
            ),
          ),

          SizedBox(height: 20),

          // 🔹 LOGIN BUTTON
          Bouncing(
            onPress: _login,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),

          SizedBox(height: 15),

          // 🔹 REQUEST LOGIN
          Bouncing(
            onPress: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RequestLogin()),
              );
            },
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: Text("Request Login ID"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
