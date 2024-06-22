import 'package:flutter/material.dart';
import '../ui/home_screen.dart';
import '../ui/login.dart';
import '../ui/register.dart';
import '../ui/complete_profile.dart';
import '../ui/news_screen.dart';
import '../ui/news_detail_screen.dart';
import '../models/news_model.dart';

MaterialPageRoute _pageRoute(
        {required Widget body, required RouteSettings settings}) =>
    MaterialPageRoute(builder: (_) => body, settings: settings);

Route? generateRoute(RouteSettings settings) {
  Route? _route;
  final _args = settings.arguments;

  switch (settings.name) {
    case rLogin:
      _route = _pageRoute(body: LoginScreen(), settings: settings);
      break;
    case rRegister:
      _route = _pageRoute(body: RegisterScreen(), settings: settings);
      break;
    case rHome:
      _route = _pageRoute(body: HomeScreen(), settings: settings);
      break;
    case rCompleteProfile:
      _route = _pageRoute(body: CompleteProfileScreen(), settings: settings);
      break;
    case rNews:
      _route = _pageRoute(body: NewsScreen(), settings: settings);
      break;
    case rNewsDetail:
      if (_args is News) {
        _route = _pageRoute(body: NewsDetailScreen(news: _args), settings: settings);
      }
      break;
  }
  return _route;
}

final NAV_KEY = GlobalKey<NavigatorState>();
const String rLogin = '/login';
const String rRegister = '/register';
const String rHome = '/home';
const String rCompleteProfile = '/complete_profile';
const String rNews = '/news';
const String rNewsDetail = '/news_detail';
