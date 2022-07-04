import 'dart:math';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:pab_finn/providers/database_provider.dart';
import 'package:pab_finn/models/ledger.dart';

class Transaction {

    static const String table = 'transaction';

    int id;
    int ledgerID;
    DateTime timestamp;
    TransactionType type;
    int amount;
    String title;
    String description;

    Transaction({
        required this.id,
        required this.ledgerID,
        required this.timestamp,
        required this.type,
        required this.amount,
        required this.title,
        required this.description
    });

    factory Transaction.create({
        required Ledger ledger,
        required DateTime timestamp,
        required TransactionType type,
        required int amount,
        required String title,
        required String description
    }) {
        var id = Random().nextInt(1 << 32);
        return Transaction(
            id: id,
            ledgerID: ledger.id,
            timestamp: timestamp,
            type: type,
            amount: amount,
            title: title,
            description: description
        );
    }

    factory Transaction.parse(Map<String, dynamic> data) {
        return Transaction(
            id: data['id'],
            ledgerID: data['ledger'],
            timestamp: DateTime.parse(data['timestamp']),
            type: Transaction.typeFromString(data['type']),
            amount: data['amount'],
            title: data['title'],
            description: data['description']
        );
    }

    static sqflite.Database db() {
        return DatabaseProvider.getInstance();
    }

    static Future<Transaction?> find(int id) async {
        Transaction? transaction;
        var list = await Transaction.db().query(Transaction.table, where: 'id = ?', whereArgs: [id]);
        if (list.length > 0) {
            transaction = Transaction.parse(list[0]);
        }
        return transaction;
    }

    Future<void> refresh() async {
        Transaction? transaction = await Transaction.find(this.id);
        if (transaction != null) {
            this.ledgerID = transaction.ledgerID;
            this.timestamp = transaction.timestamp;
            this.type = transaction.type;
            this.amount = transaction.amount;
            this.title = transaction.title;
            this.description = transaction.description;
        }
    }

    Future<int> save() async {
        return Transaction.db().insert(Transaction.table, this.prepare(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }

    Future<void> delete() async {
        await Transaction.db().delete(Transaction.table, where: 'id = ?', whereArgs: [this.id]);
    }

    Future<Ledger?> get ledger async {
        return await Ledger.find(this.ledgerID);
    }

    Map<String, dynamic> prepare() {
        return {
            'id': this.id,
            'ledger': this.ledgerID,
            'timestamp': this.timestamp.toIso8601String(),
            'type': Transaction.typeToString(this.type),
            'amount': this.amount,
            'title': this.title,
            'description': this.description
        };
    }

    static TransactionType typeFromString(String type) {
        switch (type) {
        case 'income':
            return TransactionType.income;
        case 'expense':
            return TransactionType.expense;
        }
        throw 'Invalid type';
    }

    static String typeToString(TransactionType type) {
        switch (type) {
        case TransactionType.income:
            return 'income';
        case TransactionType.expense:
            return 'expense';
        }
        throw 'Invalid operation';
    }

}

enum TransactionType {
    income,
    expense
}

