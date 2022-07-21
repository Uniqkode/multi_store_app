import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appBar_widgets.dart';

class SubCartegProducts extends StatelessWidget {
  final String subCategName;
  final String mainCategName;
  const SubCartegProducts(
      {Key? key, required this.subCategName, required this.mainCategName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: const AppBarBackButton(),
        title: AppBarTitle(title: subCategName),
      ),
      body: Center(child: Text(mainCategName)),
    );
  }
}
