import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/app_state.dart';
import 'reviews_page.dart';

class ProductPage extends StatelessWidget {
  final Product product;
  const ProductPage(this.product, {super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final inCart = app.isInCart(product);
    final productReviews = app.reviews[product.name] ?? [];

    final double? avgRating = productReviews.isEmpty
        ? null
        : productReviews
        .map((r) => r.rating)
        .reduce((a, b) => a + b) /
        productReviews.length;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        title: Text(product.name),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReviewsPage(product),
                ),
              );
            },
            child: const Text(
              "Reviews",
              style: TextStyle(color: Colors.grey),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          // IMAGE SECTION
          Expanded(
            child: Hero(
              tag: product.image,
              child: Image.asset(
                product.image,
                fit: BoxFit.contain,
              ),
            ),
          ),

          // BOTTOM DETAILS CARD
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(30)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME + PRICE
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${product.price.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 6),

                // RATING
                if (avgRating != null)
                  Row(
                    children: [
                      const Icon(Icons.star,
                          size: 18, color: Colors.amber),
                      const SizedBox(width: 4),
                      Text(
                        "${avgRating.toStringAsFixed(1)} • ${productReviews.length} review(s)",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  )
                else
                  Text(
                    "No reviews yet",
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),

                const SizedBox(height: 12),

                // DESCRIPTION
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey[800],
                  ),
                ),

                const SizedBox(height: 12),

                // WRITE REVIEW
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReviewsPage(product),
                        ),
                      );
                    },
                    icon: const Icon(Icons.edit,
                        color: Colors.deepPurple),
                    label: const Text(
                      "Write a review",
                      style:
                      TextStyle(color: Colors.deepPurple),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ADD TO CART BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                inCart ? Colors.redAccent : Colors.deepPurple,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
                elevation: 4,
              ),
              onPressed: () {
                if (inCart) {
                  app.removeFromCart(product);
                } else {
                  app.addToCart(product);
                }
              },
              icon: Icon(inCart
                  ? Icons.remove_shopping_cart
                  : Icons.shopping_cart_checkout),
              label: Text(
                inCart ? "Remove from Cart" : "Add to Cart",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}