import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/widgets/my_money_field.dart';
import 'package:nutsnbolts/widgets/my_text_field.dart';
import 'package:provider/provider.dart';

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  TextEditingController caseTitleController = TextEditingController();
  TextEditingController caseDescController = TextEditingController();
  TextEditingController moneyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> controllers = {
      CaseEntityAttr.caseTitle.value: caseTitleController,
      CaseEntityAttr.caseDesc.value: caseDescController,
      CaseEntityAttr.clientPrice.value: moneyController
    };

    return Scaffold(
      body: Consumer<UserUsecase>(
        builder: (context, userUsecase, child) {
          return Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              MyTextField(hint: "case title", validator: textVerify, controller: caseTitleController),
              MyTextField(hint: "case description", validator: textVerify, controller: caseDescController),
              MyMoneyTextField(controller: moneyController),
              imagePickerWidget(),
              ElevatedButton(
                  onPressed: () async {
                    if (picBytes != null) {
                      await FirestoreModel().addCase(controllers, userUsecase, picBytes!, picFile!.path).then(
                        (value) {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  },
                  child: const Text("submit"))
            ],
          );
        },
      ),
    );
  }

  String textVerify(value) {
    return value != null ? "" : "Please enter a valid input";
  }

  // image picking and cropping
  File? picFile;
  Uint8List? picBytes;

  dynamic _pickImageError;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();

  // image picking widget
  Widget imagePickerWidget() {
    return !kIsWeb && defaultTargetPlatform == TargetPlatform.android
        ? FutureBuilder<void>(
            future: retrieveLostData(),
            builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return _pickImageContainer();
                case ConnectionState.done:
                  return _previewImages();
                case ConnectionState.active:
                  if (snapshot.hasError) {
                    return _pickImageContainer();
                  } else {
                    return _pickImageContainer();
                  }
                default:
                  return _pickImageContainer();
              }
            },
          )
        : _previewImages();
  }

  // crop selected image
  Future _cropImage(XFile pickedFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 1080,
          maxWidth: 1080,
          compressFormat: ImageCompressFormat.jpg, // maybe change later, test quality first
          compressQuality: 40,
          aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0));

      picFile = File(croppedFile!.path);
      picBytes = await picFile!.readAsBytes();

      debugPrint(picFile!.path);
      debugPrint(picFile!.lengthSync().toString());

      setState(() {});
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  // pick image from gallery
  Future getImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        _cropImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // take picture with camera
  Future getImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
      );
      if (pickedFile != null) {
        _cropImage(pickedFile);
      }
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
    }
  }

  // ui component for pick image button
  Widget _pickImageContainer() {
    return picBytes == null
        ? Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), border: Border.all(color: Colors.black)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const Text(
                      'You have not yet picked an image.',
                      textAlign: TextAlign.center,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  getImageFromGallery();
                                },
                                tooltip: 'Pick Image from gallery or Camera',
                                icon: const Icon(Icons.photo),
                              ),
                            ),
                            const Text("Gallery"),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: IconButton(
                                onPressed: () async {
                                  getImageFromCamera();
                                },
                                icon: const Icon(Icons.camera),
                              ),
                            ),
                            const Text("Camera"),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        : Column(
            children: [
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: MediaQuery.of(context).size.width,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), border: Border.all(color: Colors.black)),
                        child: Container(
                          height: 400,
                          width: 400,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              15,
                            ),
                          ),
                          child: Image.memory(picBytes!),
                        ),
                      ),
                      Positioned(
                        top: -12,
                        left: -12,
                        child: IconButton(
                          onPressed: () {
                            picFile = null;
                            picBytes = null;
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.cancel,
                            color: Colors.red,
                            size: 25,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
  }

  // error handling image
  Widget _previewImages() {
    if (_retrieveDataError != null) {
      //return retrieveError;
    }
    if (_pickImageError != null) {
      // Pick imageError;
    }
    return _pickImageContainer();
  }

  // incase app crashes, previous image data can be retrieved
  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        if (response.files == null) {
        } else {
          picFile = response.files!.first as File?;
        }
      });
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }
  // end of pictures code
}
