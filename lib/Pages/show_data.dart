import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:terra_shifter/Pages/home_screen.dart';

class ShowData extends StatefulWidget {
  const ShowData({super.key});
  @override
  State<ShowData> createState() => _PhoneAuth();
}

class _PhoneAuth extends State<ShowData> {
  var otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Otp'),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection("Customer").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Show loading indicator while data is loading
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // Show error if there's an issue with the stream
                return Center(
                  child: Text("Error: ${snapshot.error}"),
                );
              } else if (snapshot.hasData) {
                // Show the data when it's available
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text('${index + 1}'),
                      ),
                      title: Text('${snapshot.data!.docs[index]["name"]}'),
                      subtitle:
                          Text('${snapshot.data!.docs[index]["contact"]}'),
                    );
                  },
                );
              } else {
                // Handle the case when there is no data
                return Center(child: Text("No data available"));
              }
            }));
  }
}
