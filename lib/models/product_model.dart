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
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Container(
                constraints:
                    const BoxConstraints(maxHeight: 100, maxWidth: 250),
                child:
                    Image(image: NetworkImage(widget.product['prodimages'][0])),
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
                        Text(
                          widget.product['price'].toStringAsFixed(2) + (' \$'),
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.red,
                              fontWeight: FontWeight.w600),
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
                                  context.read<Wish>().getWish.firstWhereOrNull(
                                              (product) =>
                                                  product.doumentId ==
                                                  widget.product['proid']) !=
                                          null
                                      ? context
                                          .read<Wish>()
                                          .removeThis(widget.product['proid'])
                                      : context.read<Wish>().addWishItems(
                                            widget.product['prodname'],
                                            widget.product['price'],
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
      ),
    );
  }
}
