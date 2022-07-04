import 'package:flutter/material.dart';
import 'package:pab_finn/components/main_app_bar.dart';
import 'package:pab_finn/components/main_drawer.dart';
import 'package:pab_finn/components/pages/ledgers_page.dart';

class HomePage extends StatelessWidget {

    HomePage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: MainAppBar(title: 'Home'),
            drawer: MainDrawer(context: context),
            body: ListView(
                children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 64.0),
                        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
                        child: Column(
                            children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('FINN', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.inversePrimary))
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: Text('Your Financial Buddy', style: TextStyle(fontSize: 18, color: Theme.of(context).colorScheme.inversePrimary))
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 8.0),
                                    child: ElevatedButton(
                                        onPressed: () {
                                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LedgersPage()));
                                        },
                                        child: Text('GET STARTED'),
                                        style: ElevatedButton.styleFrom(primary: Theme.of(context).colorScheme.inversePrimary, onPrimary: Theme.of(context).colorScheme.primary)
                                    )
                                )
                            ]
                        )
                    ),
                    Container(
                        padding: EdgeInsets.all(32.0),
                        child: Column(
                            children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    child: Text('Introduce FINN, an app that serves as your financial buddy. FINN can help you managing all of your transactions by grouping them onto several ledgers. You can also track your total income, expense, and balance of your ledgers.')
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(vertical: 16.0),
                                    child: Column(children: <Widget>[
                                        ListTile(leading: Icon(Icons.check), title: Text('Multiple ledgers')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Create, read, update, and delete ledgers')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Multiple transactions per ledger')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Create, read, update, and delete transactions')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Track ledger balance, income, and expense')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Sort ledgers by title or creation time')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Transactions sorted by timestamp')),
                                        ListTile(leading: Icon(Icons.check), title: Text('Works offline using SQLite database'))
                                    ])
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }

}

