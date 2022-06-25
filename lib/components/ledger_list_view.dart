import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pab_finn/models/ledger.dart';
import 'package:pab_finn/components/pages/ledger_page.dart';
import 'package:pab_finn/helpers/number_helper.dart';

class LedgerListView extends StatefulWidget {
    LedgerOrder order;

    LedgerListView({
        required this.order,
        Key? key
    }) : super(key: key);

    @override
    State<LedgerListView> createState() {
        return LedgerListViewState();
    }
}

class LedgerListViewState extends State<LedgerListView> {
    late Future<void> _populated;
    late List<Ledger> _ledgers;

    @override
    void initState() {
        super.initState();

        this.populate();
    }

    @override
    Widget build(BuildContext context) {
        var futures = <Future<dynamic>>[];

        futures.add(this._populated);

        var ledgerTotalIncome = Map<int, int>();
        var ledgerTotalExpense = Map<int, int>();
        var ledgerBalance = Map<int, int>();
        futures.add(() async {
            await this._populated;
            for (var ledger in this._ledgers) {
                ledgerTotalIncome[ledger.id] = await ledger.totalIncome;
                ledgerTotalExpense[ledger.id] = await ledger.totalExpense;
                ledgerBalance[ledger.id] = await ledger.balance;
            }
        }());

        return FutureBuilder<void>(
            future: Future.wait(futures),
            builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                    var items = List<Widget>.generate(
                        this._ledgers.length,
                        (index) {
                            var ledger = this._ledgers[index];
                            var header = ListTile(
                                tileColor: Theme.of(context).colorScheme.secondary,
                                textColor: Theme.of(context).colorScheme.inversePrimary,
                                leading: Icon(Icons.book, color: Theme.of(context).colorScheme.inversePrimary),
                                title: Text(ledger.title)
                            );

                            var balanceColor = Colors.green;
                            var balance = ledgerBalance[ledger.id];
                            if (balance != null) {
                                if (balance < 0) {
                                    balanceColor = Colors.red;
                                }
                            }

                            var tile = Container(
                                padding: EdgeInsets.symmetric(vertical: 8.0),
                                child: ListTile(
                                    title: Text(
                                        'Balance ' + NumberHelper.formatIDR(balance),
                                        style: TextStyle(color: balanceColor)
                                    ),
                                    subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                            Text('Income ' + NumberHelper.formatIDR(ledgerTotalIncome[ledger.id])),
                                            Text('Expense ' + NumberHelper.formatIDR(ledgerTotalExpense[ledger.id]))
                                        ]
                                    )
                                )
                            );
                            var body = Container(
                                padding: EdgeInsets.zero,
                                child: Column(children: <Widget>[header, tile])
                            );
                            return Card(
                                shape: ContinuousRectangleBorder(),
                                elevation: 2.0,
                                margin: EdgeInsets.only(bottom: 16.0),
                                child: InkWell(
                                    onTap: this._viewLedgerCallback(context, ledger.id),
                                    child: body
                                )
                            );
                        }
                    );
                    return Column(children: items);
                } else {
                    return Center(heightFactor: 2.0, child: CircularProgressIndicator());
                }
            }
        );
    }

    @override
    void didUpdateWidget(LedgerListView oldWidget) {
        this.populate(true);
    }

    void populate([bool refresh = false]) {
        this._populated = (() async {
            this._ledgers = await Ledger.all(this.widget.order);
        })();
        if (refresh) {
            this.setState(() {});
        }
    }

    VoidCallback _viewLedgerCallback(BuildContext context, int ledgerID) {
        return () async {
            var ledger = await Ledger.find(ledgerID);
            if (ledger != null) {
                Navigator.push(context, MaterialPageRoute(builder: (context) => LedgerPage(ledger: ledger)));
            }
        };
    }
}

