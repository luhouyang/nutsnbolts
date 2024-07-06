// Flutter imports
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nutsnbolts/entities/bid_entity.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/pages/become_technician.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/utils/constants.dart';
import 'package:nutsnbolts/widgets/my_money_field.dart';
import 'package:provider/provider.dart';
import 'package:swipe_cards/draggable_card.dart';
import 'package:swipe_cards/swipe_cards.dart';

import '../entities/case_entity.dart';

class TechnicianPage extends StatefulWidget {
  const TechnicianPage({super.key});

  @override
  State<TechnicianPage> createState() => _TechnicianPageState();
}

class _TechnicianPageState extends State<TechnicianPage> {
  TextEditingController moneyController = TextEditingController();

  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;

  final ValueNotifier<Color> _crossButtonColor = ValueNotifier<Color>(Colors.grey[300]!);
  final ValueNotifier<Color> _checkButtonColor = ValueNotifier<Color>(Colors.grey[300]!);
  bool _isStackFinished = false;

  @override
  void initState() {
    super.initState();
    _matchEngine = MatchEngine(swipeItems: _swipeItems);
  }

  @override
  void dispose() {
    _crossButtonColor.dispose();
    _checkButtonColor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Consumer<UserUsecase>(
          builder: (context, userUsecase, child) {
            return !userUsecase.userEntity.isTechnician
                ? Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.45,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.all(10),
                                  backgroundColor: MyColours.primaryColour,
                                  foregroundColor: MyColours.secondaryColour,
                                  shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => const BecomeTechnicianPage(),
                                ));
                              },
                              child: const Text("Become A Technician")),
                        ),
                      )
                    ],
                  )
                : Column(
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
                          "Find A Job",
                          style: TextStyle(color: MyColours.secondaryColour, fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('cases').orderBy('casePosted', descending: true).snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData || snapshot.connectionState == ConnectionState.waiting) {
                            return Column(
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height / 3,
                                ),
                                const Center(child: CircularProgressIndicator()),
                              ],
                            );
                          }

                          _swipeItems.clear();

                          // Populate swipe items from Firestore snapshot
                          var documents = snapshot.data!.docs;
                          for (var doc in documents) {
                            var data = doc.data();
                            CaseEntity caseEntity = CaseEntity.from(data);

                            List<BidEntity> bidList = [];
                            for (var bid in caseEntity.technicianPrice) {
                              BidEntity bidEntity = BidEntity.fromMap(bid);
                              bidList.add(bidEntity);
                            }

                            if (!bidList.any((bid) => bid.technicianId == userUsecase.userEntity.uid)) {
                              _swipeItems.add(SwipeItem(
                                content: caseEntity,
                                likeAction: () {
                                  _checkButtonColor.value = Colors.green;

                                  showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        backgroundColor: Colors.amber,
                                        content: MyMoneyTextField(controller: moneyController),
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
                                              await FirestoreModel().addBid(moneyController.text, userUsecase, caseEntity).then(
                                                (value) {
                                                  Navigator.of(context).pop();
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    _checkButtonColor.value = Colors.grey[300]!;
                                  });
                                },
                                nopeAction: () {
                                  _crossButtonColor.value = Colors.red;
                                  Future.delayed(const Duration(milliseconds: 500), () {
                                    _crossButtonColor.value = Colors.grey[300]!;
                                  });
                                },
                                onSlideUpdate: (SlideRegion? region) async {},
                              ));
                            }
                          }

                          _matchEngine = MatchEngine(swipeItems: _swipeItems);
                          return (_isStackFinished)
                              ? const Center(
                                  child: Text("Stack is Finished"),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 25),
                                  child: Stack(children: [
                                    SwipeCards(
                                      matchEngine: _matchEngine!,
                                      itemBuilder: (BuildContext context, int index) {
                                        CaseEntity caseEntity = _swipeItems[index].content as CaseEntity;
                                        return Stack(
                                          children: [
                                            Container(
                                              height: (MediaQuery.of(context).size.height / 3) * 1.8,
                                              alignment: Alignment.center,
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
                                            Align(
                                              alignment: Alignment.bottomCenter,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Container(
                                                  padding: const EdgeInsets.all(15),
                                                  margin: const EdgeInsets.symmetric(horizontal: 10),
                                                  decoration: BoxDecoration(
                                                    color: Colors.white.withOpacity(0.9),
                                                    borderRadius: BorderRadius.circular(20),
                                                  ),
                                                  child: SizedBox(
                                                    width: double.infinity,
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisSize: MainAxisSize.min,
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          caseEntity.caseTitle,
                                                          style: const TextStyle(
                                                            fontSize: 22,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                        Text(
                                                          caseEntity.caseDesc,
                                                          style: const TextStyle(fontSize: 16),
                                                        ),
                                                        const Divider(),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                          children: [
                                                            Text(
                                                              caseEntity.clientName,
                                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                            ),
                                                            Text(
                                                              DateFormat('dd/MM/yyyy hh:mm a').format(caseEntity.casePosted.toDate()),
                                                              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                      onStackFinished: () {
                                        setState(() {
                                          _isStackFinished = true;
                                        });
                                      },
                                      itemChanged: (SwipeItem item, int index) {
                                        debugPrint("item: ${(item.content as CaseEntity).caseTitle}, index: $index");
                                      },
                                      leftSwipeAllowed: true,
                                      rightSwipeAllowed: true,
                                      upSwipeAllowed: false,
                                      fillSpace: false,
                                    ),
                                  ]),
                                );
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ValueListenableBuilder<Color>(
                            valueListenable: _crossButtonColor,
                            builder: (context, color, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.close,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            },
                          ),
                          ValueListenableBuilder<Color>(
                            valueListenable: _checkButtonColor,
                            builder: (context, color, child) {
                              return Container(
                                decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.check, size: 40, color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ],
                  );
          },
        ));
  }
}
