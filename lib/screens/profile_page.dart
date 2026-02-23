import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'login_page.dart';
import 'order_history_page.dart';
import 'addresses_page.dart';
import 'payment_methods_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final app =
    Provider.of<AppState>(context,
        listen: false);

    usernameCtrl.text =
        app.user?.username ?? "";
    passwordCtrl.text =
        app.user?.password ?? "";
  }

  @override
  Widget build(BuildContext context) {
    final app =
    Provider.of<AppState>(context);

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.grey[200],
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          // ================= ACCOUNT =================

          const Text(
            "Account Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          TextField(
            controller: usernameCtrl,
            decoration:
            const InputDecoration(
              labelText: "Username",
            ),
          ),

          const SizedBox(height: 10),

          TextField(
            controller: passwordCtrl,
            obscureText: true,
            decoration:
            const InputDecoration(
              labelText: "Password",
            ),
          ),

          const SizedBox(height: 10),

          ElevatedButton(
            onPressed: () async {

              if (usernameCtrl.text.trim().isEmpty ||
                  passwordCtrl.text.trim().isEmpty) {

                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  const SnackBar(
                    content: Text(
                        "Username and password cannot be empty"),
                    behavior:
                    SnackBarBehavior.floating,
                  ),
                );
                return;
              }

              await app.saveProfile(
                usernameCtrl.text.trim(),
                passwordCtrl.text.trim(),
              );

              ScaffoldMessenger.of(context)
                  .showSnackBar(
                const SnackBar(
                  content: Text(
                      "Changes saved successfully"),
                  behavior:
                  SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text("Save Changes"),
          ),

          const SizedBox(height: 40),

          // ================= ADDRESS MANAGEMENT =================

          const Text(
            "Address Management",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on),
              title: const Text("Manage Addresses"),
              trailing:
              const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const AddressesPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // ================= PAYMENT MANAGEMENT =================

          const Text(
            "Payment Management",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.credit_card),
              title:
              const Text("Manage Payment Methods"),
              trailing:
              const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const PaymentMethodsPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 30),

          // ================= ORDERS =================

          const Text(
            "Orders",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 10),

          Card(
            child: ListTile(
              leading: const Icon(Icons.history),
              title:
              const Text("View Order History"),
              trailing:
              const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                    const OrderHistoryPage(),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 40),

          // ================= LOGOUT =================

          ElevatedButton(
            style:
            ElevatedButton.styleFrom(
              backgroundColor:
              Colors.red,
            ),
            onPressed: () async {
              await app.logout();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      LoginPage(),
                ),
                    (route) => false,
              );
            },
            child:
            const Text("Logout"),
          ),
        ],
      ),
    );
  }
}
