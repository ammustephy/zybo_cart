class Product {
  final int id;
  final String name;
  final String description;
  final String caption;
  final String featuredImage;
  final List<String> images;
  final double salePrice;
  final double mrp;
  final int stock;
  final double discount;
  final bool inWishlist;
  final double avgRating;
  final String productType;
  final String variationName;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.caption,
    required this.featuredImage,
    required this.images,
    required this.salePrice,
    required this.mrp,
    required this.stock,
    required this.discount,
    required this.inWishlist,
    required this.avgRating,
    required this.productType,
    required this.variationName,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      caption: json['caption'] ?? '',
      featuredImage: json['featured_image'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      salePrice: (json['sale_price'] ?? 0).toDouble(),
      mrp: (json['mrp'] ?? 0).toDouble(),
      stock: json['stock'] ?? 0,
      discount: double.parse(json['discount']?.toString() ?? '0'),
      inWishlist: json['in_wishlist'] ?? false,
      avgRating: (json['avg_rating'] ?? 0).toDouble(),
      productType: json['product_type'] ?? '',
      variationName: json['variation_name'] ?? '',
    );
  }

  Product copyWith({bool? inWishlist}) {
    return Product(
      id: id,
      name: name,
      description: description,
      caption: caption,
      featuredImage: featuredImage,
      images: images,
      salePrice: salePrice,
      mrp: mrp,
      stock: stock,
      discount: discount,
      inWishlist: inWishlist ?? this.inWishlist,
      avgRating: avgRating,
      productType: productType,
      variationName: variationName,
    );
  }
}