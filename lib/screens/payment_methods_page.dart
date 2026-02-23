import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/payment_card.dart';

class PaymentMethodsPage extends StatefulWidget {
  const PaymentMethodsPage({super.key});

  @override
  State<PaymentMethodsPage> createState() =>
      _PaymentMethodsPageState();
}

class _PaymentMethodsPageState
    extends State<PaymentMethodsPage> {

  final cardHolderCtrl = TextEditingController();
  final cardNumberCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Payment Methods"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ===== SAVED CARDS =====

          if (app.savedCards.isEmpty)
            const Text("No saved payment methods.")
          else
            ...app.savedCards.map((card) =>
                Card(
                  child: ListTile(
                    title: Text(card.cardHolder),
                    subtitle: Text(
                      card.cardNumber.length >= 4
                          ? "**** ${card.cardNumber.substring(card.cardNumber.length - 4)}"
                          : "****",
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await app.removeCard(card);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                                "Payment method deleted"),
                          ),
                        );
                      },
                    ),
                  ),
                ),
            ),

          const SizedBox(height: 30),

          const Text(
            "Add New Payment Method",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: cardHolderCtrl,
            decoration: const InputDecoration(
              labelText: "Cardholder Name",
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: cardNumberCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Card Number",
            ),
          ),

          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () async {

              if (cardHolderCtrl.text.trim().isEmpty ||
                  cardNumberCtrl.text.trim().length != 16) {

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                    Text("Enter valid card details"),
                  ),
                );
                return;
              }

              await app.addCard(
                PaymentCard(
                  cardHolderCtrl.text.trim(),
                  cardNumberCtrl.text.trim(),
                ),
              );

              cardHolderCtrl.clear();
              cardNumberCtrl.clear();

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content:
                  Text("Payment method saved"),
                ),
              );
            },
            child:
            const Text("Save Payment Method"),
          ),
        ],
      ),
    );
  }
}