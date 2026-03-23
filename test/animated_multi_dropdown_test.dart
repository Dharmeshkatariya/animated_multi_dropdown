import 'package:flutter_test/flutter_test.dart';
import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
import 'package:animated_multi_dropdown/animated_multi_dropdown_platform_interface.dart';
import 'package:animated_multi_dropdown/animated_multi_dropdown_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockAnimatedMultiDropdownPlatform
    with MockPlatformInterfaceMixin
    implements AnimatedMultiDropdownPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final AnimatedMultiDropdownPlatform initialPlatform = AnimatedMultiDropdownPlatform.instance;

  test('$MethodChannelAnimatedMultiDropdown is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelAnimatedMultiDropdown>());
  });

  test('getPlatformVersion', () async {
    AnimatedMultiDropdown animatedMultiDropdownPlugin = AnimatedMultiDropdown();
    MockAnimatedMultiDropdownPlatform fakePlatform = MockAnimatedMultiDropdownPlatform();
    AnimatedMultiDropdownPlatform.instance = fakePlatform;

    expect(await animatedMultiDropdownPlugin.getPlatformVersion(), '42');
  });
}
