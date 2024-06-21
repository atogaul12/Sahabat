import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/register/register_cubit.dart';

import '../utils/routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailEdc = TextEditingController();
  final passEdc = TextEditingController();
  bool passInvisible = false;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Color.fromARGB(255, 34, 97, 206),
            ),
          ),
          labelStyle: TextStyle(
            color: Colors.grey, // Default label color
          ),
          floatingLabelStyle: TextStyle(
            color: Color.fromARGB(255, 34, 97, 206), // Label color when focused
          ),
        ),
      ),
      home: Scaffold(
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterLoading) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('Loading..')));
            }
            if (state is RegisterFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.msg),
                  backgroundColor: Colors.red,
                ));
            }
            if (state is RegisterSuccess) {
              // context.read<AuthCubit>().loggedIn();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.msg),
                  backgroundColor: Colors.green,
                ));
              Navigator.pushNamedAndRemoveUntil(
                  context, rLogin, (route) => false);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
            child: ListView(
              children: [
                Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 34, 97, 206),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "Silahkan masukan e-mail dan password anda",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                TextFormField(
                  controller: emailEdc,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Masukkan email anda',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: passEdc,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Masukkan password anda',
                    prefixIcon: const Icon(Icons.lock_outline_rounded),
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(passInvisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passInvisible =
                              !passInvisible; // Toggle _isPasswordVisible ketika ikon mata ditekan
                        });
                      },
                    ),
                  ),
                  obscureText:
                      !passInvisible, // Atur obscureText berdasarkan _isPasswordVisible
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      context.read<RegisterCubit>().register(
                          email: emailEdc.text, password: passEdc.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 34, 97, 206),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Register",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    )),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Sudah punya akun ?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 34, 97, 206),
                          ),
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
