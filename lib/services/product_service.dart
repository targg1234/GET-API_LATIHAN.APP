import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  Future<List<Product>> fetchProducts() async {
    final response =
        await http.get(Uri.parse('https://dummyjson.com/products'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final List productsJson = data['products'];

      return productsJson.map<Product>((json) {
        return Product(
          id: json['id'],
          title: json['title'],
          description: json['description'],
          category: json['category'],
          price: (json['price'] as num).toDouble(),
          discountPercentage: (json['discountPercentage'] as num).toDouble(),
          rating: (json['rating'] as num).toDouble(),
          stock: json['stock'],
          tags: (json['tags'] != null) ? List<String>.from(json['tags']) : [],
          brand: json['brand'] ?? 'Unknown',
          sku: json['sku'] ?? 'SKU-${json['id']}',
          weight: json['weight'] ?? 1000,
          dimensions: json['dimensions'] != null
              ? Dimensions.fromJson(json['dimensions'])
              : Dimensions(width: 0, height: 0, depth: 0),
          warrantyInformation: json['warrantyInformation'] ?? 'N/A',
          shippingInformation: json['shippingInformation'] ?? 'N/A',
          availabilityStatus: json['availabilityStatus'] ?? 'available',
          reviews: (json['reviews'] as List?)
                  ?.map((r) => Review.fromJson(r))
                  .toList() ??
              [],
          returnPolicy: json['returnPolicy'] ?? 'No return policy',
          minimumOrderQuantity: json['minimumOrderQuantity'] ?? 1,
          meta: json['meta'] != null
              ? Meta.fromJson(json['meta'])
              : Meta(
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  barcode: '',
                  qrCode: '',
                ),
          images:
              (json['images'] != null) ? List<String>.from(json['images']) : [],
          thumbnail: json['thumbnail'] ?? '',
        );
      }).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }
}
