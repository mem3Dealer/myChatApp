import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/auth_state.dart';
import 'package:my_chat_app/cubit/cubit/room_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/models/user.dart';
import 'package:my_chat_app/pages/home.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/services/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  // WidgetsFlutterBinding.ensureInitialized();
  // print('ayy');
  GetIt.instance
    ..registerSingleton<DataBaseService>(DataBaseService())
    ..registerSingleton<UserCubit>(UserCubit())
    ..registerFactory(() => RoomCubit())
    ..registerFactory(() => AuthService())
    ..registerSingleton<AuthCubit>(AuthCubit());
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getTemporaryDirectory(),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final authCubit = GetIt.I.get<AuthCubit>();

    return MaterialApp(
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('ru', ''), // English, no country code
          // Spanish, no country code
        ],
        home: BlocBuilder<AuthCubit, AuthState>(
            bloc: authCubit,
            // value: AuthService().user,
            builder: (context, state) {
              authCubit.checkUser();

              return Wrapper();
            }));
  }
  // else {
  //   return Container();
}
