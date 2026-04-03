import 'package:flutter/material.dart';
import 'package:fzregex/utils/fzregex.dart';
import 'package:fzregex/utils/pattern.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✅ added
import 'package:school_management/Widgets/BouncingButton.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword>
    with SingleTickerProviderStateMixin {
  late Animation animation, delayedAnimation, muchDelayedAnimation, leftCurve;
  late AnimationController animationController;

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  bool _autovalidate = false;

  String? _email;
  String? _rollno;

  @override
  void initState() {
    super.initState();

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

  // 🔥 RESET PASSWORD FUNCTION
  Future<void> resetPassword() async {
    try {
      print("EMAIL ENTERED: $_email"); // ✅ debug

      await FirebaseAuth.instance.sendPasswordResetEmail(email: _email!.trim());

      print("RESET EMAIL SENT"); // ✅ debug

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Reset link sent to your email")),
      );
    } on FirebaseAuthException catch (e) {
      String message = "Something went wrong";

      print("ERROR: ${e.code}"); // ✅ debug

      if (e.code == 'user-not-found') {
        message = "No user found with this email";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email address";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      print("ERROR: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error sending email")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Scaffold(
          body: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Transform(
                  transform:
                      Matrix4.translationValues(animation.value * width, 0, 0),
                  child: Center(
                    child: Text(
                      'Forget Password',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Transform(
                  transform:
                      Matrix4.translationValues(leftCurve.value * width, 0, 0),
                  child: Form(
                    key: _formkey,
                    autovalidateMode: _autovalidate
                        ? AutovalidateMode.always
                        : AutovalidateMode.disabled,
                    child: Column(
                      children: [
                        //🔹 Roll Number (optional)
                        TextFormField(
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return "Enter Roll Number";
                            }
                            return null;
                          },
                          onSaved: (val) => _rollno = val,
                          decoration: InputDecoration(
                            labelText: 'Roll Number',
                            border: UnderlineInputBorder(),
                          ),
                        ),

                        SizedBox(height: 20),

                        // 🔹 Email
                        TextFormField(
                          validator: (value) {
                            if (value == null ||
                                !Fzregex.hasMatch(value, FzPattern.email)) {
                              return "Enter valid email";
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            border: UnderlineInputBorder(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Transform(
                  transform: Matrix4.translationValues(
                      muchDelayedAnimation.value * width, 0, 0),
                  child: Bouncing(
                    onPress: () async {
                      if (_formkey.currentState!.validate()) {
                        _formkey.currentState!.save();

                        await resetPassword(); // ✅ call function
                      } else {
                        setState(() {
                          _autovalidate = true;
                        });
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: Text(
                          "Request",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
