import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/widget/app_drawer.dart';
import 'package:isura_system/widget/theme.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Insura Consultancy'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _newPolicy(),
            _checkYourPolicy(),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }

  Widget _newPolicy() {
    return Padding(
      padding: const EdgeInsets.all(2.0),
      child: Card(
        elevation: 2.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          width: double.infinity,
          height: 400.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  text(
                    'New Policy',
                    textColor: Colors.black,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed('new-policy');
                    },
                    child: text(
                      'View all',
                      textColor: Colors.black,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Divider(
                height: 2.0,
              ),
              SizedBox(height: 5.0),
              Expanded(
                child: StreamBuilder<List<Policy>>(
                  stream: FirebaseApi.readPolicy(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    return snapshot.data.length > 0
                        ? ListView.builder(
                            itemCount: snapshot.data.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data[index].title,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5.0,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(left: 30.0),
                                          child: Text(
                                            snapshot.data[index].description,
                                            softWrap: true,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        // Get.toNamed('inquiry-policy', arguments: snapshot.data[index]);
                                        Get.toNamed('policy-detail-selection');
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Text('Get Policy'),
                                    ),
                                  ],
                                ),
                              );
                            },
                          )
                        : Center(
                            child: Image.asset(
                              'assets/images/no_result.png',
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            ),
                          );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _checkYourPolicy() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.blue.withOpacity(0.9),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
            onPressed: () {
              Get.toNamed('selected-policy');
              // Get.toNamed('download-pdf');
            },
            child: Text('Check Your Policy'),
          ),
        ),
      ],
    );
  }
}
