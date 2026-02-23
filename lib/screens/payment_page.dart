import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/payment_card.dart';
import 'order_placed_page.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final cardCtrl = TextEditingController();
  final cvvCtrl = TextEditingController();

  bool saveCard = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Payment")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [

            // ===== SAVED CARDS DROPDOWN =====
            if (app.savedCards.isNotEmpty) ...[
              const Text(
                "Saved Cards",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              DropdownButton<PaymentCard>(
                isExpanded: true,
                hint: const Text("Select saved card"),
                items: app.savedCards
                    .map(
                      (card) => DropdownMenuItem(
                    value: card,
                    child: Text(
                      "${card.cardHolder} • **** ${card.cardNumber.substring(card.cardNumber.length - 4)}",
                    ),
                  ),
                )
                    .toList(),
                onChanged: (card) {
                  if (card != null) {
                    nameCtrl.text = card.cardHolder;
                    cardCtrl.text = card.cardNumber;
                  }
                },
              ),
              const SizedBox(height: 20),
            ],

            // ===== FORM =====
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(
                        labelText: "Cardholder Name"),
                    validator: (v) =>
                    v == null || v.isEmpty
                        ? "Enter name"
                        : null,
                  ),
                  TextFormField(
                    controller: cardCtrl,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                        labelText: "Card Number"),
                    validator: (v) =>
                    v == null || v.length != 16
                        ? "Enter 16 digit card"
                        : null,
                  ),
                  TextFormField(
                    controller: cvvCtrl,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    decoration:
                    const InputDecoration(
                        labelText: "CVV"),
                    validator: (v) =>
                    v == null || v.length != 3
                        ? "Enter 3 digit CVV"
                        : null,
                  ),

                  const SizedBox(height: 10),

                  // ===== SAVE CARD CHECKBOX =====
                  CheckboxListTile(
                    value: saveCard,
                    onChanged: (val) {
                      setState(() {
                        saveCard = val ?? false;
                      });
                    },
                    title:
                    const Text("Save card for future use"),
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    onPressed: () async {
                      if (!formKey.currentState!
                          .validate()) return;

                      if (saveCard) {
                        await app.addCard(
                          PaymentCard(
                            nameCtrl.text.trim(),
                            cardCtrl.text.trim(),
                          ),
                        );
                      }

                      await app.createOrderFromCart();

                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const OrderPlacedPage(),
                        ),
                      );
                    },
                    child: const Text("Pay Now"),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}