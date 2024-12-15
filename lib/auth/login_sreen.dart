import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../ui/home_screen.dart';
import 'auth_service.dart';
import 'otp_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = AuthService();
  final _storage = GetStorage();
  bool showfield = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  final phoneController = TextEditingController();

  bool isloading = false;
  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/firebaseimage.png"),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Colors.blue),
                  child: GestureDetector(
                    onTap: () async {
                      await _auth.loginWithGoogle().then(
                        (value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ));
                        },
                      );
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.white,
                        backgroundImage:
                            AssetImage("assets/images/googleimage.jpg"),
                      ),
                      title: Text(
                        "Google",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                const SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Colors.green),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showfield = !showfield;
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.phone,
                        color: Colors.white,
                        size: 25,
                      ),
                      title: Text(
                        "Phone",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Visibility(
                    visible: !showfield,
                    child: Text("tab phone button to enter phone number")),
                const SizedBox(height: 5),
                Visibility(
                    visible: showfield,
                    child: Text("enter +91 89079 81560 and otp : 123456")),
                const SizedBox(height: 5),
                Visibility(
                  visible: showfield,
                  child: TextField(
                    keyboardType: TextInputType.phone,
                    controller: phoneController,
                    decoration: InputDecoration(
                        fillColor: Colors.grey.withOpacity(0.25),
                        filled: true,
                        hintText: "Phone number",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide.none)),
                  ),
                ),
                const SizedBox(height: 20),
                Visibility(
                  visible: showfield,
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          isloading = true;
                        });

                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneController.text,
                          verificationCompleted: (phoneAuthCredential) {},
                          verificationFailed: (error) {
                            log(error.toString());
                          },
                          codeSent: (verificationId, forceResendingToken) {
                            setState(() {
                              isloading = false;
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OTPScreen(
                                  verificationId: verificationId,
                                ),
                              ),
                            );

                            // Save phone number as username and dummy email
                            _storage.write('username',
                                phoneController.text); // Save phone number
                            _storage.write('useremail',
                                "dummyeamil@gmail.com"); // Save dummy email
                          },
                          codeAutoRetrievalTimeout: (verificationId) {
                            log("Auto Retrieval timeout");
                          },
                        );
                      },
                      child: isloading
                          ? const CircularProgressIndicator()
                          : Text(
                              "Sign in",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
