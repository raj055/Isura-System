import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/api/firebase_api.dart';
import 'package:isura_system/model/policy.dart';
import 'package:isura_system/services/validator_x.dart';
import 'package:isura_system/widget/theme.dart';

class CreatePolicy extends StatefulWidget {
  @override
  _CreatePolicyState createState() => _CreatePolicyState();
}

class _CreatePolicyState extends State<CreatePolicy> {
  final _createPolicyFormKey = GlobalKey<FormState>();

  final namePolicyController = TextEditingController();
  final descriptionPolicyController = TextEditingController();
  final amountPolicyController = TextEditingController();
  final timePolicyController = TextEditingController();
  final interestPolicyController = TextEditingController();
  final payableAmountPolicyController = TextEditingController();

  ValidatorX validator = ValidatorX();

  var policyData;

  @override
  void initState() {
    policyData = Get.arguments;

    if (policyData != null) {
      namePolicyController.text = policyData.title;
      descriptionPolicyController.text = policyData.description;
      amountPolicyController.text = policyData.amount;
      timePolicyController.text = policyData.time;
      interestPolicyController.text = policyData.interest;
      payableAmountPolicyController.text = policyData.payableAmount;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(policyData != null ? 'Edit Policy' : 'Create Policy'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _createPolicyFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter policy name"),
                    controller: namePolicyController,
                    onChanged: (String value) {
                      validator.clearErrorsAt('name');
                    },
                    validator: validator.add(
                      key: 'name',
                      rules: [
                        ValidatorX.mandatory(message: 'policy name field is required'),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter policy description"),
                    controller: descriptionPolicyController,
                    maxLines: 5,
                    onChanged: (String value) {
                      validator.clearErrorsAt('description');
                    },
                    validator: validator.add(
                      key: 'description',
                      rules: [
                        ValidatorX.mandatory(message: 'policy description field is required'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter policy Amount"),
                    controller: amountPolicyController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      validator.clearErrorsAt('amount');
                    },
                    validator: validator.add(
                      key: 'amount',
                      rules: [
                        ValidatorX.mandatory(message: 'policy amount field is required'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter policy time (years)"),
                    controller: timePolicyController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      validator.clearErrorsAt('time');
                    },
                    validator: validator.add(
                      key: 'time',
                      rules: [
                        ValidatorX.mandatory(message: 'policy time field is required'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter policy interest"),
                    controller: interestPolicyController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      validator.clearErrorsAt('interest');
                    },
                    validator: validator.add(
                      key: 'interest',
                      rules: [
                        ValidatorX.mandatory(message: 'policy interest field is required'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: TextFormField(
                    decoration: InputDecoration(hintText: "Enter policy payable amount"),
                    controller: payableAmountPolicyController,
                    keyboardType: TextInputType.number,
                    onChanged: (String value) {
                      validator.clearErrorsAt('payable amount');
                    },
                    validator: validator.add(
                      key: 'payable amount',
                      rules: [
                        ValidatorX.mandatory(message: 'policy payable amount field is required'),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: materialButton(
                    textContent: 'Add Policy'.toUpperCase(),
                    width: double.infinity,
                    onPressed: () {
                      if (_createPolicyFormKey.currentState.validate()) {
                        FocusScope.of(context).requestFocus(FocusNode());

                        final policyCreate = Policy(
                          id: policyData != null ? policyData.id : DateTime.now().toString(),
                          title: namePolicyController.text,
                          description: descriptionPolicyController.text,
                          amount: amountPolicyController.text,
                          time: timePolicyController.text,
                          interest: interestPolicyController.text,
                          payableAmount: payableAmountPolicyController.text,
                        );

                        if (policyData != null) {
                          FirebaseApi.updatePolicy(policyCreate);
                        } else {
                          FirebaseApi.createPolicy(policyCreate);
                        }

                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
