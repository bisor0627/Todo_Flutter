import 'package:flutter/material.dart';
import 'package:todo_sqlite/config/constant.dart';

class SimpleTextField extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Stream<Object?>? stream;
  String? labelText;
  String? hintText;
  int? maxLines;
  void Function()? onTap;
  SimpleTextField(
      {Key? key,
      required this.controller,
      required this.focusNode,
      this.labelText,
      this.hintText,
      this.maxLines,
      this.onTap,
      required this.stream})
      : super(
          key: key,
        );

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: stream,
        builder: (context, snapshot) {
          return TextFormField(
            onTap: onTap,
            controller: controller,
            focusNode: focusNode,
            textInputAction: TextInputAction.go,
            onChanged: (value) {},
            onFieldSubmitted: (value) => FocusScope.of(context).unfocus(),
            decoration: InputDecoration(
                labelText: labelText, //'Details'
                labelStyle: bodyText1.override(
                  fontFamily: 'Lexend Deca',
                  color: tertiaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                hintText: hintText, //'Enter a description here...'
                hintStyle: bodyText1.override(
                  fontFamily: 'Lexend Deca',
                  color: tertiaryColor,
                  fontWeight: FontWeight.normal,
                  fontSize: 14,
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: streamColor(snapshot.data, focusNode),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: streamColor(snapshot.data, focusNode),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                )),
            maxLines: maxLines ?? 1,
            style: bodyText1,
          );
        });
  }

  Color streamColor(Object? obj, FocusNode focus) {
    String text = obj.toString().trim();
    if (focus.hasFocus == true) {
      if (text.isEmpty) {
        return Colors.redAccent;
      } else {
        return Colors.blueAccent;
      }
    } else if (focus.hasFocus && text.isEmpty) {
      return black55;
    } else {
      return black55;
    }
  }
}
