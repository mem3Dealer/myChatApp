import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/auth_state.dart';
import 'package:my_chat_app/pages/authenticate.dart';
import 'package:my_chat_app/pages/home.dart';

class Wrapper extends StatelessWidget {
  // const Wrapper({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final user = Provider.of<MyUser?>(context);
    final _auth = GetIt.I.get<FirebaseAuth>();
    final authCubit = GetIt.I.get<AuthCubit>();
    // print(user);
    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        if (_auth.currentUser != null
            // || state.isLoggedIn == true
            ) {
          return HomePage();
        } else {
          return Authenticate();
        }
      },
    );
  }
}
