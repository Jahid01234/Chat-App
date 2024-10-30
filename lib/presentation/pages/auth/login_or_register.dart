import 'package:chat_app/presentation/pages/login_page.dart';
import 'package:chat_app/presentation/pages/register_page.dart';
import 'package:flutter/material.dart';

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {

  // initially, show login page
   bool showLoginPage = true;

  // toggle between login and register page
   void togglePage(){
     showLoginPage = !showLoginPage;
     setState(() {});
   }


  @override
  Widget build(BuildContext context) {
    if(showLoginPage){
      return LoginPage(
        onTap: togglePage,
      );
    }else{
      return RegisterPage(
          onTap: togglePage,
      );
    }
  }
}
