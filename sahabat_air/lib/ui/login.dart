import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sahabat_air/repositories/auth_repo.dart';
import 'package:sahabat_air/ui/home_screen.dart';
import 'package:sahabat_air/ui/phone_auth_screen.dart';
import '../bloc/login/login_cubit.dart';
import '../utils/routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailEdc = TextEditingController();
  final passEdc = TextEditingController();
  bool passInvisible = true;

  final _authRepo = AuthRepo();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
            Navigator.pushNamedAndRemoveUntil(context, rHome, (route) => false);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          child: ListView(
            children: [
              Column(
                children: [
                  Image.asset(
                    'assets/logo.png', // Path to your logo image
                    height: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Selamat Datang",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 34, 97, 206),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Halo, selamat datang di aplikasi 'Sahabat Air'\n"
                    "untuk masuk anda mengisi terlebih dahulu.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                controller: emailEdc,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'Masukkan email anda',
                  prefixIcon: Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: passEdc,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Masukkan password anda',
                  prefixIcon: const Icon(Icons.lock_outline_rounded),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
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
                obscureText: passInvisible,
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(
                      color: Color.fromARGB(255, 34, 97, 206),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<LoginCubit>()
                      .login(email: emailEdc.text, password: passEdc.text);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 34, 97, 206),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  "Login",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                      color: Colors.white),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  "atau masuk dengan",
                  style: TextStyle(
                    color: Colors.black54,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      try {
                        await _authRepo.loginWithGoogle();
                        Navigator.pushNamedAndRemoveUntil(
                            context, rHome, (route) => false);
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Login dengan Google gagal.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        'https://img2.pngdownload.id/20190228/qby/kisspng-google-logo-google-account-g-suite-google-images-g-icon-archives-search-png-5c77ad39b77471.9286340315513470017515.jpg',
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PhoneAuthScreen()));
                    },
                    child: CircleAvatar(
                      radius: 20.0,
                      backgroundImage: NetworkImage(
                        'https://freepngimg.com/thumb/business/83615-blue-icons-symbol-telephone-computer-logo.png',
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Belum punya akun ?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, rRegister);
                    },
                    child: Text(
                      "Daftar Sekarang",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 34, 97, 206)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
