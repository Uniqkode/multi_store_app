import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';

import '../widgets/categ_widgets.dart';

class MenCategory extends StatelessWidget {
  const MenCategory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.8,
              width: MediaQuery.of(context).size.width * 0.75,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CategHeadertLabel(
                      headerLabel: 'Men',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 70,
                          children: List.generate(men.length - 1, (index) {
                            return SubCategModel(
                              subcateglabel: men[index + 1],
                              subcategName: men[index + 1],
                              maincategName: 'men',
                              assetcategName: 'images/men/men$index.jpg',
                            );
                          })),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Positioned(
              bottom: 0,
              right: 0,
              child: SliderBar(
                mainCategName: 'men',
              ))
        ],
      ),
    );
  }
}
