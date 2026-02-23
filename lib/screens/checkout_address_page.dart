import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/address.dart';
import 'payment_page.dart';

class CheckoutAddressPage extends StatefulWidget {
  const CheckoutAddressPage({super.key});

  @override
  State<CheckoutAddressPage> createState() =>
      _CheckoutAddressPageState();
}

class _CheckoutAddressPageState
    extends State<CheckoutAddressPage> {

  int? selectedIndex;

  final nameCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final zipCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shipping Address"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          const Text(
            "Select Address",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          if (app.savedAddresses.isEmpty)
            const Text("No saved addresses.")
          else
            ...List.generate(
              app.savedAddresses.length,
                  (index) {
                final address =
                app.savedAddresses[index];

                return RadioListTile<int>(
                  value: index,
                  groupValue: selectedIndex,
                  onChanged: (val) {
                    setState(() {
                      selectedIndex = val;
                    });
                  },
                  title: Text(address.fullName),
                  subtitle: Text(
                    "${address.street}, ${address.city}, ${address.zip}\n"
                        "Phone: ${address.phone}\n"
                        "Email: ${address.email}",
                  ),
                );
              },
            ),

          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),

          const Text(
            "Or Add New Address",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: nameCtrl,
            decoration:
            const InputDecoration(labelText: "Full Name"),
          ),
          TextField(
            controller: streetCtrl,
            decoration:
            const InputDecoration(labelText: "Street"),
          ),
          TextField(
            controller: cityCtrl,
            decoration:
            const InputDecoration(labelText: "City"),
          ),
          TextField(
            controller: zipCtrl,
            decoration:
            const InputDecoration(labelText: "ZIP Code"),
          ),
          TextField(
            controller: phoneCtrl,
            keyboardType: TextInputType.phone,
            decoration:
            const InputDecoration(labelText: "Phone Number"),
          ),
          TextField(
            controller: emailCtrl,
            keyboardType:
            TextInputType.emailAddress,
            decoration:
            const InputDecoration(labelText: "Email"),
          ),

          const SizedBox(height: 12),

          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.isEmpty ||
                  streetCtrl.text.isEmpty ||
                  cityCtrl.text.isEmpty ||
                  zipCtrl.text.isEmpty ||
                  phoneCtrl.text.isEmpty ||
                  emailCtrl.text.isEmpty) {

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content:
                    Text("Please fill all fields"),
                  ),
                );
                return;
              }

              final newAddress = Address(
                nameCtrl.text.trim(),
                streetCtrl.text.trim(),
                cityCtrl.text.trim(),
                zipCtrl.text.trim(),
                phoneCtrl.text.trim(),
                emailCtrl.text.trim(),
              );

              await app.addAddress(newAddress);

              setState(() {
                selectedIndex =
                    app.savedAddresses.length - 1;
              });

              nameCtrl.clear();
              streetCtrl.clear();
              cityCtrl.clear();
              zipCtrl.clear();
              phoneCtrl.clear();
              emailCtrl.clear();

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text("Address saved"),
                ),
              );
            },
            child: const Text("Save Address"),
          ),

          const SizedBox(height: 30),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selectedIndex == null
                  ? null
                  : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const PaymentPage(),
                  ),
                );
              },
              child:
              const Text("Continue to Payment"),
            ),
          ),
        ],
      ),
    );
  }
}