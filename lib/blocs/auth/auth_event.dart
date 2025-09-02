import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthEvent {}

class AuthUserChanged extends AuthEvent {
  final User? user;

  AuthUserChanged(this.user);
}

class AuthLoggedOut extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  AuthLoginRequested(this.email, this.password);
}

class AuthGoogleLoginRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;

  AuthSignUpRequested(this.email, this.password);
}
