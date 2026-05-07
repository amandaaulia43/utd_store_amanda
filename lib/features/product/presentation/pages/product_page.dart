import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/network/isar_service.dart'; 
import '../../../bookmark/data/bookmark_model.dart'; // Jalur diperbaiki
import '../cubit/product_cubit.dart';

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ProductCubit>()..fetchProducts(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'UTD Store Amanda',
            style: GoogleFonts.poppins(
              color: const Color(0xFF1A1A24),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.bookmarks_outlined, color: Color(0xFF1A1A24)),
              onPressed: () => context.push('/bookmarks'),
            ),
          ],
        ),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state is ProductLoading) {
              return const Center(child: CircularProgressIndicator(color: Colors.indigo));
            } else if (state is ProductError) {
              return Center(child: Text(state.message));
            } else if (state is ProductLoaded) {
              return GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: state.products.length,
                itemBuilder: (context, index) {
                  final product = state.products[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                            child: Image.network(product.image, fit: BoxFit.contain),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 2,
                                style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.indigo),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('\$${product.price}', style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
                                  IconButton(
                                    icon: const Icon(Icons.favorite_border, color: Colors.indigo),
                                    onPressed: () async {
                                      final bookmark = BookmarkModel()
                                        ..productId = product.id
                                        ..title = product.title
                                        ..price = product.price
                                        ..image = product.image;
                                      
                                      await sl<IsarService>().saveBookmark(bookmark);
                                      
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Disimpan ke Favorit!')),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}