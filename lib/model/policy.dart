import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

class LoginUser {
  String name;
  String email;
  String password;
  String id;

  LoginUser({
    @required this.name,
    @required this.email,
    @required this.password,
    this.id,
  });

  static LoginUser fromJson(Map<String, dynamic> json) => LoginUser(
        name: json['name'],
        email: json['email'],
        password: json['password'],
        id: json['id'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'email': email,
        'password': password,
        'id': id,
      };
}

class Policy {
  String title;
  String description;
  String id;
  String amount;
  String time;
  String interest;
  String payableAmount;

  Policy({
    @required this.title,
    @required this.description,
    @required this.amount,
    @required this.time,
    @required this.interest,
    @required this.payableAmount,
    this.id,
  });

  static Policy fromJson(Map<String, dynamic> json) => Policy(
        title: json['title'],
        description: json['description'],
        id: json['id'],
        amount: json['amount'],
        time: json['time'],
        interest: json['interest'],
        payableAmount: json['payableAmount'],
      );

  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'id': id,
        'amount': amount,
        'time': time,
        'interest': interest,
        'payableAmount': payableAmount,
      };
}

class InquiryPolicyModel {
  String id;
  String userId;
  String policyId;
  String policyName;
  String policyDescription;
  String name;
  String email;
  String number;
  String dob;
  String status;
  String pdfLink;

  InquiryPolicyModel({
    @required this.name,
    @required this.number,
    @required this.policyId,
    @required this.userId,
    this.policyName,
    this.policyDescription,
    this.id,
    this.email,
    this.dob,
    this.status,
    this.pdfLink,
  });

  static InquiryPolicyModel fromJson(Map<String, dynamic> json) => InquiryPolicyModel(
        id: json['id'],
        policyId: json['policyId'],
        userId: json['userId'],
        policyName: json['policyName'],
        policyDescription: json['policyDescription'],
        name: json['name'],
        email: json['email'],
        number: json['number'],
        dob: json['dob'],
        status: json['status'],
        pdfLink: json['pdf'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        "userId": userId,
        "policyId": policyId,
        "policyName": policyName,
        "policyDescription": policyDescription,
        'name': name,
        'email': email,
        'number': number,
        'dob': dob,
        'status': status,
        'pdf': pdfLink,
      };
}

class FirebaseFile {
  final Reference ref;
  final String name;
  final String url;

  const FirebaseFile({
    @required this.ref,
    @required this.name,
    @required this.url,
  });
}
