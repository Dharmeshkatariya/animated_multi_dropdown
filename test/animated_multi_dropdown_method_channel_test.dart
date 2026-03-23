import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:animated_multi_dropdown/animated_multi_dropdown_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelAnimatedMultiDropdown platform = MethodChannelAnimatedMultiDropdown();
  const MethodChannel channel = MethodChannel('animated_multi_dropdown');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
