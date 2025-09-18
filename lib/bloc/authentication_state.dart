import 'package:equatable/equatable.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class PhoneVerified extends AuthState {
  final String otp;
  final String token;
  final String phoneNumber;

  const PhoneVerified({
    required this.otp,
    required this.token,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [otp, token, phoneNumber];
}

class OtpVerified extends AuthState {
  final String token;
  final String phoneNumber;

  const OtpVerified({
    required this.token,
    required this.phoneNumber,
  });

  @override
  List<Object> get props => [token, phoneNumber];
}

class AuthAuthenticated extends AuthState {
  final String token;
  final String userId;

  const AuthAuthenticated({
    required this.token,
    required this.userId,
  });

  @override
  List<Object> get props => [token, userId];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}