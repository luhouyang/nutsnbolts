import 'dart:io';
import 'package:dart_openai/dart_openai.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nutsnbolts/entities/case_entity.dart';
import 'package:nutsnbolts/entities/enums/enums.dart';
import 'package:nutsnbolts/model/firestore_model.dart';
import 'package:nutsnbolts/usecases/user_usecase.dart';
import 'package:nutsnbolts/widgets/my_money_field.dart';
import 'package:provider/provider.dart';

class AddCasePage extends StatefulWidget {
  const AddCasePage({super.key});

  @override
  State<AddCasePage> createState() => _AddCasePageState();
}

class _AddCasePageState extends State<AddCasePage> {
  TextEditingController caseTitleController = TextEditingController();
  TextEditingController caseDescController = TextEditingController();
  TextEditingController moneyController = TextEditingController(text: "0.0");

  String? serviceType;
  final _formKey = GlobalKey<FormState>();

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
          return Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter value';
                          }
                          return null;
                        },
                        controller: caseTitleController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusColor: Colors.amber[100],
                            hintText: "case title",
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: TextFormField(
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter value';
                          }
                          return null;
                        },
                        controller: caseDescController,
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[100],
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.black),
                              borderRadius: BorderRadius.circular(16.0),
                            ),
                            focusColor: Colors.amber[100],
                            hintText: "case description",
                            hintStyle: const TextStyle(color: Colors.black)),
                      ),
                    ),
                  ),
                  MyMoneyTextField(controller: moneyController),
                  imagePickerWidget(), // ui is at line 220-326
                  DropdownButtonFormField2<String>(
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
                  // Submit button is here!
                  ElevatedButton(
                      onPressed: () {
                        // makeApiCall() function is at the bottom of the file
                        // please check if this implmementation is correct
                        if (_formKey.currentState != null &&
                            _formKey.currentState!.validate()) {
                          makeApiCall().then((response) {
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Case added successfully"),
                              ),
                            );
                          }).catchError((error) {
                            // Handle any errors here
                          });
                        }
                      },
                      child: const Text("submit"))
                ],
              ),
            ),
          );
        },
      ),
    );
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

  // ui component for pick image button
  Widget _pickImageContainer() {
    return picBytes == null
        // no image selected view
        ? Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
              child: Container(
                padding: const EdgeInsets.all(8.0),
                height: MediaQuery.of(context).size.width * 0.7,
                width: MediaQuery.of(context).size.width * 0.7,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.0),
                    border: Border.all(color: Colors.black)),
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
                              padding:
                                  const EdgeInsets.only(left: 8.0, right: 8.0),
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
        // image selected view
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
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: Colors.black)),
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

  // crop selected image
  Future _cropImage(XFile pickedFile) async {
    try {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          maxHeight: 1080,
          maxWidth: 1080,
          compressFormat:
              ImageCompressFormat.jpg, // maybe change later, test quality first
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

makeApiCall() async {
  // the system message that will be sent to the request.
  final systemMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "return any message you are given as JSON.",
      ),
    ],
    role: OpenAIChatMessageRole.assistant,
  );

  // the user message that will be sent to the request.
  final userMessage = OpenAIChatCompletionChoiceMessageModel(
    content: [
      OpenAIChatCompletionChoiceMessageContentItemModel.text(
        "Hello, I am a chatbot created by OpenAI. How are you today?", // TODO: Engineer a custom prompt for the image case analysis
      ),

      //! image url contents are allowed only for models with image support such gpt-4.
      OpenAIChatCompletionChoiceMessageContentItemModel.imageUrl(
        "https://placehold.co/600x400", // TODO: Send the image that was picked by the user
      ),
    ],
    role: OpenAIChatMessageRole.user,
  );

// all messages to be sent.
  final requestMessages = [
    systemMessage,
    userMessage,
  ];

// the actual request.
  OpenAIChatCompletionModel chatCompletion = await OpenAI.instance.chat.create(
    model: "gpt-3.5-turbo-1106", // TODO: Change model to GPT-4
    responseFormat: {"type": "json_object"},
    seed: 6,
    messages: requestMessages,
    temperature: 0.2,
    maxTokens: 500,
  );

  // print the response.

  // TODO: Handle the response from the API and put it into a case chat
  print(chatCompletion.choices.first.message); // ...
  print(chatCompletion.systemFingerprint); // ...
  print(chatCompletion.usage.promptTokens); // ...
  print(chatCompletion.id); // ...
}
