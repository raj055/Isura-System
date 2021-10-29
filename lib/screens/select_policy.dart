import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/services/auth.dart';

class SelectPolicy extends StatefulWidget {
  @override
  _SelectPolicyState createState() => _SelectPolicyState();
}

class _SelectPolicyState extends State<SelectPolicy> {
  List policyList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selected Policy'),
      ),
      body: StreamBuilder<List<InquiryPolicyModel>>(
        stream: FirebaseApi.readInquiryPolicy(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          Map data;
          policyList = snapshot.data
              .map((e) {
                if (e.userId == Auth.userEmail()) {
                  data = {
                    "policyName": e.policyName,
                    "policyId": e.policyId,
                    "policyDescription": e.policyDescription,
                    "name": e.name,
                    "email": e.email,
                    "userId": e.userId,
                    "status": e.status,
                    "pdfLink": e.pdfLink,
                    "dob": e.dob,
                    "number": e.number,
                    "id": e.id,
                  };
                }
                return data;
              })
              .where((element) => element != null)
              .toList();

          return policyList.length > 0
              ? ListView.builder(
                  itemCount: policyList.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
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
                                    policyList[index]["policyName"] ?? "",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.lightBlue, width: 2),
                                        borderRadius: BorderRadius.all(Radius.circular(10))),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                                      child: Text(policyList[index]["status"] == "Success" ? "Success" : "Pending"),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5.0,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 30.0),
                                    child: Text(
                                      policyList[index]["policyDescription"] ?? "",
                                      softWrap: true,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (policyList[index]["pdfLink"] == "")
                                    ElevatedButton(
                                      onPressed: () {
                                        Get.toNamed(
                                          'submit-policy',
                                          arguments: policyList[index],
                                        ).then((value) {
                                          setState(() {
                                            FirebaseApi.readInquiryPolicy();
                                          });
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      child: Text('Submit Details'),
                                    ),
                                ],
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
    );
  }
}
