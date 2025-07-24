import 'package:flutter/material.dart';
import 'package:functional_app/core/utils/home/custom_Product_tile.dart';
import 'package:functional_app/data/models/product_model.dart';

Card customProductCard(ProductModel product, BuildContext context) {
  return Card(
    elevation: 2,
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.blue[100]!, Colors.white],
        ),
      ),
      // Use the customProductTile function to create the ListTile
      child: customProductTile(product, context),
    ),
  );
}
