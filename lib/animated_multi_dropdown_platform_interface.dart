import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'animated_multi_dropdown_method_channel.dart';

abstract class AnimatedMultiDropdownPlatform extends PlatformInterface {
  /// Constructs a AnimatedMultiDropdownPlatform.
  AnimatedMultiDropdownPlatform() : super(token: _token);

  static final Object _token = Object();

  static AnimatedMultiDropdownPlatform _instance = MethodChannelAnimatedMultiDropdown();

  /// The default instance of [AnimatedMultiDropdownPlatform] to use.
  ///
  /// Defaults to [MethodChannelAnimatedMultiDropdown].
  static AnimatedMultiDropdownPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [AnimatedMultiDropdownPlatform] when
  /// they register themselves.
  static set instance(AnimatedMultiDropdownPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
