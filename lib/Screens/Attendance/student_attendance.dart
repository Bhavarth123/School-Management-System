import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StudentAttendance extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(title: Text("My Attendance")),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('attendance').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          int total = 0;
          int present = 0;

          List docs = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    var dateDoc = docs[index];

                    return FutureBuilder(
                      future: dateDoc.reference
                          .collection('students')
                          .doc(uid)
                          .get(),
                      builder: (context, AsyncSnapshot<DocumentSnapshot> snap) {
                        if (!snap.hasData || !snap.data!.exists) {
                          return SizedBox();
                        }

                        var data = snap.data!;
                        total++;

                        bool isPresent = data['status'] == "present";
                        if (isPresent) present++;

                        return Card(
                          color: isPresent ? Colors.green : Colors.red,
                          child: ListTile(
                            title: Text(
                              "Date: ${dateDoc.id}",
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              isPresent ? "Present" : "Absent",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              // 🔹 Attendance %
              Padding(
                padding: EdgeInsets.all(10),
                child: Text(
                  total == 0
                      ? "Attendance: 0%"
                      : "Attendance: ${(present / total * 100).toStringAsFixed(2)}%",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
