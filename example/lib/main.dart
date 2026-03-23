import 'package:flutter/material.dart';
import 'package:animated_multi_dropdown/animated_multi_dropdown.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animated Multi Dropdown Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Selection values for different dropdowns
  Map<DropdownAnimationType, dynamic> selectedValues = {};
  Map<DropdownAnimationType, List<String>> selectedMultipleValues = {};

  // Sample data
  final List<String> fruits = [
    '🍎 Apple', '🍌 Banana', '🍊 Orange', '🥭 Mango',
    '🍇 Grapes', '🍓 Strawberry', '🫐 Blueberry', '🍒 Cherry',
    '🍍 Pineapple', '🍉 Watermelon', '🍑 Peach', '🍐 Pear'
  ];

  final List<String> countries = [
    '🇺🇸 United States', '🇬🇧 United Kingdom', '🇨🇦 Canada', '🇦🇺 Australia',
    '🇩🇪 Germany', '🇫🇷 France', '🇯🇵 Japan', '🇧🇷 Brazil',
    '🇮🇳 India', '🇨🇳 China', '🇿🇦 South Africa', '🇪🇬 Egypt'
  ];

  final List<String> programmingLanguages = [
    '🐍 Python', '🦀 Rust', '⚡ JavaScript', '🎯 Dart',
    '☕ Java', '🔷 C#', '💎 Ruby', '🐘 PHP',
    '🏃‍♂️ Go', '🦊 Kotlin', '🍎 Swift', '📱 Kotlin Multiplatform'
  ];

  final List<String> categories = [
    '🎨 Design', '💻 Development', '📊 Marketing', '💰 Sales',
    '📝 Writing', '🎬 Video', '🎵 Music', '📸 Photography'
  ];

  final List<Map<String, dynamic>> complexItems = [
    {'name': 'John Doe', 'role': 'Developer', 'avatar': '👨‍💻'},
    {'name': 'Jane Smith', 'role': 'Designer', 'avatar': '👩‍🎨'},
    {'name': 'Bob Johnson', 'role': 'Manager', 'avatar': '👨‍💼'},
    {'name': 'Alice Brown', 'role': 'Developer', 'avatar': '👩‍💻'},
    {'name': 'Charlie Wilson', 'role': 'Tester', 'avatar': '🧪'},
  ];

  @override
  void initState() {
    super.initState();
    // Initialize selected values
    for (var type in DropdownAnimationType.values) {
      selectedValues[type] = null;
      selectedMultipleValues[type] = [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Multi Dropdown - Complete Demo'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                for (var type in DropdownAnimationType.values) {
                  selectedValues[type] = null;
                  selectedMultipleValues[type] = [];
                }
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All selections reset!')),
              );
            },
            tooltip: 'Reset all selections',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            _buildHeader(context),
            const SizedBox(height: 24),

            // All Animation Types
            _buildAnimationSection(
              title: '✨ Glass & Modern Animations',
              subtitle: 'Sleek, modern effects with blur and transparency',
              children: [
                _buildGlassAnimation(),
                _buildLiquidAnimation(),
                _buildNeonAnimation(),
                _buildGlassMorphismAnimation(),
                _buildFloatingGlassAnimation(),
              ],
            ),

            const SizedBox(height: 32),

            _buildAnimationSection(
              title: '🎨 Creative & Artistic Animations',
              subtitle: 'Unique, eye-catching animation styles',
              children: [
                _buildMorphingAnimation(),
                _buildGradientWaveAnimation(),
                _buildFluidWaveAnimation(),
                _buildLiquidSmoothAnimation(),
                _buildLiquidSwipeAnimation(),
              ],
            ),

            const SizedBox(height: 32),

            _buildAnimationSection(
              title: '🚀 Futuristic & Sci-Fi Animations',
              subtitle: 'Cyberpunk, hologram, and neon effects',
              children: [
                _buildCyberpunkAnimation(),
                _buildHologramAnimation(),
                _buildCosmicRippleAnimation(),
                _buildGravityWellAnimation(),
                _buildNeonPulseAnimation(),
                _buildCyberNeonAnimation(),
              ],
            ),

            const SizedBox(height: 32),

            _buildAnimationSection(
              title: '💫 Interactive & Engaging Animations',
              subtitle: 'Bouncy, staggered, and playful effects',
              children: [
                _buildBouncy3DAnimation(),
                _buildFloatingCardAnimation(),
                _buildStaggeredAnimation(),
                _buildFoldableAnimation(),
                _buildMolecularAnimation(),
              ],
            ),

            const SizedBox(height: 32),

            _buildAnimationSection(
              title: '✨ Special & Premium Animations',
              subtitle: 'Advanced effects for premium experiences',
              children: [
                _buildHolographicFanAnimation(),
                _buildLiquidMetalAnimation(),
                _buildMorphingGlassAnimation(),
                _buildStaggeredVerticalAnimation(),
              ],
            ),

            const SizedBox(height: 32),

            // Complex Examples
            _buildComplexExamplesSection(),

            const SizedBox(height: 24),

            // Selected Values Summary
            _buildSelectedValuesSummary(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Animated Multi Dropdown',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Experience 25+ stunning animation styles with full customization',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildChip('25+ Animations', Icons.animation),
              _buildChip('Single/Multi', Icons.checklist),
              _buildChip('Search', Icons.search),
              _buildChip('Chips', Icons.child_care),
              _buildChip('Haptic', Icons.vibration),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAnimationSection({
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        ...children,
      ],
    );
  }

  // ==================== GLASS & MODERN ANIMATIONS ====================

  Widget _buildGlassAnimation() {
    return _buildDropdownCard(
      title: 'Glass Animation',
      description: 'Glass morphism with blur and transparency effects',
      icon: Icons.blur_on,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.glass,
        items: fruits,
        value: selectedValues[DropdownAnimationType.glass],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.glass] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select a fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.blue,
          blurIntensity: 10,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLiquidAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Animation',
      description: 'Smooth liquid wave effect with gradient colors',
      icon: Icons.waves,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.liquid,
        items: countries,
        value: selectedMultipleValues[DropdownAnimationType.liquid],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.liquid] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select countries'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          enableSearch: true,
          highlightColor: Colors.teal,
          gradientColors: [Colors.teal, Colors.cyan],
          searchHintText: 'Search countries...',
        ),
      ),
    );
  }

  Widget _buildNeonAnimation() {
    return _buildDropdownCard(
      title: 'Neon Animation',
      description: 'Pulsing neon glow effect',
      icon: Icons.bolt,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.neon,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.neon],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.neon] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontWeight: FontWeight.bold)),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.pink,
          glowColor: Colors.pink,
          glowIntensity: 1.2,
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  Widget _buildGlassMorphismAnimation() {
    return _buildDropdownCard(
      title: 'Glass Morphism',
      description: 'Advanced glass effect with enhanced blur',
      icon: Icons.lens_blur,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.glassMorphism,
        items: fruits.sublist(0, 6),
        value: selectedMultipleValues[DropdownAnimationType.glassMorphism],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.glassMorphism] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruits'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          blurIntensity: 15,
          highlightColor: Colors.purple,
          backgroundColor: Color(0x33FFFFFF),
        ),
      ),
    );
  }

  Widget _buildFloatingGlassAnimation() {
    return _buildDropdownCard(
      title: 'Floating Glass',
      description: 'Floating glass panels with elevation',
      icon: Icons.pan_tool,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.floatingGlass,
        items: categories,
        value: selectedValues[DropdownAnimationType.floatingGlass],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.floatingGlass] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select category'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.indigo,
          elevation: 8,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
      ),
    );
  }

  // ==================== CREATIVE & ARTISTIC ANIMATIONS ====================

  Widget _buildMorphingAnimation() {
    return _buildDropdownCard(
      title: 'Morphing Animation',
      description: 'Smooth shape morphing transitions',
      icon: Icons.transform,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.morphing,
        items: fruits,
        value: selectedValues[DropdownAnimationType.morphing],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.morphing] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select a fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.orange,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
      ),
    );
  }

  Widget _buildGradientWaveAnimation() {
    return _buildDropdownCard(
      title: 'Gradient Wave',
      description: 'Animated gradient wave patterns',
      icon: Icons.gradient,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.gradientWave,
        items: fruits,
        value: selectedMultipleValues[DropdownAnimationType.gradientWave],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.gradientWave] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruits'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          gradientColors: [Colors.red, Colors.orange, Colors.yellow],
          showSelectedItemsAsChips: true,
          highlightColor: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildFluidWaveAnimation() {
    return _buildDropdownCard(
      title: 'Fluid Wave',
      description: 'Fluid wave ripple effects',
      icon: Icons.water_damage,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.fluidWave,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.fluidWave],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.fluidWave] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.cyan,
          blurIntensity: 8,
        ),
      ),
    );
  }

  Widget _buildLiquidSmoothAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Smooth',
      description: 'Ultra-smooth liquid transitions',
      icon: Icons.shield_moon_outlined,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.liquidSmooth,
        items: countries,
        value: selectedMultipleValues[DropdownAnimationType.liquidSmooth],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.liquidSmooth] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select countries'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          enableSearch: true,
          highlightColor: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildLiquidSwipeAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Swipe',
      description: 'Swipe-based liquid transition',
      icon: Icons.swipe,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.liquidSwipe,
        items: categories,
        value: selectedValues[DropdownAnimationType.liquidSwipe],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.liquidSwipe] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select category'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.deepPurple,
        ),
      ),
    );
  }

  // ==================== FUTURISTIC & SCI-FI ANIMATIONS ====================

  Widget _buildCyberpunkAnimation() {
    return _buildDropdownCard(
      title: 'Cyberpunk',
      description: 'Glitch effects with neon grid',
      icon: Icons.cabin,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.cyberpunk,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.cyberpunk],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.cyberpunk] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontFamily: 'monospace')),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.pinkAccent,
          glowColor: Colors.cyanAccent,
          glowIntensity: 1.5,
        ),
      ),
    );
  }

  Widget _buildHologramAnimation() {
    return _buildDropdownCard(
      title: 'Hologram',
      description: 'Holographic scan line effect',
      icon: Icons.view_in_ar,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.hologram,
        items: fruits,
        value: selectedMultipleValues[DropdownAnimationType.hologram],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.hologram] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruits'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          highlightColor: Colors.cyanAccent,
        ),
      ),
    );
  }

  Widget _buildCosmicRippleAnimation() {
    return _buildDropdownCard(
      title: 'Cosmic Ripple',
      description: 'Expanding cosmic ripple waves',
      icon: Icons.circle,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.cosmicRipple,
        items: countries,
        value: selectedValues[DropdownAnimationType.cosmicRipple],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.cosmicRipple] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select country'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.purple,
          glowColor: Colors.indigo,
        ),
      ),
    );
  }

  Widget _buildGravityWellAnimation() {
    return _buildDropdownCard(
      title: 'Gravity Well',
      description: 'Distortion effect like a gravity well',
      icon: Icons.content_paste_search_outlined,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.gravityWell,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.gravityWell],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.gravityWell] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.deepPurple,
          depth: 10,
        ),
      ),
    );
  }

  Widget _buildNeonPulseAnimation() {
    return _buildDropdownCard(
      title: 'Neon Pulse',
      description: 'Heartbeat-like neon pulsing',
      icon: Icons.favorite,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.neonPulse,
        items: categories,
        value: selectedMultipleValues[DropdownAnimationType.neonPulse],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.neonPulse] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select categories'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          highlightColor: Colors.red,
          glowColor: Colors.red,
          glowIntensity: 1.3,
        ),
      ),
    );
  }

  Widget _buildCyberNeonAnimation() {
    return _buildDropdownCard(
      title: 'Cyber Neon',
      description: 'Cyberpunk neon grid effect',
      icon: Icons.grid_on,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.cyberNeon,
        items: fruits,
        value: selectedValues[DropdownAnimationType.cyberNeon],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.cyberNeon] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.lime,
          glowColor: Colors.green,
        ),
      ),
    );
  }

  // ==================== INTERACTIVE & ENGAGING ANIMATIONS ====================

  Widget _buildBouncy3DAnimation() {
    return _buildDropdownCard(
      title: 'Bouncy 3D',
      description: '3D bounce effect with depth',
      icon: Icons.three_p,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.bouncy3d,
        items: fruits,
        value: selectedValues[DropdownAnimationType.bouncy3d],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.bouncy3d] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.amber,
          depth: 8,
        ),
      ),
    );
  }

  Widget _buildFloatingCardAnimation() {
    return _buildDropdownCard(
      title: 'Floating Cards',
      description: 'Cards that float up with staggered animation',
      icon: Icons.credit_card,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.floatingCard,
        items: programmingLanguages,
        value: selectedMultipleValues[DropdownAnimationType.floatingCard],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.floatingCard] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select languages'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          elevation: 4,
        ),
      ),
    );
  }

  Widget _buildStaggeredAnimation() {
    return _buildDropdownCard(
      title: 'Staggered',
      description: 'Staggered item appearance',
      icon: Icons.view_agenda,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.staggered,
        items: countries,
        value: selectedValues[DropdownAnimationType.staggered],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.staggered] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select country'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.brown,
        ),
      ),
    );
  }

  Widget _buildFoldableAnimation() {
    return _buildDropdownCard(
      title: 'Foldable',
      description: 'Paper-like folding animation',
      icon: Icons.folder,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.foldable,
        items: categories,
        value: selectedMultipleValues[DropdownAnimationType.foldable],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.foldable] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select categories'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
        ),
      ),
    );
  }

  Widget _buildMolecularAnimation() {
    return _buildDropdownCard(
      title: 'Molecular',
      description: 'Molecular bonding animation',
      icon: Icons.bubble_chart,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.molecular,
        items: fruits,
        value: selectedValues[DropdownAnimationType.molecular],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.molecular] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.lightBlue,
        ),
      ),
    );
  }

  // ==================== SPECIAL & PREMIUM ANIMATIONS ====================

  Widget _buildHolographicFanAnimation() {
    return _buildDropdownCard(
      title: 'Holographic Fan',
      description: 'Fan spread with holographic effect',
      icon: Icons.filter_b_and_w,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.holographicFan,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.holographicFan],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.holographicFan] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.purpleAccent,
        ),
      ),
    );
  }

  Widget _buildLiquidMetalAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Metal',
      description: 'Premium liquid metal effect',
      icon: Icons.water,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.liquidMetal,
        items: countries,
        value: selectedMultipleValues[DropdownAnimationType.liquidMetal],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.liquidMetal] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select countries'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          highlightColor: Colors.grey,
          gradientColors: [Colors.grey, Colors.white70],
        ),
      ),
    );
  }

  Widget _buildMorphingGlassAnimation() {
    return _buildDropdownCard(
      title: 'Morphing Glass',
      description: 'Morphing shapes with glass effect',
      icon: Icons.animation,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.morphingGlass,
        items: fruits,
        value: selectedValues[DropdownAnimationType.morphingGlass],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.morphingGlass] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Colors.tealAccent,
          blurIntensity: 12,
        ),
      ),
    );
  }

  Widget _buildStaggeredVerticalAnimation() {
    return _buildDropdownCard(
      title: 'Staggered Vertical',
      description: 'Vertical staggered drop animation',
      icon: Icons.vertical_align_bottom,
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.staggeredVerticalDropItem,
        items: categories,
        value: selectedMultipleValues[DropdownAnimationType.staggeredVerticalDropItem],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.staggeredVerticalDropItem] = value;
          });
        },
        itemBuilder: (item) => Text(item),
        hint: const Text('Select categories'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
        ),
      ),
    );
  }

  // ==================== COMPLEX EXAMPLES ====================

  Widget _buildComplexExamplesSection() {
    // Add these to your state for complex examples
    Map<String, dynamic>? _selectedComplexValue;
    List<String> _selectedAdvancedSearch = [];
    List<String> _selectedFullFeatured = [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),
        const Text(
          '🎯 Complex Examples',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Custom items, complex data structures, and advanced configurations',
          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
        ),
        const SizedBox(height: 16),

        // Custom Complex Items
        _buildDropdownCard(
          title: 'Custom Complex Items',
          description: 'Display custom widgets with avatars and roles',
          icon: Icons.people,
          dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
            animationType: DropdownAnimationType.glass,
            items: complexItems,
            value: _selectedComplexValue,
            onChanged: (value) {
              setState(() {
                _selectedComplexValue = value;
              });
            },
            itemBuilder: (item) => Row(
              children: [
                Text(item['avatar'], style: const TextStyle(fontSize: 24)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text(item['role'], style: const TextStyle(fontSize: 12)),
                  ],
                ),
              ],
            ),
            hint: const Text('Select a team member'),
            config: const MultiDropDownConfig(
              highlightColor: Colors.blue,
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Search with Custom Filter
        _buildDropdownCard(
          title: 'Advanced Search',
          description: 'Search with custom filtering and highlighting',
          icon: Icons.search_rounded,
          dropdown: CustomAnimatedMultiDropDown<String>(
            animationType: DropdownAnimationType.liquidSmooth,
            items: programmingLanguages,
            value: _selectedAdvancedSearch,
            onChanged: (value) {
              setState(() {
                _selectedAdvancedSearch = value;
              });
            },
            itemBuilder: (item) => Text(item),
            hint: const Text('Search and select languages'),
            config: const MultiDropDownConfig(
              selectionMode: SelectionMode.multiple,
              enableSearch: true,
              showSelectedItemsAsChips: true,
              searchHintText: 'Search by language name...',
              highlightColor: Colors.deepOrange,
              searchBackgroundColor: Colors.white,
              searchCursorColor: Colors.deepOrange,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Full Featured Dropdown
        _buildDropdownCard(
          title: 'Full Featured Dropdown',
          description: 'All features combined: search, chips, haptic feedback',
          icon: Icons.star,
          dropdown: CustomAnimatedMultiDropDown<String>(
            animationType: DropdownAnimationType.cyberpunk,
            items: fruits,
            value: _selectedFullFeatured,
            onChanged: (value) {
              setState(() {
                _selectedFullFeatured = value;
              });
            },
            itemBuilder: (item) => Text(item),
            hint: const Text('Select fruits (try search!)'),
            config: const MultiDropDownConfig(
              selectionMode: SelectionMode.multiple,
              enableSearch: true,
              showSelectedItemsAsChips: true,
              enableHapticFeedback: true,
              showCheckmark: true,
              searchHintText: 'Search fruits...',
              highlightColor: Colors.purple,
              glowColor: Colors.purple,
              glowIntensity: 0.8,
              chipSpacing: 8,
              chipRunSpacing: 8,
            ),
          ),
        ),
      ],
    );
  }

  // ==================== SELECTED VALUES SUMMARY ====================

  Widget _buildSelectedValuesSummary() {
    int totalSelections = 0;
    for (var value in selectedValues.values) {
      if (value != null && value is! List) totalSelections++;
    }
    for (var value in selectedMultipleValues.values) {
      if (value.isNotEmpty) totalSelections += value.length;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.grey[100]
            : Colors.grey[900],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📊 Selected Values Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalSelections selections',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSummaryChip('Glass', selectedValues[DropdownAnimationType.glass]),
                _buildSummaryChip('Liquid', selectedMultipleValues[DropdownAnimationType.liquid]),
                _buildSummaryChip('Neon', selectedValues[DropdownAnimationType.neon]),
                _buildSummaryChip('Cyberpunk', selectedValues[DropdownAnimationType.cyberpunk]),
                _buildSummaryChip('Hologram', selectedMultipleValues[DropdownAnimationType.hologram]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryChip(String label, dynamic value) {
    String displayValue = '';
    if (value == null) {
      displayValue = 'None';
    } else if (value is List) {
      displayValue = value.isEmpty ? 'None' : '${value.length} selected';
    } else {
      displayValue = value.toString().split(' ').last;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.light
            ? Colors.white
            : Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
          Text(
            displayValue,
            style: const TextStyle(fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // ==================== HELPER WIDGET ====================

  Widget _buildDropdownCard({
    required String title,
    required String description,
    required IconData icon,
    required Widget dropdown,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, size: 20, color: Theme.of(context).primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            dropdown,
          ],
        ),
      ),
    );
  }
}