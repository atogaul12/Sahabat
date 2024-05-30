import 'package:firebase_auth/firebase_auth.dart';
import 'home_screen.dart';
import 'phone_auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login/login_cubit.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailEdc = TextEditingController();
  final passEdc = TextEditingController();
  bool passInvisible = false;

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );
    return await FirebaseAuth.instance.signInWithCredential(credential).then(
        (value) async => await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
            (route) => false));
  }

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
        body: BlocListener<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginLoading) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(content: Text('Loading..')));
            }
            if (state is LoginFailure) {
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.msg),
                  backgroundColor: Colors.red,
                ));
            }
            if (state is LoginSuccess) {
              // context.read<AuthCubit>().loggedIn();
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text(state.msg),
                  backgroundColor: Colors.green,
                ));
              Navigator.pushNamedAndRemoveUntil(
                  context, rHome, (route) => false);
            }
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
            child: ListView(
              children: [
                Text(
                  "SAHABAT AIR",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 97, 206)),
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  textAlign: TextAlign.center,
                  "Halo, selamat datang di aplikasi SAHABAT AIR, untuk masuk anda harus mengisi terlebih dahulu",
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
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(passInvisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () {
                        setState(() {
                          passInvisible = !passInvisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !passInvisible,
                ),
                SizedBox(
                  height: 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      context
                          .read<LoginCubit>()
                          .login(email: emailEdc.text, password: passEdc.text);
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 34, 97, 206),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white),
                    )),
                SizedBox(
                  height: 25,
                ),
                const SizedBox(
                  height: 30.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        signInWithGoogle();
                      },
                      child: const CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            'https://img2.pngdownload.id/20190228/qby/kisspng-google-logo-google-account-g-suite-google-images-g-icon-archives-search-png-5c77ad39b77471.9286340315513470017515.jpg'),
                      ),
                    ),
                    const SizedBox(
                      width: 30.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PhoneAuthScreen()));
                      },
                      child: const CircleAvatar(
                        radius: 20.0,
                        backgroundImage: NetworkImage(
                            'https://freepngimg.com/thumb/business/83615-blue-icons-symbol-telephone-computer-logo.png'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // Menengahkan elemen horizontal
                  children: [
                    Text("Belum punya akun ?"),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        child: Text(
                          "Daftar",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 34, 97, 206)),
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
