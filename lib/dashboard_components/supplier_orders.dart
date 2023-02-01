import 'package:flutter/material.dart';
import 'package:multi_store_app/dashboard_components/delivered_orders.dart';
import 'package:multi_store_app/dashboard_components/preparing_orders.dart';
import 'package:multi_store_app/dashboard_components/shipping_orders.dart';
import 'package:multi_store_app/main_screen/home.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';

class SupplierOrders extends StatelessWidget {
  const SupplierOrders({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          leading: const AppBarBackButton(),
          backgroundColor: Colors.white,
          title: const AppBarTitle(title: 'Orders'),
          bottom: const TabBar(
            tabs: [
              RepeatedTabs(label: 'Preparing'),
              RepeatedTabs(label: 'Shipping'),
              RepeatedTabs(label: 'Delivered'),
            ],
            indicatorColor: Colors.yellow,
            indicatorWeight: 8,
          ),
        ),
        body: const TabBarView(children: [
          PreparingOrders(),
          ShippingOrders(),
          DeliveredOrders(),
        ]),
      ),
    );
  }
}
