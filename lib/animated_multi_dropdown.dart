/// Animated Multi Dropdown
///
/// A highly customizable animated multi-dropdown widget with 25+ stunning animations
/// including glass morphism, liquid effects, neon, cyberpunk, and more.
///
/// ## Features
/// - 25+ stunning animation strategies
/// - Single & Multi selection modes
/// - Built-in search functionality
/// - 16+ indicator types
/// - Full customization options
/// - Responsive across all platforms
///
/// ## Quick Start
/// ```dart
/// import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
///
/// // Single selection
/// SimpleDropdownFactory.single(
///   items: ['Apple', 'Banana', 'Orange'],
///   value: selectedValue,
///   onChanged: (value) => setState(() => selectedValue = value),
///   itemBuilder: (item) => Text(item),
///   animationType: DropdownAnimationType.glass,
/// );
/// ```
library animated_multi_dropdown;

// ==================== MODELS ====================
/// Selection mode types (single or multiple)
export 'src/models/selection_mode.dart';

/// All available animation types (25+ animations)
export 'src/models/dropdown_animation_type.dart';

/// Configuration class for full customization
export 'src/models/multi_dropdown_config.dart';

// ==================== WIDGETS ====================
/// Main dropdown widget with all animations
export 'src/widgets/custom_animated_multi_dropdown.dart';

/// Indicator widget for selection indicators
export 'src/widgets/indicator.dart';

/// Custom text widget with animations
export 'src/widgets/custom_text.dart';

/// Custom container widget
export 'src/widgets/custom_container.dart';

/// Custom button widget
export 'src/widgets/custom_button.dart';

/// Custom card widget
export 'src/widgets/custom_card.dart';

/// Custom chip widget for multi-select
export 'src/widgets/custom_chip.dart';

/// Custom loading widget
export 'src/widgets/custom_loading.dart';

// ==================== THEME ====================
/// App colors for consistent theming
export 'src/theme/app_colors.dart';

/// App text styles
export 'src/theme/app_text_styles.dart';

// ==================== STRATEGIES ====================
/// Base animation strategy interface
export 'src/strategies/multi_dropdown_animation_strategy.dart';

/// Factory for creating animation strategies
export 'src/strategies/strategy_factory.dart';

/// Index of all strategies
export 'src/strategies/index.dart';

// ==================== PAINTERS ====================
/// Bond painter for molecular animation
export 'src/painters/bond_painter.dart';

/// Cosmic ripple painter
export 'src/painters/cosmic_ripple_painter.dart';

/// Cyber grid painter for cyberpunk effect
export 'src/painters/cyber_grid_painter.dart';

/// Fluid clipper for liquid animations
export 'src/painters/fluid_clipper.dart';

/// Fluid liquid backdrop painter
export 'src/painters/fluid_liquid_backdrown_painter.dart';

/// Fluid wave painter
export 'src/painters/fluid_wave_painter.dart';

/// Glitch painter for cyberpunk effect
export 'src/painters/glitch_painter.dart';

/// Gradient wave painter
export 'src/painters/gradient_wave_painter.dart';

/// Gravity well painter
export 'src/painters/gravity_well_painter.dart';

/// Hologram painter
export 'src/painters/holo_gram_painter.dart';

/// Liquid swipe painter
export 'src/painters/liquid_swipe_painter.dart';

/// Liquid wave clipper
export 'src/painters/liquid_wave_clipper.dart';

/// Morphing painter
export 'src/painters/morphing.dart';

/// Morphing gradient painter
export 'src/painters/morphing_gradient_painter.dart';

// ==================== UTILS ====================
/// Color file utilities
export 'src/utils/color_file.dart';

/// Color utilities with modern API
export 'src/utils/color_utils.dart';

/// Custom matrix utilities for 3D transformations
export 'src/utils/custom_matrix_utils.dart';

/// Dropdown physics for custom scrolling
export 'src/utils/drop_down_physics.dart';

// ==================== FACTORY & PRESETS ====================
/// Simple dropdown factory for easy setup
export 'src/strategies/simple_dropdown_factory.dart';

/// Pre-configured dropdowns for common use cases
export 'src/strategies/preset_dropdowns.dart';