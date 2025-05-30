
import 'package:flutter/material.dart';



PreferredSizeWidget AppointmenAppBar(BuildContext context,String text){
  return AppBar(

    centerTitle: true,
    backgroundColor: Colors.indigo,
    foregroundColor: Colors.white,
    automaticallyImplyLeading: false,
    leading: BackButton(
      onPressed: () => Navigator.pop(context),

         ),

    title: Text(text ),

  );
}


