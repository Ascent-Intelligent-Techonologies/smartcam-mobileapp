import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartcam_dashboard/blocs/email_auth/login/login_bloc.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_cubit.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/utils/utils.dart';
import 'package:smartcam_dashboard/views/auth/auth_cubit.dart';
import 'package:smartcam_dashboard/views/components/common_text_field.dart';
import 'package:smartcam_dashboard/views/components/exa_app_bar.dart';

class LoginView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: ExaAppBar(
        showLogOutButton: false,
      ),
      body: BlocProvider(
        create: (context) => LoginBloc(
            repository: RepositoryProvider.of<AuthRepository>(context),
            sessionCubit: BlocProvider.of<SessionCubit>(context)),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            _loginForm(),
            _showSignUpButton(context),
          ],
        ),
      ),
    );
  }

  Widget _loginForm() {
    return BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoginError) {
            _showSnackBar(context, 'Login Failed');
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Hero(
                //     tag: 'exwzdlogo',
                //     child: SvgPicture.asset('assets/logo_black.svg')),
                // const SizedBox(height: 20),
                _usernameField(),
                const SizedBox(height: 8),
                _passwordField(),
                const SizedBox(height: 8),
                _loginButton(),
              ],
            ),
          ),
        ));
  }

  Widget _usernameField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return CommonTextField(
        fieldController: _usernameController,
        icon: Icon(Icons.person),
        hintText: 'Username',
        validator: validateUsername,
      );
    });
  }

  Widget _passwordField() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return CommonTextField(
        fieldController: _passwordController,
        obscureText: true,
        icon: Icon(Icons.security),
        hintText: 'Password',
        validator: validatePassword,
      );
    });
  }

  Widget _loginButton() {
    return BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
      return state is LoginLoading
          ? SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            )
          : SizedBox(
              height: 40,
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                    padding: MaterialStatePropertyAll(EdgeInsets.zero)),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    context.read<LoginBloc>().add(LoginWithCredentialsPressed(
                        email: _usernameController.text,
                        password: _passwordController.text));
                  }
                },
                child: Text('Login'),
              ),
            );
    });
  }

  Widget _showSignUpButton(BuildContext context) {
    return SafeArea(
      child: TextButton(
        child: Text('Don\'t have an account? Sign up.',
            style: TextStyle(color: Theme.of(context).primaryColor)),
        onPressed: () => context.read<AuthCubit>().showSignUp(),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
