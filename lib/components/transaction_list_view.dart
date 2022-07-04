import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pab_finn/models/ledger.dart';
import 'package:pab_finn/models/transaction.dart';
import 'package:pab_finn/helpers/number_helper.dart';
import 'package:pab_finn/components/dialogs/transaction_editor.dart';

class TransactionListView extends StatefulWidget {
    final Ledger ledger;

    TransactionListView({
        required this.ledger,
        Key? key
    }) : super(key: key);

    @override
    State<TransactionListView> createState() {
        return TransactionListViewState();
    }
}

class TransactionListViewState extends State<TransactionListView> {
    late Future<void> _populated;
    late List<Transaction> _transactions;

    @override
    void initState() {
        super.initState();

        this.populate();
    }

    @override
    Widget build(BuildContext context) {
        return FutureBuilder<void>(
            future: this._populated,
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                    var items = List<Widget>.generate(
                        this._transactions.length,
                        (index) => Card(
                            elevation: 2.0,
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                                onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) => _TransactionDetailsDialog(transaction: this._transactions[index])
                                    );
                                },
                                leading: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                        Text(this._transactions[index].timestamp.year.toString().padLeft(4, '0'), style: TextStyle(color: Colors.grey)),
                                        Text(this._transactions[index].timestamp.month.toString().padLeft(2, '0') + '/' + this._transactions[index].timestamp.day.toString().padLeft(2, '0'), style: TextStyle(color: Colors.grey))
                                    ]
                                ),
                                title: Text(this._transactions[index].title),
                                subtitle: this._transactions[index].type == TransactionType.income
                                    ? Text('+ ' + NumberHelper.formatIDR(this._transactions[index].amount), style: TextStyle(color: Colors.green))
                                    : Text('- ' + NumberHelper.formatIDR(this._transactions[index].amount), style: TextStyle(color: Colors.red)),
                                trailing: IconButton(
                                    icon: Icon(Icons.edit),
                                    onPressed: () {
                                        showDialog(
                                            context: context,
                                            builder: (context) => TransactionEditorDialog(transaction: this._transactions[index], action: TransactionEditorAction.update)
                                        );
                                    }
                                )
                            )
                        )
                    );

                    return Column(children: items);
                } else {
                    return Center(heightFactor: 2.0, child: CircularProgressIndicator());
                }
            }
        );
    }

    void populate([bool refresh = false]) {
        this._populated = (() async {
            this._transactions = await this.widget.ledger.transactions(TransactionOrder.timestamp);
        })();
        if (refresh) {
            this.setState(() {});
        }
    }
}

class _TransactionDetailsDialog extends StatelessWidget {

    Transaction transaction;

    _TransactionDetailsDialog({
        required this.transaction,
        Key? key
    }) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return SimpleDialog(
            title: Text(this.transaction.title),
            children: <Widget>[Container(
                width: 300,
                height: 300,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                    children: <Widget>[
                        ListTile(leading: Icon(Icons.schedule), title: Text(DateFormat('yyyy-MM-dd HH:mm:ss').format(this.transaction.timestamp))),
                        ListTile(leading: Icon(Icons.credit_card), title: Text(Transaction.typeToString(this.transaction.type))),
                        ListTile(leading: Icon(Icons.attach_money), title: Text(NumberHelper.formatIDR(this.transaction.amount))),
                        ListTile(leading: Icon(Icons.notes), title: Text(this.transaction.description))
                    ]
                )
            )]
        );
    }

}

