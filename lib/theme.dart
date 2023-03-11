import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

double defaultMargin = 16.0;
double ArtikelMargin = 5.0;

class MyColors {
  static Color blackText = Color(0xFF1C1E1D);
  static Color green = Color(0xFF00880C);
  static Color white = Color(0xFFFFFFFF);
  static Color grey = Color(0xFFBBBBBB);
  static Color softGrey = Color(0xFFE8E8E8);
}

//size font
class MyFontSize {
  static double small1 = 8;
  static double small2 = 10;
  static double small3 = 12;
  static double medium1 = 14;
  static double medium2 = 16;
  static double large1 = 18;
  static double large2 = 20;
  static double large3 = 22;
}

Color accentColor2 = Color(0xFFFBD460);

Color primaryColor = Color(0xff368983);
//Color primaryColor = Color(0xFF1E88E5);
Color secondaryColor = Color(0xFF38ABBE);
Color alertColor = Color(0xFFED6363);
Color priceColor = Color(0xFF2C96F1);
Color greyLightColor = Color(0xffADADAD);
Color bgColor1 = Color(0xFF4AB581);
Color bgColor2 = Color(0xFF2B2937);
Color bgColor3 = Color(0xFF242231);
Color bgColor4 = Color(0xFF302F37);
Color bgColor5 = Color(0xFF2B2844);
Color bgColor6 = Color(0xFF252836);
Color bgColor7 = Color(0xFFECEDEF);
Color bgColor8 = Color(0xFFFFFFFF);
Color transparent = Colors.transparent;

//Color Palette for Text
Color primaryTextColor = Color(0xFF4AB581);

Color secondaryTextColor = Color(0xFF999999);
Color subtitleTextColor = Color(0xFF504F5E);
Color button_TextColor = Color(0xFFFFFFFF);
Color text_bar = Color(0xFF212121);

TextStyle primaryTextStyle = GoogleFonts.roboto(color: primaryTextColor);
TextStyle secondaryTextStyle = GoogleFonts.roboto(color: secondaryTextColor);
TextStyle priceTextStyle = GoogleFonts.roboto(color: priceColor);
TextStyle subtitleTextStyle = GoogleFonts.roboto(color: subtitleTextColor);
TextStyle hyperLinkStyle = GoogleFonts.roboto(color: primaryColor);
TextStyle productCardTextStyle = GoogleFonts.roboto(color: Color(0xff2E2E2E));
TextStyle button_TextStyle = GoogleFonts.roboto(color: button_TextColor);
TextStyle text_barStyle = GoogleFonts.roboto(color: text_bar);
TextStyle sub_nameuser_TextSyle = GoogleFonts.roboto(color: Color(0xFFE8E8E8));
TextStyle yellowNumberFont =
    GoogleFonts.quicksand().copyWith(color: accentColor2);

TextStyle blackTextFont = GoogleFonts.raleway()
    .copyWith(color: Colors.black, fontWeight: FontWeight.w500);

TextStyle alertTextStyle = GoogleFonts.poppins(
  color: alertColor,
);
TextStyle lightTextStyle =
    GoogleFonts.firaSans().copyWith(fontWeight: FontWeight.w300);

FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;
