import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smartcam_dashboard/views/auth/auth_cubit.dart';
import 'package:smartcam_dashboard/views/auth/confirm/confirmation_view.dart';
import 'package:smartcam_dashboard/views/auth/login/login_view.dart';
import 'package:smartcam_dashboard/views/auth/signup/sign_up_view.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late final AuthCubit _authCubit;
  @override
  void initState() {
    super.initState();
    _authCubit = AuthCubit();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => _authCubit,
      child: BlocBuilder<AuthCubit, AuthState>(
          bloc: _authCubit,
          builder: (context, state) {
            if (state == AuthState.login) {
              return LoginView();
            } else {
              return SignUpView();
            }
          }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _authCubit.close();
  }
}
