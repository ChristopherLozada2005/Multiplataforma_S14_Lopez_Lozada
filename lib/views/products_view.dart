import 'package:flutter/material.dart';
import '../models/product.dart';
import '../database/product_database.dart';
import '../widgets/product_card.dart';
import 'product_details_view.dart';

class ProductsView extends StatefulWidget {
  const ProductsView({Key? key}) : super(key: key);

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final productDatabase = ProductDatabase.instance;
  List<Product> products = [];
  bool isLoading = true;

  final Color primaryColor = Colors.teal;
  final Color backgroundColor = Colors.grey[100]!;
  final Color textColor = Colors.grey[800]!;

  @override
  void initState() {
    super.initState();
    refreshProducts();
  }

  @override
  void dispose() {
    productDatabase.close();
    super.dispose();
  }

  Future<void> refreshProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      final productsList = await productDatabase.readAll();
      setState(() {
        products = productsList;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> goToProductDetailsView({int? id}) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductDetailsView(productId: id),
      ),
    );
    refreshProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Gestión de Productos'),
        backgroundColor: primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
            },
            icon: Icon(Icons.search),
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : products.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: EdgeInsets.only(top: 8, bottom: 80),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: ProductCard(
                        product: product,
                        onTap: () => goToProductDetailsView(id: product.id),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => goToProductDetailsView(),
        icon: Icon(Icons.add),
        label: Text('Agregar'),
        backgroundColor: primaryColor,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inventory_2_outlined,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16),
            Text(
              'No hay productos',
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey[600],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Toca el botón + para agregar tu primer producto',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
