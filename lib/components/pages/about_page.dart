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
            body: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('FINN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Your Financial Buddy', style: TextStyle(fontSize: 18, color: Colors.grey))
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                                children: <Widget>[
                                    Text('Copyright (C) 2022', style: TextStyle(fontWeight: FontWeight.bold)),
                                    Text('Michael Raditya Krisnadhi'),
                                    Text('NIM M0520047'),
                                    Text('S1 Informatika'),
                                    Text('Universitas Sebelas Maret')
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }

}

