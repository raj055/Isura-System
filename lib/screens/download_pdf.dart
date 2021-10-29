import 'package:flutter/material.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';

class DownloadPDF extends StatefulWidget {
  @override
  _DownloadPDFState createState() => _DownloadPDFState();
}

class _DownloadPDFState extends State<DownloadPDF> {
  Future<List<FirebaseFile>> futureFiles;

  @override
  void initState() {
    _pdfDownload();
    super.initState();
    futureFiles = FirebaseApi.listAll('pdf/');
  }

  bool downloadingInvoice = false;

  String localPath;

  Future _pdfDownload() async {
    _checkPermission().then((hasGranted) async {
      if (hasGranted) {
      } else {
        _checkPermission();
      }
    });
  }

  Future<bool> _checkPermission() async {
    PermissionStatus status = await Permission.storage.status;
    if (await Permission.storage.request().isGranted) {
      if (status.isGranted) {
        return true;
      } else {
        _checkPermission();
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Download Policy'),
      ),
      body: SafeArea(
        child: FutureBuilder<List<FirebaseFile>>(
          future: futureFiles,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError) {
                  return Center(child: Text('Some error occurred!'));
                } else {
                  final files = snapshot.data;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: files.length,
                          itemBuilder: (context, index) {
                            final file = files[index];
                            print("file $file");
                            return buildFile(context, file);
                          },
                        ),
                      ),
                    ],
                  );
                }
            }
          },
        ),
      ),
    );
  }
}

Widget buildFile(BuildContext context, FirebaseFile file) => ListTile(
      title: Text(
        file.name,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.blue,
        ),
      ),
      trailing: GestureDetector(
        onTap: () async {
          await FirebaseApi.downloadFile(file.ref).whenComplete(() {
            final snackBar = SnackBar(
              backgroundColor: Colors.green,
              content: Text('PDF Downloaded in mobile storage'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          });
        },
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.lightBlue.shade100,
            borderRadius: BorderRadius.circular(40),
          ),
          child: Icon(
            UniconsLine.file_download,
            size: 30,
          ),
        ),
      ),
    );
