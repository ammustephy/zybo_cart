import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_cart/Api_Servide.dart';
import 'package:zybo_cart/bloc/wishlist_event.dart';
import 'package:zybo_cart/bloc/wishlist_state.dart';

class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final ApiRepository apiRepository;
  final SharedPreferences prefs;

  WishlistBloc(this.apiRepository, this.prefs) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<ToggleWishlistItem>(_onToggleWishlistItem);
  }

  void _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final token = prefs.getString('token');
      if (token != null) {
        final wishlistItems = await apiRepository.getWishlist(token);
        emit(WishlistLoaded(wishlistItems));
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }

  void _onToggleWishlistItem(ToggleWishlistItem event, Emitter<WishlistState> emit) async {
    try {
      final token = prefs.getString('token');
      if (token != null) {
        await apiRepository.toggleWishlist(event.productId, token);
        add(LoadWishlist());
      }
    } catch (e) {
      emit(WishlistError(e.toString()));
    }
  }
}