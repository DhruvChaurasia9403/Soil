
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/auth/auth_bloc.dart';
import '../blocs/auth/auth_event.dart';
import '../blocs/auth/auth_state.dart';
import '../utils/validators.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

enum AuthMode { login, signup }

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  AuthMode _authMode = AuthMode.login;

  void _switchAuthMode() {
    setState(() {
      _authMode =
      _authMode == AuthMode.login ? AuthMode.signup : AuthMode.login;
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final authBloc = context.read<AuthBloc>();
    if (_authMode == AuthMode.login) {
      authBloc.add(AuthLoginRequested(
          _emailController.text.trim(), _passwordController.text.trim()));
    } else {
      authBloc.add(AuthSignUpRequested(
          _emailController.text.trim(), _passwordController.text.trim()));
    }
  }

  void _loginWithGoogle() {
    context.read<AuthBloc>().add(AuthGoogleLoginRequested());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).scaffoldBackgroundColor,
            ],
          ),
        ),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.redAccent,
                  ),
                );
            }
          },
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.eco_outlined,
                      size: 64, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(height: 16),
                  Text(
                    'Welcome to ReadSoil',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary),
                  ),
                  Text(
                    _authMode == AuthMode.login
                        ? 'Sign in to continue'
                        : 'Create a new account',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 40),
                  _buildForm(context),
                  const SizedBox(height: 24),
                  _buildSocialLogin(context),
                ],
              ).animate().fadeIn(duration: 500.ms),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    final isLoading = context.watch<AuthBloc>().state is AuthLoading;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
                labelText: 'Email', prefixIcon: Icon(Icons.alternate_email)),
            keyboardType: TextInputType.emailAddress,
            validator: (val) =>
            Validators.isValidEmail(val ?? '') ? null : 'Enter a valid email',
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            decoration: const InputDecoration(
                labelText: 'Password', prefixIcon: Icon(Icons.lock_outline)),
            obscureText: true,
            validator: (val) => Validators.isValidPassword(val ?? '')
                ? null
                : 'Password must be 8+ chars, with uppercase, digit, special char',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
              onPressed: _submit,
              child: Text(
                  _authMode == AuthMode.login ? 'Login' : 'Sign Up'),
            ),
          ),
          TextButton(
            onPressed: _switchAuthMode,
            child: Text(_authMode == AuthMode.login
                ? "Don't have an account? Sign Up"
                : "Already have an account? Login"),
          ),
        ]
            .animate(interval: 100.ms)
            .slideY(begin: 0.5, end: 0, curve: Curves.easeOutCubic)
            .fadeIn(),
      ),
    );
  }

  Widget _buildSocialLogin(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text('OR'),
            ),
            Expanded(child: Divider()),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            icon: Image.asset('assets/ic_login_google.png', height: 20),
            label: const Text('Continue with Google'),
            onPressed: context.watch<AuthBloc>().state is AuthLoading
                ? null
                : _loginWithGoogle,
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              side: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
      ],
    ).animate().fadeIn(delay: 500.ms);
  }
}

