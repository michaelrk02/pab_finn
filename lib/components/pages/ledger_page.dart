import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pab_finn/components/main_app_bar.dart';
import 'package:pab_finn/components/main_drawer.dart';
import 'package:pab_finn/components/transaction_list_view.dart';
import 'package:pab_finn/components/dialogs/ledger_editor.dart';
import 'package:pab_finn/components/dialogs/transaction_editor.dart';
import 'package:pab_finn/models/ledger.dart';
import 'package:pab_finn/models/transaction.dart';
import 'package:pab_finn/helpers/number_helper.dart';

class LedgerPage extends StatefulWidget {

    static final active = GlobalKey<_LedgerPageState>();
    static final transactionListView = GlobalKey<TransactionListViewState>();

    final Ledger ledger;

    LedgerPage({
        required this.ledger,
        Key? key
    }) : super(key: key);

    @override
    State<LedgerPage> createState() => _LedgerPageState(ledger: this.ledger);

}

class _LedgerPageState extends State<LedgerPage> {

    final Ledger ledger;

    _LedgerPageState({required this.ledger});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: _LedgerPageAppBar(),
            body: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                    Card(
                        elevation: 2.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        color: Theme.of(context).colorScheme.secondary,
                        child: ListTile(
                            title: Text(this.ledger.title, style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary, fontSize: 16)),
                            trailing: IconButton(
                                icon: Icon(Icons.edit, color: Theme.of(context).colorScheme.inversePrimary),
                                onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => LedgerEditorDialog(ledger: this.ledger, action: LedgerEditorAction.update)
                                    );
                                }
                            ),
                            onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => _LedgerDetailsDialog(ledger: this.ledger)
                                );
                            }
                        )
                    ),
                    TransactionListView(ledger: this.ledger, key: LedgerPage.transactionListView)
                ]
            ),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => TransactionEditorDialog(
                            transaction: Transaction.create(
                                ledger: this.ledger,
                                timestamp: DateTime.now(),
                                type: TransactionType.income,
                                title: '',
                                description: '',
                                amount: 0
                            ),
                            action: TransactionEditorAction.create
                        )
                    );
                },
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                child: Icon(Icons.add)
            )
        );
    }

}

class _LedgerPageAppBar extends AppBar {

    _LedgerPageAppBar() : super(
        title: Text('Transactions'),
        actions: <Widget>[
            PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (item) async {
                    await LedgerPage.active.currentState?.ledger.refresh();
                    LedgerPage.active.currentState?.setState(() {});
                    LedgerPage.transactionListView.currentState?.populate(true);
                },
                itemBuilder: (context) => <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                        value: 'refresh',
                        child: ListTile(
                            leading: Icon(Icons.refresh),
                            title: Text('Refresh')
                        )
                    )
                ]
            )
        ]
    );

}

class _LedgerDetailsDialog extends StatelessWidget {

    Ledger ledger;

    _LedgerDetailsDialog({
        required this.ledger,
        Key? key
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        Future<Map<String, int>> Function() getBalance = () async {
            return {
                'balance': await this.ledger.balance,
                'totalIncome': await this.ledger.totalIncome,
                'totalExpense': await this.ledger.totalExpense
            };
        };

        return FutureBuilder<Map<String, int>>(
            future: getBalance(),
            builder: (context, snapshot) => SimpleDialog(
                title: Text(this.ledger.title),
                children: <Widget>[Container(
                    width: 300,
                    height: 300,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: snapshot.connectionState != ConnectionState.done ? Center(child: CircularProgressIndicator()) : ListView(
                        children: <Widget>[
                            ListTile(leading: Icon(Icons.schedule), title: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(this.ledger.createdAt))),
                            ListTile(
                                leading: Icon(Icons.attach_money),
                                title: Text(NumberHelper.formatIDR(snapshot.data!['balance']!)),
                                subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                        Text('Income ' + NumberHelper.formatIDR(snapshot.data!['totalIncome']!)),
                                        Text('Expense ' + NumberHelper.formatIDR(snapshot.data!['totalExpense']!))
                                    ]
                                )
                            ),
                            ListTile(leading: Icon(Icons.notes), title: Text(this.ledger.description))
                        ]
                    )
                )]
            )
        );
    }

}

