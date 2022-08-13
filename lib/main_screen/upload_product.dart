// ignore_for_file: avoid_print

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:multi_store_app/utilities/categ_list.dart';
import 'package:multi_store_app/widgets/snackbars.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({Key? key}) : super(key: key);

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  late double price;
  late int quantity;
  late String proName;
  late String proDesc;
  String mainCategValue = 'select category';
  String subCategValue = 'subcategory';
  dynamic _pickImageError;
  List<XFile>? imageFileList = [];
  List<String> subCategList = [];

  final ImagePicker _picker = ImagePicker();
  void _pickProductPictures() async {
    try {
      final pickedImages = await _picker.pickMultiImage(
          maxHeight: 300, maxWidth: 300, imageQuality: 95);
      setState(() {
        imageFileList = pickedImages!;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  Widget previewimages() {
    if (imageFileList!.isNotEmpty) {
      return ListView.builder(
          itemCount: imageFileList!.length,
          itemBuilder: (context, index) {
            return Image.file(File(imageFileList![index].path));
          });
    } else {
      return const Center(
        child: Text(
          'You have not \n\n picked an image',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 16,
          ),
        ),
      );
    }
  }

  void selectMainCateg(String? value) {
    if (value == 'select category') {
      subCategList = [];
    } else if (value == 'men') {
      subCategList = men;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'women') {
      subCategList = women;
    } else if (value == 'electronics') {
      subCategList = electronics;
    } else if (value == 'accessories') {
      subCategList = accessories;
    } else if (value == 'shoes') {
      subCategList = shoes;
    } else if (value == 'home & garden') {
      subCategList = homeandgarden;
    } else if (value == 'beauty') {
      subCategList = beauty;
    } else if (value == 'kids') {
      subCategList = kids;
    } else if (value == 'bags') {
      subCategList = bags;
    }
    print(value);
    setState(() {
      mainCategValue = value!;
      subCategValue = 'subcategory';
    });
  }

  void uploadProduct() {
    if (_formkey.currentState!.validate()) {
      _formkey.currentState!.save();
      if (imageFileList!.isNotEmpty) {
        print('image picked');
        print('Valid');
        print(price);
        print(quantity);
        print(proName);
        print(proDesc);
        setState(() {
          imageFileList = [];
        });
        _formkey.currentState!.reset();
      } else {
        MyMessageHandler.showSnackBar(_scaffoldKey, 'please pick an image');
      }
    } else {
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            reverse: true,
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        color: Colors.blueGrey.shade100,
                        height: MediaQuery.of(context).size.width * .5,
                        width: MediaQuery.of(context).size.width * .5,
                        child: imageFileList != null
                            ? previewimages()
                            : const Center(
                                child: Text(
                                  'You have not \n\n picked an image',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                      ),
                      Column(
                        children: [
                          const Text('select main category'),
                          DropdownButton(
                              value: mainCategValue,
                              items: maincateg
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                selectMainCateg(value);
                              }),
                          const Text('select sub category'),
                          DropdownButton(
                              disabledHint: const Text('select category'),
                              value: subCategValue,
                              items: subCategList
                                  .map<DropdownMenuItem<String>>((value) {
                                return DropdownMenuItem(
                                  child: Text(value),
                                  value: value,
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                print(value);
                                setState(() {
                                  subCategValue = value!;
                                });
                              })
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 30,
                    child: Divider(
                      color: Colors.yellow,
                      thickness: 1.5,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .38,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter price';
                          } else if (value.isValidPrice() != true) {
                            return 'Invalid input';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          price = double.parse(value!);
                        },
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        decoration: inputDecor.copyWith(
                            labelText: 'Price', hintText: 'price \$'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * .45,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter quantity';
                          } else if (value.isValidQuant() != true) {
                            return 'Invalid input';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          quantity = int.parse(value!);
                        },
                        keyboardType: TextInputType.number,
                        decoration: inputDecor.copyWith(
                          labelText: 'Quantity',
                          hintText: 'Add quantity',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter product name';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          proName = value!;
                        },
                        maxLength: 100,
                        maxLines: 3,
                        decoration: inputDecor.copyWith(
                          labelText: 'Product name',
                          hintText: 'Enter product name',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'please enter description';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          proDesc = value!;
                        },
                        maxLength: 800,
                        maxLines: 5,
                        decoration: inputDecor.copyWith(
                          labelText: 'Description',
                          hintText: 'Enter product description',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: FloatingActionButton(
                onPressed: imageFileList!.isEmpty
                    ? () {
                        _pickProductPictures();
                      }
                    : () {
                        setState(() {
                          imageFileList = [];
                        });
                      },
                backgroundColor: Colors.yellow,
                child: imageFileList!.isEmpty
                    ? const Icon(
                        Icons.photo_library,
                        color: Colors.black,
                      )
                    : const Icon(
                        Icons.delete_forever,
                        color: Colors.black,
                      ),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                uploadProduct();
              },
              backgroundColor: Colors.yellow,
              child: const Icon(
                Icons.upload,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var inputDecor = InputDecoration(
  labelStyle: const TextStyle(color: Colors.purple),
  labelText: 'Price',
  hintText: 'price...\$ ',
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Colors.yellow, width: 1),
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Colors.blueAccent, width: 1)),
);

extension QuantityValidator on String {
  bool isValidQuant() {
    return RegExp(r'^[1-9][0-9]*$').hasMatch(this);
  }
}

extension PriceValidator on String {
  bool isValidPrice() {
    return RegExp(r'^((([1-9][0-9]*[\.]*)||([0][\.]*))([0-9]{1,2}))$')
        .hasMatch(this);
  }
}
