import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/services/validator_x.dart';
import 'package:isura_system/widget/theme.dart';

class PolicyDetailSelection extends StatefulWidget {
  @override
  _PolicyDetailSelectionState createState() => _PolicyDetailSelectionState();
}

class _PolicyDetailSelectionState extends State<PolicyDetailSelection> {
  ValidatorX validator = ValidatorX();
  String selectPolicyValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Policy Selection'),
      ),
      body: StreamBuilder<List<Policy>>(
        stream: FirebaseApi.readPolicy(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return snapshot.data.length > 0
              ? Column(
                  children: [
                    SizedBox(height: 10.0),
                    selectPolicyDropDown(snapshot.data),
                    if (selectPolicyValue != null) policyDetails(snapshot.data),
                  ],
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

  Widget selectPolicyDropDown(data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: DropdownButtonFormField<String>(
        dropdownColor: app_background,
        validator: validator.add(
          key: 'acceptAppointment',
          rules: [
            ValidatorX.mandatory(message: "Select Accept Appointment"),
          ],
        ),
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          enabledBorder: UnderlineInputBorder(
            borderRadius: BorderRadius.circular(spacing_standard),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
          filled: true,
          fillColor: Colors.blueAccent.withOpacity(0.1),
          hintStyle: TextStyle(
            fontSize: textSizeMedium,
            color: textColorSecondary,
          ),
        ),
        hint: text('Select Policy', textColor: Colors.blueAccent),
        value: selectPolicyValue,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.blueAccent.withOpacity(0.5),
        ),
        iconSize: 30,
        onChanged: (String newValue) {
          setState(() {
            selectPolicyValue = newValue;
          });
        },
        items: data.map<DropdownMenuItem<String>>((contact) {
          return DropdownMenuItem<String>(
            value: contact.id.toString(),
            child: text(contact.title.toString(), textColor: Colors.blueAccent),
          );
        }).toList(),
      ),
    );
  }

  Widget policyDetails(policyData) {
    var selectPolicy;
    policyData.map((policy) {
      if (selectPolicyValue == policy.id.toString()) {
        selectPolicy = policy;
      }
      return selectPolicy;
    }).toList();

    return Container(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Policy Amount : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(" ₹ " + selectPolicy.amount),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Policy Time : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(selectPolicy.time + " Years "),
              ],
            ),
            SizedBox(height: 10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Interest on Policy : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(selectPolicy.interest + " % "),
              ],
            ),
            SizedBox(height: 5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Payable Amount : ",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(" ₹ " + selectPolicy.payableAmount),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('inquiry-policy', arguments: selectPolicy);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              child: Text('Continue Policy'),
            ),
          ],
        ),
      ),
    );
  }
}
