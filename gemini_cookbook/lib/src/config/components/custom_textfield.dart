import 'package:flutter/material.dart';

// CustomTextField is a reusable widget for text input fields with customizable styles and properties.
class CustomTextField extends StatelessWidget {
  // Common properties for both the container and the text field.
  final double width; // Width of the container and text field.
  final String text; // Placeholder text for the text field.
  final Icon prefixIcon; // Icon to display inside the text field.
  final TextEditingController
      textEditingController; // Controller for the text input.
  final bool
      obscureText; // Whether the text field should hide the text. Useful for passwords.
  final String? Function(String?)? onChanged;

  // Container-specific properties for styling the outer container of the text field.
  final double?
      containerBorderRadius; // Border radius of the container. Optional.
  final Color? containerColor; // Background color of the container. Optional.

  // Text field-specific properties for configuring the behavior and appearance of the text field.
  final String? Function(String?)?
      validator; // Function to validate the input. Optional.
  final String?
      errorMsg; // Error message to display if validation fails. Optional.
  final TextStyle? style; // Text style for the input text. Optional.
  final Color? prefixIconColor; // Color of the prefix icon. Optional.
  final Color? suffixIconColor; // Color of the suffix icon. Optional
  final EdgeInsetsGeometry? padding; // Padding inside the text field. Optional.
  final FocusNode?
      focusNode; // Focus node for managing keyboard focus. Optional.
  final Widget? suffixIcon;

  // Constructor for initializing the CustomTextField with required and optional parameters.
  const CustomTextField(
      {super.key,
      required this.width,
      required this.text,
      required this.prefixIcon,
      required this.textEditingController,
      required this.obscureText,
      this.containerBorderRadius,
      this.containerColor,
      this.validator,
      this.errorMsg,
      this.style,
      this.prefixIconColor,
      this.suffixIconColor,
      this.padding,
      this.focusNode,
      this.suffixIcon,
      this.onChanged});

  @override
  Widget build(BuildContext context) {
    // Building the widget tree for CustomTextField.
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),

      width: width, // Set the width of the container.
      child: TextFormField(
        onChanged: onChanged,
        validator: validator,
        obscureText: obscureText, // Set whether to obscure text.
        textAlignVertical:
            TextAlignVertical.center, // Align text vertically in the center.
        style: style, // Apply text style.
        decoration: InputDecoration(
            fillColor: containerColor,
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.transparent),
              borderRadius:
                  BorderRadius.all(Radius.circular(containerBorderRadius ?? 0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.7),
              borderRadius: const BorderRadius.all(Radius.circular(8)),
            ),
            suffixIcon: suffixIcon,
            suffixIconColor: suffixIconColor,
            prefixIcon: prefixIcon, // Display an icon inside the text field.
            prefixIconColor: prefixIconColor, // Set the color of the icon.
            contentPadding: padding, // Set padding inside the text field.
            hintText: text, // Display placeholder text.
            hintStyle: style),
        controller: textEditingController, // Set the text controller.
        focusNode: focusNode, // Set the focus node.
      ),
    );
  }
}
