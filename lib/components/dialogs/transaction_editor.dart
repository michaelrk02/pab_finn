import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pab_finn/models/transaction.dart';
import 'package:pab_finn/components/pages/ledger_page.dart';

enum TransactionEditorAction {
    create,
    update
}

class TransactionEditorDialog extends StatefulWidget {

    Transaction transaction;
    TransactionEditorAction action;

    TransactionEditorDialog({
        required this.transaction,
        required this.action,
        Key? key
    }) : super(key: key);

    @override
    State<TransactionEditorDialog> createState() => _TransactionEditorDialogState(transaction: this.transaction, action: this.action);

}

class _TransactionEditorDialogState extends State<TransactionEditorDialog> {

    Transaction transaction;
    TransactionEditorAction action;

    late DateTime _timestampDateController;
    late TimeOfDay _timestampTimeController;
    late TransactionType _typeController;
    late TextEditingController _titleController;
    late TextEditingController _descriptionController;
    late TextEditingController _amountController;

    _TransactionEditorDialogState({
        required this.transaction,
        required this.action
    });

    @override
    void initState() {
        super.initState();
        this._timestampDateController = DateTime.parse(DateFormat('yyyy-MM-dd').format(this.transaction.timestamp));
        this._timestampTimeController = TimeOfDay.fromDateTime(this.transaction.timestamp);
        this._typeController = this.transaction.type;
        this._titleController = TextEditingController(text: this.transaction.title);
        this._descriptionController = TextEditingController(text: this.transaction.description);
        this._amountController = TextEditingController(text: this.transaction.amount.toString());
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
            title: this.action == TransactionEditorAction.create ? Text('Create New Transaction') : Text('Edit Transaction'),
            children: <Widget>[
                Container(
                    width: 300,
                    height: 300,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Text('Timestamp'),
                                    ListTile(
                                        leading: Icon(Icons.calendar_month),
                                        title: Text(DateFormat('yyyy-MM-dd').format(this._timestampDateController)),
                                        trailing: OutlinedButton(
                                            child: Text('Change'),
                                            onPressed: () async {
                                                var date = await showDatePicker(
                                                    context: context,
                                                    initialDate: this._timestampDateController,
                                                    firstDate: DateTime.parse('1900-01-01'),
                                                    lastDate: DateTime.parse('2100-12-31')
                                                );
                                                if (date != null) {
                                                    this.setState(() {
                                                        this._timestampDateController = date;
                                                    });
                                                }
                                            }
                                        )
                                    ),
                                    ListTile(
                                        leading: Icon(Icons.schedule),
                                        title: Text(this._timestampTimeController.format(context)),
                                        trailing: OutlinedButton(
                                            child: Text('Change'),
                                            onPressed: () async {
                                                var time = await showTimePicker(
                                                    context: context,
                                                    initialTime: this._timestampTimeController
                                                );
                                                if (time != null) {
                                                    this.setState(() {
                                                        this._timestampTimeController = time;
                                                    });
                                                }
                                            }
                                        )
                                    )
                                ]
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                    Text('Type'),
                                    ListTile(
                                        leading: Radio<TransactionType>(
                                            value: TransactionType.income,
                                            groupValue: this._typeController,
                                            onChanged: this._onChangeType
                                        ),
                                        title: Text('Income')
                                    ),
                                    ListTile(
                                        leading: Radio<TransactionType>(
                                            value: TransactionType.expense,
                                            groupValue: this._typeController,
                                            onChanged: this._onChangeType
                                        ),
                                        title: Text('Expense')
                                    )
                                ]
                            ),
                            TextField(
                                controller: this._titleController,
                                decoration: InputDecoration(labelText: 'Title')
                            ),
                            TextField(
                                controller: this._descriptionController,
                                decoration: InputDecoration(labelText: 'Description'),
                                maxLines: null
                            ),
                            TextField(
                                controller: this._amountController,
                                decoration: InputDecoration(labelText: 'Amount'),
                                keyboardType: TextInputType.numberWithOptions(signed: true)
                            )
                        ]
                    )
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                             this.action == TransactionEditorAction.create ? Container() : TextButton(
                                child: Text('Delete'),
                                onPressed: () {
                                    this.transaction.delete();
                                    Navigator.pop(context);
                                    LedgerPage.transactionListView.currentState?.populate(true);
                                }
                            ),
                            TextButton(
                                child: Text('Save'),
                                onPressed: () {
                                    this.transaction.timestamp = this._timestampDateController.add(Duration(hours: this._timestampTimeController.hour, minutes: this._timestampTimeController.minute));
                                    this.transaction.type = this._typeController;
                                    this.transaction.title = this._titleController.text;
                                    this.transaction.description = this._descriptionController.text;
                                    this.transaction.amount = int.parse(this._amountController.text);
                                    this.transaction.save();
                                    Navigator.pop(context);
                                    LedgerPage.transactionListView.currentState?.populate(true);
                                }
                            )
                        ]
                    )
                )
            ]
        );
    }

    void _onChangeType(TransactionType? value) {
        this.setState(() {
            this._typeController = value!;
        });
    }

}
