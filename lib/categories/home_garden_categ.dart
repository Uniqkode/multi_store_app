import 'package:flutter/material.dart';
import 'package:multi_store_app/utilities/categ_list.dart';

import '../widgets/categ_widgets.dart';

class HomeandgardenCategory extends StatelessWidget {
  const HomeandgardenCategory({Key? key}) : super(key: key);

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
                      headerLabel: 'home & garden',
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.68,
                      child: GridView.count(
                          crossAxisCount: 3,
                          crossAxisSpacing: 15,
                          mainAxisSpacing: 70,
                          children:
                              List.generate(homeandgarden.length - 1, (index) {
                            return SubCategModel(
                              subcateglabel: homeandgarden[index + 1],
                              subcategName: homeandgarden[index + 1],
                              maincategName: 'home & garden',
                              assetcategName:
                                  'images/homegarden/home$index.jpg',
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
                mainCategName: 'home & garden',
              ))
        ],
      ),
    );
  }
}
