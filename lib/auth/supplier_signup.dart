// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../widgets/auth_widgets.dart';
import '../widgets/snackbars.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class SupplierReg extends StatefulWidget {
  const SupplierReg({Key? key}) : super(key: key);

  @override
  State<SupplierReg> createState() => _SupplierRegState();
}

class _SupplierRegState extends State<SupplierReg> {
  late String email;
  late String storeLogo;
  bool isProcessing = false;
  late String _uid;
  late String storeName;
  late String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordvisibility = true;
  dynamic _pickImageError;
  XFile? _imageFile;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('suppliers');
  final ImagePicker _picker = ImagePicker();
  void _pickImageFromCamera() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void _pickImageFromGallery() async {
    try {
      final pickedImage = await _picker.pickImage(
          source: ImageSource.gallery,
          maxHeight: 300,
          maxWidth: 300,
          imageQuality: 95);
      setState(() {
        _imageFile = pickedImage;
      });
    } catch (e) {
      setState(() {
        _pickImageError = e;
      });
      print(_pickImageError);
    }
  }

  void signup() async {
    setState(() {
      isProcessing = true;
    });
    if (_formKey.currentState!.validate()) {
      if (_imageFile != null) {
        try {
          await FirebaseAuth.instance
              .createUserWithEmailAndPassword(email: email, password: password);

          firebase_storage.Reference ref = firebase_storage
              .FirebaseStorage.instance
              .ref('supplier-images/$email.jpg');

          await ref.putFile(File(_imageFile!.path));
          _uid = FirebaseAuth.instance.currentUser!.uid;
          storeLogo = await ref.getDownloadURL();
          await customers.doc(_uid).set({
            'storename': storeName,
            'email': email,
            'storelogo': storeLogo,
            'phone': '',
            'sid': _uid,
            'coverimage': '',
          });

          _formKey.currentState!.reset();
          setState(() {
            _imageFile = null;
          });
          Navigator.pushReplacementNamed(context, '/supplier_login');
        } on FirebaseAuthException catch (e) {
          if (e.code == 'weak-password') {
            setState(() {
              isProcessing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The password provided is too weak.');
          } else if (e.code == 'email-already-in-use') {
            setState(() {
              isProcessing = false;
            });
            MyMessageHandler.showSnackBar(
                _scaffoldKey, 'The account already exists for that email.');
          }
        }
      } else {
        setState(() {
          isProcessing = false;
        });
        MyMessageHandler.showSnackBar(
            _scaffoldKey, 'please pick an image first');
      }
    } else {
      setState(() {
        isProcessing = false;
      });
      MyMessageHandler.showSnackBar(_scaffoldKey, 'please fill all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              reverse: true,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const AuthHeaderLabel(
                        label: 'Sign up',
                      ),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 20),
                            child: CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.purpleAccent,
                              backgroundImage: _imageFile == null
                                  ? null
                                  : FileImage(File(_imageFile!.path)),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                child: IconButton(
                                    onPressed: () {
                                      _pickImageFromCamera();
                                    },
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    )),
                                decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(50),
                                        topRight: Radius.circular(50))),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Container(
                                child: IconButton(
                                    onPressed: () {
                                      _pickImageFromGallery();
                                    },
                                    icon: const Icon(
                                      Icons.photo,
                                      color: Colors.white,
                                    )),
                                decoration: const BoxDecoration(
                                    color: Colors.purple,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(50),
                                        bottomRight: Radius.circular(50))),
                              )
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            storeName = (value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your name';
                            } else {
                              return null;
                            }
                          },
                          decoration: textFormDecor.copyWith(
                            labelText: 'Full name',
                            hintText: 'John Doe',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            email = (value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter your email';
                            } else if (value.isValidEmail() == false) {
                              return 'invalid email';
                            } else if (value.isValidEmail() == true) {
                              return null;
                            } else {
                              return null;
                            }
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: textFormDecor.copyWith(
                            labelText: 'Email',
                            hintText: 'name@email.com',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          onChanged: (value) {
                            password = (value);
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'please enter Password';
                            } else {
                              return null;
                            }
                          },
                          obscureText: passwordvisibility,
                          decoration: textFormDecor.copyWith(
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordvisibility = !passwordvisibility;
                                });
                              },
                              icon: passwordvisibility
                                  ? const Icon(
                                      Icons.visibility,
                                      color: Colors.purple,
                                    )
                                  : const Icon(
                                      Icons.visibility_off,
                                      color: Colors.purple,
                                    ),
                            ),
                            labelText: 'Password',
                            hintText: 'enter password',
                          ),
                        ),
                      ),
                      HaveAccount(
                        haveAccount: 'already have account? ',
                        haveaccountLabel: 'login',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_home');
                        },
                      ),
                      isProcessing == true
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.purpleAccent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purple,
                              ),
                            )
                          : AuthMainBTN(
                              onPressed: () {
                                signup();
                              },
                              authLabel: 'Sign up',
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
