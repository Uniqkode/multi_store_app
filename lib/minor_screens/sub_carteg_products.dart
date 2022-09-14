import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/widgets/appbar_widgets.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';

import '../models/product_model.dart';

class SubCartegProducts extends StatefulWidget {
  final String subCategName;
  final String mainCategName;
  const SubCartegProducts(
      {Key? key, required this.subCategName, required this.mainCategName})
      : super(key: key);

  @override
  State<SubCartegProducts> createState() => _SubCartegProductsState();
}

class _SubCartegProductsState extends State<SubCartegProducts> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.mainCategName)
        .where('subcateg', isEqualTo: widget.subCategName)
        .snapshots();
    return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          leading: const AppBarBackButton(),
          title: AppBarTitle(title: widget.subCategName),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _productStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(
                  child: Text(
                'Something went wrong!!',
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontFamily: 'Acme',
                    color: Colors.blueGrey,
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ));
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.purpleAccent,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.purple,
                  ),
                ),
              );
            }
            if (snapshot.data!.docs.isEmpty) {
              return const Center(
                child: Text(
                  'COMING SOON!!!',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontFamily: 'Acme',
                      color: Colors.blueGrey,
                      fontSize: 24,
                      fontWeight: FontWeight.w500),
                ),
              );
            }
            return SingleChildScrollView(
              child: StaggeredGridView.countBuilder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  crossAxisCount: 2,
                  itemBuilder: (context, index) {
                    return ProductModel(
                      product: snapshot.data!.docs[index],
                    );
                  },
                  staggeredTileBuilder: (context) =>
                      const StaggeredTile.fit(1)),
            );
          },
        ));
  }
}
