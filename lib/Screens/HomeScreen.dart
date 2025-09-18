import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_cart/Widgets/ProdCard.dart';
import 'package:zybo_cart/bloc/product_bloc.dart';
import 'package:zybo_cart/bloc/product_event.dart';
import 'package:zybo_cart/bloc/product_state.dart';
import 'package:zybo_cart/bloc/wishlist_bloc.dart';
import 'package:zybo_cart/bloc/wishlist_event.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    context.read<ProductsBloc>().add(LoadProducts());
    context.read<ProductsBloc>().add(LoadBanners());
  }

  void _onSearch(String query) {
    if (query.isNotEmpty) {
      context.read<ProductsBloc>().add(SearchProducts(query));
    } else {
      context.read<ProductsBloc>().add(ClearSearch());
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Search Bar
            Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: TextField(
                controller: _searchController,
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF5B7AE8)),
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: screenSize.height * 0.015,
                    horizontal: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ProductsLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Banner Carousel
                          if (state.banners.isNotEmpty) ...[
                            CarouselSlider(
                              options: CarouselOptions(
                                height: screenSize.height * 0.2,
                                autoPlay: true,
                                enlargeCenterPage: true,
                                viewportFraction: 0.9,
                                autoPlayInterval: const Duration(seconds: 3),
                              ),
                              items: state.banners.map((banner) {
                                return Container(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: screenSize.width * 0.01,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 1,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: banner.image,
                                      fit: BoxFit.cover,
                                      width: double.infinity,
                                      placeholder: (context, url) => Container(
                                        color: Colors.grey.shade200,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Container(
                                            color: Colors.grey.shade200,
                                            child: const Icon(Icons.error),
                                          ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: screenSize.height * 0.03),
                          ],

                          // Products Section
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.04,
                            ),
                            child: Text(
                              'Popular Products',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.05,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          SizedBox(height: screenSize.height * 0.02),

                          // Product Grid
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenSize.width * 0.04,
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.75,
                                crossAxisSpacing: screenSize.width * 0.03,
                                mainAxisSpacing: screenSize.width * 0.03,
                              ),
                              itemCount: state.isSearching
                                  ? state.searchResults.length
                                  : state.products.length,
                              itemBuilder: (context, index) {
                                final product = state.isSearching
                                    ? state.searchResults[index]
                                    : state.products[index];
                                return ProductCard(
                                  product: product,
                                  onWishlistTap: () {
                                    context.read<WishlistBloc>().add(
                                      ToggleWishlistItem(product.id),
                                    );
                                  },
                                );
                              },
                            ),
                          ),

                          // Latest Products Section (for demonstration)
                          if (!state.isSearching && state.products.isNotEmpty) ...[
                            SizedBox(height: screenSize.height * 0.03),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.04,
                              ),
                              child: Text(
                                'Latest Products',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                            SizedBox(height: screenSize.height * 0.02),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenSize.width * 0.04,
                              ),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.75,
                                  crossAxisSpacing: screenSize.width * 0.03,
                                  mainAxisSpacing: screenSize.width * 0.03,
                                ),
                                itemCount: state.products.length > 2 ? 2 : state.products.length,
                                itemBuilder: (context, index) {
                                  final product = state.products[index];
                                  return ProductCard(
                                    product: product,
                                    onWishlistTap: () {
                                      context.read<WishlistBloc>().add(
                                        ToggleWishlistItem(product.id),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  } else if (state is ProductsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error, size: 64, color: Colors.grey),
                          SizedBox(height: screenSize.height * 0.02),
                          Text(state.message),
                          SizedBox(height: screenSize.height * 0.02),
                          ElevatedButton(
                            onPressed: _loadData,
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
