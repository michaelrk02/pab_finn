import 'package:flutter/material.dart';
import 'package:pab_finn/components/pages/home_page.dart';

class App extends StatelessWidget {

    App({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            title: 'FINN',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.green
                ).copyWith(
                    secondary: Colors.orange,
                    tertiary: Colors.purple
                )
            ),
            home: HomePage()
        );
    }

}

