import 'package:flutter/material.dart';
import 'package:pab_finn/models/ledger.dart';
import 'package:pab_finn/components/pages/ledgers_page.dart';
import 'package:pab_finn/components/pages/ledger_page.dart';

enum LedgerEditorAction {
    create,
    update
}

class LedgerEditorDialog extends StatefulWidget {

    Ledger ledger;
    LedgerEditorAction action;

    LedgerEditorDialog({
        required this.ledger,
        required this.action,
        Key? key
    }) : super(key: key);

    @override
    State<LedgerEditorDialog> createState() => _LedgerEditorDialogState(ledger: this.ledger, action: this.action);

}

class _LedgerEditorDialogState extends State<LedgerEditorDialog> {

    Ledger ledger;
    LedgerEditorAction action;

    late TextEditingController _titleController;
    late TextEditingController _descriptionController;

    _LedgerEditorDialogState({
        required this.ledger,
        required this.action
    });

    @override
    void initState() {
        super.initState();
        this._titleController = TextEditingController(text: this.ledger.title);
        this._descriptionController = TextEditingController(text: this.ledger.description);
    }

    @override
    void dispose() {
        this._titleController.dispose();
        this._descriptionController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        return SimpleDialog(
            title: this.action == LedgerEditorAction.create ? Text('Create New Ledger') : Text('Edit Ledger'),
            children: <Widget>[
                Container(
                    width: 300,
                    height: 300,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                            TextField(
                                controller: this._titleController,
                                decoration: InputDecoration(labelText: 'Title')
                            ),
                            TextField(
                                controller: this._descriptionController,
                                decoration: InputDecoration(labelText: 'Description'),
                                maxLines: null
                            )
                        ]
                    )
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                             this.action == LedgerEditorAction.create ? Container() : TextButton(
                                child: Text('Delete'),
                                onPressed: () async {
                                    await this.ledger.delete();
                                    Navigator.pop(context);
                                    if (LedgerPage.active.currentWidget != null) {
                                        Navigator.pop(context);
                                    }
                                    LedgersPage.listView.currentState?.populate(true);
                                }
                            ),
                            TextButton(
                                child: Text('Save'),
                                onPressed: () async {
                                    this.ledger.title = this._titleController.text;
                                    this.ledger.description = this._descriptionController.text;
                                    await this.ledger.save();
                                    Navigator.pop(context);
                                    LedgersPage.listView.currentState?.populate(true);

                                    await LedgerPage.active.currentState?.ledger.refresh();
                                    LedgerPage.active.currentState?.setState(() {});
                                }
                            )
                        ]
                    )
                )
            ]
        );
    }

}
