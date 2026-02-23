import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'checkout_address_page.dart';
import 'login_page.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final entries = app.cart.entries.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Cart")),
      body: entries.isEmpty
          ? const Center(
        child: Text(
          "Your cart is empty",
          style: TextStyle(fontSize: 16),
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: entries.length,
              itemBuilder: (_, i) {
                final entry = entries[i];
                final product = entry.key;
                final qty = entry.value;
                final lineTotal =
                    product.price * qty;

                return ListTile(
                  leading: Image.asset(
                    product.image,
                    width: 50,
                  ),
                  title: Text(product.name),
                  subtitle: Text(
                    "\$${product.price.toStringAsFixed(2)} x $qty = \$${lineTotal.toStringAsFixed(2)}",
                  ),
                  trailing: Row(
                    mainAxisSize:
                    MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(
                            Icons.remove),
                        onPressed: () =>
                            app.removeFromCart(
                                product),
                      ),
                      Text(
                        qty.toString(),
                        style: const TextStyle(
                            fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(
                            Icons.add),
                        onPressed: () =>
                            app.addToCart(
                                product),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // ===== TOTAL + CHECKOUT =====

          Padding(
            padding:
            const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Total: \$${app.total.toStringAsFixed(2)}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                      // 🔥 MUST BE LOGGED IN
                      if (app.user == null) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Please login before checkout"),
                          ),
                        );

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                LoginPage(),
                          ),
                        );
                        return;
                      }

                      // 🔥 GO TO ADDRESS STEP
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const CheckoutAddressPage(),
                        ),
                      );
                    },
                    child: const Text("Checkout"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}