// Flutter imports
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Third-party package imports
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Local project imports - Pages
import 'package:nutsnbolts/pages/add_case_page.dart';
import 'package:nutsnbolts/pages/home_page.dart';
import 'package:nutsnbolts/pages/payment_page.dart';
import 'package:nutsnbolts/pages/profile_page.dart';
import 'package:nutsnbolts/pages/technician_page.dart';

// Local project imports - Use cases and utilities
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/utils/constants.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  final user = FirebaseAuth.instance.currentUser;

  static List<IconData> iconList = const [
    Icons.home_outlined,
    Icons.handyman_rounded,
    Icons.attach_money_rounded,
    Icons.person
  ];

  int _bottomNavIndex = 0;

  Widget getPage(int index) {
    if (index == 0) {
      return const HomePage();
    } else if (index == 1) {
      return const TechnicianPage();
    } else if (index == 2) {
      return const PaymentPage();
    } else if (index == 3) {
      return const ProfilePage();
    }
    return const HomePage();
  }

  @override
  void initState() {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    userUsecase.getUser(user!.uid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<UserUsecase>(
      builder: (context, userUsecase, child) {
        return userUsecase.userEntity.uid.isEmpty
            ? Center(
                child: CircularProgressIndicator(
                  color: MyColours.primaryColour,
                ),
              )
            : Scaffold(
                backgroundColor: const Color(0xfff8f9fd),
                body: getPage(_bottomNavIndex),
                floatingActionButton: FloatingActionButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const AddCasePage(),
                    ));
                  },
                  shape: const CircleBorder(),
                  backgroundColor: MyColours.primaryColour,
                  child: const Icon(Icons.add),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerDocked,
                bottomNavigationBar: AnimatedBottomNavigationBar.builder(
                  itemCount: iconList.length,
                  tabBuilder: (int index, bool isActive) {
                    return Icon(
                      iconList[index],
                      size: 24,
                      color: isActive ? MyColours.primaryColour : Colors.grey,
                    );
                  },
                  activeIndex: _bottomNavIndex,
                  gapLocation: GapLocation.center,
                  notchSmoothness: NotchSmoothness.softEdge,
                  leftCornerRadius: 20,
                  rightCornerRadius: 20,
                  onTap: (index) => setState(() => _bottomNavIndex = index),
                ),
              );
      },
    );
  }
}
