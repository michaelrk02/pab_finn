import 'package:flutter/material.dart';
import 'package:pab_finn/components/main_app_bar.dart';
import 'package:pab_finn/components/main_drawer.dart';

class AboutPage extends StatelessWidget {

    AboutPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: MainAppBar(title: 'About'),
            drawer: MainDrawer(context: context),
            body: Center(child: Text('About us'))
        );
    }

}

