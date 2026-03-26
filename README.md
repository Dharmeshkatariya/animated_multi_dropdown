# Animated Multi Dropdown

[![pub package](https://img.shields.io/pub/v/animated_multi_dropdown.svg)](https://pub.dev/packages/animated_multi_dropdown)
[![Flutter Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A highly customizable animated multi-dropdown widget with **25+ stunning animations** including glass morphism, liquid effects, neon, cyberpunk, and more.

---

## ✨ Features

| Category | Features |
|----------|----------|
| 🎨 **Animations** | 25+ stunning animation strategies |
| 📱 **Selection** | Single & Multi selection with chips |
| 🔍 **Search** | Built-in search with filtering |
| 🎯 **Indicators** | 16+ indicator types |
| ⚡ **Performance** | Smooth 60 FPS animations |
| 🎨 **Customization** | 50+ configuration options |
| 📱 **Platforms** | Android, iOS, Web, Desktop |
| 🌓 **Dark Mode** | Full dark mode support |

---

## 🚀 Quick Start

### 1. Add Dependency

```yaml
dependencies:
  animated_multi_dropdown: ^1.0.4


2. Import Package

  import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';


3. Basic Usage
Single Selection:

dart
String? selectedValue;

SimpleDropdownFactory.single(
  items: ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'],
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  hintText: 'Select a fruit',
  animationType: DropdownAnimationType.glass,
)

Multiple Selection:

dart
List<String> selectedValues = [];

SimpleDropdownFactory.multiple(
  items: ['Flutter', 'React', 'Vue.js', 'Angular', 'Svelte'],
  value: selectedValues,
  onChanged: (values) => setState(() => selectedValues = List<String>.from(values)),
  itemBuilder: (item) => Text(item),
  hintText: 'Select frameworks',
  animationType: DropdownAnimationType.liquid,
)




 Animation Types
Glass & Morphing (6 animations)
Animation	Description
glass	Frosted glass effect with blur
glassMorphism	Advanced glass morphing
floatingGlass	Floating glass panels
floatingCard	Card-like floating effect
morphingGlass	Morphing glass effect
morphing	Smooth shape morphing
Liquid & Fluid (6 animations)
Animation	Description
liquid	Smooth liquid wave effect
liquidSmooth	Extra smooth liquid animation
fluidWave	Flowing wave animation
liquidMetal	Metallic liquid effect
liquidSwipe	Swipe-style liquid effect
gradientWave	Gradient wave animation
Neon & Cyber (4 animations)
Animation	Description
neon	Glowing neon effect
neonPulse	Pulsing neon glow
cyberpunk	Cyberpunk grid effect
cyberNeon	Cyberpunk with neon glow
3D & Bounce (4 animations)
Animation	Description
bouncy3d	3D bounce animation
gravityWell	Gravity pull effect
foldable	Folding card effect
cosmicRipple	Cosmic wave ripple
Staggered & Holographic (5 animations)
Animation	Description
staggered	Staggered item animation
staggeredVerticalDropItem	Vertical staggered effect
hologram	Holographic scan lines
holographicFan	Holographic fan spread
molecular	Molecular bonding animation
🎨 Indicator Types
Radio Indicators
Type	Code Example
Classic Radio	SimpleDropdownFactory.radio()
Radio with Checkmark	IndicatorType.radioCheckmark
Radio with Dot	IndicatorType.radioDot
Square Radio	IndicatorType.radioSquare



// Classic Radio
SimpleDropdownFactory.radio(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  activeColor: Colors.blue,
);



Checkbox Indicators
Type	Code Example
Classic Checkbox	IndicatorType.classic
Modern Checkbox	IndicatorType.checkmark
Dot Checkbox	SimpleDropdownFactory.dotCheckbox()
Square Checkbox	IndicatorType.square

// Classic Checkbox
SimpleDropdownFactory.multiple(
  items: items,
  value: selectedValues,
  onChanged: (values) => setState(() => selectedValues = values),
  itemBuilder: (item) => Text(item),
  indicatorType: IndicatorType.classic,
);



Toggle & Switch
Type	Code Example
Toggle Style	SimpleDropdownFactory.toggle()
Switch Style	SimpleDropdownFactory.switchStyle()


// Toggle Style
SimpleDropdownFactory.toggle(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
);
Gradient Indicators
Type	Code Example
Gradient Radio	SimpleDropdownFactory.gradientRadio()
Gradient Checkbox	SimpleDropdownFactory.gradientCheckbox()


// Gradient Radio
SimpleDropdownFactory.gradientRadio(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  gradientColors: [Colors.blue, Colors.purple],
);


Neumorphic Indicators
Type	Code Example
Neumorphic Radio	IndicatorType.neumorphic
Neumorphic Checkbox	IndicatorType.neumorphic
Custom Indicators
Type	Code Example
Star Icon	SimpleDropdownFactory.customStarSingle()
Heart Icon	SimpleDropdownFactory.customHeartMultiple()
dart
// Custom Star Indicator
SimpleDropdownFactory.customStarSingle(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  activeColor: Colors.amber,
);
⚙️ Configuration Options
MultiDropDownConfig
Property	Type	Default	Description
duration	Duration	400ms	Animation duration
highlightColor	Color	Colors.blue	Selection highlight color
backgroundColor	Color	Colors.white	Dropdown background color
borderRadius	BorderRadius	12px	Border radius
selectorHeight	double	48px	Selector height
selectorWidth	double	∞	Selector width
enableSearch	bool	false	Enable search functionality
showSelectedItemsAsChips	bool	true	Show chips in multi-select
chipColor	Color?	Colors.grey[200]	Chip background color
chipSpacing	double	8px	Spacing between chips
enableHapticFeedback	bool	false	Haptic feedback on interactions
🛠️ Advanced Usage
Custom Styling with SimpleDropdownStyle
dart
SimpleDropdownFactory.styledSingle(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  style: SimpleDropdownStyle.glass(
    highlightColor: Colors.purple,
    height: 56,
    width: double.infinity,
  ),
);
Custom Indicator Builder
dart
SimpleDropdownFactory.single(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  indicatorType: IndicatorType.custom,
  customIndicatorBuilder: (context, isSelected, color) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      child: Icon(
        isSelected ? Icons.favorite : Icons.favorite_border,
        color: color,
        size: 24,
      ),
    );
  },
);
Full Configuration Example
dart
CustomAnimatedMultiDropDown<String>(
  animationType: DropdownAnimationType.glass,
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  config: MultiDropDownConfig(
    duration: Duration(milliseconds: 500),
    highlightColor: Colors.teal,
    backgroundColor: Colors.white,
    borderRadius: BorderRadius.circular(16),
    selectorHeight: 56,
    enableSearch: true,
    showSelectedItemsAsChips: true,
    enableHapticFeedback: true,
  ),
);