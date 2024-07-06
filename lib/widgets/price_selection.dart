// Third-party package imports
import 'package:dropdown_button2/dropdown_button2.dart';

// Flutter imports
import 'package:flutter/material.dart';

// Local project imports
import 'package:nutsnbolts/entities/bid_entity.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/utils/constants.dart';

class PriceSelection extends StatefulWidget {
  final List<dynamic> technicianPrice;
  final CaseEntity caseEntity;

  const PriceSelection(
      {super.key, required this.technicianPrice, required this.caseEntity});

  @override
  State<PriceSelection> createState() => _PriceSelectionState();
}

class _PriceSelectionState extends State<PriceSelection> {
  String? winningBid;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    List<BidEntity> bidList = [];
    for (var bid in widget.caseEntity.technicianPrice) {
      BidEntity bidEntity = BidEntity.fromMap(bid);
      bidList.add(bidEntity);
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField2<String>(
              isExpanded: true,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              hint: const Text(
                'Choose Technician',
                style: TextStyle(fontSize: 14),
              ),
              items: widget.technicianPrice
                  .map((item) => DropdownMenuItem<String>(
                      value: BidEntity.fromMap(item as Map<String, dynamic>)
                          .technicianId,
                      child: () {
                        BidEntity bidEntity = BidEntity.fromMap(item);

                        return Row(
                          children: [
                            Text("RM ${bidEntity.price.toString()}"),
                            Text(" | ${bidEntity.technicianName} | "),
                            Text("R: ${bidEntity.rating.toString()}"),
                          ],
                        );
                      }()))
                  .toList(),
              validator: (value) {
                if (value == null) {
                  return 'Please select technician';
                }
                return null;
              },
              onChanged: (value) {},
              onSaved: (value) {
                winningBid = value;
              },
              buttonStyleData: const ButtonStyleData(
                padding: EdgeInsets.only(right: 8),
              ),
              iconStyleData: const IconStyleData(
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.black45,
                ),
                iconSize: 24,
              ),
              dropdownStyleData: DropdownStyleData(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              menuItemStyleData: const MenuItemStyleData(
                padding: EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.all(10),
                        backgroundColor: MyColours.primaryColour,
                        foregroundColor: MyColours.secondaryColour,
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(20))),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                      }
                      List<BidEntity> l = bidList
                          .where((bid) => bid.technicianId == winningBid)
                          .toList();
                      await FirestoreModel()
                          .confirmTechnician(l[0], widget.caseEntity);
                    },
                    child: const Text("Confirm")))
          ],
        ),
      ),
    );
  }
}
