import 'package:path/path.dart' as path;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class AssetProvider {

    static Future<String> loadString(String assetPath) async {
        return await rootBundle.loadString(path.join('assets', assetPath));
    }

}

