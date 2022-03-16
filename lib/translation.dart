import 'package:get/get.dart';
import 'package:todo_app/utils_langs/ar.dart';
import 'package:todo_app/utils_langs/en.dart';

class TranslationController extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en': en,
        'ar': ar,
      };
}
