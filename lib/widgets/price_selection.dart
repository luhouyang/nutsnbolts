// Third-party package imports
import 'package:dropdown_button2/dropdown_button2.dart';

// Flutter imports
import 'package:flutter/material.dart';

// Local project imports
import 'package:nutsnbolts/entities/bid_entity.dart';

class PriceSelection extends StatefulWidget {
  final List<dynamic> technicianPrice;

  const PriceSelection({super.key, required this.technicianPrice});

  @override
  State<PriceSelection> createState() => _PriceSelectionState();
}

class _PriceSelectionState extends State<PriceSelection> {
  String? serviceType;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButtonFormField2<BidEntity>(
              isExpanded: true,
              decoration: InputDecoration(
                // Add Horizontal padding using menuItemStyleData.padding so it matches
                // the menu padding when button's width is not specified.
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                // Add more decoration..
              ),
              hint: const Text(
                'Choose Technician',
                style: TextStyle(fontSize: 14),
              ),
              items: widget.technicianPrice
                  .map((item) => DropdownMenuItem<BidEntity>(
                      value: BidEntity.fromMap(item as Map<String, dynamic>),
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
              onChanged: (value) {
                //Do something when selected item is changed.
              },
              onSaved: (value) {
                serviceType = value.toString();
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
            // Submit button is here! TODO: style this button
            ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                  }
                },
                child: const Text("confrim"))
          ],
        ),
      ),
    );
  }
}
