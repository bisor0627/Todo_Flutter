import 'package:flutter/material.dart';

class SimpleButton extends ElevatedButton {
  const SimpleButton(
      {Key? key,
      required VoidCallback? onPressed,
      Widget? child,
      ButtonStyle? style})
      : super(
          key: key,
          onPressed: onPressed,
          style: style,
          child: child,
        );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 130,
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: child,
        style: ElevatedButton.styleFrom(primary: Colors.grey),
      ),
    );
  }
}
