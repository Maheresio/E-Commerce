class PaymentCardValidators {
  static String? validateNameOnCard(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Name on card is required';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (value.trim().length > 50) {
      return 'Name must be less than 50 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters, spaces, hyphens, and dots';
    }
    return null;
  }

  static String? validateCardNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Card number is required';
    }
    final String cardNumber = value.replaceAll(RegExp(r'\s+'), '');
    if (cardNumber.length < 13 || cardNumber.length > 19) {
      return 'Card number must be between 13-19 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(cardNumber)) {
      return 'Card number can only contain digits';
    }
    if (!_isValidLuhn(cardNumber)) {
      return 'Invalid card number';
    }
    return null;
  }

  static String? validateExpireDate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Expire date is required';
    }
    if (!RegExp(r'^(0[1-9]|1[0-2])\/([0-9]{2})$').hasMatch(value.trim())) {
      return 'Enter date in MM/YY format';
    }
    final List<String> parts = value.trim().split('/');
    final int month = int.parse(parts[0]);
    final int year = int.parse('20${parts[1]}');
    final DateTime now = DateTime.now();
    final DateTime expiry = DateTime(year, month);
    if (expiry.isBefore(DateTime(now.year, now.month))) {
      return 'Card has expired';
    }
    return null;
  }

  static String? validateSecurityCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Security code is required';
    }
    if (value.trim().length < 3 || value.trim().length > 4) {
      return 'Security code must be 3-4 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'Security code can only contain digits';
    }
    return null;
  }

  static bool _isValidLuhn(String cardNumber) {
    var sum = 0;
    var alternate = false;
    for (var i = cardNumber.length - 1; i >= 0; i--) {
      var n = int.parse(cardNumber[i]);
      if (alternate) {
        n *= 2;
        if (n > 9) {
          n = (n % 10) + 1;
        }
      }
      sum += n;
      alternate = !alternate;
    }
    return sum % 10 == 0;
  }
}
