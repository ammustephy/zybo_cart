import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_cart/bloc/authentication_bloc.dart';
import 'package:zybo_cart/bloc/authentication_event.dart';
import 'package:zybo_cart/bloc/authentication_state.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  Timer? _timer;
  int _remainingTime = 120;
  String _phoneNumber = '';
  String _dummyOtp = '';

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Get the current auth state to display OTP
    final authState = context.read<AuthBloc>().state;
    if (authState is PhoneVerified) {
      setState(() {
        _phoneNumber = authState.phoneNumber;
        _dummyOtp = authState.otp;
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime > 0) {
        setState(() {
          _remainingTime--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')} Sec';
  }

  String _getEnteredOtp() {
    return _otpControllers.map((controller) => controller.text).join();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is PhoneVerified) {
          setState(() {
            _phoneNumber = state.phoneNumber;
            _dummyOtp = state.otp;
          });
        } else if (state is OtpVerified) {
          Navigator.pushNamed(context, '/name');
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: keyboardHeight),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: screenSize.height - MediaQuery.of(context).padding.top - MediaQuery.of(context).padding.bottom,
              ),
              child: IntrinsicHeight(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenSize.width * 0.06,
                    vertical: screenSize.height * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.05),
                      Text(
                        'OTP VERIFICATION',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.06,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.01),
                      Text(
                        'Enter the otp sent to - $_phoneNumber',
                        style: TextStyle(
                          fontSize: screenSize.width * 0.04,
                          color: Colors.grey[600],
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      if (_dummyOtp.isNotEmpty)
                        Text(
                          'OTP is $_dummyOtp',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.04,
                            color: const Color(0xFF5B7AE8),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      SizedBox(height: screenSize.height * 0.05),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) {
                          return Container(
                            width: screenSize.width * 0.15,
                            height: screenSize.width * 0.15,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              textAlign: TextAlign.center,
                              keyboardType: TextInputType.number,
                              maxLength: 1,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                counterText: '',
                              ),
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.bold,
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index < 3) {
                                    _focusNodes[index + 1].requestFocus();
                                  } else {
                                    // Hide keyboard when last field is filled
                                    _focusNodes[index].unfocus();
                                  }
                                } else {
                                  if (index > 0) {
                                    _focusNodes[index - 1].requestFocus();
                                  }
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: screenSize.height * 0.03),
                      Center(
                        child: Text(
                          _formatTime(_remainingTime),
                          style: TextStyle(
                            fontSize: screenSize.width * 0.035,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),
                      Center(
                        child: RichText(
                          text: TextSpan(
                            text: "Don't receive code? ",
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: screenSize.width * 0.035,
                            ),
                            children: const [
                              TextSpan(
                                text: 'Re-send',
                                style: TextStyle(
                                  color: Color(0xFF5B7AE8),
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: EdgeInsets.only(
                          bottom: keyboardHeight > 0 ? 16 : screenSize.height * 0.02,
                        ),
                        child: SizedBox(
                          width: double.infinity,
                          height: screenSize.height * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              final enteredOtp = _getEnteredOtp();
                              if (enteredOtp.length == 4) {
                                context.read<AuthBloc>().add(VerifyOtp(enteredOtp));
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF5B7AE8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.04,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}