import 'package:intl/intl.dart';

class NumberHelper {

    static String formatIDR(int? number) {
        var numberFormat = NumberFormat.decimalPattern('en_US');
        return 'IDR ' + numberFormat.format(number);
    }

}

