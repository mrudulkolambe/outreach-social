String? usernameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Username is required';
  }

  final length = value.length;
  if (length < 6 || length > 20) {
    return 'Username must be between 6 and 20 characters long';
  }

  final invalidCharacters = RegExp(r'[A-Z0-9_\s]');
  if (invalidCharacters.hasMatch(value)) {
    return 'Username must not contain uppercase letters, numbers, spaces, or underscores';
  }

  return null;
}
