import 'package:flutter/material.dart';
import 'package:pab_finn/components/app.dart';
import 'package:pab_finn/providers/database_provider.dart';

class AppService {

    static Future<void> init() async {
        WidgetsFlutterBinding.ensureInitialized();

        await DatabaseProvider.init();

        runApp(App());
    }

}

