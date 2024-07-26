class Validator {
  static bool isValidEmail(String email) {
    // Define the regex pattern for a valid email address
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    // Check if the email matches the regex pattern
    return emailRegex.hasMatch(email);
  }
}
