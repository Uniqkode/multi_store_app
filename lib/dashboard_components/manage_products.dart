import 'package:flutter/material.dart';

import '../widgets/appBar_widgets.dart';

class ManageBusiness extends StatelessWidget {
  const ManageBusiness({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const AppBarBackButton(),

        backgroundColor: Colors.white,
        title: const AppBarTitle(title: 'Manage Business'),
        // leading: const AppBarBackButton(),
      ),
    );
  }
}
