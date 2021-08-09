import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:my_chat_app/cubit/cubit/auth_cubit.dart';
import 'package:my_chat_app/cubit/cubit/user_cubit.dart';
import 'package:my_chat_app/services/database.dart';
import 'package:my_chat_app/shared/input.dart';

class RegisterPage extends StatefulWidget {
  // const RegisterPage({Key? key}) : super(key: key);
  final Function? letsToggleView;
  RegisterPage({required this.letsToggleView});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  // final _auth = AuthService();
  final data = DataBaseService();
  final userCubit = GetIt.I.get<UserCubit>();
  final authCubit = GetIt.I.get<AuthCubit>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  // String email = '';
  // Sng email = '';
  // String email = '';
  // String password = '';
  // String error = 'this';
  // String name = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.all(7.0),
            child: ElevatedButton.icon(
              icon: Icon(Icons.person),
              label: Text('Sign In'),
              onPressed: () {
                widget.letsToggleView!();
                print('pressed');
              },
            ),
          )
        ],
        title: Text('this is register page'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: textInputDecoration.copyWith(
                      hintText: 'What`s your name?'),
                  validator: (val) =>
                      val!.isEmpty ? "introduce yourself" : null,
                  // onChanged: (val) {
                  //   setState(() {
                  //     name = val;
                  //     // data.updateCurrentUser(name);
                  //   });
                  // },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (val) => val!.isEmpty ? "Enter an email" : null,
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
                  child:
                      Text('Register', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      authCubit.registrate(_nameController.text,
                          _emailController.text, _passwordController.text);
                    }
                    // print("email: $email");
                    // print("password: $password");
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Text('')
              ],
            ),
          ),
        ),
      ),
    );
  }
}
