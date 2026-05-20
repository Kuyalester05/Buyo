import 'package:buyo_piper_betle/src/shared/assets/app_assets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Piper betle leaf model asset is bundled', () async {
    final modelData = await rootBundle.load(AppAssets.piperBetleLeafModel);

    expect(modelData.lengthInBytes, greaterThan(0));
  });

  test('Piper betle leaf labels asset is bundled', () async {
    final labels = await rootBundle.loadString(AppAssets.piperBetleLeafLabels);

    expect(labels.trim().split('\n'), hasLength(5));
    expect(labels, contains('Healthy'));
  });
}
