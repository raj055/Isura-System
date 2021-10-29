import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/services/utils.dart';
import 'package:path_provider/path_provider.dart';

class FirebaseApi {
  static Future<String> loginCreate(LoginUser loginUser) async {
    final docPolicy = FirebaseFirestore.instance.collection('login').doc();

    loginUser.id = docPolicy.id;
    await docPolicy.set(loginUser.toJson());

    return docPolicy.id;
  }

  static Stream<List<LoginUser>> loginRead() => FirebaseFirestore.instance.collection('login').snapshots().transform(
        Utils.transformer(LoginUser.fromJson),
      );

  static Future<String> createPolicy(Policy policy) async {
    final docPolicy = FirebaseFirestore.instance.collection('policy').doc();

    policy.id = docPolicy.id;
    await docPolicy.set(policy.toJson());

    return docPolicy.id;
  }

  static Stream<List<Policy>> readPolicy() => FirebaseFirestore.instance.collection('policy').snapshots().transform(
        Utils.transformer(Policy.fromJson),
      );

  static Future updatePolicy(Policy policy) async {
    final docPolicy = FirebaseFirestore.instance.collection('policy').doc(policy.id);

    await docPolicy.update(policy.toJson());
  }

  static Future deletePolicy(Policy policy) async {
    final docPolicy = FirebaseFirestore.instance.collection('policy').doc(policy.id);

    await docPolicy.delete();
  }

  static Future<String> createInquiryPolicy(InquiryPolicyModel inquiryPolicy) async {
    final docInquiryPolicy = FirebaseFirestore.instance.collection('inquiryPolicy').doc();

    inquiryPolicy.id = docInquiryPolicy.id;
    await docInquiryPolicy.set(inquiryPolicy.toJson());

    return docInquiryPolicy.id;
  }

  static Stream<List<InquiryPolicyModel>> readInquiryPolicy() =>
      FirebaseFirestore.instance.collection('inquiryPolicy').snapshots().transform(
            Utils.transformer(InquiryPolicyModel.fromJson),
          );

  static Future updateInquiryPolicy(InquiryPolicyModel inquiryPolicyModel) async {
    final docPolicy = FirebaseFirestore.instance.collection('inquiryPolicy').doc(inquiryPolicyModel.id);
    await docPolicy.update(inquiryPolicyModel.toJson());
  }

  static UploadTask uploadFile(String destination, File file) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putFile(file);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static UploadTask uploadBytes(String destination, Uint8List data) {
    try {
      final ref = FirebaseStorage.instance.ref(destination);

      return ref.putData(data);
    } on FirebaseException catch (e) {
      return null;
    }
  }

  static Future<List<String>> _getDownloadLinks(List<Reference> refs) =>
      Future.wait(refs.map((ref) => ref.getDownloadURL()).toList());

  static Future<List<FirebaseFile>> listAll(String path) async {
    final ref = FirebaseStorage.instance.ref(path);
    final result = await ref.listAll();

    final urls = await _getDownloadLinks(result.items);

    return urls
        .asMap()
        .map((index, url) {
          final ref = result.items[index];
          final name = ref.name;
          final file = FirebaseFile(ref: ref, name: name, url: url);

          return MapEntry(index, file);
        })
        .values
        .toList();
  }

  static Future downloadFile(Reference ref) async {
    Directory dir = await getExternalStorageDirectory();
    File file;

    String newPath = "";
    print(dir);
    List<String> paths = dir.path.split("/");
    for (int x = 1; x < paths.length; x++) {
      String folder = paths[x];
      if (folder != "Android") {
        newPath += "/" + folder;
      } else {
        break;
      }
    }

    newPath = newPath + "/insura";
    dir = Directory(newPath);

    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    if (await dir.exists()) {
      file = File('${dir.path}/${ref.name}');
    }

    await ref.writeToFile(file);
  }
}
