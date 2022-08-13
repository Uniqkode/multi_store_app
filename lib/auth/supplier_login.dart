import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/auth_widgets.dart';
import '../widgets/snackbars.dart';

class SupplierLogin extends StatefulWidget {
  const SupplierLogin({Key? key}) : super(key: key);

  @override
  State<SupplierLogin> createState() => _SupplierRegState();
}

class _SupplierRegState extends State<SupplierLogin> {
  late String email;
  bool isProcessing = false;
  late String password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();
  bool passwordvisibility = true;

  void login() async {
    setState(() {
      isProcessing = true;
    });
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);

        _formKey.currentState!.reset();

        Navigator.pushReplacementNamed(context, '/supplier_home');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            isProcessing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'User does not exist.');
        } else if (e.code == 'wrong-password') {
          setState(() {
            isProcessing = false;
          });
          MyMessageHandler.showSnackBar(_scaffoldKey, 'Wrong password');
        }
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AuthHeaderLabel(
                        label: 'Log in',
                      ),
                      const SizedBox(
                        height: 100,
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
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                                fontSize: 18, fontStyle: FontStyle.italic),
                          )),
                      HaveAccount(
                        haveAccount: 'Don\'t have account? ',
                        haveaccountLabel: 'Sign Up',
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/supplier_signup');
                        },
                      ),
                      isProcessing == true
                          ? const Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Colors.purpleAccent,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.purple,
                                ),
                              ),
                            )
                          : AuthMainBTN(
                              onPressed: () {
                                login();
                              },
                              authLabel: 'Log in',
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
