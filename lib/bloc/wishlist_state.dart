import 'package:equatable/equatable.dart';
import 'package:zybo_cart/Models/ProductModel.dart';

abstract class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

class WishlistInitial extends WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Product> wishlistItems;

  const WishlistLoaded(this.wishlistItems);

  @override
  List<Object> get props => [wishlistItems];
}

class WishlistError extends WishlistState {
  final String message;

  const WishlistError(this.message);

  @override
  List<Object> get props => [message];
}
