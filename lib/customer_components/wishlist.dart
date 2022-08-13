import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appBar_widgets.dart';

class Wishlist extends StatelessWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackButton(),
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Wishlist'),
      ),
    );
  }
}