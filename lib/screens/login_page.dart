import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'register_page.dart';
import 'main_shell.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Icon(Icons.shopping_bag, size: 90, color: Colors.teal),
                const SizedBox(height: 20),
                const Text("Login",
                    style:
                    TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                TextField(
                  controller: username,
                  decoration:
                  const InputDecoration(labelText: "Username"),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: password,
                  obscureText: true,
                  decoration:
                  const InputDecoration(labelText: "Password"),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: loading
                      ? null
                      : () async {
                    final userText = username.text.trim();
                    final passText = password.text.trim();

                    if (userText.isEmpty || passText.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please enter both username and password")),
                      );
                      return;
                    }

                    setState(() => loading = true);
                    final ok =
                    await app.validateLogin(userText, passText);
                    setState(() => loading = false);

                    if (!ok) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "Invalid credentials or no account found."),
                        ),
                      );
                      return;
                    }

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MainShell()),
                    );
                  },
                  child: loading
                      ? const CircularProgressIndicator(
                      color: Colors.white)
                      : const Text("Login"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => RegisterPage()),
                    );
                  },
                  child: const Text("Create an Account"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MainShell()),
                    );
                  },
                  child: const Text("Continue as Guest"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}