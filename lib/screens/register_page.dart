import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state.dart';
import 'main_shell.dart';

class RegisterPage extends StatefulWidget {
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final username = TextEditingController();
  final password = TextEditingController();
  final key = GlobalKey<FormState>();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<AppState>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: key,
          child: Column(
            children: [
              TextFormField(
                controller: username,
                validator: (v) =>
                v!.isEmpty ? "Enter username" : null,
                decoration:
                const InputDecoration(labelText: "Username"),
              ),
              TextFormField(
                controller: password,
                validator: (v) =>
                v!.length < 4 ? "Password too short" : null,
                obscureText: true,
                decoration:
                const InputDecoration(labelText: "Password"),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                  if (key.currentState!.validate()) {
                    setState(() => loading = true);
                    await app.saveProfile(
                      username.text.trim(),
                      password.text.trim(),
                    );
                    setState(() => loading = false);

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (_) => MainShell()),
                    );
                  }
                },
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text("Register"),
              )
            ],
          ),
        ),
      ),
    );
  }
}