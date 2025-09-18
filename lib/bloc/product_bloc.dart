import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zybo_cart/Api_Servide.dart';
import 'package:zybo_cart/bloc/product_event.dart';
import 'package:zybo_cart/bloc/product_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ApiRepository apiRepository;
  final SharedPreferences prefs;

  ProductsBloc(this.apiRepository, this.prefs) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadBanners>(_onLoadBanners);
    on<SearchProducts>(_onSearchProducts);
    on<ClearSearch>(_onClearSearch);
  }

  void _onLoadProducts(LoadProducts event, Emitter<ProductsState> emit) async {
    if (state is! ProductsLoaded) {
      emit(ProductsLoading());
    }

    try {
      final token = prefs.getString('token');
      if (token != null) {
        final products = await apiRepository.getProducts(token);

        if (state is ProductsLoaded) {
          emit((state as ProductsLoaded).copyWith(products: products));
        } else {
          emit(ProductsLoaded(products: products, banners: []));
        }
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void _onLoadBanners(LoadBanners event, Emitter<ProductsState> emit) async {
    try {
      final token = prefs.getString('token');
      if (token != null) {
        final banners = await apiRepository.getBanners(token);

        if (state is ProductsLoaded) {
          emit((state as ProductsLoaded).copyWith(banners: banners));
        } else {
          emit(ProductsLoaded(products: [], banners: banners));
        }
      }
    } catch (e) {
      emit(ProductsError(e.toString()));
    }
  }

  void _onSearchProducts(SearchProducts event, Emitter<ProductsState> emit) async {
    if (state is ProductsLoaded) {
      try {
        final token = prefs.getString('token');
        if (token != null) {
          final searchResults = await apiRepository.searchProducts(event.query, token);
          emit((state as ProductsLoaded).copyWith(
            searchResults: searchResults,
            isSearching: true,
          ));
        }
      } catch (e) {
        emit(ProductsError(e.toString()));
      }
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<ProductsState> emit) {
    if (state is ProductsLoaded) {
      emit((state as ProductsLoaded).copyWith(
        searchResults: [],
        isSearching: false,
      ));
    }
  }
}