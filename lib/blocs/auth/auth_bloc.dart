import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readsoil/blocs/auth/auth_event.dart';
import 'auth_state.dart';
import '../../repositories/auth_repository.dart';
import '../../repositories/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository = AuthRepository();
  final UserRepository _userRepository = UserRepository();
  late final StreamSubscription<User?> _userSubscription;

  AuthBloc() : super(AuthInitial()) {
    // Listen to Firebase Auth changes
    _userSubscription = _authRepository.authStateChanges.listen((user) {
      add(AuthUserChanged(user));
    });

    // Handle auth state change
    on<AuthUserChanged>((event, emit) async {
      final user = event.user;
      if (user != null) {
        // Ensure Firestore profile exists
        await _userRepository.createUserProfile(user);

        emit(AuthAuthenticated(
          userId: user.uid,
          displayName: user.displayName,
          email: user.email,
          photoUrl: user.photoURL,
        ));

      } else {
        emit(AuthUnauthenticated());
      }
    });

    // Email/Password login
    on<AuthLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signInWithEmail(event.email, event.password);
        // Auth state handled by stream
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Google login
    on<AuthGoogleLoginRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signInWithGoogle();
        // Stream will trigger AuthUserChanged
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Email/Password sign-up
    on<AuthSignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await _authRepository.signUp(event.email, event.password);
      } catch (e) {
        emit(AuthFailure(e.toString()));
      }
    });

    // Logout
    on<AuthLoggedOut>((event, emit) async {
      await _authRepository.signOut();
    });
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}
