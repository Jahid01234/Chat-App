import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final bool? centerTitle;

  const AppBarWidget({
    super.key,
    this.centerTitle,
    required this.title,
  });


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey,
      elevation: 0,
      title: Text(title),
      centerTitle: centerTitle ,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios,size: 22,),
        onPressed: (){
          Navigator.pop(context);
        }
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
