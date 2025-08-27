class ShippingAddressValidators {
  static String? validateFullName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Full name is required';
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

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().length < 5) {
      return 'Address must be at least 5 characters';
    }
    if (value.trim().length > 100) {
      return 'Address must be less than 100 characters';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    if (value.trim().length < 2) {
      return 'City must be at least 2 characters';
    }
    if (value.trim().length > 30) {
      return 'City must be less than 30 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(value.trim())) {
      return 'City can only contain letters, spaces, hyphens, and dots';
    }
    return null;
  }

  static String? validateState(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State/Province/Region is required';
    }
    if (value.trim().length < 2) {
      return 'State/Province/Region must be at least 2 characters';
    }
    if (value.trim().length > 30) {
      return 'State/Province/Region must be less than 30 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(value.trim())) {
      return 'State/Province/Region can only contain letters, spaces, hyphens, and dots';
    }
    return null;
  }

  static String? validateZipCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Zip code is required';
    }
    final String zipCode = value.trim();
    if (zipCode.length < 3) {
      return 'Zip code must be at least 3 characters';
    }
    if (zipCode.length > 10) {
      return 'Zip code must be less than 10 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9\s\-]+$').hasMatch(zipCode)) {
      return 'Zip code can only contain letters, numbers, spaces, and hyphens';
    }
    return null;
  }

  static String? validateCountry(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Country is required';
    }
    if (value.trim().length < 2) {
      return 'Country must be at least 2 characters';
    }
    if (value.trim().length > 30) {
      return 'Country must be less than 30 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s\-\.]+$').hasMatch(value.trim())) {
      return 'Country can only contain letters, spaces, hyphens, and dots';
    }
    return null;
  }
}
