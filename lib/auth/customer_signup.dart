// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

class CustomerReg extends StatefulWidget {
  const CustomerReg({Key? key}) : super(key: key);

  @override
  State<CustomerReg> createState() => _CustomerPegState();
}

class _CustomerPegState extends State<CustomerReg> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 45, fontWeight: FontWeight.bold),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/welcome_screen');
                  },
                  icon: const Icon(
                    Icons.home_work,
                    size: 40,
                  ))
            ],
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.purpleAccent,
                ),
              ),
              Column(
                children: [
                  Container(
                    child: IconButton(
                        onPressed: () {
                          print('pick image from camera');
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
                          print('pick image from gallery');
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
          TextFormField(
            decoration: InputDecoration(
                hintText: 'Enter your name',
                labelText: 'Full Name',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25))),
          )
        ],
      ),
    );
  }
}
