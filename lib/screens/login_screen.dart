import 'package:flutter/material.dart';
import 'package:authtask/services/api.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameEditingController =
      TextEditingController();
  final TextEditingController _passwordEditingController =
      TextEditingController();

  final Api _api = Api();

  @override
  void initState() {
    super.initState();
    _handleLogin(
      _usernameEditingController.text,
      _passwordEditingController.text,
    );
  }

  Future<void> _handleLogin(String username, String password) async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.postData(username, password);
    } catch (e) {
      throw Error();
    } finally {
      _isLoading = false;
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameEditingController,
              decoration: const InputDecoration(hintText: 'Username'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _passwordEditingController,
              obscureText: true,
              decoration: const InputDecoration(hintText: 'Password'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                if (!_isLoading) {
                  _handleLogin(
                    _usernameEditingController.text,
                    _passwordEditingController.text,
                  );
                }
              },
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text("Logged In"),
            ),
          ],
        ),
      ),
    );
  }
}
