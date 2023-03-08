// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_store_app/providers/cart_provider.dart';
import 'package:multi_store_app/widgets/yellow_button.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

import '../widgets/appBar_widgets.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isProcessing = false;
  int selectedValue = 1;
  late String orderId;
  CollectionReference customers =
      FirebaseFirestore.instance.collection('customers');
  void showProgress() {
    ProgressDialog progress = ProgressDialog(context: context);
    progress.show(
        max: 100,
        msg: 'Please wait',
        progressBgColor: Colors.red,
        progressValueColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = context.watch<Cart>().totalPrice;
    double totalPaid = context.watch<Cart>().totalPrice + 10.0;

    return FutureBuilder<DocumentSnapshot>(
        future: customers.doc(FirebaseAuth.instance.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return const Center(child: Text("Document does not exist"));
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
            ));
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            return Material(
              color: Colors.grey.shade200,
              child: SafeArea(
                child: Scaffold(
                  backgroundColor: Colors.grey.shade200,
                  appBar: AppBar(
                    leading: const AppBarBackButton(),
                    backgroundColor: Colors.grey.shade200,
                    centerTitle: true,
                    elevation: 0,
                    title: const AppBarTitle(title: 'Payment'),
                  ),
                  body: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                    child: Column(
                      children: [
                        Container(
                          width: double.infinity,
                          height: 120,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                    Text(
                                      '${totalPaid.toStringAsFixed(2)} USD',
                                      style: const TextStyle(fontSize: 20),
                                    )
                                  ],
                                ),
                                const Divider(
                                  color: Colors.grey,
                                  thickness: 2,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      'Total Order',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      '${totalPrice.toStringAsFixed(2)} USD',
                                      style: const TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      'Shipping cost',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    ),
                                    Text(
                                      '10.00 USD',
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.grey),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15)),
                            child: Column(
                              children: [
                                RadioListTile(
                                  value: 1,
                                  groupValue: selectedValue,
                                  onChanged: (int? value) {
                                    setState(() {
                                      selectedValue = value!;
                                    });
                                  },
                                  title: const Text('Pay on delivery'),
                                  subtitle: const Text('Pay cash at door'),
                                ),
                                RadioListTile(
                                    value: 2,
                                    groupValue: selectedValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    },
                                    title: const Text('Pay with card'),
                                    subtitle: Row(
                                      children: const [
                                        Icon(
                                          Icons.payment,
                                          color: Colors.blue,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 15),
                                          child: Icon(
                                            FontAwesomeIcons.ccMastercard,
                                            color: Colors.blue,
                                          ),
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccVisa,
                                          color: Colors.blue,
                                        )
                                      ],
                                    )),
                                RadioListTile(
                                    value: 3,
                                    groupValue: selectedValue,
                                    onChanged: (int? value) {
                                      setState(() {
                                        selectedValue = value!;
                                      });
                                    },
                                    title: const Text('Pay with paypal'),
                                    subtitle: Row(
                                      children: const [
                                        Icon(
                                          FontAwesomeIcons.paypal,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 15,
                                        ),
                                        Icon(
                                          FontAwesomeIcons.ccPaypal,
                                          color: Colors.blue,
                                        )
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottomSheet: Container(
                    color: Colors.grey.shade200,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: YellowButton(
                          btnLabel:
                              'Confirm ${totalPaid.toStringAsFixed(2)} USD',
                          onPressed: () {
                            if (selectedValue == 1) {
                              showModalBottomSheet(
                                  context: context,
                                  builder: (context) => SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .3,
                                        child: Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 80,
                                            ),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  'Pay at door step \$${totalPaid.toStringAsFixed(2)}',
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                                YellowButton(
                                                    btnLabel:
                                                        'Confirm \$${totalPaid.toStringAsFixed(2)}',
                                                    onPressed: () async {
                                                      showProgress();
                                                      for (var item in context
                                                          .read<Cart>()
                                                          .getItems) {
                                                        CollectionReference
                                                            orderRef =
                                                            FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'orders');
                                                        orderId =
                                                            const Uuid().v4();

                                                        await orderRef
                                                            .doc(orderId)
                                                            .set({
                                                          'cid': data['cid'],
                                                          'custname':
                                                              data['name'],
                                                          'email':
                                                              data['email'],
                                                          'address':
                                                              data['address'],
                                                          'phone':
                                                              data['phone'],
                                                          'profileimage': data[
                                                              'profileimage'],
                                                          'sid': item.suppId,
                                                          'prodid':
                                                              item.doumentId,
                                                          'ordername':
                                                              item.name,
                                                          'orderid': orderId,
                                                          'orderimage': item
                                                              .imageUrl.first,
                                                          'orderqty': item.qty,
                                                          'orderprice':
                                                              item.qty *
                                                                  item.price,
                                                          'deliverystatus':
                                                              'preparing',
                                                          'deliverydate': '',
                                                          'orderdate':
                                                              DateTime.now(),
                                                          'paymentstatus':
                                                              'cash on delivery',
                                                          'orderreview': false,
                                                        }).whenComplete(
                                                                () async {
                                                          await FirebaseFirestore
                                                              .instance
                                                              .runTransaction(
                                                                  (transaction) async {
                                                            DocumentReference
                                                                documentReference =
                                                                FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'products')
                                                                    .doc(item
                                                                        .doumentId);
                                                            DocumentSnapshot
                                                                snapshot2 =
                                                                await transaction
                                                                    .get(
                                                                        documentReference);
                                                            transaction.update(
                                                                documentReference,
                                                                {
                                                                  'instock':
                                                                      snapshot2[
                                                                              'instock'] -
                                                                          item.qty
                                                                });
                                                          });
                                                        });
                                                      }
                                                      context
                                                          .read<Cart>()
                                                          .clearCart();
                                                      Navigator.popUntil(
                                                        context,
                                                        ModalRoute.withName(
                                                            '/customer_home'),
                                                      );
                                                    },
                                                    width: 0.9)
                                              ],
                                            )),
                                      ));
                            } else if (selectedValue == 2) {
                              print('paid with card');
                            } else if (selectedValue == 3) {
                              print('paid with paypal');
                            }
                          },
                          width: 1),
                    ),
                  ),
                ),
              ),
            );
          }

          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.purpleAccent,
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.purple,
              ),
            ),
          );
        });
  }
}
