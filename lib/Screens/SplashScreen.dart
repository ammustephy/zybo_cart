import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_cart/bloc/authentication_bloc.dart';
import 'package:zybo_cart/bloc/authentication_event.dart';
import 'package:zybo_cart/bloc/authentication_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Add 3 second delay to show the logo before checking auth status
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        context.read<AuthBloc>().add(CheckAuthStatus());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Navigator.pushReplacementNamed(context, '/home');
        } else if (state is AuthUnauthenticated) {
          Navigator.pushReplacementNamed(context, '/login');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Image.asset(
            "Assets/Images/logo.jpg",
            width: 200,
            height: 200,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              // This will show if image fails to load
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 50, color: Colors.red),
                  Text('Image not found: $error'),
                  SizedBox(height: 20),
                  // Fallback logo
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6FA8DC), Color(0xFF9FC5E8), Color(0xFF6FA8DC), Color(0xFFE06B6B)],
                      ),
                    ),
                    child: const Center(
                      child: Text('LOGO', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}