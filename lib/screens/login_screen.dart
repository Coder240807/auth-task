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
  }

  Future<void> _handleLogin(String username, String password) async {
    setState(() => _isLoading = true);
    try {
      final data = await _api.postData(username, password);

      setState(() {
        _usernameEditingController.clear();
        _passwordEditingController.clear();
      });
    } catch (e) {
      throw Error();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Page")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
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
              onPressed: _isLoading
                  ? null
                  : () {
                      _handleLogin(
                        _usernameEditingController.text,
                        _passwordEditingController.text,
                      );
                    },
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(),
                    )
                  : const Text("Log In"),
            ),
          ],
        ),
      ),
    );
  }
}
