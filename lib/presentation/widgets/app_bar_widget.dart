import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? text;
  final bool showAvatar;
  final bool? centerTitle;
  final List<Widget>? actions;


  const AppBarWidget({
    super.key,
    this.text,
    this.actions,
    this.centerTitle,
    this.showAvatar = false,
    required this.title,
  });


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.grey,
      elevation: 0,
      leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,size: 22,),
          onPressed: (){
            Navigator.pop(context);
          }
      ),
      title: Row(
        children: [
          if (showAvatar) // Check if avatar should be shown
            const Padding(
              padding: EdgeInsets.only(right: 3),
              child: CircleAvatar(
                radius: 17,
                child: Icon(
                  Icons.person_outline_outlined,
                  size: 25,
                ),
              ),
            ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,style: const TextStyle(fontSize: 18)),
              // if text is null, it does not assign space for column
              if (text != null && text!.isNotEmpty)
                Text(
                  text!,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
            ],
          ),
        ],
      ),
      centerTitle: centerTitle ,
      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
