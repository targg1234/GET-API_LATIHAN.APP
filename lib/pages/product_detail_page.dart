import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Hero(
              tag: 'product_image_${product.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.thumbnail,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 100),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(product.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text('Brand: ${product.brand}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green)),
                const SizedBox(width: 12),
                if (product.discountPercentage > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '-${product.discountPercentage}%',
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                RatingBarIndicator(
                  rating: product.rating,
                  itemBuilder: (context, _) =>
                      const Icon(Icons.star, color: Colors.amber),
                  itemSize: 20,
                ),
                const SizedBox(width: 8),
                Text('${product.rating}/5'),
              ],
            ),
            const SizedBox(height: 16),
            Text(product.description,
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
            const SizedBox(height: 20),
            _buildInfoSection(product),
            const SizedBox(height: 20),
            _buildBarcodeAndQR(context, product),
            const SizedBox(height: 24),
            _buildImageGallery(product),
            const SizedBox(height: 24),
            _buildReviews(product),
            const SizedBox(height: 80), // Untuk space tombol bawah
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${product.title} ditambahkan ke keranjang!')),
            );
          },
          icon: const Icon(Icons.shopping_cart),
          label: const Text('Add to Cart'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey,
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: const TextStyle(fontSize: 18),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(Product product) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile(Icons.category, 'Category', product.category),
            _infoTile(Icons.confirmation_number, 'SKU', product.sku),
            _infoTile(Icons.inventory, 'Stock', '${product.stock} pcs'),
            _infoTile(Icons.scale, 'Weight', '${product.weight} g'),
            _infoTile(Icons.straighten, 'Dimensions',
                '${product.dimensions.width} x ${product.dimensions.height} x ${product.dimensions.depth} cm'),
            _infoTile(Icons.local_shipping, 'Shipping Info',
                product.shippingInformation),
            _infoTile(
                Icons.verified_user, 'Warranty', product.warrantyInformation),
            _infoTile(Icons.store, 'Availability', product.availabilityStatus),
            _infoTile(Icons.undo, 'Return Policy', product.returnPolicy),
            _infoTile(Icons.shopping_cart, 'Min. Order',
                '${product.minimumOrderQuantity} pcs'),
            _infoTile(Icons.date_range, 'Created At',
                product.meta.createdAt.toLocal().toString().split(' ')[0]),
            _infoTile(Icons.update, 'Updated At',
                product.meta.updatedAt.toLocal().toString().split(' ')[0]),
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[700]),
          const SizedBox(width: 12),
          Expanded(
            child: Text('$label: $value',
                style: const TextStyle(fontSize: 15, color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  Widget _buildBarcodeAndQR(BuildContext context, Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Barcode', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: BarcodeWidget(
            barcode: Barcode.code128(),
            data: product.meta.barcode,
            width: 200,
            height: 80,
          ),
        ),
        const SizedBox(height: 16),
        Text('QR Code', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Center(
          child: QrImageView(
            data: product.meta.qrCode,
            version: QrVersions.auto,
            size: 120.0,
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(Product product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Product Images',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          height: 100,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: product.images.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.images[index],
                  width: 100,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReviews(Product product) {
    return ExpansionTile(
      title: const Text('Customer Reviews',
          style: TextStyle(fontWeight: FontWeight.bold)),
      initiallyExpanded: false,
      children: product.reviews.map((review) {
        return ListTile(
          leading: CircleAvatar(
            child: Text(review.reviewerName[0]),
          ),
          title: Text(review.reviewerName,
              style: const TextStyle(fontWeight: FontWeight.w600)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              RatingBarIndicator(
                rating: review.rating.toDouble(),
                itemBuilder: (context, _) =>
                    const Icon(Icons.star, color: Colors.amber),
                itemSize: 16,
              ),
              const SizedBox(height: 4),
              Text(review.comment),
            ],
          ),
          trailing: Text(
            '${review.date.toLocal()}'.split(' ')[0],
            style: const TextStyle(fontSize: 12),
          ),
        );
      }).toList(),
    );
  }
}
