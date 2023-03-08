import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_components/balance.dart';
import 'package:multi_store_app/dashboard_components/edit_profile.dart';
import 'package:multi_store_app/dashboard_components/manage_products.dart';
import 'package:multi_store_app/dashboard_components/statistics.dart';
import 'package:multi_store_app/dashboard_components/supplier_orders.dart';
import 'package:multi_store_app/minor_screens/visit_store.dart';

import '../widgets/alert_dialog.dart';
import '../widgets/appBar_widgets.dart';

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
List<Widget> pages = [
  VisitStore(suppId: FirebaseAuth.instance.currentUser!.uid),
  const SupplierOrders(),
  const EditProfile(),
  const ManageBusiness(),
  const Balance(),
  const Statistics()
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
              onPressed: () async {
                MyAlertDialog.showMyDialog(
                  context: context,
                  contentText: 'Do you want to logout',
                  title: 'Log out',
                  tabNo: () {
                    Navigator.pop(context);
                  },
                  tabYes: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(
                      context,
                      '/welcome_screen',
                    );
                  },
                );
              },
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
            return InkWell(
              onTap: () {
                Navigator.push((context),
                    MaterialPageRoute(builder: (context) => pages[index]));
              },
              child: Card(
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
                          fontSize: 20,
                          color: Colors.yellowAccent),
                    )
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
