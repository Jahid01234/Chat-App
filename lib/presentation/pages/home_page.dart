import 'package:chat_app/presentation/pages/auth/auth_services.dart';
import 'package:chat_app/presentation/widgets/my_drawer.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // logout  method..........
  void logout() async {
    // access the authServices
    final authServices = AuthServices();
    await authServices.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: const Text("Home"),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: logout,
              icon: const Icon(Icons.logout),
          ),
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
