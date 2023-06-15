import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartcam_dashboard/blocs/email_auth/confirmation/confirmation_bloc.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_cubit.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';
import 'package:smartcam_dashboard/views/auth/auth_cubit.dart';
import 'package:smartcam_dashboard/views/components/common_text_field.dart';

class ConfirmationView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  ConfirmationView();
  final TextEditingController _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ConfirmationBloc(
          authRepository: RepositoryProvider.of<AuthRepository>(context),
          sessionCubit: BlocProvider.of<SessionCubit>(context)),
      child: _confirmationForm(),
    );
  }

  Widget _confirmationForm() {
    return BlocListener<ConfirmationBloc, ConfirmationState>(
        listener: (context, state) {
          if (state is ConfirmationError) {
            _showSnackBar(context, state.message);
          } else if (state is ConfirmationSuccess) {
            _showSnackBar(context, 'Sign up successful!');
            BlocProvider.of<AuthCubit>(context).showLogin();
          }
        },
        child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _codeField(),
                SizedBox(height: 8),
                _confirmButton(),
              ],
            ),
          ),
        ));
  }

  Widget _codeField() {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
        builder: (context, state) {
      return CommonTextField(
        fieldController: _codeController,
        icon: Icon(Icons.person),
        hintText: 'Confirmation Code',
        validator: (value) => value != null && value.length == 6
            ? null
            : 'Invalid confirmation code',
      );
    });
  }

  Widget _confirmButton() {
    return BlocBuilder<ConfirmationBloc, ConfirmationState>(
        builder: (context, state) {
      return state is ConfirmationLoading
          ? SizedBox(
              child: CircularProgressIndicator(
                  color: Theme.of(context).primaryColor),
              height: 40,
              width: 40,
            )
          : ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll<Color>(
                      Theme.of(context).primaryColor)),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  context.read<ConfirmationBloc>().add(
                      ConfirmationCodeSubmitPressed(
                          code: _codeController.text,
                          username: BlocProvider.of<AuthCubit>(context)
                              .credentials
                              .username!));
                }
              },
              child: Text('Confirm'),
            );
    });
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
