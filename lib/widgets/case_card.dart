// Flutter imports
import 'package:flutter/material.dart';

// Third-party package imports
import 'package:intl/intl.dart';

// Local project imports
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/pages/chat_page.dart';
import 'package:nutsnbolts/utils/constants.dart';
import 'package:nutsnbolts/widgets/price_selection.dart';

class CaseCard extends StatelessWidget {
  final CaseEntity caseEntity;
  const CaseCard({super.key, required this.caseEntity});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onHover: (val) {},
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ChatPage(caseEntity: caseEntity),
        ));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: MyColours.secondaryColour,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                caseEntity.caseTitle,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Text(caseEntity.clientName),
              //     Text(caseEntity.clientPhoneNo)
              //   ],
              // ),
              Text(
                caseEntity.caseDesc,
                style: TextStyle(color: Colors.grey[700]),
              ),
              Text(
                  "posted on: ${DateFormat.yMEd().add_jms().format(caseEntity.casePosted.toDate())}"),
              // Text(
              //     "lat: ${caseEntity.caseLocation.latitude.toString()} long: ${caseEntity.caseLocation.longitude.toString()}")
              if (caseEntity.technicianPrice.isNotEmpty &&
                  caseEntity.status == 0)
                PriceSelection(
                  technicianPrice: caseEntity.technicianPrice,
                  caseEntity: caseEntity,
                ),
              if (caseEntity.status == 1)
                Text(
                  "CHAT WITH TECHNICIAN: ${caseEntity.technicianName}",
                  style: const TextStyle(
                      color: Colors.amber, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
