import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/services/auth.dart';
import 'package:isura_system/widget/theme.dart';
import 'package:path/path.dart';

class SubmitPolicy extends StatefulWidget {
  @override
  _SubmitPolicyState createState() => _SubmitPolicyState();
}

class _SubmitPolicyState extends State<SubmitPolicy> {
  var policyDetails;

  UploadTask task;
  File file;
  bool uploading = false;
  String progressString = "";

  @override
  void initState() {
    policyDetails = Get.arguments;
    super.initState();
  }

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;
    final path = result.files.single.path;

    setState(() => file = File(path));
  }

  Future uploadFile() async {
    if (file == null) return;

    final fileName = basename(file.path);
    final destination = 'files/$fileName';

    task = FirebaseApi.uploadFile(destination, file);
    setState(() {});

    if (task == null) return;

    final snapshot = await task.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();

    print('Download-Link: $urlDownload');
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );

  @override
  Widget build(BuildContext context) {
    final fileName = file != null ? basename(file.path) : 'No File Selected';

    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Policy'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildPolicyDetails(),
            SizedBox(height: 15),
            _buildSubmitData(fileName),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        child: materialButton(
          textContent: 'Submit'.toUpperCase(),
          onPressed: () {
            if (fileName != null) {
              uploadFile().whenComplete(() {
                final inquiryPolicyUpdate = InquiryPolicyModel(
                  id: policyDetails['id'],
                  userId: Auth.userEmail(),
                  policyId: policyDetails['policyId'],
                  policyName: policyDetails['policyName'],
                  policyDescription: policyDetails['policyDescription'],
                  name: policyDetails['name'],
                  email: policyDetails['email'],
                  number: policyDetails['number'],
                  dob: policyDetails['dob'],
                  status: "Success",
                  pdfLink: fileName,
                );

                FirebaseApi.updateInquiryPolicy(inquiryPolicyUpdate);

                Get.back();
              });
            } else {
              GetBar(
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
                message: "please select upload file",
              ).show();
            }
          },
        ),
      ),
    );
  }

  Widget _buildPolicyDetails() {
    return Container(
      color: Colors.blueAccent.withOpacity(0.3),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                text(
                  'Client Policy Details',
                  textColor: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue.withOpacity(0.6), width: 2),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                    child: Text(
                      policyDetails['status'],
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Column(
              children: [
                Row(
                  children: [
                    text('Policy Name', textColor: Colors.black54),
                    SizedBox(width: 15),
                    Text(
                      policyDetails['policyName'],
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 5.0),
                Divider(height: 2.0),
                SizedBox(height: 5.0),
                Row(
                  children: [
                    text('Client Name', textColor: Colors.black54),
                    SizedBox(width: 15),
                    Text(
                      policyDetails['name'],
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    text('Client email', textColor: Colors.black54),
                    SizedBox(width: 15),
                    Text(
                      policyDetails['email'],
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    text('Client Date of Birth', textColor: Colors.black54),
                    SizedBox(width: 15),
                    Text(
                      policyDetails['dob'],
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                Row(
                  children: [
                    text('Client Mobile No', textColor: Colors.black54),
                    SizedBox(width: 15),
                    Text(
                      policyDetails['number'],
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitData(fileName) {
    return Column(
      children: [
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            selectFile();
          },
          child: Container(
            width: 200,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Center(
              child: Text(
                'Select File',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.0,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 20),
        Text(fileName),
      ],
    );
  }
}
