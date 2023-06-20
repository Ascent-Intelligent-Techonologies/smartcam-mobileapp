import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smartcam_dashboard/blocs/session_cubit/session_cubit.dart';
import 'package:smartcam_dashboard/data/repositories/auth_repository.dart';

class ExaAppBar extends StatefulWidget implements PreferredSizeWidget {
  final bool showLogOutButton;
  const ExaAppBar({super.key, this.showLogOutButton = false});

  @override
  State<ExaAppBar> createState() => _ExaAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(55);
}

class _ExaAppBarState extends State<ExaAppBar> {
  late final AuthRepository _authRepo;
  @override
  void initState() {
    super.initState();
    _authRepo = RepositoryProvider.of<AuthRepository>(context);
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.black),
      // iconTheme: IconThemeData(color: Colors.black),
      systemOverlayStyle: const SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: SafeArea(
        child: Center(
            child: Hero(
                tag: 'exwzdlogo',
                child: SvgPicture.asset('assets/logo_black.svg'))),
      ),
      actionsIconTheme: IconThemeData(color: Colors.black),
      actions: [
        widget.showLogOutButton
            ? IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  BlocProvider.of<SessionCubit>(context).signOut();
                },
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
