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

  static final TextStyle recipeContent = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 15);

  static final TextStyle recipeContentBold = TextStyle(
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 12);

  static final TextStyle stepTitle = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 18);

  static final TextStyle validText = TextStyle(
      color: const Color(0xFF20F42F),
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 13);

  static final TextStyle linkText = TextStyle(
      color: Colors.blue,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14);

  static final TextStyle invalidText = TextStyle(
      color: Colors.black87,
      fontFamily: GoogleFonts.poppins().fontFamily,
      fontWeight: FontWeight.w600,
      fontSize: 14);

  static final TextStyle snackBarText = TextStyle(
      fontFamily: GoogleFonts.roboto().fontFamily,
      fontWeight: FontWeight.w500,
      fontSize: 14,
      color: const Color(0xFFD0BCFF));
}

class ImageConstants {
  static const String onBoardingBackground =
      'assets/images/onBoardingBackground.jpg';
  static const String loginBackground = 'assets/images/loginBackground1.jpg';
  static const String loginDarkBackground =
      'assets/images/loginBackground3.jpg';
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
  static const String upIcon = 'assets/icons/expand_circle_up.svg';
  static const String downIcon = 'assets/icons/expand_circle_down.svg';
  static const String youtubeIcon = 'assets/icons/youtube.svg';
  static const String mealIcon = 'assets/icons/meal.svg';
  static const String unsavedRecipeIcon = 'assets/icons/unsavedRecipe.svg';
  static const String savedRecipeIcon = 'assets/icons/savedRecipe.svg';
  static const String recipeSavingScreenIcon = 'assets/icons/recipe.svg';

  //Icon Data
  static const IconData iconPassword = Icons.lock_outline;
  static const IconData iconMail = Icons.mail;
  static const IconData iconName = Icons.person;
  static const IconData iconHidePassword = Icons.visibility;
  static const IconData iconShowPassword = Icons.visibility_off;
}

class LottieConstants {
  static const String cookingAnimation = 'assets/lottie/cooking_animation.json';
  static const String noRecipeAnimation =
      'assets/lottie/noRecipe_animation.json';
  static const String makeRecipeAnimation = 'assets/lottie/food_animation.json';
}

class Constants {
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(4));
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
  static const String rejectNameString =
      r'^[A-Za-z0-9](?!.*\s{2})[A-Za-z0-9\s]{0,23}[A-Za-z0-9]$';
  static const String rejectEmailString =
      r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
      r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
      r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
      r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
      r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
      r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
      r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
  static const String rejectPasswordString =
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])(?!.*\s).{8,}$';
}
