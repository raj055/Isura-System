import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:isura_system/screens/auth/authentications.dart';
import 'package:isura_system/services/validator_x.dart';
import 'package:isura_system/widget/theme.dart';
import 'package:unicons/unicons.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _registerFormKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  ValidatorX validator = ValidatorX();
  bool passwordVisible = true;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Center(
              child: SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(spacing_standard_new),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          logo,
                          width: width / 2.5,
                        ),
                      ),
                      SizedBox(height: 30),
                      Form(
                        key: _registerFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: formField(
                                context,
                                "Name",
                                prefixIcon: Icons.perm_identity,
                                controller: nameController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.text,
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
                              child: formField(
                                context,
                                "Email Id",
                                prefixIcon: Icons.mail_outlined,
                                controller: emailController,
                                textInputAction: TextInputAction.next,
                                keyboardType: TextInputType.emailAddress,
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
                              padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                              child: formField(
                                context,
                                "Password",
                                prefixIcon: UniconsLine.lock,
                                isPassword: true,
                                controller: passwordController,
                                isPasswordVisible: passwordVisible,
                                textInputAction: TextInputAction.done,
                                onChanged: (String value) {
                                  validator.clearErrorsAt('password');
                                },
                                validator: validator.add(
                                  key: 'password',
                                  rules: [
                                    ValidatorX.mandatory(),
                                  ],
                                ),
                                suffixIconSelector: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                                suffixIcon: !passwordVisible ? Icons.visibility : Icons.visibility_off,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: materialButton(
                          textContent: 'Register'.toUpperCase(),
                          width: double.infinity,
                          onPressed: () {
                            if (_registerFormKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(FocusNode());

                              signUp(emailController.text, passwordController.text, context).then((value) {
                                //   final userLoginCreate = LoginUser(
                                //     id: DateTime.now().toString(),
                                //     name: nameController.text,
                                //     email: emailController.text,
                                //     password: passwordController.text,
                                //   );
                                //
                                //   FirebaseApi.loginCreate(userLoginCreate).whenComplete(() =>
                                //     Get.offAllNamed('sign-in')
                                //   );
                                Get.offAllNamed('sign-in');
                              });
                            }
                          },
                        ),
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          text(
                            'You have an account ?',
                            textColor: Colors.black54,
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            child: text(
                              'Login',
                              textColor: Colors.black,
                              fontFamily: fontMedium,
                            ),
                            onTap: () {
                              Get.toNamed('sign-in');
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
