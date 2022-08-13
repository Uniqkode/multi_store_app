import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multi_store_app/customer_components/cust_orders.dart';
import 'package:multi_store_app/customer_components/wishlist.dart';
import 'package:multi_store_app/main_screen/cart.dart';
import 'package:multi_store_app/widgets/appBar_widgets.dart';

import '../widgets/alert_dialog.dart';

class ProfileScreen extends StatefulWidget {
  final String documentId;
  const ProfileScreen({
    Key? key,
    required this.documentId,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    CollectionReference customers =
        FirebaseFirestore.instance.collection('customers');
    return FutureBuilder<DocumentSnapshot>(
      future: customers.doc(widget.documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text("Something went wrong"));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Center(child: Text("Document does not exist"));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            backgroundColor: Colors.grey.shade300,
            body: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Colors.yellow, Colors.brown])),
                ),
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      pinned: true,
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.white,
                      expandedHeight: 140,
                      flexibleSpace: LayoutBuilder(
                        builder: ((context, constraints) {
                          return FlexibleSpaceBar(
                            title: AnimatedOpacity(
                              opacity:
                                  constraints.biggest.height <= 120 ? 1 : 0,
                              duration: const Duration(milliseconds: 200),
                              child: const Text(
                                'Account',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                            background: Container(
                              height: 230,
                              decoration: const BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.yellow, Colors.brown],
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 25, left: 30),
                                child: Row(
                                  children: [
                                    data['profileimage'] == ''
                                        ? const CircleAvatar(
                                            radius: 50,
                                            backgroundImage: AssetImage(
                                                'images/inapp/guest.jpg'),
                                          )
                                        : CircleAvatar(
                                            radius: 50,
                                            backgroundImage: NetworkImage(
                                              data['profileimage'],
                                            ),
                                          ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 25),
                                      child: Text(
                                        data['name'] == ''
                                            ? 'guest'.toUpperCase()
                                            : data['name'].toUpperCase(),
                                        style: const TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          Container(
                            height: 80,
                            width: MediaQuery.of(context).size.width * 0.9,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.black54,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        bottomLeft: Radius.circular(30),
                                      )),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CartScreen(
                                            back: AppBarBackButton(),
                                          ),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: const Center(
                                        child: Text(
                                          'Cart',
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.yellow,
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CustomerOrder(),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: const Center(
                                        child: Text(
                                          'Orders',
                                          style: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      bottomRight: Radius.circular(30),
                                    ),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const Wishlist(),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      height: 40,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: const Center(
                                        child: Text(
                                          'Wishlist',
                                          style: TextStyle(
                                              color: Colors.yellow,
                                              fontSize: 20),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            color: Colors.grey.shade300,
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 150,
                                  child: Image(
                                    image: AssetImage('images/inapp/logo.jpg'),
                                  ),
                                ),
                                const ProfileHeaderLabel(
                                  headerLabel: '  Account Info.  ',
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                            icon: Icons.email,
                                            // onpressed: () {},
                                            subtitle: data['email'] == ''
                                                ? 'name@email.com'
                                                : data['email'],
                                            title: 'Email Address'),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                            icon: Icons.phone,
                                            // onpressed: () {},
                                            subtitle: data['phone'] == ''
                                                ? '+11111'
                                                : data['phone'],
                                            title: 'Phone No.'),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                            icon: Icons.location_pin,
                                            // onpressed: () {},
                                            subtitle: data['address'] == ''
                                                ? '23b detroy ST'
                                                : data['address'],
                                            title: 'Address'),
                                      ],
                                    ),
                                  ),
                                ),
                                const ProfileHeaderLabel(
                                    headerLabel: '  Account Settings  '),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 260,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      children: [
                                        RepeatedListTile(
                                          title: 'Edit Profile',
                                          icon: Icons.edit,
                                          onpressed: () {},
                                        ),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                            icon: Icons.lock,
                                            onpressed: () {},
                                            title: 'Change Password'),
                                        const YellowDivider(),
                                        RepeatedListTile(
                                            icon: Icons.logout,
                                            onpressed: () async {
                                              MyAlertDialog.showMyDialog(
                                                context: context,
                                                contentText:
                                                    'Do you want to logout',
                                                title: 'Log out',
                                                tabNo: () {
                                                  Navigator.pop(context);
                                                },
                                                tabYes: () async {
                                                  await FirebaseAuth.instance
                                                      .signOut();
                                                  Navigator.pop(context);
                                                  Navigator
                                                      .pushReplacementNamed(
                                                    context,
                                                    '/welcome_screen',
                                                  );
                                                },
                                              );
                                            },
                                            title: 'Log Out'),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
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
      },
    );
  }
}

class YellowDivider extends StatelessWidget {
  const YellowDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Divider(
        color: Colors.yellow,
        thickness: 1,
      ),
    );
  }
}

class RepeatedListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Function()? onpressed;
  const RepeatedListTile(
      {Key? key,
      required this.icon,
      this.onpressed,
      this.subtitle = '',
      required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpressed,
      child: ListTile(
        title: Text(title),
        subtitle: Text(subtitle),
        leading: Icon(icon),
      ),
    );
  }
}

class ProfileHeaderLabel extends StatelessWidget {
  final String headerLabel;
  const ProfileHeaderLabel({Key? key, required this.headerLabel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
          Text(
            headerLabel,
            style: const TextStyle(
                fontSize: 24, color: Colors.grey, fontWeight: FontWeight.w600),
          ),
          const SizedBox(
            height: 40,
            width: 50,
            child: Divider(
              color: Colors.grey,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
