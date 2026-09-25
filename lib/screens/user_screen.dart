import "package:flutter/material.dart";
import 'package:authtask/models/users.dart';

class UserScreen extends StatelessWidget {
  final User user;
  const UserScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("My Profile")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            CircleAvatar(radius: 50, child: Image.network(user.image)),
            const SizedBox(height: 15),
            Text(user.firstName),
            const SizedBox(height: 4),
            Text('@${user.username}'),
            const SizedBox(height: 32),

            const Divider(),
          ],
        ),
      ),
    );
  }
}
