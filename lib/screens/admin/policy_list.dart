import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:unicons/unicons.dart';

class PolicyList extends StatefulWidget {
  @override
  _PolicyListState createState() => _PolicyListState();
}

class _PolicyListState extends State<PolicyList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Policy List'),
      ),
      body: StreamBuilder<List<Policy>>(
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
                    print("policy data ${snapshot.data[index]}");
                    return Card(
                      color: Colors.white38,
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    snapshot.data[index].title,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(UniconsLine.edit),
                                        onPressed: () {
                                          Get.toNamed('create-policy', arguments: snapshot.data[index]);
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete_outline),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                              title: Text(
                                                'Are you sure you want to delete this policy?',
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(false),
                                                  child: Text(
                                                    'No',
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    FirebaseApi.deletePolicy(snapshot.data[index]);
                                                  },
                                                  child: Text(
                                                    'Yes',
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      )
                                    ],
                                  )
                                ],
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
                        ),
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
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Get.toNamed('create-policy');
        },
      ),
    );
  }
}
