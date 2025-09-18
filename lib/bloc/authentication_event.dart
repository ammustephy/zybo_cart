import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class CheckAuthStatus extends AuthEvent {}

class VerifyPhone extends AuthEvent {
  final String phoneNumber;

  const VerifyPhone(this.phoneNumber);

  @override
  List<Object> get props => [phoneNumber];
}

class VerifyOtp extends AuthEvent {
  final String otp;

  const VerifyOtp(this.otp);

  @override
  List<Object> get props => [otp];
}

class RegisterUser extends AuthEvent {
  final String firstName;

  const RegisterUser(this.firstName);

  @override
  List<Object> get props => [firstName];
}

class Logout extends AuthEvent {}
