import 'package:equatable/equatable.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class ToggleWishlistItem extends WishlistEvent {
  final int productId;

  const ToggleWishlistItem(this.productId);

  @override
  List<Object> get props => [productId];
}