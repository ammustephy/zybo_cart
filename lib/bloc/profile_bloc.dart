import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_cart/Api_Servide.dart';
import 'package:zybo_cart/bloc/profile_event.dart';
import 'package:zybo_cart/bloc/profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ApiRepository apiRepository;
  final SharedPreferences prefs;

  ProfileBloc(this.apiRepository, this.prefs) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
  }

  void _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    try {
      final token = prefs.getString('token');
      if (token != null) {
        final user = await apiRepository.getUserData(token);
        emit(ProfileLoaded(user));
      }
    } catch (e) {
      emit(ProfileError(e.toString()));
    }
  }
}