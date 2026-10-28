import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> saveCsv(String csv) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File(
    '${directory.path}${Platform.pathSeparator}'
    'posture_pulse_${DateTime.now().millisecondsSinceEpoch}.csv',
  );
  await file.writeAsString(csv);
  return 'CSV saved to ${file.path}';
}

