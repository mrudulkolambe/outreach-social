String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Name is required';
  }

  final validCharacters = RegExp(r'^[a-zA-Z\s]+$');
  if (!validCharacters.hasMatch(value)) {
    return 'Name must not contain special characters or numbers';
  }

  return null;
}
