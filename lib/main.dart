
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_cart/Api_Servide.dart';
import 'package:zybo_cart/Screens/BottomNavigation.dart';
import 'package:zybo_cart/Screens/LoginScreen.dart';
import 'package:zybo_cart/Screens/NameScreen.dart';
import 'package:zybo_cart/Screens/OTPverification.dart';
import 'package:zybo_cart/Screens/SplashScreen.dart';
import 'package:zybo_cart/bloc/authentication_bloc.dart';
import 'package:zybo_cart/bloc/product_bloc.dart';
import 'package:zybo_cart/bloc/profile_bloc.dart';
import 'package:zybo_cart/bloc/wishlist_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final apiRepository = ApiRepository();

  runApp(MyApp(prefs: prefs, apiRepository: apiRepository));
}

class MyApp extends StatelessWidget {
  final SharedPreferences prefs;
  final ApiRepository apiRepository;

  const MyApp({
    Key? key,
    required this.prefs,
    required this.apiRepository,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc(apiRepository, prefs)),
        BlocProvider(create: (context) => ProductsBloc(apiRepository, prefs)),
        BlocProvider(create: (context) => WishlistBloc(apiRepository, prefs)),
        BlocProvider(create: (context) => ProfileBloc(apiRepository, prefs)),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Spice App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'System',
        ),
        home: const SplashScreen(),
        routes: {
          '/splash' : (context) => const SplashScreen(),
          '/login': (context) => const LoginScreen(),
          '/otp': (context) => const OtpVerificationScreen(),
          '/name': (context) => const NameEntryScreen(),
          '/home': (context) => const MainNavigationScreen(),
        },
      ),
    );
  }
}

