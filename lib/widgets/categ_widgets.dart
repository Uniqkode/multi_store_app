import 'package:flutter/material.dart';

import '../minor_screens/sub_carteg_products.dart';

class SliderBar extends StatelessWidget {
  final String mainCategName;
  const SliderBar({Key? key, required this.mainCategName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.8,
      width: MediaQuery.of(context).size.width * 0.05,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Container(
          child: RotatedBox(
            quarterTurns: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                mainCategName == 'bags'
                    ? const Text('')
                    : const Text('<<', style: style),
                Text(mainCategName.toUpperCase(), style: style),
                mainCategName == 'men'
                    ? const Text('')
                    : const Text('>>', style: style)
              ],
            ),
          ),
          decoration: BoxDecoration(
              color: Colors.brown.withOpacity(0.2),
              borderRadius: BorderRadius.circular(50)),
        ),
      ),
    );
  }
}

const style = TextStyle(
    color: Colors.brown,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 10);

class SubCategModel extends StatelessWidget {
  final String maincategName;
  final String subcategName;
  final String assetcategName;
  final String subcateglabel;

  const SubCategModel(
      {Key? key,
      required this.assetcategName,
      required this.maincategName,
      required this.subcategName,
      required this.subcateglabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SubCartegProducts(
                      subCategName: subcategName,
                      mainCategName: maincategName,
                    )));
      },
      child: Column(
        children: [
          SizedBox(
            child: Image(image: AssetImage(assetcategName)),
            height: 65,
            width: 70,
          ),
          Text(
            subcateglabel,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class CategHeadertLabel extends StatelessWidget {
  final String headerLabel;
  const CategHeadertLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(30.0),
      child: Text(
        headerLabel.toUpperCase(),
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 1.5),
      ),
    );
  }
}
