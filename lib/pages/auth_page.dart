// Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Local project imports - Pages
import 'package:nutsnbolts/pages/route_page.dart';
import 'package:nutsnbolts/utils/constants.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  TextEditingController inEmailTextController = TextEditingController();
  TextEditingController inPassTextController = TextEditingController();

  TextEditingController upEmailTextController = TextEditingController();
  TextEditingController upPassTextController = TextEditingController();
  TextEditingController userNameTextController = TextEditingController();

  bool _isSignIn = true;

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            body: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    decoration:
                        BoxDecoration(color: MyColours.primaryColour, borderRadius: const BorderRadius.only(bottomRight: Radius.circular(50))),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        Text(
                          'nuts&bolts.',
                          style: TextStyle(color: MyColours.primaryColour, fontFamily: "Poppins", fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Welcome to nuts&bolts, sign in and start generating income by showing off your hands on skills!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                foregroundColor: Colors.white,
                                backgroundColor: MyColours.primaryColour,
                                shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                            onPressed: () async {
                              User? user = await _signInWithGoogle();
                              if (user != null) {
                                // User successfully signed in
                                // You can navigate to another screen if necessary
                              }
                            },
                            child: const Text(
                              'Sign in with Google',
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Divider(color: Colors.black, thickness: 1.5, height: 3.0),
                        const SizedBox(height: 10),
                        _isSignIn
                            ? Column(
                                children: [
                                  inputTextWidget("email", emailVerify, inEmailTextController),
                                  inputTextWidget("password", passwordVerify, inPassTextController),
                                  forgotPasswordWidget(),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.all(10),
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: MyColours.primaryColour,
                                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              onPressed: () async {
                                                await signIn(context, inEmailTextController.text.trim(), inPassTextController.text.trim());
                                              },
                                              child: const Text(
                                                "SIGN IN",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.black, thickness: 1.5, height: 3.0),
                                  createNewAccountText(),
                                ],
                              )
                            : Column(
                                children: [
                                  inputTextWidget("email", emailVerify, upEmailTextController),
                                  inputTextWidget("password", passwordVerify, upPassTextController),
                                  inputTextWidget("username", usernameVerify, userNameTextController),
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                            padding: const EdgeInsets.fromLTRB(0, 24, 0, 16),
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.all(10),
                                                  foregroundColor: Colors.white,
                                                  backgroundColor: MyColours.primaryColour,
                                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                                              onPressed: () async {
                                                await signUp(context, upEmailTextController.text.trim(), upPassTextController.text.trim(),
                                                    userNameTextController.text);
                                              },
                                              child: const Text(
                                                "SIGN UP",
                                                style: TextStyle(fontSize: 20),
                                              ),
                                            )),
                                      ),
                                    ],
                                  ),
                                  const Divider(color: Colors.black, thickness: 1.5, height: 3.0),
                                  loginWithAccountText(),
                                ],
                              ),
                        const Text(
                          'By signing in, you agree to our terms and conditions.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return const RoutePage();
      },
    );
  }

  Future<void> signUp(BuildContext context, String email, String password, String username) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      debugPrint("SIGNING UP");
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during create user: $e");
      showErrorBanner("Error during create user: $e");
    }
  }

  Future<void> signIn(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      debugPrint("SIGNING IN");
    } catch (e) {
      // Handle authentication exceptions
      debugPrint("Error during sign-in: $e");
      showErrorBanner("Error during sign-in: $e");
    }
  }

  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } catch (e) {
      // Handle exceptions
      debugPrint("Error during send reset email: $e");
      showErrorBanner("Error during send reset email: $e");
    }
  }

  void showErrorBanner(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.transparent,
        content: Dialog(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(msg),
          ),
        )));
  }

  String emailVerify(value) {
    return EmailValidator.validate(value ?? "") ? "" : "Please enter a valid email";
  }

  String passwordVerify(value) {
    return value != null ? "" : "Please enter a valid password";
  }

  String usernameVerify(value) {
    return value != null ? "" : "Please enter a valid username";
  }

  Widget inputTextWidget(String hint, Function validator, TextEditingController controller) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
        child: TextFormField(
          validator: (value) => validator(value),
          controller: controller,
          style: const TextStyle(color: Colors.black),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.amber[50],
            hintText: hint,
            hintStyle: const TextStyle(fontSize: 16, color: Colors.black),
            border: const UnderlineInputBorder(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(20)),
              borderSide: BorderSide(
                color: Colors.black,
              ),
            ),
            focusColor: Colors.black,
          ),
        ));
  }

  Widget forgotPasswordWidget() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RichText(
              text: TextSpan(
                  text: "forgot password?",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      if (inEmailTextController.text.isNotEmpty) {
                        forgotPassword(context, inEmailTextController.text);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.blue[200],
                            duration: const Duration(milliseconds: 700),
                            content: const Text(
                              "Enter your email",
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                        );
                      }
                    }))
        ],
      ),
    );
  }

  Widget createNewAccountText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: RichText(
          text: TextSpan(style: const TextStyle(fontSize: 16), children: <TextSpan>[
        const TextSpan(text: "Create a new account ", style: TextStyle(color: Colors.black)),
        TextSpan(
            text: "Here",
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _isSignIn = !_isSignIn;
                setState(() {});
              })
      ])),
    );
  }

  Widget loginWithAccountText() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      child: RichText(
          text: TextSpan(style: const TextStyle(fontSize: 16), children: <TextSpan>[
        const TextSpan(text: "Already have an account? ", style: TextStyle(color: Colors.black)),
        TextSpan(
            text: "Login",
            style: const TextStyle(color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                _isSignIn = !_isSignIn;
                setState(() {});
              })
      ])),
    );
  }
}
