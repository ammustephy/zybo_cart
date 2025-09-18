import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:zybo_cart/Models/ProductModel.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback onWishlistTap;

  const ProductCard({
    Key? key,
    required this.product,
    required this.onWishlistTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with Wishlist Icon
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                  ),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: CachedNetworkImage(
                      imageUrl: product.featuredImage,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey.shade200,
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey.shade200,
                        child: const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: onWishlistTap,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 1,
                            blurRadius: 2,
                          ),
                        ],
                      ),
                      child: Icon(
                        product.inWishlist ? Icons.favorite : Icons.favorite_outline,
                        color: product.inWishlist ? Colors.red : const Color(0xFF5B7AE8),
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(screenSize.width * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price Section
                  Row(
                    children: [
                      if (product.discount > 0) ...[
                        Text(
                          '₹${product.mrp.toInt()}',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.03,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        SizedBox(width: screenSize.width * 0.01),
                      ],
                      Text(
                        '₹${product.salePrice.toInt()}',
                        style: TextStyle(
                          fontSize: 15,
                          // fontSize: screenSize.width * 0.035,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 50),
                      Icon(
                        Icons.star,
                        color: Colors.orange,
                        size:15,
                        // size: screenSize.width * 0.035,
                      ),
                      SizedBox(width: screenSize.width * 0.01),
                      Text(
                        product.avgRating > 0 ? product.avgRating.toString() : '4.5',
                        style: TextStyle(
                          fontSize: 15,
                          // fontSize: screenSize.width * 0.03,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenSize.height * 0.005),
                  // Product Name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 18,
                      // fontSize: screenSize.width * 0.032,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}