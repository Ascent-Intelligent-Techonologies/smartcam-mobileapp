import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/blocs/email_auth/signup/signup_bloc.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/auth/auth_cubit.dart';
import 'package:smartcam_dashboard/views/auth/confirm/confirmation_view.dart';
import 'package:smartcam_dashboard/views/components/common_text_field.dart';
import 'package:smartcam_dashboard/views/components/exa_app_bar.dart';

class SignUpView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String username = '';

  SignUpView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const ExaAppBar(
        showLogOutButton: false,
      ),
      body: BlocProvider(
        create: (context) => SignupBloc(
            authRepository: RepositoryProvider.of<AuthRepository>(context),
            authCubit: BlocProvider.of<AuthCubit>(context)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            BlocProvider.of<AuthCubit>(context).state == AuthState.confirmSignUp
                ? ConfirmationView()
                : _signUpForm(),
            _showLoginButton(context),
          ],
        ),
      ),
    );
  }

  Widget _signUpForm() {
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupError) {
            _showSnackBar(context, 'Sign Up Failed');
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // SvgPicture.asset('assets/logo_black.svg'),
                // const SizedBox(height: 20),
                _usernameField(),
                const SizedBox(height: 8),
                _emailField(),
                const SizedBox(height: 8),
                _passwordField(),
                const SizedBox(height: 8),
                _signUpButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return CommonTextField(
      icon: const Icon(Icons.person),
      validator: validateUsername,
      hintText: 'Username',
      fieldController: _usernameController,
    );
  }

  Widget _emailField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return CommonTextField(
        fieldController: _emailController,
        icon: const Icon(Icons.person),
        hintText: 'Email',
        validator: validateEmail,
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return CommonTextField(
        fieldController: _passwordController,
        obscureText: true,
        icon: const Icon(Icons.security),
        hintText: 'Password',
        validator: validatePassword,
      );
    });
  }

  Widget _signUpButton() {
    return BlocBuilder<SignupBloc, SignupState>(builder: (context, state) {
      return state is SignupLoading
          ? SizedBox(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              height: 40,
              width: 40,
            )
          : SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll<Color>(
                        Theme.of(context).primaryColor)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<SignupBloc>().add(SignupWithCredentialsPressed(
                        email: _emailController.text,
                        password: _passwordController.text,
                        username: _usernameController.text));
                  }
                },
                child: const Text(
                  'Sign Up',
                ),
              ));
    });
  }

  Widget _showLoginButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text(
          'Already have an account? Sign in.',
          style: TextStyle(color: Theme.of(context).primaryColor),
        ),
        onPressed: () => context.read<AuthCubit>().showLogin(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
