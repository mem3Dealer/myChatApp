import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/services/auth.dart';
import 'package:my_chat_app/shared/input.dart';

class SignInPage extends StatefulWidget {
  // const SignInPage({Key? key}) : super(key: key);
  final Function letsToggleView;
  SignInPage({required this.letsToggleView});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  // final _auth = AuthService();
  final authCubit = GetIt.I.get<AuthCubit>();

  // String email = '';
  // String password = '';
  String error = '';
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('this is Sign In page'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: ElevatedButton.icon(
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.amber.shade700)),
              icon: Icon(Icons.person),
              label: Text('Register'),
              onPressed: () {
                widget.letsToggleView();
                // print('pressed');
              },
            ),
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  // initialValue: 'test@mail.com',
                  controller: _emailController,
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) =>
                      val!.isEmpty ? "Enter a valid email" : null,
                  // onChanged: (val) {
                  //   setState(() {
                  //     email = val;
                  //   });
                  // },
                ), // email
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  // initialValue: 'test123',
                  controller: _passwordController,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (val) =>
                      val!.length < 6 ? "Enter an password 6+ long" : null,
                  obscureText: true,
                  // onChanged: (val) {
                  //   setState(() {
                  //     password = val;
                  //   });
                  // },
                ), // password
                SizedBox(height: 20),
                ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.purple.shade900)),
                  child: Text('Sign in', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await authCubit.signIn(
                          _emailController.text, _passwordController.text);
                      // print(
                      //     "THAT PRING IS FROM PAGE IT IS ${authCubit.state.isLoggedIn}");
                      // print(
                      //     'THIS IS page signIN VERSION PRINT: ${authCubit.state.version}');
                      // setState(() => loading = true);
                      // final result = await _auth.signInWithEmailandPassword(
                      //     email, password);
                      // print(result);
                      // if (result == null) {
                      //   setState(() {
                      //     // loading = false;
                      //     error = 'we didnt manage to sign u in';
                      //   });
                      // }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text(error)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
