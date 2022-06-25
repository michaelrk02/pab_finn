import 'dart:math';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:pab_finn/providers/database_provider.dart';
import 'package:pab_finn/models/ledger.dart';

class Transaction {

    static const String table = 'transaction';

    int id;
    int ledgerID;
    DateTime timestamp;
    String type;
    String title;
    String description;
    int amount;

    Transaction({
        required this.id,
        required this.ledgerID,
        required this.timestamp,
        required this.type,
        required this.title,
        required this.description,
        required this.amount
    });

    factory Transaction.create({
        required Ledger ledger,
        required DateTime timestamp,
        required String type,
        required String title,
        required String description,
        required int amount
    }) {
        var id = Random().nextInt(1 << 32);
        return Transaction(
            id: id,
            ledgerID: ledger.id,
            timestamp: timestamp,
            type: type,
            title: title,
            description: description,
            amount: amount
        );
    }

    factory Transaction.parse(Map<String, dynamic> data) {
        return Transaction(
            id: data['id'],
            ledgerID: data['ledger'],
            timestamp: DateTime.parse(data['timestamp']),
            type: data['type'],
            title: data['title'],
            description: data['description'],
            amount: data['amount']
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

    Future<int> save() async {
        return Transaction.db().insert(Transaction.table, this.prepare(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }

    Future<Ledger?> get ledger async {
        return await Ledger.find(this.ledgerID);
    }

    Map<String, dynamic> prepare() {
        return {
            'id': this.id,
            'ledger': this.ledgerID,
            'timestamp': this.timestamp.toIso8601String(),
            'type': this.type,
            'title': this.title,
            'description': this.description,
            'amount': this.amount
        };
    }

}

