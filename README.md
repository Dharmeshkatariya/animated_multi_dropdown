# 🚀 Animated Multi Dropdown

<p align="center">
  <img src="https://img.shields.io/pub/v/animated_multi_dropdown.svg" />
  <img src="https://img.shields.io/badge/Platform-Flutter-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/License-MIT-yellow.svg" />
</p>

<p align="center">
✨ <b>Turn boring dropdowns into stunning animated experiences</b> ✨  
</p>

---

## 🎬 Preview

> ⚠️ Add your GIF here (very important for pub.dev ranking)

```
assets/demo.gif
```

---

## ⚡ Why This Package?

Stop using plain dropdowns.

This package gives you:

* 🎨 **25+ Stunning Animations**
* 🎯 **16+ Indicator Styles**
* ⚡ **Smooth 60 FPS Performance**
* 🔍 **Built-in Search**
* 📱 **Single & Multi Select**
* 🎨 **Fully Customizable**
* 🌙 **Dark Mode Ready**
* 💻 **Works Everywhere (Android, iOS, Web, Desktop)**

---

## 🚀 Quick Start

### 1️⃣ Add Dependency

```yaml
dependencies:
  animated_multi_dropdown: ^1.0.4
```

---

### 2️⃣ Import

```dart
import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';
```

---

## 🟢 Basic Usage

### 🔹 Single Selection

```dart
String? selectedValue;

SimpleDropdownFactory.single(
  items: ['Apple', 'Banana', 'Orange', 'Mango', 'Grapes'],
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  hintText: 'Select a fruit',
  animationType: DropdownAnimationType.glass,
);
```

---

### 🔹 Multiple Selection

```dart
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
```

---

## 🎨 Animation Types

### 🧊 Glass & Morphing

* `glass`
* `glassMorphism`
* `floatingGlass`
* `floatingCard`
* `morphingGlass`
* `morphing`

### 🌊 Liquid & Fluid

* `liquid`
* `liquidSmooth`
* `fluidWave`
* `liquidMetal`
* `liquidSwipe`
* `gradientWave`

### 💡 Neon & Cyber

* `neon`
* `neonPulse`
* `cyberpunk`
* `cyberNeon`

### 🎯 3D & Physics

* `bouncy3d`
* `gravityWell`
* `foldable`
* `cosmicRipple`

### 🧬 Advanced Effects

* `staggered`
* `staggeredVerticalDropItem`
* `hologram`
* `holographicFan`
* `molecular`

---

## 🎯 Indicator Types

### 🔘 Radio

```dart
SimpleDropdownFactory.radio(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  activeColor: Colors.blue,
);
```

Types:

* `radio`
* `radioCheckmark`
* `radioDot`
* `radioSquare`

---

### ☑️ Checkbox

```dart
SimpleDropdownFactory.multiple(
  items: items,
  value: selectedValues,
  onChanged: (values) => setState(() => selectedValues = values),
  itemBuilder: (item) => Text(item),
  indicatorType: IndicatorType.classic,
);
```

Types:

* `classic`
* `checkmark`
* `dotCheckbox`
* `square`

---

### 🔁 Toggle & Switch

```dart
SimpleDropdownFactory.toggle(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
);
```

---

### 🌈 Gradient Indicators

```dart
SimpleDropdownFactory.gradientRadio(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  gradientColors: [Colors.blue, Colors.purple],
);
```

---

### 🎨 Custom Indicator

```dart
SimpleDropdownFactory.customStarSingle(
  items: items,
  value: selectedValue,
  onChanged: (value) => setState(() => selectedValue = value),
  itemBuilder: (item) => Text(item),
  activeColor: Colors.amber,
);
```

---

## ⚙️ Configuration

```dart
MultiDropDownConfig(
  duration: Duration(milliseconds: 500),
  highlightColor: Colors.teal,
  backgroundColor: Colors.white,
  borderRadius: BorderRadius.circular(16),
  selectorHeight: 56,
  enableSearch: true,
  showSelectedItemsAsChips: true,
  enableHapticFeedback: true,
)
```

---

## 🛠 Advanced Usage

### 🎨 Styled Dropdown

```dart
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
```

---

### 🧩 Custom Indicator Builder

```dart
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
```

---

### 🚀 Full Example

```dart
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
```

---

## 📦 Installation

👉 https://pub.dev/packages/animated_multi_dropdown

---

## 📄 License

MIT License © 2026

---

## 💙 Support

If you like this package:

* ⭐ Star the repo
* 🐛 Report issues
* 🚀 Contribute

---

## ❤️ Final Thought

> Don’t ship boring UI.
> Ship something users remember.

---
