// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:get/get.dart';
import 'package:isura_system/screens/auth/authentications.dart';
import 'package:isura_system/services/auth.dart';
import 'package:isura_system/services/validator_x.dart';
import 'package:isura_system/widget/theme.dart';
import 'package:unicons/unicons.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _loginFormKey = GlobalKey<FormState>();

  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();

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
                        key: _loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                              child: formField(
                                context,
                                "Email Id",
                                prefixIcon: Icons.mail_outlined,
                                controller: emailTextController,
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
                                controller: passwordTextController,
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
                          textContent: 'Login'.toUpperCase(),
                          width: double.infinity,
                          onPressed: () {
                            if (_loginFormKey.currentState.validate()) {
                              FocusScope.of(context).requestFocus(FocusNode());
                              signin(emailTextController.text, passwordTextController.text, context).then((user) async {
                                if (user != null && user.getIdToken() != null) {
                                  Auth.login(userEmail: user.email);
                                  Get.offAllNamed('home');
                                } else {
                                  GetBar(
                                    backgroundColor: Colors.red,
                                    duration: Duration(seconds: 3),
                                    message: "Email id or Password Wrong",
                                  ).show();
                                }
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
                            "Don't have an account ?",
                            textColor: Colors.black54,
                          ),
                          SizedBox(width: 4),
                          GestureDetector(
                            child: text(
                              'Register',
                              textColor: Colors.black,
                              fontFamily: fontMedium,
                            ),
                            onTap: () {
                              Get.toNamed('sign-up');
                            },
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: SignInButton(
                              Buttons.Google,
                              text: "Login with Google",
                              onPressed: () {
                                googleSignIn().whenComplete(() async {
                                  User user = await FirebaseAuth.instance.currentUser;
                                  Auth.login(userEmail: user.email);
                                  Get.offAllNamed('home');
                                });
                              },
                            ),
                          ),
                        ],
                      ),
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
