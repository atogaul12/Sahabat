import 'package:firebase_auth/firebase_auth.dart';
<<<<<<< HEAD
import 'ui/home_screen.dart';
import 'ui/login.dart';
import 'ui/complete_profile.dart';
=======
>>>>>>> 50b6291d45675841081e6a3830adf30598b6da2e
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/login/login_cubit.dart';
import 'bloc/register/register_cubit.dart';
import 'firebase_options.dart';
import 'ui/home_screen.dart';
import 'ui/login.dart';
import 'ui/order_screen.dart';
import 'ui/history_screen.dart';
import 'ui/account_screen.dart';
import 'ui/splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  print("Initializing Firebase...");
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ).then((_) {
    print("Firebase initialized successfully");
  }).catchError((error) {
    print("Firebase initialization failed: $error");
  });
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit())
      ],
      child: MaterialApp(
        title: "Sahabat Air",
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const InitialScreen(),
          '/home': (context) => const HomeScreen(),
          '/order': (context) => const OrderScreen(),
          '/history': (context) => const HistoryScreen(),
          '/account': (context) => const AccountScreen(),
          '/login': (context) => const LoginScreen(),
        },
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/home':
              return noAnimationPageRoute(const HomeScreen());
            case '/order':
              return noAnimationPageRoute(const OrderScreen());
            case '/history':
              return noAnimationPageRoute(const HistoryScreen());
            case '/account':
              return noAnimationPageRoute(const AccountScreen());
            case '/login':
              return noAnimationPageRoute(const LoginScreen());
            default:
              return null;
          }
        },
      ),
    );
  }
}

class InitialScreen extends StatelessWidget {
  const InitialScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        print("Checking auth state...");
        if (snapshot.connectionState == ConnectionState.waiting) {
          print("Connection state is waiting...");
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          print("User is authenticated...");
          return const HomeScreen();
        } else if (snapshot.hasError) {
          print("Auth state has error...");
          return const Center(child: Text('Something went wrong'));
        } else {
          print("User is not authenticated...");
          return const LoginScreen();
        }
      },
    );
  }
}

PageRouteBuilder noAnimationPageRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: Duration.zero,
    reverseTransitionDuration: Duration.zero,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return child;
    },
  );
}
