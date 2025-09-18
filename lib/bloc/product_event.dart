import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {}

class LoadBanners extends ProductsEvent {}

class SearchProducts extends ProductsEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class ClearSearch extends ProductsEvent {}
