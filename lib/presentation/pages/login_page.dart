import 'package:chat_app/data/services/auth/auth_services.dart';
import 'package:chat_app/presentation/widgets/custom_button.dart';
import 'package:chat_app/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _obscureText = true;
  bool _isLoading = false;

  // Login Method -------------------------
  void login(context) async {
    final AuthServices authServices = AuthServices();

    setState(() {
      _isLoading = true;
    });

    try {
      await authServices.signInWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(
              child: Text(
                "Login error",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            content: Text(e.toString()),
          );
        },
      );

      // Close the dialog after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      Navigator.pop(context);
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // Logo ------------------------------------------
              Icon(
                Icons.message,
                color: Theme.of(context).colorScheme.primary,
                size: 60,
              ),
              const SizedBox(height: 50),

              // Welcome message --------------------------------
              Text(
                "Welcome back, you've been missed!",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 20),

              // Email Field ------------------------------------
              CustomTextFormField(
                controller: _emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                      .hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Password Field --------------------------------
              CustomTextFormField(
                controller: _passwordController,
                hintText: "Enter your password",
                prefixIcon: Icons.lock,
                obscureText: _obscureText,
                keyboardType: TextInputType.visiblePassword,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter password";
                  } else if (value.length <= 7) {
                    return "Please enter at least 8 characters";
                  }
                  return null;
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    _obscureText = !_obscureText;
                    setState(() {});
                  },
                  icon: Icon(
                    _obscureText ? Icons.visibility : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Login Button OR Loader -------------------------
              CustomElevatedButton(
                title: "Login",
                isLoading: _isLoading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    login(context);
                  }
                },
              ),
              const SizedBox(height: 10),

              // Register Navigation ----------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

