import 'package:flutter/services.dart';

Future<String> saveCsv(String csv) async {
  await Clipboard.setData(ClipboardData(text: csv));
  return 'CSV copied to clipboard';
}

