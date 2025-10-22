class AdminWhitelist {
  static const Set<String> emails = {'sandro.bucciarelli89@gmail.com'};

  static final Set<String> _normalizedEmails = emails
      .map((email) => email.trim().toLowerCase())
      .toSet();

  static bool contains(String? email) {
    if (email == null) return false;
    return _normalizedEmails.contains(email.trim().toLowerCase());
  }
}
