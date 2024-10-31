import 'package:chat_app/presentation/pages/auth/auth_services.dart';
import 'package:chat_app/presentation/widgets/custom_button.dart';
import 'package:chat_app/presentation/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';

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

  // Register method.....
  void register(context) async{
    // access the AuthServices
    final authServices = AuthServices();

    // password match and then try to Register
    if(_passwordController.text == _confirmPasswordController.text) {
      try {
        await authServices.signUpWithEmailPassword(
          _emailController.text,
          _passwordController.text,
        );
        // errors throw
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Center(
                child: Text(
                  "Register error",
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
      // password does not match and then show error message
    } else{
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text("Password does not match!",style: TextStyle(
                fontSize: 15,
             ),
            ),
          );
        },
      );
      // Close the dialog after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
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
                onTap: (){
                  if(_formKey.currentState!.validate()){
                    register(context);
                  }
                },
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
