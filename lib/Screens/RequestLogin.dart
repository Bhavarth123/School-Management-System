import 'package:flutter/material.dart';
import 'package:school_management/Widgets/BouncingButton.dart';

class RequestLogin extends StatefulWidget {
  const RequestLogin({Key? key}) : super(key: key);

  @override
  _RequestLoginState createState() => _RequestLoginState();
}

class _RequestLoginState extends State<RequestLogin>
    with SingleTickerProviderStateMixin {
  late Animation animation;
  late AnimationController animationController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? name;
  String? email;
  String? rollNo;

  @override
  void initState() {
    super.initState();

    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));

    animation = Tween(begin: -1.0, end: 0.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // 👉 Here you can connect Firebase / API later

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Request submitted successfully")),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Request Login ID"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Transform(
              transform:
                  Matrix4.translationValues(animation.value * width, 0, 0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    // 🔹 Name
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Full Name",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter name" : null,
                      onSaved: (val) => name = val,
                    ),

                    SizedBox(height: 15),

                    // 🔹 Email
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) =>
                          val == null || val.isEmpty ? "Enter email" : null,
                      onSaved: (val) => email = val,
                    ),

                    SizedBox(height: 15),

                    // 🔹 Roll Number
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: "Roll Number",
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty
                          ? "Enter roll number"
                          : null,
                      onSaved: (val) => rollNo = val,
                    ),

                    SizedBox(height: 30),

                    // 🔹 Submit Button
                    Bouncing(
                      onPress: _submit,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            "Submit Request",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
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
