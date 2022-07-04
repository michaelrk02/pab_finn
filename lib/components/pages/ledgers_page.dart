import 'package:flutter/material.dart';
import 'package:pab_finn/components/app.dart';
import 'package:pab_finn/components/main_app_bar.dart';
import 'package:pab_finn/components/main_drawer.dart';
import 'package:pab_finn/components/ledger_list_view.dart';
import 'package:pab_finn/components/dialogs/ledger_editor.dart';
import 'package:pab_finn/models/ledger.dart';

class LedgersPage extends StatefulWidget {

    static final listView = GlobalKey<LedgerListViewState>();

    LedgersPage({Key? key}) : super(key: key);

    @override
    State<LedgersPage> createState() {
        return _LedgersPageState();
    }

}

class _LedgersPageState extends State<LedgersPage> {

    LedgerOrder _order = LedgerOrder.title;

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: _LedgersPageAppBar(),
            drawer: MainDrawer(context: context),
            floatingActionButton: FloatingActionButton(
                onPressed: () {
                    showDialog(
                        context: context,
                        builder: (context) => LedgerEditorDialog(ledger: Ledger.create(title: '', description: ''), action: LedgerEditorAction.create)
                    );
                },
                backgroundColor: Theme.of(context).colorScheme.tertiary,
                foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                child: Icon(Icons.add)
            ),
            body: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    child: Text('Order:', style: TextStyle(fontWeight: FontWeight.bold))
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ChoiceChip(
                                        avatar: Icon(Icons.abc),
                                        label: Text('Title'),
                                        selected: this._order == LedgerOrder.title,
                                        onSelected: this._changeOrderCallback(LedgerOrder.title)
                                    )
                                ),
                                Container(
                                    padding: EdgeInsets.symmetric(horizontal: 4.0),
                                    child: ChoiceChip(
                                        avatar: Icon(Icons.calendar_month),
                                        label: Text('Creation'),
                                        selected: this._order == LedgerOrder.creation,
                                        onSelected: this._changeOrderCallback(LedgerOrder.creation)
                                    )
                                )
                            ]
                        )
                    ),
                    LedgerListView(order: this._order, key: LedgersPage.listView)
                ]
            )
        );
    }

    ValueChanged<bool> _changeOrderCallback(LedgerOrder order) {
        return (selected) {
            if (selected) {
                this.setState(() {
                    this._order = order;
                });
            }
        };
    }

}

class _LedgersPageAppBar extends MainAppBar {

    _LedgersPageAppBar() : super(
        title: 'Ledgers',
        actions: <Widget>[
            PopupMenuButton<String>(
                icon: Icon(Icons.more_vert),
                onSelected: (item) {
                    LedgersPage.listView.currentState?.populate(true);
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

