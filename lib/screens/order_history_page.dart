import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/order.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Order History"),
      ),
      body: app.orders.isEmpty
          ? const Center(
        child: Text("No previous orders."),
      )
          : ListView.builder(
        itemCount: app.orders.length,
        itemBuilder: (_, index) {
          final Order order =
          app.orders[index];

          return Card(
            margin:
            const EdgeInsets.all(12),
            child: ListTile(
              title: Text(
                  "Order ID: ${order.id}"),
              subtitle: Text(
                  "Total: \$${order.total.toStringAsFixed(2)}"),
              trailing: IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await app.deleteOrder(order);

                  ScaffoldMessenger.of(
                      context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                          "Order deleted"),
                      behavior:
                      SnackBarBehavior
                          .floating,
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}