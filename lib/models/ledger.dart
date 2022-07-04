import 'dart:math';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:pab_finn/providers/database_provider.dart';
import 'package:pab_finn/models/transaction.dart';

enum LedgerOrder {
    title,
    creation
}

enum TransactionOrder {
    title,
    timestamp
}

class Ledger {

    static const String table = 'ledger';
    static const String totalIncomeView = 'ledger_total_income';
    static const String totalExpenseView = 'ledger_total_expense';
    static const String balanceView = 'ledger_balance';

    int id;
    String title;
    String description;
    DateTime createdAt;

    Ledger({
        required this.id,
        required this.title,
        required this.description,
        required this.createdAt
    });

    factory Ledger.create({
        required String title,
        required String description
    }) {
        var id = Random().nextInt(1 << 32);
        var createdAt = DateTime.now();
        return Ledger(
            id: id,
            title: title,
            description: description,
            createdAt: createdAt
        );
    }

    factory Ledger.parse(Map<String, dynamic> data) {
        return Ledger(
            id: data['id'],
            title: data['title'],
            description: data['description'],
            createdAt: DateTime.parse(data['created_at'])
        );
    }

    static sqflite.Database db() {
        return DatabaseProvider.getInstance();
    }

    static Future<List<Ledger>> all(LedgerOrder order) async {
        Map<LedgerOrder, String> orderExpr = {
            LedgerOrder.title: 'title',
            LedgerOrder.creation: 'DATETIME(created_at)',
        };

        var list = await Ledger.db().query(Ledger.table, orderBy: orderExpr[order]);
        return List<Ledger>.generate(list.length, (i) {
            return Ledger.parse(list[i]);
        });
    }

    static Future<Ledger?> find(int id) async {
        Ledger? ledger;
        var list = await Ledger.db().query(Ledger.table, where: 'id = ?', whereArgs: [id]);
        if (list.length > 0) {
            ledger = Ledger.parse(list[0]);
        }
        return ledger;
    }

    Future<void> refresh() async {
        Ledger? ledger = await Ledger.find(this.id);
        if (ledger != null) {
            this.title = ledger.title;
            this.description = ledger.description;
            this.createdAt = ledger.createdAt;
        }
    }

    Future<int> save() async {
        return await Ledger.db().insert(Ledger.table, this.prepare(), conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
    }

    Future<List<Transaction>> transactions(TransactionOrder order) async {
        Map<TransactionOrder, String> orderExpr = {
            TransactionOrder.title: '"title"',
            TransactionOrder.timestamp: 'DATETIME("timestamp")'
        };

        var list = await Ledger.db().query(Transaction.table, where: 'ledger = ?', whereArgs: [this.id], orderBy: orderExpr[order]);
        return List<Transaction>.generate(list.length, (i) {
            return Transaction.parse(list[i]);
        });
    }

    Future<void> delete() async {
        await Transaction.db().delete(Transaction.table, where: 'ledger = ?', whereArgs: [this.id]);
        await Ledger.db().delete(Ledger.table, where: 'id = ?', whereArgs: [this.id]);
    }

    Future<int> get totalIncome async {
        var data = await Ledger.db().query(Ledger.totalIncomeView, where: 'id = ?', whereArgs: [this.id]);
        return data[0]['total_income'] as int;
    }

    Future<int> get totalExpense async {
        var data = await Ledger.db().query(Ledger.totalExpenseView, where: 'id = ?', whereArgs: [this.id]);
        return data[0]['total_expense'] as int;
    }

    Future<int> get balance async {
        var data = await Ledger.db().query(Ledger.balanceView, where: 'id = ?', whereArgs: [this.id]);
        return data[0]['balance'] as int;
    }

    Map<String, dynamic> prepare() {
        return {
            'id': this.id,
            'title': this.title,
            'description': this.description,
            'created_at': this.createdAt.toIso8601String()
        };
    }

}
