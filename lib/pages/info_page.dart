import 'package:flutter/material.dart';
import 'package:nutsnbolts/utils/constants.dart';
import 'dart:ui' as ui;
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget {
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> launchUrlAsync(String urlString) async {
      final Uri url = Uri.parse(urlString);

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "Nuts & Bolt",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Text(
              "By:\nLu Hou Yang\nLim Jia Chyuen\nAdi Ahmad Danish",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(
              height: 36,
              width: 36,
            ),
            const Text(
              "Visit us at",
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
              width: 8,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: const WidgetStatePropertyAll(Size(240, 40)), backgroundColor: WidgetStatePropertyAll(MyColours.primaryColour)),
              onPressed: () async {
                launchUrlAsync("https://www.luhouyang.com");
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 36, right: 36),
                child: Text(
                  'Lu Hou Yang',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
              width: 16,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: const WidgetStatePropertyAll(Size(240, 40)), backgroundColor: WidgetStatePropertyAll(MyColours.primaryColour)),
              onPressed: () async {
                launchUrlAsync("https://limjiachyuen.com/");
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 36, right: 36),
                child: Text(
                  'Lim Jia Chyuen',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 16,
              width: 16,
            ),
            ElevatedButton(
              style: ButtonStyle(
                  fixedSize: const WidgetStatePropertyAll(Size(240, 40)), backgroundColor: WidgetStatePropertyAll(MyColours.primaryColour)),
              onPressed: () async {
                launchUrlAsync("https://www.linkedin.com/in/adiahmaddanish/");
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 36, right: 36),
                child: Text(
                  'Adi Ahmad Danish',
                  style: TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 24,
              width: 24,
            ),
            const Text(
              "Get the code at: ",
              style: TextStyle(fontSize: 16, color: Colors.black, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 8,
              width: 8,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                  fixedSize: WidgetStatePropertyAll(Size(240, 40)), backgroundColor: WidgetStatePropertyAll(Color.fromARGB(255, 110, 84, 148))),
              onPressed: () async {
                launchUrlAsync("https://github.com/luhouyang/nutsnbolts.git");
              },
              child: const Padding(
                padding: EdgeInsets.only(left: 36, right: 36),
                child: Text(
                  'GitHub',
                  style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(
              height: 64,
              width: 64,
            ),
          ],
        ),
      ),
    );
  }
}
