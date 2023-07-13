import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/product_model.dart';
import '../widgets/appBar_widgets.dart';

class VisitStore extends StatefulWidget {
  final String suppId;
  const VisitStore({Key? key, required this.suppId}) : super(key: key);

  @override
  State<VisitStore> createState() => _VisitStoreState();
}

class _VisitStoreState extends State<VisitStore> {
  bool following = false;
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance
        .collection('products')
        .where('sid', isEqualTo: widget.suppId)
        .snapshots();
    CollectionReference suppliers =
        FirebaseFirestore.instance.collection('suppliers');

    return FutureBuilder<DocumentSnapshot>(
      future: suppliers.doc(widget.suppId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.purpleAccent,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.purple,
                ),
              ),
            ),
          );
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.blueGrey.shade100,
            appBar: AppBar(
              title: Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 4, color: Colors.yellow),
                        borderRadius: BorderRadius.circular(15)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        data['storelogo'],
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100,
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                data['storename'].toUpperCase(),
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.yellow),
                              ),
                            ),
                          ],
                        ),
                        data['sid'] == FirebaseAuth.instance.currentUser!.uid
                            ? Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    border: Border.all(
                                        width: 3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
                                child: MaterialButton(
                                  onPressed: () {},
                                  child: const Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('EDIT'),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ))
                            : Container(
                                height: 35,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.yellow,
                                    border: Border.all(
                                        width: 3, color: Colors.black),
                                    borderRadius: BorderRadius.circular(25)),
                                child: MaterialButton(
                                  onPressed: () {
                                    setState(() {
                                      following = !following;
                                    });
                                  },
                                  child: following == true
                                      ? const Text(
                                          'following',
                                          // style: TextStyle(fontSize: 12),
                                        )
                                      : const Text('follow'),
                                ))
                      ],
                    ),
                  )
                ],
              ),
              leading: const YellowBarBackButton(),
              toolbarHeight: 100,
              flexibleSpace: Image.asset(
                'images/inapp/coverimage.jpg',
                fit: BoxFit.cover,
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder<QuerySnapshot>(
                stream: _productStream,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
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
                    return const Material(
                      child: Center(
                        child: CircularProgressIndicator(
                          backgroundColor: Colors.purpleAccent,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.purple,
                          ),
                        ),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'No products yet',
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
              ),
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: Colors.green,
              onPressed: () {},
              child: const Icon(
                FontAwesomeIcons.whatsapp,
                color: Colors.white,
                size: 40,
              ),
            ),
          );
        }

        return const Text("loading");
      },
    );
  }
}
