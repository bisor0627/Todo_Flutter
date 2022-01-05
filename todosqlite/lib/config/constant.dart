/*
this is constant pages
 */

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String appname = 'To-do!';

// color for apps
// ignore: constant_identifier_names
const Color primarycolor = Color(0xFF0181cc);
const Color assentcolor = Color(0xFFe75f3f);
const Color tertiaryColor = Color(0xFF95A1AC);

const Color black21 = Color(0xFF212121);
const Color black55 = Color(0xFF555555);
const Color black77 = Color(0xFF777777);
const Color softgray = Color(0xFFaaaaaa);
const Color softblue = Color(0xff01aed6);

const int statusOk = 200;
const int statusBadRequst = 400;
const int statusNotAuthorizde = 403;
const int statusNotFound = 404;
const int statusInternalError = 500;

const String errorOccured = '네트워크가 불안정합니다. 잠시 뒤에 다시 시도해주세요.';

const String grobalUrl = '';
//const String GLOBAL_URL = '';

const String serverUrl = '';
//const String SERVER_URL = '';

String primaryFontFamily = 'Poppins';
String secondaryFontFamily = 'Roboto';
TextStyle get title1 => GoogleFonts.getFont(
      'Lexend Deca',
      color: black21,
      fontWeight: FontWeight.bold,
      fontSize: 34,
    );
TextStyle get title2 => GoogleFonts.getFont(
      'Lexend Deca',
      color: black21,
      fontWeight: FontWeight.bold,
      fontSize: 24,
    );
TextStyle get title3 => GoogleFonts.getFont(
      'Lexend Deca',
      color: black21,
      fontWeight: FontWeight.bold,
      fontSize: 20,
    );
TextStyle get subtitle1 => GoogleFonts.getFont(
      'Lexend Deca',
      color: tertiaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 18,
    );
TextStyle get subtitle2 => GoogleFonts.getFont(
      'Lexend Deca',
      color: black21,
      fontWeight: FontWeight.normal,
      fontSize: 16,
    );
TextStyle get bodyText1 => GoogleFonts.getFont(
      'Lexend Deca',
      color: black21,
      fontWeight: FontWeight.normal,
      fontSize: 14,
    );
TextStyle get bodyText2 => GoogleFonts.getFont(
      'Lexend Deca',
      color: tertiaryColor,
      fontWeight: FontWeight.normal,
      fontSize: 12,
    );

extension TextStyleHelper on TextStyle {
  TextStyle override({
    required String fontFamily,
    required Color color,
    required double fontSize,
    required FontWeight fontWeight,
    bool useGoogleFonts = true,
  }) =>
      useGoogleFonts
          ? GoogleFonts.getFont(
              fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
            )
          : copyWith(
              fontFamily: fontFamily,
              color: color,
              fontSize: fontSize,
              fontWeight: fontWeight,
              fontStyle: fontStyle,
            );
}
