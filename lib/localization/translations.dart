import 'dart:ui';

import 'package:get/get.dart';

class AppTranslations extends Translations {
  final fallbackLocale = const Locale('en', 'US');
//todo: 用 xlsx 整理，轉成 json 再讀取
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': {
          'app_title': 'Alfa Tool',
          'start_provisioning': 'Start Provisioning',
          'enter_ssid': 'Enter SSID',
          'enter_password': 'Enter Password',
          'enter_custom_data': 'Enter Custom Data',
          'enter_aes_key': 'Enter AES Key',
          'view_events': 'View Events',
          'event_log': 'Event Log',
          'close': 'Close',
          'retry': 'Retry',
        },
        'zh_TW': {
          'app_title': 'Alfa 工具',
          'start_provisioning': '開始配置',
          'enter_ssid': '輸入SSID',
          'enter_password': '輸入密碼',
          'enter_custom_data': '輸入自定義數據',
          'enter_aes_key': '輸入AES密鑰',
          'view_events': '查看事件',
          'event_log': '事件日誌',
          'close': '關閉',
          'retry': '重試',
        },
        'zh_CN': {
          'app_title': 'Alfa 工具',
          'start_provisioning': '开始配置',
          'enter_ssid': '输入SSID',
          'enter_password': '输入密码',
          'enter_custom_data': '输入自定义数据',
          'enter_aes_key': '输入AES密钥',
          'view_events': '查看事件',
          'event_log': '事件日志',
          'close': '关闭',
          'retry': '重试',
        },
        'ja_JP': {
          'app_title': 'Alfa ツール',
          'start_provisioning': 'プロビジョニングを開始',
          'enter_ssid': 'SSIDを入力',
          'enter_password': 'パスワードを入力',
          'enter_custom_data': 'カスタムデータを入力',
          'enter_aes_key': 'AESキーを入力',
          'view_events': 'イベントを表示',
          'event_log': 'イベントログ',
          'close': '閉じる',
          'retry': 'リトライ',
        },
      };
}
