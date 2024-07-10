import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextStyleConstants {
  static final TextStyle onBoardingTitle = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 52);

  static final TextStyle tabBarTitle = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 26);

  static final TextStyle title = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 20);

  static final TextStyle headline1 = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 18);

  static final TextStyle headline2 = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 16);

  static final TextStyle semiMedium = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14);

  static final TextStyle medium = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14);

  static final TextStyle semiNormal = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 13);

  static final TextStyle normal = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 13);

  static final TextStyle loginButtonTitle = TextStyle(
      color: Colors.white70,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w700,
      fontSize: 20);

  static final TextStyle recipeContent = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 15);

  static final TextStyle recipeContentBold = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 15);

  static final TextStyle validText = TextStyle(
      color: const Color(0xFF20F42F),
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 13);

  static final TextStyle inputText = TextStyle(
      color: Colors.black54,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 13);

  static final TextStyle invalidText = TextStyle(
      color: Colors.black54,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14);
}

class ImageConstants {
  static const String onBoardingBackground =
      'assets/images/onBoardingBackground.jpg';
  static const String loginBackground = 'assets/images/loginBackground3.jpg';
  static const String recipeBackground = 'assets/images/recipeBackground.jpg';
  static const String recipeDarkBackground =
      'assets/images/recipeDarkBackground.jpg';
}

class IconConstants {
  //Icon path
  static const String caloriesIcon = 'assets/icons/calories.svg';
  static const String chefHatIcon = 'assets/icons/chef_hat.svg';
  static const String clockIcon = 'assets/icons/clock.svg';
  static const String allergensIcon = 'assets/icons/allergens.svg';
  static const String ingredientsIcon = 'assets/icons/ingredients.svg';
  static const String instructionsIcon = 'assets/icons/instructions.svg';
  static const String nutritionIcon = 'assets/icons/nutrition.svg';
  static const String servingsIcon = 'assets/icons/servings.svg';
  static const String logoutIcon = 'assets/icons/logout.svg';
  static const String accountIcon = 'assets/icons/account.svg';

  //Icon Data
  static const IconData iconPassword = Icons.lock_outline;
  static const IconData iconMail = Icons.mail;
  static const IconData iconHidePassword = Icons.visibility;
  static const IconData iconShowPassword = Icons.visibility_off;
}

class Constants {
  static const List<String> extraBadWords = [
    'json',
    'result',
    'results',
    'put',
    'enter',
    'remove',
    'add',
    'give',
    'put',
    'entered',
    'removed',
    'added',
    'given',
    'nothing',
    'empty',
    "'",
    '"',
    '[',
    ']',
    '{',
    '}',
    '(',
    ')',
    '<',
    '>',
    '~',
    '!',
    '@',
    '#',
    '%',
    '*',
    '+',
    '-',
    '=',
    '^',
    '&'
  ];
  static const String rejectEmailString = r'^[\w-\.]+@([\w-]+.)+[\w-]{2,4}$';
  static const String rejectPasswordString =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^]).{8,}$';
}
