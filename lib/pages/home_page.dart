// Dart imports
import 'dart:async';

// Flutter imports
import 'package:flutter/material.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/widgets/my_money_field.dart';
import 'package:provider/provider.dart';

// Third-party package imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:location/location.dart';

// Local project imports - Entities, services, use cases, utils, widgets
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/services/location_service.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/utils/constants.dart';
import 'package:nutsnbolts/widgets/case_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController moneyController = TextEditingController();

  final StreamController<void> _rebuildStream = StreamController.broadcast();
  FlutterMap? map;

  bool _work = false;

  List<CaseEntity> caseList = [];

  Future<void> getCaseList() async {
    UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
    caseList = await FirestoreModel().getRecommendCases(userUsecase);
    _getMap();
  }

  @override
  void initState() {
    getCaseList();
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
                padding: const EdgeInsets.fromLTRB(25, 50, 25, 15),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Jobs Near You",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.3,
                        child: map ??
                            LoadingAnimationWidget.beat(
                              size: 60,
                              color: Colors.amber,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: !_work ? Colors.black : Colors.grey,
                      elevation: !_work ? 8 : 0,
                    ),
                    onPressed: () {
                      if (_work) {
                        setState(() {
                          _work = !_work;
                        });
                      }
                    },
                    child: Text(
                      "Your Cases",
                      style: TextStyle(
                        color: !_work ? Colors.yellow : Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: !_work ? Colors.grey : Colors.black,
                      elevation: !_work ? 0 : 8,
                    ),
                    onPressed: () {
                      if (!_work) {
                        setState(() {
                          _work = !_work;
                        });
                      }
                    },
                    child: Text(
                      "Ongoing Work",
                      style: TextStyle(
                        color: !_work ? Colors.white : Colors.yellow,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              _work
                  ? userUsecase.userEntity.nuts.isEmpty
                      ? const Column(
                          children: [
                            SizedBox(
                              height: 50,
                            ),
                            Text(
                              "No Ongoing Work",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        )
                      : StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('cases')
                              .where(FieldPath.documentId, whereIn: userUsecase.userEntity.nuts)
                              .orderBy('casePosted', descending: true)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                              return Column(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height / 5,
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
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: snapshot.data!.size,
                                    itemBuilder: (context, index) {
                                      CaseEntity caseEntity = CaseEntity.fromMap(snapshot.data!.docs[index].data());

                                      return CaseCard(caseEntity: caseEntity);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        )
                  : StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('cases')
                          .where("clientId", isEqualTo: userUsecase.userEntity.uid)
                          .orderBy('casePosted', descending: true)
                          .limit(10)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                          return Column(
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height / 5,
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
                              const SizedBox(
                                height: 10,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.size,
                                itemBuilder: (context, index) {
                                  CaseEntity caseEntity = CaseEntity.fromMap(snapshot.data!.docs[index].data());

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
          TileLayer(retinaMode: true, urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png"),
          // live location, orientation tracker
          currerntLocationandOrientation(),
          if (caseList.isNotEmpty)
            MarkerLayer(
              markers: caseList.map((caseEntity) {
                GeoPoint geoPoint = caseEntity.caseLocation;
                return Marker(
                    point: LatLng(geoPoint.latitude, geoPoint.longitude),
                    width: 80,
                    height: 80,
                    child: InkWell(
                        onHover: (val) {},
                        onTap: () {
                          showDialog(
                              barrierDismissible: false,
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                    backgroundColor: Colors.white,
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: MediaQuery.of(context).size.height * 0.3,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius: BorderRadius.circular(20),
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                caseEntity.publicImageLink,
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 30,
                                        ),
                                        MyMoneyTextField(controller: moneyController)
                                      ],
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          'Cancel',
                                          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          'Confirm',
                                          style: TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                        onPressed: () async {
                                          UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
                                          await FirestoreModel().addBid(moneyController.text, userUsecase, caseEntity).then(
                                            (value) {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      )
                                    ]);
                              });
                        },
                        child: Stack(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Colors.red,
                              size: 50.0,
                            ),
                            Positioned(
                              top: 7,
                              left: 9,
                              child: SizedBox(
                                height: 30,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50),
                                  child: Image.network(caseEntity.photoUrl),
                                ),
                              ),
                            ),
                            Positioned(top: 0, child: Text(caseEntity.type)),
                          ],
                        )));
              }).toList(),
            )
        ],
      );
    });
  }

  Widget currerntLocationandOrientation() {
    return CurrentLocationLayer(
      // alignPositionOnUpdate: AlignOnUpdate.always,
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
