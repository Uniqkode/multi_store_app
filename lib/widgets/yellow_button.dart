import 'package:flutter/material.dart';

class YellowButton extends StatelessWidget {
  final String btnLabel;
  final Function() onPressed;
  final double width;
  const YellowButton({
    Key? key,
    required this.btnLabel,
    required this.onPressed,
    required this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: MediaQuery.of(context).size.width * width,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25), color: Colors.yellow),
      child: MaterialButton(onPressed: onPressed, child: Text(btnLabel)),
    );
  }
}
