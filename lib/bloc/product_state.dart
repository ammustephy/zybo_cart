import 'package:equatable/equatable.dart';
import 'package:zybo_cart/Models/BannerModel.dart';
import 'package:zybo_cart/Models/ProductModel.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final List<BannerModel> banners;
  final List<Product> searchResults;
  final bool isSearching;

  const ProductsLoaded({
    required this.products,
    required this.banners,
    this.searchResults = const [],
    this.isSearching = false,
  });

  @override
  List<Object> get props => [products, banners, searchResults, isSearching];

  ProductsLoaded copyWith({
    List<Product>? products,
    List<BannerModel>? banners,
    List<Product>? searchResults,
    bool? isSearching,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      banners: banners ?? this.banners,
      searchResults: searchResults ?? this.searchResults,
      isSearching: isSearching ?? this.isSearching,
    );
  }
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
