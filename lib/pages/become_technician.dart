import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:nutsnbolts/entities/enums/enums.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/utils/constants.dart';
import 'package:provider/provider.dart';

class BecomeTechnicianPage extends StatefulWidget {
  const BecomeTechnicianPage({super.key});

  @override
  State<BecomeTechnicianPage> createState() => _BecomeTechnicianPageState();
}

class _BecomeTechnicianPageState extends State<BecomeTechnicianPage> {
  String? serviceType;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<UserUsecase>(
        builder: (context, userUsecase, child) {
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  DropdownButtonFormField2<String>(
                    isExpanded: true,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    hint: const Text(
                      'Service Category',
                      style: TextStyle(fontSize: 14),
                    ),
                    items: Specialty.values
                        .map((item) => DropdownMenuItem<String>(
                              value: item.value,
                              child: Text(
                                item.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ))
                        .toList(),
                    validator: (value) {
                      if (value == null) {
                        return 'Please select category';
                      }
                      return null;
                    },
                    onChanged: (value) {},
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
                  SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(10),
                              backgroundColor: MyColours.primaryColour,
                              foregroundColor: MyColours.secondaryColour,
                              shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          onPressed: () async {
                            // validation
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                            }
                            await userUsecase.signupTechnician(serviceType!).then(
                                  (value) => Navigator.of(context).pop(),
                                );
                          },
                          child: const Text("submit")))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
