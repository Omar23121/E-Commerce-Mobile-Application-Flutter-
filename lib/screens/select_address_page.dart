import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'payment_page.dart';

class SelectAddressPage extends StatefulWidget {
  const SelectAddressPage({super.key});

  @override
  State<SelectAddressPage> createState() =>
      _SelectAddressPageState();
}

class _SelectAddressPageState
    extends State<SelectAddressPage> {

  int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Address"),
      ),
      body: app.savedAddresses.isEmpty
          ? const Center(
        child: Text(
          "No saved addresses.\nPlease add one in your profile first.",
          textAlign: TextAlign.center,
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount:
              app.savedAddresses.length,
              itemBuilder: (_, i) {
                final address =
                app.savedAddresses[i];

                return RadioListTile<int>(
                  value: i,
                  groupValue: selectedIndex,
                  onChanged: (val) {
                    setState(() {
                      selectedIndex = val;
                    });
                  },
                  title:
                  Text(address.fullName),
                  subtitle: Text(
                    "${address.street}, ${address.city}, ${address.zip}",
                  ),
                );
              },
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                selectedIndex == null
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
                child: const Text(
                    "Continue to Payment"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}