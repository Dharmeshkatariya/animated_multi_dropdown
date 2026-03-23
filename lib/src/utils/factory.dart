
import '../models/dropdown_animation_type.dart';
import '../models/multi_dropdown_config.dart' show MultiDropDownConfig;
import '../strategies/multi_dropdown_animation_strategy.dart';
import '../widgets/custom_animated_multi_dropdown.dart';

class DropdownStrategyFactory {
  static MultiDropdownAnimationStrategy<T> create<T>({
    required DropdownAnimationType type,
    required MultiDropDownConfig config,
  }) {
    switch (type) {
      case DropdownAnimationType.glass:
        return MultiGlassDropdownStrategy<T>();
      case DropdownAnimationType.liquid:
        return MultiLiquidDropdownStrategy<T>();
      default:
        return MultiGlassDropdownStrategy<T>();
    }
  }
}