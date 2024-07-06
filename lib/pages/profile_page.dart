import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:nutsnbolts/utils/constants.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(25, 50, 25, 15),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.amber,
                  Colors.amber[800]!,
                ],
              ),
            ),
            child: Text(
              "Profile Page",
              style: TextStyle(
                  color: MyColours.secondaryColour,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height / 5,
          ),
          Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                const ProfileWidget(),
                const SizedBox(height: 10),
                UserNameWidget(),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    child: const Text(
                      "Log Out",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return CircleAvatar(
      radius: 50,
      backgroundImage: NetworkImage(user?.photoURL ?? ''),
    );
  }
}

class UserNameWidget extends StatelessWidget {
  const UserNameWidget({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Text(
      user?.displayName ?? '',
      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    );
  }
}
