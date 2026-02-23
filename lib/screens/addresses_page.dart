import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import '../models/address.dart';

class AddressesPage extends StatefulWidget {
  const AddressesPage({super.key});

  @override
  State<AddressesPage> createState() =>
      _AddressesPageState();
}

class _AddressesPageState
    extends State<AddressesPage> {

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
      appBar:
      AppBar(title: const Text("Saved Addresses")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          ...app.savedAddresses.map(
                (address) => Card(
              child: ListTile(
                title: Text(address.fullName),
                subtitle: Text(
                    "${address.street}, ${address.city}, ${address.zip}\n"
                        "Phone: ${address.phone}\n"
                        "Email: ${address.email}"),
                trailing: IconButton(
                  icon: const Icon(
                      Icons.delete,
                      color: Colors.red),
                  onPressed: () async {
                    await app
                        .removeAddress(address);
                  },
                ),
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Divider(),

          const SizedBox(height: 20),

          const Text(
            "Add New Address",
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),

          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(
                labelText: "Full Name"),
          ),
          TextField(
            controller: streetCtrl,
            decoration: const InputDecoration(
                labelText: "Street"),
          ),
          TextField(
            controller: cityCtrl,
            decoration:
            const InputDecoration(labelText: "City"),
          ),
          TextField(
            controller: zipCtrl,
            decoration:
            const InputDecoration(labelText: "ZIP"),
          ),
          TextField(
            controller: phoneCtrl,
            decoration:
            const InputDecoration(labelText: "Phone"),
          ),
          TextField(
            controller: emailCtrl,
            decoration:
            const InputDecoration(labelText: "Email"),
          ),

          ElevatedButton(
            onPressed: () async {
              await app.addAddress(
                Address(
                  nameCtrl.text.trim(),
                  streetCtrl.text.trim(),
                  cityCtrl.text.trim(),
                  zipCtrl.text.trim(),
                  phoneCtrl.text.trim(),
                  emailCtrl.text.trim(),
                ),
              );

              nameCtrl.clear();
              streetCtrl.clear();
              cityCtrl.clear();
              zipCtrl.clear();
              phoneCtrl.clear();
              emailCtrl.clear();
            },
            child: const Text("Save Address"),
          ),
        ],
      ),
    );
  }
}