import 'package:flutter/material.dart';

import '../widgets/appBar_widgets.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackButton(),
        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Statistics'),
      ),
    );
  }
}
