import 'package:flutter/material.dart';

class MainAppBar extends AppBar {

    MainAppBar({
        required String title,
        List<Widget>? actions
    }) : super(
        title: Text(title),
        leading: Builder(
            builder: (context) => IconButton(
                icon: Icon(Icons.menu),
                onPressed: () {
                    Scaffold.of(context).openDrawer();
                }
            )
        ),
        actions: actions
    );

}

