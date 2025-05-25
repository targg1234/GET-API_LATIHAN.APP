import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latihan_4/blocs/product_bloc.dart';
import 'package:latihan_4/blocs/product_event.dart';
import 'package:latihan_4/blocs/product_state.dart';
import 'package:latihan_4/services/product_service.dart';
import 'product_loaded_page.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Product List')),
      body: BlocProvider(
        create: (_) => ProductBloc(ProductService())..add(LoadProducts()),
        child: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductLoaded) {
              return ProductLoadedPage(products: state.products);
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
