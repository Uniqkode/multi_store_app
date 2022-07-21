import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/fake_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: const FakeSearch(),
          bottom: const TabBar(
              isScrollable: true,
              indicatorColor: Colors.yellow,
              indicatorWeight: 8,
              tabs: [
                RepeatedTabs(label: 'Men'),
                RepeatedTabs(label: 'Women'),
                RepeatedTabs(label: 'Shoes'),
                RepeatedTabs(label: 'Bags'),
                RepeatedTabs(label: 'Electronics'),
                RepeatedTabs(label: 'Accessories'),
                RepeatedTabs(label: 'Home & Garden'),
                RepeatedTabs(label: 'Kids'),
                RepeatedTabs(label: 'Beauty'),
              ]),
        ),
        body: const TabBarView(children: [
          Center(child: Text('men screen')),
          Center(child: Text('women screen')),
          Center(child: Text('shoe screen')),
          Center(child: Text('Bags screen')),
          Center(child: Text('electronics screen')),
          Center(child: Text('accessories screen')),
          Center(child: Text('home & garden screen')),
          Center(child: Text('kids screen')),
          Center(child: Text('beauty screen')),
        ]),
      ),
    );
  }
}

class RepeatedTabs extends StatelessWidget {
  final String label;
  const RepeatedTabs({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Text(
        label,
        style: TextStyle(color: Colors.grey.shade600),
      ),
    );
  }
}
