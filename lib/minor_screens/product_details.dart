import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:multi_store_app/main_screen/cart.dart';
import 'package:multi_store_app/minor_screens/full_screen_view.dart';
import 'package:multi_store_app/minor_screens/visit_store.dart';
import 'package:multi_store_app/models/product_model.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/providers/wishlist_provider.dart';
import 'package:multi_store_app/widgets/snackbars.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';
import 'package:badges/badges.dart' as badges;
import '../widgets/appBar_widgets.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic proList;
  const ProductDetailsScreen({Key? key, required this.proList})
      : super(key: key);

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool isloding = true;
  late List<dynamic> imageLists = widget.proList['prodimages'];
  final GlobalKey<ScaffoldMessengerState> _scaffoldKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    var exsitingCartItem = context.read<Cart>().getItems.firstWhereOrNull(
        (proList) => proList.doumentId == widget.proList['proid']);
    var existingWishlistItem = context.read<Wish>().getWish.firstWhereOrNull(
        (proList) => proList.doumentId == widget.proList['proid']);
    final Stream<QuerySnapshot> _proListStream = FirebaseFirestore.instance
        .collection('products')
        .where('maincateg', isEqualTo: widget.proList['maincateg'])
        .where('subcateg', isEqualTo: widget.proList['subcateg'])
        .snapshots();
    var onSale = widget.proList['discount'];
    return Material(
      child: SafeArea(
        child: ScaffoldMessenger(
          key: _scaffoldKey,
          child: Scaffold(
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FullScreenView(
                                      imageList: imageLists,
                                    )));
                      },
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .40,
                            child: Swiper(
                                pagination: const SwiperPagination(
                                    builder: SwiperPagination.fraction),
                                itemBuilder: (context, index) {
                                  return Image(
                                      image: NetworkImage(
                                    imageLists[index],
                                  ));
                                },
                                itemCount: imageLists.length),
                          ),
                          Positioned(
                              top: 20,
                              left: 15,
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios_new,
                                      color: Colors.black,
                                    )),
                              )),
                          Positioned(
                              right: 15,
                              top: 20,
                              child: CircleAvatar(
                                backgroundColor: Colors.yellow,
                                child: IconButton(
                                    onPressed: () {},
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    )),
                              ))
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 8,
                        right: 8,
                        bottom: 50,
                        left: 8,
                      ),
                      child: Column(
                        children: [
                          Text(
                            widget.proList['prodname'],
                            style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    '\$ ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  onSale != 0
                                      ? Text(
                                          ((1 - (onSale / 100)) *
                                                  widget.proList['price'])
                                              .toStringAsFixed(2),
                                          style: const TextStyle(
                                              fontSize: 16,
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600),
                                        )
                                      : const Text(''),
                                  const SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    '\$ ' +
                                        widget.proList['price']
                                            .toStringAsFixed(2),
                                    style: onSale != 0
                                        ? const TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontWeight: FontWeight.w600)
                                        : const TextStyle(
                                            fontSize: 16,
                                            color: Colors.red,
                                            fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                              IconButton(
                                color: Colors.red,
                                onPressed: () {
                                  existingWishlistItem != null
                                      ? context
                                          .read<Wish>()
                                          .removeThis(widget.proList['proid'])
                                      : context.read<Wish>().addWishItems(
                                            widget.proList['prodname'],
                                            onSale != 0
                                                ? ((1 - (onSale / 100)) *
                                                    widget.proList['price'])
                                                : widget.proList['price'],
                                            1,
                                            widget.proList['instock'],
                                            widget.proList['prodimages'],
                                            widget.proList['proid'],
                                            widget.proList['sid'],
                                          );
                                },
                                icon: context
                                            .watch<Wish>()
                                            .getWish
                                            .firstWhereOrNull((proList) =>
                                                proList.doumentId ==
                                                widget.proList['proid']) !=
                                        null
                                    ? const Icon(
                                        Icons.favorite,
                                      )
                                    : const Icon(
                                        Icons.favorite_border_outlined),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              widget.proList['instock'] == 0
                                  ? const Text(
                                      (' Not in stock'),
                                      style: TextStyle(
                                          color: Colors.blueGrey, fontSize: 16),
                                    )
                                  : Text(
                                      (widget.proList['instock'].toString()) +
                                          (' piece(s) available'),
                                      style: const TextStyle(
                                          color: Colors.blueGrey, fontSize: 16),
                                    ),
                            ],
                          ),
                          const ProListDetailsHeader(
                            label: '  Item description  ',
                          ),
                          Text(
                            widget.proList['prodesc'],
                            textScaleFactor: 1.1,
                            style: TextStyle(
                                color: Colors.blueGrey.shade800,
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                          const ProListDetailsHeader(
                            label: '  Similar Items  ',
                          ),
                          SizedBox(
                            child: StreamBuilder<QuerySnapshot>(
                              stream: _proListStream,
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

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
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
                                      physics:
                                          const NeverScrollableScrollPhysics(),
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
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomSheet: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VisitStore(
                                        suppId: widget.proList['sid'])));
                          },
                          icon: const Icon(Icons.store)),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const CartScreen(
                                        back: AppBarBackButton())));
                          },
                          icon: badges.Badge(
                              showBadge: context.read<Cart>().getItems.isEmpty
                                  ? false
                                  : true,
                              badgeStyle: const badges.BadgeStyle(
                                padding: EdgeInsets.all(2),
                                badgeColor: Colors.yellow,
                              ),
                              badgeContent: Text(
                                context
                                    .watch<Cart>()
                                    .getItems
                                    .length
                                    .toString(),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                              child: const Icon(Icons.shopping_cart))),
                    ],
                  ),
                  YellowButton(
                      btnLabel: exsitingCartItem != null
                          ? 'added to cart'.toUpperCase()
                          : 'ADD TO CART',
                      onPressed: () {
                        if (widget.proList['instock'] == 0) {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'Not in stock');
                        } else if (exsitingCartItem != null) {
                          MyMessageHandler.showSnackBar(
                              _scaffoldKey, 'Item already in Cart!');
                        } else {
                          context.read<Cart>().addItems(
                                widget.proList['prodname'],
                                onSale != 0
                                    ? ((1 - (onSale / 100)) *
                                        widget.proList['price'])
                                    : widget.proList['price'],
                                1,
                                widget.proList['instock'],
                                widget.proList['prodimages'],
                                widget.proList['proid'],
                                widget.proList['sid'],
                              );
                        }
                      },
                      width: 0.55)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProListDetailsHeader extends StatelessWidget {
  final String label;
  const ProListDetailsHeader({
    required this.label,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
          Text(
            label,
            style: TextStyle(
                fontSize: 24,
                color: Colors.yellow.shade900,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.yellow.shade900,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
