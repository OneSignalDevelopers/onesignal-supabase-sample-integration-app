import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _loading = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _loading
        ? const Center(child: CircularProgressIndicator())
        : ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            children: [
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                controller: _emailController,
                decoration: const InputDecoration(label: Text('Email')),
              ),
              const SizedBox(height: 16),
              TextFormField(
                obscureText: true,
                controller: _passwordController,
                decoration: const InputDecoration(label: Text('Password')),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    await Supabase.instance.client.auth.signInWithPassword(
                      email: email,
                      password: password,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString() ?? "Login failed"),
                      backgroundColor: Colors.red,
                    ));
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: const Text('Login'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () async {
                  setState(() {
                    _loading = true;
                  });
                  try {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    await Supabase.instance.client.auth.signUp(
                      email: email,
                      password: password,
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString() ?? "Signup failed"),
                      backgroundColor: Colors.red,
                    ));
                    setState(() {
                      _loading = false;
                    });
                  }
                },
                child: const Text('Signup'),
              ),
            ],
          );
  }
}
