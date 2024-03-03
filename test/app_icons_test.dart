import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:psws_storage/res/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.icCheck).existsSync(), isTrue);
    expect(File(AppIcons.icExport).existsSync(), isTrue);
    expect(File(AppIcons.icFile).existsSync(), isTrue);
    expect(File(AppIcons.icFolder).existsSync(), isTrue);
    expect(File(AppIcons.icImport).existsSync(), isTrue);
    expect(File(AppIcons.icInformation).existsSync(), isTrue);
    expect(File(AppIcons.icLock).existsSync(), isTrue);
    expect(File(AppIcons.icPoints).existsSync(), isTrue);
    expect(File(AppIcons.icSettings).existsSync(), isTrue);
    expect(File(AppIcons.icUp).existsSync(), isTrue);
  });
}
