import 'package:flutter/material.dart';
import 'package:pab_finn/components/main_app_bar.dart';
import 'package:pab_finn/components/main_drawer.dart';
import 'package:pab_finn/components/transaction_list_view.dart';
import 'package:pab_finn/models/ledger.dart';

class LedgerPage extends StatelessWidget {

    static final transactionListView = GlobalKey<TransactionListViewState>();

    final Ledger ledger;

    LedgerPage({
        required this.ledger,
        Key? key
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text('Transactions')),
            body: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                    Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        color: Theme.of(context).colorScheme.secondary,
                        child: ListTile(
                            title: Text(this.ledger.title, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16)),
                            trailing: IconButton(icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.inversePrimary), onPressed: () {}),
                            onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => _LedgerDetailsDialog(this.ledger)
                                );
                            }
                        )
                    ),
                    TransactionListView(ledger: this.ledger, key: LedgerPage.transactionListView)
                ]
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {},
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                child: Icon(Icons.add)
            )
        );
    }

}

class _LedgerDetailsDialog extends SimpleDialog {

    _LedgerDetailsDialog(Ledger ledger) : super(
        title: Text('Ledger Details'),
        children: <Widget>[
            Text('Ledger: ' + ledger.title)
        ]
    );

}

