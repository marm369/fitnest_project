class MyFormatException implements Exception {
  final String message;

  const MyFormatException(
      [this.message =
      'An unexpected format error occurred. Please check your input.']);

  factory MyFormatException.fromMessage(String message) {
    return MyFormatException(message);
  }

  String get formattedMessage => message;

  factory MyFormatException.fromCode(String code) {
    switch (code) {
      case 'invalid-email-format':
        return const MyFormatException(
            'The email address format is invalid. Please enter a valid email.');
      case 'invalid-phone-number-format':
        return const MyFormatException(
            'The provided phone number format is invalid. Please enter a valid number.');
      case 'invalid-date-format':
        return const MyFormatException(
            'The date format is invalid. Please enter a valid date.');
      case 'invalid-url-format':
        return const MyFormatException(
            'The URL format is invalid. Please enter a valid URL.');
      case 'invalid-credit-card-format':
        return const MyFormatException(
            'The credit card format is invalid. Please enter a valid credit card number.');
      case 'invalid-numeric-format':
        return const MyFormatException(
            'The input should be a valid numeric format.');
      default:
        return const MyFormatException(
            'An unrecognized format error occurred. Please verify your input.');
    }
  }

  @override
  String toString() {
    return 'FormatException: $message';
  }
}
