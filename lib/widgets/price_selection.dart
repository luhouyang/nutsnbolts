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

  // Function to truncate strings
  String truncateString(String text, int length) {
    return text.length > length ? '${text.substring(0, length)}...' : text;
  }

  @override
  Widget build(BuildContext context) {
    List<BidEntity> bidList = [];
    for (var bid in widget.caseEntity.technicianPrice) {
      BidEntity bidEntity = BidEntity.fromMap(bid);
      bidList.add(bidEntity);
    }

    return Form(
      key: _formKey,
      child: SizedBox(
        width: double.infinity,
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
              items: widget.technicianPrice.map((item) {
                BidEntity bidEntity =
                    BidEntity.fromMap(item as Map<String, dynamic>);
                return DropdownMenuItem<String>(
                  value: bidEntity.technicianId,
                  child: Row(
                    children: [
                      Text(
                          "RM ${truncateString(bidEntity.price.toString(), 5)}"),
                      Text(
                          " | ${truncateString(bidEntity.technicianName, 15)} | "),
                      Text(
                          "R: ${truncateString(bidEntity.rating.toString(), 4)}"),
                    ],
                  ),
                );
              }).toList(),
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
                      borderRadius: BorderRadius.circular(20)),
                ),
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
                child: const Text("Confirm"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
