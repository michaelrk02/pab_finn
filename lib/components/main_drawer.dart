import 'package:flutter/material.dart';
import 'package:pab_finn/components/pages/home_page.dart';
import 'package:pab_finn/components/pages/ledgers_page.dart';
import 'package:pab_finn/components/pages/about_page.dart';

class MainDrawer extends Drawer {

    MainDrawer({
        required BuildContext context
    }) : super(
        child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
                DrawerHeader(
                    decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                    child: Text(
                        'FINN',
                        style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 24)
                    )
                ),
                ListTile(
                    leading: Icon(Icons.home_rounded),
                    title: Text('Home'),
                    onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                    }
                ),
                ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Ledgers'),
                    onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LedgersPage()));
                    }
                ),
                ListTile(
                    leading: Icon(Icons.info),
                    title: Text('About'),
                    onTap: () {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AboutPage()));
                    }
                )
            ]
        )
    );

}

