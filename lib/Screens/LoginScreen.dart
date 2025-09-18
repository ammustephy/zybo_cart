import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:zybo_cart/bloc/authentication_bloc.dart';
import 'package:zybo_cart/bloc/authentication_event.dart';
import 'package:zybo_cart/bloc/authentication_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  String _completePhoneNumber = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PhoneVerified) {
          Navigator.pushNamed(context, '/otp');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.06,
              vertical: screenSize.height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: screenSize.height * 0.15),
                Text(
                  'Login',
                  style: TextStyle(
                    fontSize: screenSize.width * 0.08,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: screenSize.height * 0.01),
                Text(
                  "Let's Connect with Lorem Ipsum...!",
                  style: TextStyle(
                    fontSize: screenSize.width * 0.04,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: screenSize.height * 0.05),
                IntlPhoneField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    hintText: 'Enter Phone',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF5B7AE8)),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: screenSize.height * 0.02,
                      horizontal: 16,
                    ),
                  ),
                  initialCountryCode: 'IN',
                  onChanged: (phone) {
                    _completePhoneNumber = phone.completeNumber;
                  },
                ),
                SizedBox(height: screenSize.height * 0.03),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return SizedBox(
                      width: double.infinity,
                      height: screenSize.height * 0.07,
                      child: ElevatedButton(
                        onPressed: state is AuthLoading
                            ? null
                            : () {
                          if (_completePhoneNumber.isNotEmpty) {
                            context.read<AuthBloc>().add(
                              VerifyPhone(_completePhoneNumber),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5B7AE8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: state is AuthLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: screenSize.height * 0.02),
                Center(
                  child: Text(
                    'By Continuing you accept to the Terms of Use &\nPrivacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: screenSize.width * 0.03,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
