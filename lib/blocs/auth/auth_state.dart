abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final String userId;
  final String? displayName;
  final String? email;
  final String? photoUrl;

  AuthAuthenticated({
    required this.userId,
    this.displayName,
    this.email,
    this.photoUrl,
  });
}

class AuthUnauthenticated extends AuthState {}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
