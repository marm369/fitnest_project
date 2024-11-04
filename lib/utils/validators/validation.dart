import 'package:flutter/material.dart';

class MyValidator {
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  static String? validateEmptyText(String? fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }
    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }
// Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }
    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }
// Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number. ';
    }
// Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }
// Regular expression for phone number validation (assuming a 10-digit US phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }
    return null;
  }

  static String? validateImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'Identity Image must be selected.';
    }
    return null;
  }

  static String? validateProfileImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'Profile image must be selected.';
    }
    return null;
  }

  static String? validatePasswords(String? password, String? confirmPassword) {
    if (confirmPassword != password) {
      return "Passwords do not match.";
    }
    return null;
  }

  static String? validateAcceptTerms(bool acceptTerms) {
    if (!acceptTerms) {
      return "You must accept the Privacy Policy and Terms of Use.";
    }
    return "";
  }
}
// Regular expression for phone number validation (assuming a 10-digit US phone number format)
