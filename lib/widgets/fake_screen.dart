import 'package:flutter/material.dart';
import 'package:multi_store_app/minor_screens/search.dart';

class FakeSearch extends StatelessWidget {
  const FakeSearch({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SearchScreen()));
      },
      child: Container(
        height: 35,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.yellow, width: 1.4),
            borderRadius: BorderRadius.circular(25)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Icon(Icons.search, color: Colors.grey),
                ),
                Text(
                  'what are you searching for?',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
            Container(
              height: 35,
              width: 75,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.yellow),
              child: const Center(
                child: Text(
                  'Search',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
