import 'package:chat_app/presentation/pages/auth/auth_services.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // logout  method
  void logout() async {
    // access the authServices
    final authServices = AuthServices();
    await authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
          ),
        ],
      ),
    );
  }
}
