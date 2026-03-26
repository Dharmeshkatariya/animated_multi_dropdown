# Animated Multi Dropdown

[![pub package](https://img.shields.io/pub/v/animated_multi_dropdown.svg)](https://pub.dev/packages/animated_multi_dropdown)
[![Flutter Platform](https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter)](https://flutter.dev)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A highly customizable animated multi-dropdown widget with **25+ stunning animations** including
glass morphism, liquid effects, neon, cyberpunk, and more.

---

## ✨ Features

| Category             | Features                            |
|----------------------|-------------------------------------|
| 🎨 **Animations**    | 25+ stunning animation strategies   |
| 📱 **Selection**     | Single & Multi selection with chips |
| 🔍 **Search**        | Built-in search with filtering      |
| 🎯 **Indicators**    | 16+ indicator types                 |
| ⚡ **Performance**    | Smooth 60 FPS animations            |
| 🎨 **Customization** | 50+ configuration options           |
| 📱 **Platforms**     | Android, iOS, Web, Desktop          |
| 🌓 **Dark Mode**     | Full dark mode support              |

---
A highly customizable animated multi-dropdown widget for Flutter with 25+ stunning animations
including glass morphism, liquid effects, neon, cyberpunk, and more.

✨ Features
🎨 25+ Animation Styles (Glass, Liquid, Neon, 3D, Holographic)
📱 Single & Multi Selection
🔍 Built-in Search & Filtering
🎯 16+ Indicator Types
⚡ Smooth 60 FPS Performance
🎨 Highly Customizable (50+ options)
🌙 Dark Mode Support
💻 Cross Platform (Android, iOS, Web, Desktop)
🚀 Quick Start
1️⃣ Add Dependency
dependencies:
animated_multi_dropdown: ^1.0.4
2️⃣ Import Package
import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
3️⃣ Basic Usage
🔹 Single Selection
String? selectedValue;

SimpleDropdownFactory.single(
items: ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'],
value: selectedValue,
onChanged: (value) => setState(() => selectedValue = value),
itemBuilder: (item) => Text(item),
hintText: 'Select a fruit',
animationType: DropdownAnimationType.glass,
);
🔹 Multiple Selection
List<String> selectedValues = [];

SimpleDropdownFactory.multiple(
items: ['Flutter', 'React', 'Vue.js', 'Angular', 'Svelte'],
value: selectedValues,
onChanged: (values) =>
setState(() => selectedValues = List<String>.from(values)),
itemBuilder: (item) => Text(item),
hintText: 'Select frameworks',
animationType: DropdownAnimationType.liquid,
);
🎨 Animation Types
🧊 Glass & Morphing
glass – Frosted blur effect
glassMorphism – Advanced glass UI
floatingGlass – Floating panels
floatingCard – Card-like animation
morphingGlass – Morph transitions
morphing – Smooth shape shift
🌊 Liquid & Fluid
liquid – Wave animation
liquidSmooth – Smooth fluid motion
fluidWave – Flowing effect
liquidMetal – Metallic liquid
liquidSwipe – Swipe-based effect
gradientWave – Gradient waves
💡 Neon & Cyber
neon – Glow effect
neonPulse – Pulsing glow
cyberpunk – Cyber grid style
cyberNeon – Neon cyber combo
🎯 3D & Bounce
bouncy3d – 3D bounce
gravityWell – Gravity pull
foldable – Folding UI
cosmicRipple – Ripple waves
🧬 Staggered & Holographic
staggered – Stagger animation
staggeredVerticalDropItem – Vertical drop
hologram – Scan lines
holographicFan – Fan spread
molecular – Bond-style animation
🎯 Indicator Types
🔘 Radio
SimpleDropdownFactory.radio(
items: items,
value: selectedValue,
onChanged: (value) => setState(() => selectedValue = value),
itemBuilder: (item) => Text(item),
activeColor: Colors.blue,
);

Types:

radio
radioCheckmark
radioDot
radioSquare
☑️ Checkbox
SimpleDropdownFactory.multiple(
items: items,
value: selectedValues,
onChanged: (values) => setState(() => selectedValues = values),
itemBuilder: (item) => Text(item),
indicatorType: IndicatorType.classic,
);

Types:

classic
checkmark
dotCheckbox
square
🔁 Toggle & Switch
SimpleDropdownFactory.toggle(
items: items,
value: selectedValue,
onChanged: (value) => setState(() => selectedValue = value),
itemBuilder: (item) => Text(item),
);
🌈 Gradient
SimpleDropdownFactory.gradientRadio(
items: items,
value: selectedValue,
onChanged: (value) => setState(() => selectedValue = value),
itemBuilder: (item) => Text(item),
gradientColors: [Colors.blue, Colors.purple],
);
🎨 Custom Indicator
SimpleDropdownFactory.customStarSingle(
items: items,
value: selectedValue,
onChanged: (value) => setState(() => selectedValue = value),
itemBuilder: (item) => Text(item),
activeColor: Colors.amber,
);
⚙️ Configuration
MultiDropDownConfig
Property Type Default Description
duration Duration 400ms Animation duration
highlightColor Color Blue Selected color
backgroundColor Color White Background
borderRadius BorderRadius 12px Radius
selectorHeight double 48 Height
enableSearch bool false Enable search
showSelectedItemsAsChips bool true Show chips
enableHapticFeedback bool false Haptics
🛠 Advanced Usage
🎨 Styled Dropdown
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
🧩 Custom Indicator Builder
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
),
);
},
);
🚀 Full Example
CustomAnimatedMultiDropDown<String>(
animationType: DropdownAnimationType.glass,
items: items,
value: selectedValue,
onChanged: (value) => setState(() => selectedValue = value),
itemBuilder: (item) => Text(item),
config: MultiDropDownConfig(
duration: Duration(milliseconds: 500),
highlightColor: Colors.teal,
borderRadius: BorderRadius.circular(16),
selectorHeight: 56,
enableSearch: true,
showSelectedItemsAsChips: true,
enableHapticFeedback: true,
),
);
📦 Installation

👉 https://pub.dev/packages/animated_multi_dropdown

📄 License

MIT License © 2026

💙 Support

If you like this package:

⭐ Star the repo
🐛 Report issues
🚀 Contribute