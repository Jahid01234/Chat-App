import 'package:chat_app/presentation/widgets/custom_button.dart';
import 'package:chat_app/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _obscureText1 = true;
  bool _obscureText2 = true;

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

              // Let's create an account for you!
              Text(
                "Let's create an account for you!",
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
                obscureText: _obscureText1,
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
                    _obscureText1 = !_obscureText1;
                    setState(() {});
                  },
                  icon: Icon( _obscureText1
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ) ,
              ),
              const SizedBox(height: 10),

              // Confirm Password textFormField
              CustomTextFormField(
                obscureText: _obscureText2,
                controller: _confirmPasswordController,
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
                hintText: "Enter your confirm password",
                prefixIcon: Icons.lock,
                suffixIcon: IconButton(
                  onPressed: (){
                    _obscureText2 = !_obscureText2;
                    setState(() {});
                  },
                  icon: Icon( _obscureText2
                      ? Icons.visibility
                      : Icons.visibility_off,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ) ,
              ),
              const SizedBox(height: 30),

              // Register button
              CustomElevatedButton(
                title: "Register",
                onTap: (){},
              ),
              const SizedBox(height: 10),

              // Login now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onTap ,
                    child: Text(
                      "Login now",
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
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
