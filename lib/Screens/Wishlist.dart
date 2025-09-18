import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zybo_cart/Widgets/ProdCard.dart';
import 'package:zybo_cart/bloc/wishlist_bloc.dart';
import 'package:zybo_cart/bloc/wishlist_event.dart';
import 'package:zybo_cart/bloc/wishlist_state.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    context.read<WishlistBloc>().add(LoadWishlist());
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Wishlist',
          style: TextStyle(
            fontSize: screenSize.width * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: BlocBuilder<WishlistBloc, WishlistState>(
        builder: (context, state) {
          if (state is WishlistLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WishlistLoaded) {
            if (state.wishlistItems.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_outline,
                      size: screenSize.width * 0.16,
                      color: Colors.grey,
                    ),
                    SizedBox(height: screenSize.height * 0.02),
                    Text(
                      'Your wishlist is empty',
                      style: TextStyle(
                        fontSize: screenSize.width * 0.045,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              );
            }
            return Padding(
              padding: EdgeInsets.all(screenSize.width * 0.04),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: screenSize.width * 0.03,
                  mainAxisSpacing: screenSize.width * 0.03,
                ),
                itemCount: state.wishlistItems.length,
                itemBuilder: (context, index) {
                  final product = state.wishlistItems[index];
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
            );
          } else if (state is WishlistError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error,
                    size: screenSize.width * 0.16,
                    color: Colors.grey,
                  ),
                  SizedBox(height: screenSize.height * 0.02),
                  Text(state.message),
                  SizedBox(height: screenSize.height * 0.02),
                  ElevatedButton(
                    onPressed: () {
                      context.read<WishlistBloc>().add(LoadWishlist());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
