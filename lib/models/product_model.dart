import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../minor_screens/product_details.dart';
import '../providers/wishlist_provider.dart';
import 'package:collection/collection.dart';

class ProductModel extends StatefulWidget {
  final dynamic product;
  const ProductModel({
    Key? key,
    required this.product,
  }) : super(key: key);

  @override
  State<ProductModel> createState() => _ProductModelState();
}

class _ProductModelState extends State<ProductModel> {
  @override
  Widget build(BuildContext context) {
    var onSale = widget.product['discount'];
    var existingWishlistItem = context.read<Wish>().getWish.firstWhereOrNull(
        (product) => product.doumentId == widget.product['proid']);
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                      proList: widget.product,
                    )));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(children: [
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Container(
                  constraints:
                      const BoxConstraints(maxHeight: 100, maxWidth: 250),
                  child: Image(
                      image: NetworkImage(widget.product['prodimages'][0])),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Text(
                        widget.product['prodname'],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
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
                              Text(
                                widget.product['price'].toStringAsFixed(2),
                                style: onSale != 0
                                    ? const TextStyle(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                        fontWeight: FontWeight.w600)
                                    : const TextStyle(
                                        fontSize: 16,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600),
                              ),
                              onSale != 0
                                  ? Text(
                                      ((1 - (onSale / 100)) *
                                              widget.product['price'])
                                          .toStringAsFixed(2),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600),
                                    )
                                  : const Text(''),
                            ],
                          ),
                          widget.product['sid'] ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? const Icon(
                                  Icons.edit,
                                  color: Colors.red,
                                )
                              : IconButton(
                                  color: Colors.red,
                                  onPressed: () {
                                    existingWishlistItem != null
                                        ? context
                                            .read<Wish>()
                                            .removeThis(widget.product['proid'])
                                        : context.read<Wish>().addWishItems(
                                              widget.product['prodname'],
                                              onSale != 0
                                                  ? ((1 - (onSale / 100)) *
                                                      widget.product['price'])
                                                  : widget.product['price'],
                                              1,
                                              widget.product['instock'],
                                              widget.product['prodimages'],
                                              widget.product['proid'],
                                              widget.product['sid'],
                                            );
                                  },
                                  icon: context
                                              .watch<Wish>()
                                              .getWish
                                              .firstWhereOrNull((product) =>
                                                  product.doumentId ==
                                                  widget.product['proid']) !=
                                          null
                                      ? const Icon(
                                          Icons.favorite,
                                        )
                                      : const Icon(
                                          Icons.favorite_border_outlined),
                                )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          onSale != 0
              ? Positioned(
                  top: 30,
                  left: 0,
                  child: Container(
                    height: 25,
                    width: 80,
                    decoration: const BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(15),
                          bottomRight: Radius.circular(15),
                        )),
                    child: Center(child: Text('Save ${onSale.toString()}%')),
                  ),
                )
              : Container()
        ]),
      ),
    );
  }
}
