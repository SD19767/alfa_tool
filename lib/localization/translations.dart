import 'dart:convert';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/foundation.dart';

class AppTranslations extends Translations {
  final fallbackLocale = const Locale('en', 'US');

  Future<void> loadTranslations() async {
    var translations = <String, Map<String, String>>{};

    try {
      // Define the list of languages and their corresponding JSON file paths
      final languages = ['en_US', 'zh_TW', 'zh_CN', 'ja_JP'];

      for (var lang in languages) {
        var filePath = 'assets/translations/$lang.json';
        String jsonString = await rootBundle.loadString(filePath);
        Map<String, dynamic> jsonMap = json.decode(jsonString);

        // Convert the JSON map to the required format
        translations[lang] =
            jsonMap.map((key, value) => MapEntry(key, value.toString()));
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
