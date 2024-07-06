import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';

import 'package:nutsnbolts/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:nutsnbolts/entities/enums/enums.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';

class Skill {
  final int id;
  final String name;

  Skill({
    required this.id,
    required this.name,
  });
}

class BecomeTechnicianPage extends StatefulWidget {
  const BecomeTechnicianPage({super.key});

  @override
  State<BecomeTechnicianPage> createState() => _BecomeTechnicianPageState();
}

class _BecomeTechnicianPageState extends State<BecomeTechnicianPage> {
  List<Specialty> specialties = Specialty.values;
  final _multiSelectKey = GlobalKey<FormFieldState<List<Skill?>>>();
  List<Skill> specialtiesList = [];

  String? serviceType;

  @override
  Widget build(BuildContext context) {
    List<Skill> skills = [];

    for (int i = 0; i < specialties.length; i++) {
      skills.add(Skill(id: i + 1, name: specialties[i].value));
    }

    final items = skills.map((skill) => MultiSelectItem<Skill>(skill, skill.name)).toList();

    return Scaffold(
      body: Consumer<UserUsecase>(
        builder: (context, userUsecase, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                ),
                MultiSelectChipField<Skill?>(
                  key: _multiSelectKey,
                  items: items,
                  scroll: false,
                  title: const Text("Specialty"),
                  headerColor: Colors.amber.withOpacity(0.5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.amber, width: 1.8),
                  ),
                  selectedChipColor: Colors.amber.withOpacity(0.5),
                  selectedTextStyle: TextStyle(color: Colors.amber[800]),
                  onTap: (values) {
                      specialtiesList = values.whereType<Skill>().toList();
                  },
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
                          UserUsecase userUsecase = Provider.of<UserUsecase>(context, listen: false);
                          List<String> specialties = specialtiesList
                              .map(
                                (e) => e.name.toString(),
                              )
                              .toList();

                          await userUsecase.signupTechnician(specialties).then((value) => Navigator.of(context).pop(),);
                        },
                        child: const Text("Confirm")))
              ],
            ),
          );
        },
      ),
    );
  }
}
