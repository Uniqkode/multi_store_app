import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appBar_widgets.dart';

List<String> label = [
  'my store',
  'orders',
  'edit profile',
  'manage products',
  'balance',
  'statistics',
];

List<IconData> icons = [
  Icons.store,
  Icons.shop_2_outlined,
  Icons.edit,
  Icons.settings,
  Icons.attach_money,
  Icons.show_chart,
];

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const AppBarTitle(title: 'Dashboard'),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.logout,
                color: Colors.black,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          mainAxisSpacing: 50,
          crossAxisSpacing: 50,
          crossAxisCount: 2,
          children: List.generate(6, (index) {
            return Card(
              shadowColor: Colors.purpleAccent.shade200,
              elevation: 20,
              color: Colors.blueGrey.withOpacity(0.7),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(
                    icons[index],
                    color: Colors.yellowAccent,
                    size: 50,
                  ),
                  Text(
                    label[index].toUpperCase(),
                    style: const TextStyle(
                        fontFamily: 'Acme',
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        fontSize: 24,
                        color: Colors.yellowAccent),
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}