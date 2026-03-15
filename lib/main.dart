import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product List',
      theme: ThemeData(
        colorSchemeSeed: Colors.deepOrange,
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}

// ViewModel (using ChangeNotifier)
class ProductViewModel extends ChangeNotifier {
  final List<String> products = [
    'Laptop',
    'Smartphone',
    'Headphones',
    'Keyboard',
    'Mouse',
    'Monitor',
  ];

  String? _selectedProduct;
  String? get selectedProduct => _selectedProduct;

  void selectProduct(String product) {
    _selectedProduct = product;
    notifyListeners();
  }
}

// Global instance for simplicity in this exercise
final viewModel = ProductViewModel();

// Screen 1: Product List
class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: viewModel,
        builder: (context, child) {
          return ListView.builder(
            itemCount: viewModel.products.length,
            itemBuilder: (context, index) {
              final product = viewModel.products[index];
              final isSelected = viewModel.selectedProduct == product;
              return Card(
                color: isSelected ? Theme.of(context).colorScheme.primaryContainer : null,
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  title: Text(
                    product,
                    style: TextStyle(
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    viewModel.selectProduct(product);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ProductDetailScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// Screen 2: Product Detail
class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // We can access the selected product from the viewModel
    final product = viewModel.selectedProduct ?? 'Unknown Product';

    return Scaffold(
      appBar: AppBar(title: const Text('Product Details')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 12),
            const Text(
              'This is a great product with amazing features. '
                  'It offers high quality and durability.',
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$product added to cart!')),
                );
              },
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}
