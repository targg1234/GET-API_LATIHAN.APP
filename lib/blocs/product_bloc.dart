import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_4/blocs/product_event.dart';
import 'package:latihan_4/blocs/product_state.dart';
import 'package:latihan_4/services/product_service.dart';
import 'package:logger/logger.dart'; // ✅ Tambahkan ini

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductService productService;
  final Logger logger = Logger(); // ✅ Inisialisasi logger

  ProductBloc(this.productService) : super(ProductInitial()) {
    on<LoadProducts>(_onLoadProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());
    try {
      final products = await productService.fetchProducts();
      emit(ProductLoaded(products));
    } catch (e, stacktrace) {
      logger.e('Error loading products: $e');
      logger.e('Stacktrace:', error: e, stackTrace: stacktrace);
      emit(ProductError('Gagal memuat produk. Silakan coba lagi.'));
    }
  }
}
