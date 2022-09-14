import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/yellow_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

const textcolor = [
  Colors.yellowAccent,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.purple,
  Colors.teal
];
const textstyle =
    TextStyle(fontSize: 45, fontWeight: FontWeight.bold, fontFamily: 'Acme');

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({Key? key}) : super(key: key);

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen>
    with SingleTickerProviderStateMixin {
  CollectionReference anonymous =
      FirebaseFirestore.instance.collection('anonymous');
  late String _uid;
  bool processing = false;
  late AnimationController _controller;
  @override
  void initState() {
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));
    _controller.repeat();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'images/inapp/bgimage.jpg',
                ),
                fit: BoxFit.cover)),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedTextKit(
                animatedTexts: [
                  ColorizeAnimatedText(
                    'WELCOME',
                    textStyle: textstyle,
                    colors: textcolor,
                  ),
                  ColorizeAnimatedText(
                    'Duck Store',
                    textStyle: textstyle,
                    colors: textcolor,
                  ),
                ],
                isRepeatingAnimation: true,
                repeatForever: true,
              ),
              const SizedBox(
                height: 120,
                width: 200,
                child: Image(
                  image: AssetImage('images/inapp/logo.jpg'),
                ),
              ),
              DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 40.0,
                  color: Colors.lightBlueAccent,
                  fontFamily: 'Acme',
                ),
                child: SizedBox(
                  height: 80,
                  child: AnimatedTextKit(
                    animatedTexts: [
                      RotateAnimatedText('BUY'),
                      RotateAnimatedText('SHOP'),
                      RotateAnimatedText('MULTI STORE'),
                    ],
                    repeatForever: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            'Suppliers only',
                            style: TextStyle(
                                color: Colors.yellowAccent,
                                fontWeight: FontWeight.w600,
                                fontSize: 26),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: const BoxDecoration(
                          color: Colors.white38,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            bottomLeft: Radius.circular(50),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            AnimatedLogo(controller: _controller),
                            YellowButton(
                                btnLabel: 'Log in',
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    '/supplier_login',
                                  );
                                },
                                width: 0.25),
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: YellowButton(
                                  btnLabel: ' Sign up',
                                  onPressed: () {
                                    Navigator.pushReplacementNamed(
                                      context,
                                      '/supplier_signup',
                                    );
                                  },
                                  width: 0.25),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width * 0.9,
                    decoration: const BoxDecoration(
                      color: Colors.white38,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        bottomRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: YellowButton(
                              btnLabel: 'Log in',
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/cust_login',
                                );
                              },
                              width: 0.25),
                        ),
                        YellowButton(
                            btnLabel: ' Sign up',
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                '/customer_signup',
                              );
                            },
                            width: 0.25),
                        AnimatedLogo(controller: _controller),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 25),
                child: Container(
                  decoration:
                      BoxDecoration(color: Colors.white38.withOpacity(0.3)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SocialsBTN(
                        child: const Image(
                          image: AssetImage('images/inapp/google.jpg'),
                        ),
                        btnLabel: 'Google',
                        onPressed: () {},
                      ),
                      SocialsBTN(
                        btnLabel: 'Facebook',
                        onPressed: () {},
                        child: const Image(
                          image: AssetImage('images/inapp/facebook.jpg'),
                        ),
                      ),
                      processing == true
                          ? const CircularProgressIndicator(
                              backgroundColor: Colors.purpleAccent,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.purple,
                              ),
                            )
                          : SocialsBTN(
                              btnLabel: 'Guest',
                              onPressed: () async {
                                setState(() {
                                  processing = true;
                                });
                                await FirebaseAuth.instance
                                    .signInAnonymously()
                                    .whenComplete(() async {
                                  _uid = FirebaseAuth.instance.currentUser!.uid;
                                  await anonymous.doc(_uid).set({
                                    'name': '',
                                    'email': '',
                                    'profileimage': '',
                                    'phone': '',
                                    'address': '',
                                    'cid': _uid,
                                  });
                                });

                                Navigator.pushReplacementNamed(
                                    context, '/customer_home');
                              },
                              child: const Icon(
                                Icons.person,
                                size: 55,
                                color: Colors.blueAccent,
                              ))
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLogo extends StatelessWidget {
  const AnimatedLogo({
    Key? key,
    required AnimationController controller,
  })  : _controller = controller,
        super(key: key);

  final AnimationController _controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.rotate(
          angle: _controller.value * 2 * pi,
          child: child,
        );
      },
      child: const Image(
        image: AssetImage('images/inapp/logo.jpg'),
      ),
    );
  }
}

class SocialsBTN extends StatelessWidget {
  final String btnLabel;
  final Function() onPressed;
  final Widget child;

  const SocialsBTN({
    Key? key,
    required this.btnLabel,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onPressed,
        child: Column(
          children: [
            SizedBox(height: 50, width: 50, child: child),
            Text(
              btnLabel,
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
