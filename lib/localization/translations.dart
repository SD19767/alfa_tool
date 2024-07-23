import 'dart:ui';
import 'package:get/get.dart';
import 'package:excel/excel.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

class AppTranslations extends Translations {
  final fallbackLocale = const Locale('en', 'US');

  Future<void> loadTranslations() async {
    var translations = <String, Map<String, String>>{};

    try {
      var filePath = 'assets/translations.xlsx';
      ByteData data = await rootBundle.load(filePath);
      List<int> bytes = data.buffer.asUint8List();
      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys) {
        var sheet = excel.tables[table];
        if (sheet != null) {
          var header = sheet.rows[0];
          for (var i = 1; i < sheet.rows.length; i++) {
            var row = sheet.rows[i];
            for (var j = 1; j < row.length; j++) {
              var lang = header[j]!.value.toString();
              var key = row[0]!.value.toString();
              var value = row[j]!.value.toString();
              if (!translations.containsKey(lang)) {
                translations[lang] = {};
              }
              translations[lang]![key] = value;
            }
          }
        }
      }

      _translations = translations;
      debugPrint('Alvin test: Translations updated successfully');
    } catch (e) {
      debugPrint('Alvin test: Error loading translations: $e');
    }
  }

  @override
  Map<String, Map<String, String>> get keys => _translations;
  Map<String, Map<String, String>> _translations = {};
}
