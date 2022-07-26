import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class CustomerOrder extends StatelessWidget {
  const CustomerOrder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackButton(),
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Orders'),
      ),
    );
  }
}
