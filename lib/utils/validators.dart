class Validators {
  static final RegExp _emailRegExp =
  RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$');

  static final RegExp _passwordRegExp =
  RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*\W).{8,}$');

  static bool isValidEmail(String email) {
    return _emailRegExp.hasMatch(email);
  }

  static bool isValidPassword(String password) {
    return _passwordRegExp.hasMatch(password);
  }
}
