import '../models/dropdown_animation_type.dart';
import 'multi_dropdown_animation_strategy.dart';
import 'glass_strategy/glass_strategy.dart';
import 'liquid_strategy/liquid_strategy.dart';
import 'neon_strategy/neon_strategy.dart';
import 'bounce3d_strategy/bounce3d_strategy.dart';
import 'floating_card_strategy/floating_card_strategy.dart';
import 'morphing_strategy/morphing_strategy.dart';
import 'staggered_strategy/staggered_strategy.dart';
import 'staggered_vertical_strategy/staggered_vertical_strategy.dart';
import 'foldable_strategy/foldable_strategy.dart';
import 'fluid_wave_strategy/fluid_wave_strategy.dart';
import 'holographic_fan_strategy/holographic_fan_strategy.dart';
import 'molecular_strategy/molecular_strategy.dart';
import 'cosmic_ripple_strategy/cosmic_ripple_strategy.dart';
import 'gravity_well_strategy/gravity_well_strategy.dart';
import 'neon_pulse_strategy/neon_pulse_strategy.dart';
import 'glass_morphism_strategy/glass_morphism_strategy.dart';
import 'liquid_swipe_strategy/liquid_swipe_strategy.dart';
import 'cyberpunk_strategy/cyberpunk_strategy.dart';
import 'morphing_glass_strategy/morphing_glass_strategy.dart';
import 'hologram_strategy/hologram_strategy.dart';
import 'liquid_metal_strategy/liquid_metal_strategy.dart';
import 'cyber_neon_strategy/cyber_neon_strategy.dart';
import 'gradient_wave_strategy/gradient_wave_strategy.dart';
import 'floating_glass_strategy/floating_glass_strategy.dart';
import 'liquid_smooth_strategy/liquid_smooth_strategy.dart';

/// Factory class for creating dropdown animation strategies
class StrategyFactory {
  static MultiDropdownAnimationStrategy<T> create<T>(
      DropdownAnimationType type) {
    switch (type) {
      case DropdownAnimationType.glass:
        return MultiGlassDropdownStrategy<T>();
      case DropdownAnimationType.liquid:
        return MultiLiquidDropdownStrategy<T>();
      case DropdownAnimationType.neon:
        return MultiNeonDropdownStrategy<T>();
      case DropdownAnimationType.bouncy3d:
        return MultiBounce3DDropdownStrategy<T>();
      case DropdownAnimationType.floatingCard:
        return FloatingCardsMultiDropdownStrategy<T>();
      case DropdownAnimationType.morphing:
        return MorphingMultiDropdownStrategy<T>();
      case DropdownAnimationType.staggered:
        return StaggeredMultiDropdownStrategy<T>();
      case DropdownAnimationType.staggeredVerticalDropItem:
        return StaggeredVerticalMultiDropdownStrategy<T>();
      case DropdownAnimationType.foldable:
        return FoldableMultiDropdownStrategy<T>();
      case DropdownAnimationType.fluidWave:
        return FluidWaveMultiDropdownStrategy<T>();
      case DropdownAnimationType.holographicFan:
        return HolographicFanMultiDropdownStrategy<T>();
      case DropdownAnimationType.molecular:
        return MolecularMultiDropdownStrategy<T>();
      case DropdownAnimationType.cosmicRipple:
        return CosmicRippleMultiDropdownStrategy<T>();
      case DropdownAnimationType.gravityWell:
        return GravityWellMultiDropdownStrategy<T>();
      case DropdownAnimationType.neonPulse:
        return NeonPulseMultiDropdownStrategy<T>();
      case DropdownAnimationType.glassMorphism:
        return GlassMorphismMultiDropdownStrategy<T>();
      case DropdownAnimationType.liquidSwipe:
        return LiquidSwipeMultiDropdownStrategy<T>();
      case DropdownAnimationType.cyberpunk:
        return CyberpunkMultiDropdownStrategy<T>();
      case DropdownAnimationType.morphingGlass:
        return MorphingGlassMultiDropdownStrategy<T>();
      case DropdownAnimationType.hologram:
        return HologramMultiDropdownStrategy<T>();
      case DropdownAnimationType.liquidMetal:
        return LiquidMetalMultiDropdownStrategy<T>();
      case DropdownAnimationType.cyberNeon:
        return CyberNeonMultiDropdownStrategy<T>();
      case DropdownAnimationType.gradientWave:
        return GradientWaveMultiDropdownStrategy<T>();
      case DropdownAnimationType.floatingGlass:
        return FloatingGlassMultiDropdownStrategy<T>();
      case DropdownAnimationType.liquidSmooth:
        return LiquidSmoothMultiDropdownStrategy<T>();
    }
  }
}
