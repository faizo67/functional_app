import 'package:flutter/material.dart';
import 'package:functional_app/data/models/product_model.dart';
import 'package:go_router/go_router.dart';

ListTile customProductTile(ProductModel product, BuildContext context) {
  return ListTile(
    leading: Image.network(
      product.image,
      width: 50,
      height: 50,
      fit: BoxFit.cover,
    ),
    title: Text(product.title),
    subtitle: Text(' 24${product.price.toStringAsFixed(2)}'),
    onTap: () {
      // Use go_router for navigation to details
      context.go('/home/details', extra: product.title);
    },
  );
}
