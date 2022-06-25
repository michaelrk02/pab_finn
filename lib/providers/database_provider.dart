import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:pab_finn/providers/asset_provider.dart';

class DatabaseProvider {

    static late Database _connection;

    static Future<void> init() async {
        if (kDebugMode) {
            await Sqflite.devSetDebugModeOn(true);
        }

        DatabaseProvider._connection = await openDatabase(
            path.join(await getDatabasesPath(), 'finn.db'),
            version: 1,
            onCreate: (Database db, int version) async {
                await db.execute(await AssetProvider.loadString('database/schema/001-table-ledger.sql'));
                await db.execute(await AssetProvider.loadString('database/schema/002-table-transaction.sql'));
                await db.execute(await AssetProvider.loadString('database/schema/003-view-ledger_total_income.sql'));
                await db.execute(await AssetProvider.loadString('database/schema/004-view-ledger_total_expense.sql'));
                await db.execute(await AssetProvider.loadString('database/schema/005-view-ledger_balance.sql'));

                await db.execute(await AssetProvider.loadString('database/dummy/001-ledger.sql'));
                await db.execute(await AssetProvider.loadString('database/dummy/002-transaction.sql'));
            }
        );
    }

    static Database getInstance() {
        return DatabaseProvider._connection;
    }

}

