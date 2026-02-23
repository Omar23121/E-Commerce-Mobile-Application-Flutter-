import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';

class OrderTrackingPage extends StatelessWidget {
  const OrderTrackingPage({super.key});

  String formatDate(DateTime dt) {
    return "${dt.day}/${dt.month}/${dt.year} "
        "${dt.hour.toString().padLeft(2, '0')}:"
        "${dt.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);
    final order = app.activeOrder;

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Track Order")),
        body: const Center(
          child: Text("No active order."),
        ),
      );
    }

    final now = DateTime.now();
    final totalMinutes =
        order.eta.difference(order.createdAt).inMinutes;

    int elapsedMinutes =
        now.difference(order.createdAt).inMinutes;

    if (elapsedMinutes < 0) elapsedMinutes = 0;
    if (elapsedMinutes > totalMinutes && totalMinutes > 0) {
      elapsedMinutes = totalMinutes;
    }

    final progress =
    totalMinutes == 0 ? 1.0 : (elapsedMinutes / totalMinutes);

    final steps = [
      "Order placed",
      "Packed",
      "Shipped",
      "Out for delivery",
    ];

    int currentStep;
    if (progress >= 0.9) {
      currentStep = 3;
    } else if (progress >= 0.6) {
      currentStep = 2;
    } else if (progress >= 0.3) {
      currentStep = 1;
    } else {
      currentStep = 0;
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Track Order"),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,
          children: [
            // TOP CARD
            Card(
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
                  children: [
                    Text(
                      "Order ID: ${order.id}",
                      style:
                      const TextStyle(
                        fontWeight:
                        FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                        "Placed: ${formatDate(order.createdAt)}"),
                    const SizedBox(height: 6),
                    Text(
                      "Estimated delivery: ${formatDate(order.eta)}",
                      style:
                      const TextStyle(
                        color:
                        Colors.teal,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(
                      value:
                      progress.clamp(
                          0.0, 1.0),
                      minHeight: 6,
                      backgroundColor:
                      Colors.purple
                          .withOpacity(
                          0.2),
                      valueColor:
                      const AlwaysStoppedAnimation(
                          Colors
                              .deepPurple),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      progress >= 1.0
                          ? "Delivered"
                          : "In progress...",
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            const Text(
              "Order status",
              style: TextStyle(
                fontWeight:
                FontWeight.bold,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 12),

            Expanded(
              child: ListView.builder(
                itemCount: steps.length,
                itemBuilder:
                    (_, index) {
                  IconData icon;
                  Color color;

                  if (index <
                      currentStep) {
                    icon =
                        Icons.check_circle;
                    color =
                        Colors.green;
                  } else if (index ==
                      currentStep) {
                    icon = Icons
                        .radio_button_checked;
                    color =
                        Colors.teal;
                  } else {
                    icon = Icons
                        .radio_button_unchecked;
                    color =
                        Colors.grey;
                  }

                  return ListTile(
                    leading:
                    Icon(icon,
                        color:
                        color),
                    title: Text(
                        steps[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}