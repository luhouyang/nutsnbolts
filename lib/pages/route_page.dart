import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:nutsnbolts/pages/home_page.dart';
import 'package:nutsnbolts/pages/payment_page.dart';
import 'package:nutsnbolts/pages/profile_page.dart';
import 'package:nutsnbolts/pages/technician_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  static List<IconData> iconList = const [
    Icons.home_outlined,
    Icons.handyman_rounded,
    Icons.attach_money_rounded,
    Icons.person
  ];

  int _bottomNavIndex = 0;

  Widget getPage(int idx) {
    if (idx == 0) {
      return const HomePage();
    } else if (idx == 1) {
      return const TechnicianPage();
    } else if (idx == 2) {
      return const PaymentPage();
    } else if (idx == 3) {
      return const ProfilePage();
    }
    return const HomePage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getPage(_bottomNavIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        shape: const CircleBorder(),
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: AnimatedBottomNavigationBar.builder(
        itemCount: iconList.length,
        tabBuilder: (int index, bool isActive) {
          return Icon(
            iconList[index],
            size: 24,
            color: isActive ? Colors.amber : Colors.grey,
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
  }
}
