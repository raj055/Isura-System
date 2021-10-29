import 'dart:async';
import 'dart:ui';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/services/auth.dart';
import 'package:isura_system/services/validator_x.dart';
import 'package:isura_system/widget/theme.dart';

class InquiryPolicy extends StatefulWidget {
  @override
  _InquiryPolicyState createState() => _InquiryPolicyState();
}

class _InquiryPolicyState extends State<InquiryPolicy> {
  final _inquiryFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final dobController = TextEditingController();

  ValidatorX validator = ValidatorX();

  DateTime dobValue;

  var inquiryPolicyData;

  final mainReference = FirebaseDatabase.instance.reference();

  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    inquiryPolicyData = Get.arguments;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inquiry Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: buildInquiryForm(context),
        ),
      ),
    );
  }

  Widget buildInquiryForm(BuildContext context) {
    return Form(
      key: _inquiryFormKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Enter your name"),
              controller: nameController,
              onChanged: (String value) {
                validator.clearErrorsAt('name');
              },
              validator: validator.add(
                key: 'name',
                rules: [
                  ValidatorX.mandatory(message: 'name field is required'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Enter your email"),
              controller: emailController,
              onChanged: (String value) {
                validator.clearErrorsAt('email');
              },
              validator: validator.add(
                key: 'email',
                rules: [
                  ValidatorX.mandatory(message: 'email field is required'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: TextFormField(
              decoration: InputDecoration(hintText: "Enter phone number"),
              controller: phoneController,
              keyboardType: TextInputType.number,
              onChanged: (String value) {
                validator.clearErrorsAt('phone');
              },
              validator: validator.add(
                key: 'phone',
                rules: [
                  ValidatorX.mandatory(message: 'phone field is required'),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: formField(
              context,
              "Date Of Birth",
              controller: dobController,
              onChanged: (String value) {
                validator.clearErrorsAt('dob');
              },
              onTap: () {
                _openDatePicker();
              },
              validator: validator.add(
                key: 'dob',
                rules: [
                  ValidatorX.mandatory(message: 'dob field is required'),
                ],
              ),
            ),
          ),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: materialButton(
              textContent: 'Register'.toUpperCase(),
              width: double.infinity,
              onPressed: () {
                if (_inquiryFormKey.currentState.validate()) {
                  FocusScope.of(context).requestFocus(FocusNode());

                  final inquiryPolicyCreate = InquiryPolicyModel(
                    id: DateTime.now().toString(),
                    userId: Auth.userEmail(),
                    policyId: inquiryPolicyData.id,
                    policyName: inquiryPolicyData.title,
                    policyDescription: inquiryPolicyData.description,
                    name: nameController.text,
                    email: emailController.text,
                    number: phoneController.text,
                    dob: dobController.text,
                    status: "Pending",
                    pdfLink: "",
                  );

                  FirebaseApi.createInquiryPolicy(inquiryPolicyCreate).whenComplete(() => Get.toNamed('download-pdf'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _openDatePicker() {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            headerColor: Colors.blue.withOpacity(0.8),
            backgroundColor: app_background,
            itemStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
            doneStyle: TextStyle(color: Colors.black, fontSize: 16)),
        onChanged: (date) {}, onConfirm: (date) {
      setState(() {
        dobValue = date;
        dobController.text = _formatDate(dobValue.toString());
      });
    }, currentTime: dobValue ?? DateTime.now(), locale: LocaleType.en);
  }

  String _formatDate(String date) {
    final DateTime now = DateTime.parse(date.split(' ').first.split('-').join());
    print(now);
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    return formatted;
  }
}
