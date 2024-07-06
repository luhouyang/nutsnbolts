// Flutter imports
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Local project imports - Pages
import 'package:nutsnbolts/pages/route_page.dart';
import 'package:nutsnbolts/utils/constants.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print(e);
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
            body: Center(
              child: Column(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                        color: MyColours.primaryColour,
                        borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(50))),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(25),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          height: 200,
                          child: Image.asset('assets/images/logo.png'),
                        ),
                        Text(
                          'nuts&bolts.',
                          style: TextStyle(
                              color: MyColours.primaryColour,
                              fontFamily: "Poppins",
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Welcome to nuts&bolts, sign in and start generating income by showing off your hands on skills!',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.all(10),
                                foregroundColor: Colors.white,
                                backgroundColor: MyColours.primaryColour,
                                shape: ContinuousRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
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
}
