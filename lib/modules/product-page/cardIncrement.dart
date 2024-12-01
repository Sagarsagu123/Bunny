import 'package:flutter/material.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<ProductCardWidget> productList = [];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Product List'),
        ),
        body: Column(
          children: [
            ElevatedButton(
              onPressed: _addProductCard,
              child: const Text('Add Choice'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: productList.length,
                itemBuilder: (context, index) {
                  return productList[index];
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addProductCard() {
    setState(() {
      productList.add(
        const ProductCardWidget(
          defaultProductName: 'Sample Product',
          defaultMRP: '100.0',
          defaultSellingPrice: '80.0',
        ),
      );
    });
  }
}

class ProductCardWidget extends StatefulWidget {
  final String defaultProductName;
  final String defaultMRP;
  final String defaultSellingPrice;

  const ProductCardWidget({
    super.key,
    required this.defaultProductName,
    required this.defaultMRP,
    required this.defaultSellingPrice,
  });

  @override
  _ProductCardWidgetState createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productNameController;
  late TextEditingController _mrpController;
  late TextEditingController _sellingPriceController;

  @override
  void initState() {
    super.initState();
    _productNameController =
        TextEditingController(text: widget.defaultProductName);
    _mrpController = TextEditingController(text: widget.defaultMRP);
    _sellingPriceController =
        TextEditingController(text: widget.defaultSellingPrice);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(labelText: 'Product Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the product name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _mrpController,
                decoration: const InputDecoration(labelText: 'MRP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the MRP';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sellingPriceController,
                decoration: const InputDecoration(labelText: 'Selling Price'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the selling price';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
