import 'package:chat_app/presentation/pages/auth/auth_services.dart';
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

  // login method
  void login(context) async{
    // access the AuthServices
    final authServices = AuthServices();

    // try to login
    try {
      await authServices.signInWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
    }

    // catch any errors
    catch(e){
      showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: const Center(
                  child: Text("Login error"),
              ),
              content: Text(e.toString()),
            );
          },
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body:  Center(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                  Icons.message,
                  color: Theme.of(context).colorScheme.primary,
                  size: 60,
              ),
              const SizedBox(height: 50),

              // Welcome back message
              Text(
                "Welcome back, you've been missed!",
                 style: TextStyle(
                   color: Theme.of(context).colorScheme.primary,
                   fontSize: 19,
                 ),
              ),
              const SizedBox(height: 20),

              // Email textFormField
              CustomTextFormField(
                controller: _emailController,
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
                hintText: "Enter your email",
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 10),

              // Password textFormField
              CustomTextFormField(
                obscureText: _obscureText,
                controller: _passwordController,
                validator: (String? value){
                  if(value==null || value.isEmpty){
                    return "Please enter password";
                  }
                  else if(value.length<=7){
                    return " please enter 8 character";
                  }
                  return null;
                },
                keyboardType: TextInputType.visiblePassword,
                hintText: "Enter your password",
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  onPressed: (){
                    _obscureText = !_obscureText;
                    setState(() {});
                  },
                  icon: Icon( _obscureText
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ) ,
              ),
              const SizedBox(height: 30),

              // Login button
              CustomElevatedButton(
                title: "Login",
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    login(context);
                  }
                },
              ),
              const SizedBox(height: 10),

              // Register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap ,
                    child: Text(
                      "Register now",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold
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
