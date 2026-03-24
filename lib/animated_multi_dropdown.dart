/// A highly customizable animated multi-dropdown widget.
///
/// This package provides a beautiful, animated dropdown widget with
/// multiple animation styles including glass morphism, liquid effects,
/// neon glow, cyberpunk, and many more.
///
/// ## Features
///
/// - **20+ Animation Types**: Glass, Liquid, Neon, Cyberpunk, Hologram, etc.
/// - **Single/Multiple Selection**: Support for both selection modes
/// - **Search Functionality**: Built-in search for large lists
/// - **Chip Display**: Show selected items as chips in multi-select mode
/// - **Highly Customizable**: Extensive configuration options
/// - **Haptic Feedback**: Optional haptic feedback on interactions
library animated_multi_dropdown;

// ==================== MODELS ====================
export 'src/models/selection_mode.dart';
export 'src/models/dropdown_animation_type.dart';
export 'src/models/multi_dropdown_config.dart';

// ==================== WIDGETS ====================
export 'src/widgets/custom_animated_multi_dropdown.dart';
export 'src/widgets/indicator.dart';
export 'src/widgets/custom_text.dart';
export 'src/widgets/custom_container.dart';
export 'src/widgets/custom_button.dart';
export 'src/widgets/custom_card.dart';
export 'src/widgets/custom_chip.dart';
export 'src/widgets/custom_loading.dart';

// ==================== THEME ====================
export 'src/theme/app_colors.dart';
export 'src/theme/app_text_styles.dart';

// ==================== PAINTERS ====================
export 'src/painters/bond_painter.dart';
export 'src/painters/cosmic_ripple_painter.dart';
export 'src/painters/cyber_grid_painter.dart';
export 'src/painters/fluid_clipper.dart';
export 'src/painters/fluid_liquid_backdrown_painter.dart';
export 'src/painters/fluid_wave_painter.dart';
export 'src/painters/glitch_painter.dart';
export 'src/painters/gradient_wave_painter.dart';
export 'src/painters/gravity_well_painter.dart';
export 'src/painters/holo_gram_painter.dart';
export 'src/painters/liquid_swipe_painter.dart';
export 'src/painters/liquid_wave_clipper.dart';
export 'src/painters/morphing.dart';
export 'src/painters/morphing_gradient_painter.dart';

// ==================== UTILS ====================
export 'src/utils/color_utils.dart';
export 'src/utils/drop_down_physics.dart';