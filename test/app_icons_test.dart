import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:psws_storage/res/resources.dart';

void main() {
  test('app_icons assets test', () {
    expect(File(AppIcons.icCheck).existsSync(), true);
    expect(File(AppIcons.icExport).existsSync(), true);
    expect(File(AppIcons.icFile).existsSync(), true);
    expect(File(AppIcons.icFolder).existsSync(), true);
    expect(File(AppIcons.icImport).existsSync(), true);
    expect(File(AppIcons.icInformation).existsSync(), true);
    expect(File(AppIcons.icLock).existsSync(), true);
    expect(File(AppIcons.icPoints).existsSync(), true);
    expect(File(AppIcons.icSettings).existsSync(), true);
    expect(File(AppIcons.icUp).existsSync(), true);
    expect(File(AppIcons.five).existsSync(), true);
    expect(File(AppIcons.four).existsSync(), true);
    expect(File(AppIcons.one).existsSync(), true);
    expect(File(AppIcons.three).existsSync(), true);
    expect(File(AppIcons.two).existsSync(), true);
  });
}
