import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_cart/Api_Servide.dart';
import 'package:zybo_cart/bloc/authentication_event.dart';
import 'package:zybo_cart/bloc/authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiRepository apiRepository;
  final SharedPreferences prefs;

  String? _currentToken;
  String? _currentPhoneNumber;
  String? _currentOtp;

  AuthBloc(this.apiRepository, this.prefs) : super(AuthInitial()) {
    on<CheckAuthStatus>(_onCheckAuthStatus);
    on<VerifyPhone>(_onVerifyPhone);
    on<VerifyOtp>(_onVerifyOtp);
    on<RegisterUser>(_onRegisterUser);
    on<Logout>(_onLogout);
  }

  void _onCheckAuthStatus(CheckAuthStatus event, Emitter<AuthState> emit) {
    final token = prefs.getString('token');
    final userId = prefs.getString('user_id');

    if (token != null && userId != null) {
      _currentToken = token;
      emit(AuthAuthenticated(token: token, userId: userId));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  void _onVerifyPhone(VerifyPhone event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final response = await apiRepository.verifyPhone(event.phoneNumber);
      _currentToken = response['token']['access'];
      _currentPhoneNumber = event.phoneNumber;
      _currentOtp = response['otp'];

      emit(PhoneVerified(
        otp: response['otp'],
        token: response['token']['access'],
        phoneNumber: event.phoneNumber,
      ));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onVerifyOtp(VerifyOtp event, Emitter<AuthState> emit) async {
    if (_currentOtp == event.otp && _currentToken != null) {
      emit(OtpVerified(
        token: _currentToken!,
        phoneNumber: _currentPhoneNumber!,
      ));
    } else {
      emit(const AuthError('Invalid OTP'));
    }
  }

  void _onRegisterUser(RegisterUser event, Emitter<AuthState> emit) async {
    if (_currentToken == null || _currentPhoneNumber == null) {
      emit(const AuthError('No valid session'));
      return;
    }

    emit(AuthLoading());
    try {
      final response = await apiRepository.loginRegister(
        phoneNumber: _currentPhoneNumber!,
        firstName: event.firstName,
        token: _currentToken!,
      );

      final newToken = response['token']['access'];
      final userId = response['user_id'];

      await prefs.setString('token', newToken);
      await prefs.setString('user_id', userId);
      await prefs.setString('phone_number', _currentPhoneNumber!);
      await prefs.setString('first_name', event.firstName);

      _currentToken = newToken;
      emit(AuthAuthenticated(token: newToken, userId: userId));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  void _onLogout(Logout event, Emitter<AuthState> emit) async {
    await prefs.clear();
    _currentToken = null;
    _currentPhoneNumber = null;
    _currentOtp = null;
    emit(AuthUnauthenticated());
  }

  String? get currentToken => _currentToken ?? prefs.getString('token');
}