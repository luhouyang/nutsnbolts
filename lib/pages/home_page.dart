import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/services/location_service.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/utils/constants.dart';
import 'package:nutsnbolts/widgets/case_card.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final StreamController<void> _rebuildStream = StreamController.broadcast();
  FlutterMap? map;

  @override
  void initState() {
    _getMap(); // initialize data
    super.initState();
  }

  @override
  void dispose() {
    _rebuildStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _rebuildStream.add(null);
    });

    return Consumer<UserUsecase>(
      builder: (context, userUsecase, child) {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 25),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.amber,
                    Colors.amber[800]!,
                  ],
                )),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "nuts&bolts.",
                              style: TextStyle(fontFamily: "Poppins", color: MyColours.secondaryColour, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Welcome, ${user!.displayName}!",
                              style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 18, fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        // Container(
                        //   padding: const EdgeInsets.all(10),
                        //   decoration: BoxDecoration(color: MyColours.secondaryColour, borderRadius: BorderRadius.circular(50)),
                        //   child: Icon(
                        //     Icons.person,
                        //     color: MyColours.primaryColour,
                        //   ),
                        // )
                        SizedBox(
                          height: 50,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.network(user.photoURL!),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.all(20),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: MyColours.secondaryColour,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Want something fixed?",
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Text(
                            "Get a technician now!",
                            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: map ??
                    LoadingAnimationWidget.beat(
                      size: 60,
                      color: Colors.amber,
                    ),
              ),
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('cases')
                    .where("clientId", isEqualTo: userUsecase.userEntity.uid)
                    .orderBy('casePosted', descending: true)
                    .limit(5)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                    return Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 3,
                        ),
                        CircularProgressIndicator(
                          color: MyColours.primaryColour,
                        ),
                      ],
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.fromLTRB(25, 10, 25, 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Your Cases",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!.size,
                          itemBuilder: (context, index) {
                            CaseEntity caseEntity = CaseEntity.from(snapshot.data!.docs[index].data());
                            return CaseCard(caseEntity: caseEntity);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  _getMap() async {
    // get geo location
    LocationData location = await LocationService().getLiveLocation();
    if (!mounted) return;
    setState(() {
      // create hybrid map
      map = FlutterMap(
        options: MapOptions(
          initialCenter: LatLng(location.latitude!, location.longitude!),
          initialZoom: 18.0,
        ),
        children: [
          TileLayer(retinaMode: true, urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", subdomains: ['a', 'b', 'c']),
          // live location, orientation tracker
          currerntLocationandOrientation()
        ],
      );
    });
  }

  Widget currerntLocationandOrientation() {
    return CurrentLocationLayer(
      alignPositionOnUpdate: AlignOnUpdate.always,
      alignDirectionOnUpdate: AlignOnUpdate.never,
      style: const LocationMarkerStyle(
        marker: DefaultLocationMarker(
          child: Icon(
            Icons.navigation,
            color: Colors.white,
          ),
        ),
        markerSize: Size(30, 30),
        markerDirection: MarkerDirection.heading,
      ),
    );
  }
}
