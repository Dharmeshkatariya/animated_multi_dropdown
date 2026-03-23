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
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
          tertiary: Color(0xFFEC4899),
          surface: Color(0xFFF8FAFC),
          background: Color(0xFFF1F5F9),
          error: Color(0xFFEF4444),
          onPrimary: Colors.white,
          onSecondary: Colors.white,
          onBackground: Color(0xFF0F172A),
          onSurface: Color(0xFF1E293B),
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          titleTextStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF0F172A),
            letterSpacing: -0.5,
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF6366F1), width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
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

  // Complex example values
  Map<String, dynamic>? selectedComplexValue;
  List<String> selectedAdvancedSearch = [];
  List<String> selectedFullFeatured = [];

  // Sample data with icons and colors
  final List<Map<String, dynamic>> fruits = [
    {'name': 'Apple', 'icon': '🍎', 'color': 0xFFEF4444},
    {'name': 'Banana', 'icon': '🍌', 'color': 0xFFEAB308},
    {'name': 'Orange', 'icon': '🍊', 'color': 0xFFF97316},
    {'name': 'Mango', 'icon': '🥭', 'color': 0xFFEAB308},
    {'name': 'Grapes', 'icon': '🍇', 'color': 0xFFA855F7},
    {'name': 'Strawberry', 'icon': '🍓', 'color': 0xFFEC4899},
    {'name': 'Blueberry', 'icon': '🫐', 'color': 0xFF3B82F6},
    {'name': 'Cherry', 'icon': '🍒', 'color': 0xFFEF4444},
  ];

  final List<Map<String, dynamic>> countries = [
    {'name': 'United States', 'flag': '🇺🇸', 'code': 'US'},
    {'name': 'United Kingdom', 'flag': '🇬🇧', 'code': 'UK'},
    {'name': 'Canada', 'flag': '🇨🇦', 'code': 'CA'},
    {'name': 'Australia', 'flag': '🇦🇺', 'code': 'AU'},
    {'name': 'Germany', 'flag': '🇩🇪', 'code': 'DE'},
    {'name': 'France', 'flag': '🇫🇷', 'code': 'FR'},
    {'name': 'Japan', 'flag': '🇯🇵', 'code': 'JP'},
    {'name': 'India', 'flag': '🇮🇳', 'code': 'IN'},
  ];

  final List<Map<String, dynamic>> programmingLanguages = [
    {'name': 'Python', 'icon': '🐍', 'color': 0xFF3B82F6},
    {'name': 'Rust', 'icon': '🦀', 'color': 0xFFF97316},
    {'name': 'JavaScript', 'icon': '⚡', 'color': 0xFFEAB308},
    {'name': 'Dart', 'icon': '🎯', 'color': 0xFF06B6D4},
    {'name': 'Java', 'icon': '☕', 'color': 0xFFEF4444},
    {'name': 'C#', 'icon': '🔷', 'color': 0xFF8B5CF6},
    {'name': 'Go', 'icon': '🏃‍♂️', 'color': 0xFF10B981},
    {'name': 'Kotlin', 'icon': '🦊', 'color': 0xFFEC4899},
  ];

  final List<String> categories = [
    '🎨 Design', '💻 Development', '📊 Marketing', '💰 Sales',
    '📝 Writing', '🎬 Video', '🎵 Music', '📸 Photography'
  ];

  final List<Map<String, dynamic>> complexItems = [
    {'name': 'John Doe', 'role': 'Lead Developer', 'avatar': '👨‍💻', 'color': 0xFF6366F1},
    {'name': 'Jane Smith', 'role': 'Creative Director', 'avatar': '👩‍🎨', 'color': 0xFFEC4899},
    {'name': 'Bob Johnson', 'role': 'Product Manager', 'avatar': '👨‍💼', 'color': 0xFF10B981},
    {'name': 'Alice Brown', 'role': 'Senior Developer', 'avatar': '👩‍💻', 'color': 0xFF8B5CF6},
    {'name': 'Charlie Wilson', 'role': 'QA Lead', 'avatar': '🧪', 'color': 0xFFF97316},
  ];

  @override
  void initState() {
    super.initState();
    for (var type in DropdownAnimationType.values) {
      selectedValues[type] = null;
      selectedMultipleValues[type] = [];
    }
  }

  void _resetAllSelections() {
    setState(() {
      for (var type in DropdownAnimationType.values) {
        selectedValues[type] = null;
        selectedMultipleValues[type] = [];
      }
      selectedComplexValue = null;
      selectedAdvancedSearch = [];
      selectedFullFeatured = [];
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('All selections reset!'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.primary, colorScheme.secondary],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.animation, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Animated Multi Dropdown',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          '25+ Premium Animation Styles',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.star, size: 14, color: colorScheme.primary),
                        const SizedBox(width: 4),
                        Text(
                          'v1.0.0',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _resetAllSelections,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.refresh, size: 20, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero Header
            _buildHeroHeader(),
            const SizedBox(height: 32),

            // Quick Stats
            _buildQuickStats(),
            const SizedBox(height: 32),

            // Glass & Modern Animations
            _buildSectionHeader('Glass & Modern', Icons.blur_on, [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]),
            const SizedBox(height: 16),
            _buildGlassAnimation(),
            const SizedBox(height: 16),
            _buildLiquidAnimation(),
            const SizedBox(height: 16),
            _buildNeonAnimation(),
            const SizedBox(height: 16),
            _buildGlassMorphismAnimation(),
            const SizedBox(height: 16),
            _buildFloatingGlassAnimation(),
            const SizedBox(height: 32),

            // Creative & Artistic Animations
            _buildSectionHeader('Creative & Artistic', Icons.palette, [const Color(0xFFEC4899), const Color(0xFFF97316)]),
            const SizedBox(height: 16),
            _buildMorphingAnimation(),
            const SizedBox(height: 16),
            _buildGradientWaveAnimation(),
            const SizedBox(height: 16),
            _buildFluidWaveAnimation(),
            const SizedBox(height: 16),
            _buildLiquidSmoothAnimation(),
            const SizedBox(height: 16),
            _buildLiquidSwipeAnimation(),
            const SizedBox(height: 32),

            // Futuristic & Sci-Fi Animations
            _buildSectionHeader('Futuristic & Sci-Fi', Icons.science, [const Color(0xFF06B6D4), const Color(0xFF8B5CF6)]),
            const SizedBox(height: 16),
            _buildCyberpunkAnimation(),
            const SizedBox(height: 16),
            _buildHologramAnimation(),
            const SizedBox(height: 16),
            _buildCosmicRippleAnimation(),
            const SizedBox(height: 16),
            _buildGravityWellAnimation(),
            const SizedBox(height: 16),
            _buildNeonPulseAnimation(),
            const SizedBox(height: 16),
            _buildCyberNeonAnimation(),
            const SizedBox(height: 32),

            // Interactive & Engaging Animations
            _buildSectionHeader('Interactive & Engaging', Icons.touch_app, [const Color(0xFF10B981), const Color(0xFF3B82F6)]),
            const SizedBox(height: 16),
            _buildBouncy3DAnimation(),
            const SizedBox(height: 16),
            _buildFloatingCardAnimation(),
            const SizedBox(height: 16),
            _buildStaggeredAnimation(),
            const SizedBox(height: 16),
            _buildFoldableAnimation(),
            const SizedBox(height: 16),
            _buildMolecularAnimation(),
            const SizedBox(height: 32),

            // Premium & Exclusive Animations
            _buildSectionHeader('Premium & Exclusive', Icons.diamond, [const Color(0xFFF59E0B), const Color(0xFFEF4444)]),
            const SizedBox(height: 16),
            _buildHolographicFanAnimation(),
            const SizedBox(height: 16),
            _buildLiquidMetalAnimation(),
            const SizedBox(height: 16),
            _buildMorphingGlassAnimation(),
            const SizedBox(height: 16),
            _buildStaggeredVerticalAnimation(),
            const SizedBox(height: 32),

            // Advanced Examples
            _buildSectionHeader('Advanced Examples', Icons.auto_awesome, [const Color(0xFF6366F1), const Color(0xFF8B5CF6)]),
            const SizedBox(height: 16),
            _buildComplexExamplesSection(),
            const SizedBox(height: 32),

            // Summary
            _buildSelectedValuesSummary(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colorScheme.primary, colorScheme.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.rocket_launch, color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'EXPERIENCE THE MAGIC',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      '25+ Stunning Animations',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Premium dropdown widget with glass morphism, liquid effects, neon glow, cyberpunk, and more. Fully customizable and performance-optimized.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _buildFeatureChip(Icons.animation, '25+ Animations'),
              _buildFeatureChip(Icons.checklist, 'Single/Multi'),
              _buildFeatureChip(Icons.search, 'Search'),
              _buildFeatureChip(Icons.thermostat, 'Chips'),
              _buildFeatureChip(Icons.vibration, 'Haptic'),
              _buildFeatureChip(Icons.palette, 'Customizable'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    int totalSelections = 0;
    for (var value in selectedValues.values) {
      if (value != null && value is! List) totalSelections++;
    }
    for (var value in selectedMultipleValues.values) {
      if (value.isNotEmpty) totalSelections += value.length;
    }
    if (selectedComplexValue != null) totalSelections++;
    totalSelections += selectedAdvancedSearch.length;
    totalSelections += selectedFullFeatured.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '$totalSelections',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6366F1),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Total Selections',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${DropdownAnimationType.values.length}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B5CF6),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Animation Types',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: Colors.grey[200]),
          Expanded(
            child: Column(
              children: [
                const Text(
                  '⭐ 5.0',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFF59E0B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Premium Rating',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, List<Color> gradientColors) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: gradientColors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: Colors.white, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownCard({
    required String title,
    required String description,
    required IconData icon,
    required List<Color> gradientColors,
    required Widget dropdown,
  }) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.grey.shade100, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: gradientColors,
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, size: 20, color: Colors.white),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
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
            const SizedBox(height: 20),
            dropdown,
          ],
        ),
      ),
    );
  }

  // ==================== GLASS & MODERN ANIMATIONS ====================

  Widget _buildGlassAnimation() {
    return _buildDropdownCard(
      title: 'Glass Animation',
      description: 'Premium glass morphism with blur',
      icon: Icons.blur_on,
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.glass,
        items: fruits,
        value: selectedValues[DropdownAnimationType.glass],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.glass] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select a fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF6366F1),
          blurIntensity: 12,
          borderRadius: BorderRadius.all(Radius.circular(16)),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget _buildLiquidAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Animation',
      description: 'Smooth liquid wave effect',
      icon: Icons.waves,
      gradientColors: [const Color(0xFF06B6D4), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.liquid,
        items: countries,
        value: selectedMultipleValues[DropdownAnimationType.liquid],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.liquid] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['flag'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select countries'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          enableSearch: true,
          highlightColor: Color(0xFF06B6D4),
          gradientColors: [Color(0xFF06B6D4), Color(0xFF3B82F6)],
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
      gradientColors: [const Color(0xFFEC4899), const Color(0xFFF97316)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.neon,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.neon],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.neon] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFFEC4899),
          glowColor: Color(0xFFEC4899),
          glowIntensity: 1.2,
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildGlassMorphismAnimation() {
    return _buildDropdownCard(
      title: 'Glass Morphism',
      description: 'Advanced glass effect with enhanced blur',
      icon: Icons.lens_blur,
      gradientColors: [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.glassMorphism,
        items: fruits.sublist(0, 6),
        value: selectedMultipleValues[DropdownAnimationType.glassMorphism],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.glassMorphism] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruits'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          blurIntensity: 15,
          highlightColor: Color(0xFF8B5CF6),
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
      gradientColors: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.floatingGlass,
        items: categories,
        value: selectedValues[DropdownAnimationType.floatingGlass],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.floatingGlass] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
        hint: const Text('Select category'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF10B981),
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
      gradientColors: [const Color(0xFFF97316), const Color(0xFFEF4444)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.morphing,
        items: fruits,
        value: selectedValues[DropdownAnimationType.morphing],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.morphing] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select a fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFFF97316),
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
      gradientColors: [const Color(0xFFEF4444), const Color(0xFFF59E0B)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.gradientWave,
        items: fruits,
        value: selectedMultipleValues[DropdownAnimationType.gradientWave],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.gradientWave] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruits'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          gradientColors: [Color(0xFFEF4444), Color(0xFFF59E0B), Color(0xFFEAB308)],
          showSelectedItemsAsChips: true,
          highlightColor: Color(0xFFF59E0B),
        ),
      ),
    );
  }

  Widget _buildFluidWaveAnimation() {
    return _buildDropdownCard(
      title: 'Fluid Wave',
      description: 'Fluid wave ripple effects',
      icon: Icons.water_damage,
      gradientColors: [const Color(0xFF06B6D4), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.fluidWave,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.fluidWave],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.fluidWave] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF06B6D4),
          blurIntensity: 8,
        ),
      ),
    );
  }

  Widget _buildLiquidSmoothAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Smooth',
      description: 'Ultra-smooth liquid transitions',
      icon: Icons.medication_liquid_outlined,
      gradientColors: [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.liquidSmooth,
        items: countries,
        value: selectedMultipleValues[DropdownAnimationType.liquidSmooth],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.liquidSmooth] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['flag'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select countries'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          enableSearch: true,
          highlightColor: Color(0xFF8B5CF6),
        ),
      ),
    );
  }

  Widget _buildLiquidSwipeAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Swipe',
      description: 'Swipe-based liquid transition',
      icon: Icons.swipe,
      gradientColors: [const Color(0xFFEC4899), const Color(0xFFF97316)],
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.liquidSwipe,
        items: categories,
        value: selectedValues[DropdownAnimationType.liquidSwipe],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.liquidSwipe] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
        hint: const Text('Select category'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFFEC4899),
        ),
      ),
    );
  }

  // ==================== FUTURISTIC & SCI-FI ANIMATIONS ====================

  Widget _buildCyberpunkAnimation() {
    return _buildDropdownCard(
      title: 'Cyberpunk',
      description: 'Glitch effects with neon grid',
      icon: Icons.punch_clock,
      gradientColors: [const Color(0xFFEC4899), const Color(0xFF06B6D4)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.cyberpunk,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.cyberpunk],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.cyberpunk] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFFEC4899),
          glowColor: Color(0xFF06B6D4),
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
      gradientColors: [const Color(0xFF8B5CF6), const Color(0xFF06B6D4)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.hologram,
        items: fruits,
        value: selectedMultipleValues[DropdownAnimationType.hologram],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.hologram] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruits'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          highlightColor: Color(0xFF06B6D4),
        ),
      ),
    );
  }

  Widget _buildCosmicRippleAnimation() {
    return _buildDropdownCard(
      title: 'Cosmic Ripple',
      description: 'Expanding cosmic ripple waves',
      icon: Icons.circle,
      gradientColors: [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.cosmicRipple,
        items: countries,
        value: selectedValues[DropdownAnimationType.cosmicRipple],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.cosmicRipple] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['flag'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select country'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF8B5CF6),
          glowColor: Color(0xFF6366F1),
        ),
      ),
    );
  }

  Widget _buildGravityWellAnimation() {
    return _buildDropdownCard(
      title: 'Gravity Well',
      description: 'Distortion effect like a gravity well',
      icon: Icons.wheelchair_pickup,
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.gravityWell,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.gravityWell],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.gravityWell] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF6366F1),
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
      gradientColors: [const Color(0xFFEF4444), const Color(0xFFEC4899)],
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.neonPulse,
        items: categories,
        value: selectedMultipleValues[DropdownAnimationType.neonPulse],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.neonPulse] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
        hint: const Text('Select categories'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          highlightColor: Color(0xFFEF4444),
          glowColor: Color(0xFFEF4444),
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
      gradientColors: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.cyberNeon,
        items: fruits,
        value: selectedValues[DropdownAnimationType.cyberNeon],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.cyberNeon] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF10B981),
          glowColor: Color(0xFF3B82F6),
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
      gradientColors: [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.bouncy3d,
        items: fruits,
        value: selectedValues[DropdownAnimationType.bouncy3d],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.bouncy3d] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFFF59E0B),
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
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.floatingCard,
        items: programmingLanguages,
        value: selectedMultipleValues[DropdownAnimationType.floatingCard],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.floatingCard] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
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
      gradientColors: [const Color(0xFF8B5CF6), const Color(0xFF6366F1)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.staggered,
        items: countries,
        value: selectedValues[DropdownAnimationType.staggered],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.staggered] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['flag'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select country'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF8B5CF6),
        ),
      ),
    );
  }

  Widget _buildFoldableAnimation() {
    return _buildDropdownCard(
      title: 'Foldable',
      description: 'Paper-like folding animation',
      icon: Icons.folder,
      gradientColors: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.foldable,
        items: categories,
        value: selectedMultipleValues[DropdownAnimationType.foldable],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.foldable] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
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
      gradientColors: [const Color(0xFF06B6D4), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.molecular,
        items: fruits,
        value: selectedValues[DropdownAnimationType.molecular],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.molecular] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF06B6D4),
        ),
      ),
    );
  }

  // ==================== PREMIUM & EXCLUSIVE ANIMATIONS ====================

  Widget _buildHolographicFanAnimation() {
    return _buildDropdownCard(
      title: 'Holographic Fan',
      description: 'Fan spread with holographic effect',
      icon: Icons.filter_b_and_w,
      gradientColors: [const Color(0xFFEC4899), const Color(0xFFF97316)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.holographicFan,
        items: programmingLanguages,
        value: selectedValues[DropdownAnimationType.holographicFan],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.holographicFan] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select language'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFFEC4899),
        ),
      ),
    );
  }

  Widget _buildLiquidMetalAnimation() {
    return _buildDropdownCard(
      title: 'Liquid Metal',
      description: 'Premium liquid metal effect',
      icon: Icons.water,
      gradientColors: [const Color(0xFF64748B), const Color(0xFF94A3B8)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.liquidMetal,
        items: countries,
        value: selectedMultipleValues[DropdownAnimationType.liquidMetal],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.liquidMetal] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['flag'], style: const TextStyle(fontSize: 24)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select countries'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
          highlightColor: Color(0xFF64748B),
          gradientColors: [Color(0xFF64748B), Color(0xFF94A3B8)],
        ),
      ),
    );
  }

  Widget _buildMorphingGlassAnimation() {
    return _buildDropdownCard(
      title: 'Morphing Glass',
      description: 'Morphing shapes with glass effect',
      icon: Icons.animation,
      gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
      dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
        animationType: DropdownAnimationType.morphingGlass,
        items: fruits,
        value: selectedValues[DropdownAnimationType.morphingGlass],
        onChanged: (value) {
          setState(() {
            selectedValues[DropdownAnimationType.morphingGlass] = value;
          });
        },
        itemBuilder: (item) => Row(
          children: [
            Text(item['icon'], style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        hint: const Text('Select fruit'),
        config: const MultiDropDownConfig(
          highlightColor: Color(0xFF6366F1),
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
      gradientColors: [const Color(0xFF10B981), const Color(0xFF3B82F6)],
      dropdown: CustomAnimatedMultiDropDown<String>(
        animationType: DropdownAnimationType.staggeredVerticalDropItem,
        items: categories,
        value: selectedMultipleValues[DropdownAnimationType.staggeredVerticalDropItem],
        onChanged: (value) {
          setState(() {
            selectedMultipleValues[DropdownAnimationType.staggeredVerticalDropItem] = value;
          });
        },
        itemBuilder: (item) => Text(item, style: const TextStyle(fontWeight: FontWeight.w500)),
        hint: const Text('Select categories'),
        config: const MultiDropDownConfig(
          selectionMode: SelectionMode.multiple,
          showSelectedItemsAsChips: true,
        ),
      ),
    );
  }

  // ==================== ADVANCED EXAMPLES ====================

  Widget _buildComplexExamplesSection() {
    return Column(
      children: [
        _buildDropdownCard(
          title: 'Team Members',
          description: 'Custom widgets with avatars and roles',
          icon: Icons.people,
          gradientColors: [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
          dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
            animationType: DropdownAnimationType.glass,
            items: complexItems,
            value: selectedComplexValue,
            onChanged: (value) {
              setState(() {
                selectedComplexValue = value;
              });
            },
            itemBuilder: (item) => Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(item['color']), Color(item['color']).withValues(alpha: 0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(item['avatar'], style: const TextStyle(fontSize: 24)),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'],
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text(
                        item['role'],
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            hint: const Text('Select team member'),
            config: const MultiDropDownConfig(
              highlightColor: Color(0xFF6366F1),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildDropdownCard(
          title: 'Advanced Search',
          description: 'Search with custom filtering',
          icon: Icons.search_rounded,
          gradientColors: [const Color(0xFF06B6D4), const Color(0xFF3B82F6)],
          dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
            animationType: DropdownAnimationType.liquidSmooth,
            items: programmingLanguages,
            value: selectedAdvancedSearch,
            onChanged: (value) {
              setState(() {
                selectedAdvancedSearch = value;
              });
            },
            itemBuilder: (item) => Row(
              children: [
                Text(item['icon'], style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['name'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            hint: const Text('Search languages'),
            config: const MultiDropDownConfig(
              selectionMode: SelectionMode.multiple,
              enableSearch: true,
              showSelectedItemsAsChips: true,
              searchHintText: 'Search by language name...',
              highlightColor: Color(0xFF06B6D4),
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildDropdownCard(
          title: 'Full Featured',
          description: 'All features combined',
          icon: Icons.star,
          gradientColors: [const Color(0xFFF59E0B), const Color(0xFFEF4444)],
          dropdown: CustomAnimatedMultiDropDown<Map<String, dynamic>>(
            animationType: DropdownAnimationType.cyberpunk,
            items: fruits,
            value: selectedFullFeatured,
            onChanged: (value) {
              setState(() {
                selectedFullFeatured = value;
              });
            },
            itemBuilder: (item) => Row(
              children: [
                Text(item['icon'], style: const TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    item['name'],
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            hint: const Text('Select fruits'),
            config: const MultiDropDownConfig(
              selectionMode: SelectionMode.multiple,
              enableSearch: true,
              showSelectedItemsAsChips: true,
              enableHapticFeedback: true,
              showCheckmark: true,
              searchHintText: 'Search fruits...',
              highlightColor: Color(0xFFF59E0B),
              glowColor: Color(0xFFEF4444),
              glowIntensity: 0.8,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedValuesSummary() {
    int totalSelections = 0;
    for (var value in selectedValues.values) {
      if (value != null && value is! List) totalSelections++;
    }
    for (var value in selectedMultipleValues.values) {
      if (value.isNotEmpty) totalSelections += value.length;
    }
    if (selectedComplexValue != null) totalSelections++;
    totalSelections += selectedAdvancedSearch.length;
    totalSelections += selectedFullFeatured.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.grey.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.summarize, color: Color(0xFF6366F1), size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Selection Summary',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$totalSelections items',
                  style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildSummaryChip('Glass', selectedValues[DropdownAnimationType.glass]),
                _buildSummaryChip('Liquid', selectedMultipleValues[DropdownAnimationType.liquid]),
                _buildSummaryChip('Neon', selectedValues[DropdownAnimationType.neon]),
                _buildSummaryChip('Cyberpunk', selectedValues[DropdownAnimationType.cyberpunk]),
                _buildSummaryChip('Hologram', selectedMultipleValues[DropdownAnimationType.hologram]),
                _buildSummaryChip('Team', selectedComplexValue),
                _buildSummaryChip('Search', selectedAdvancedSearch),
                _buildSummaryChip('Featured', selectedFullFeatured),
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
    } else if (value is Map) {
      displayValue = value['name'] ?? 'Selected';
    } else {
      displayValue = value.toString().split(' ').last;
    }

    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF6366F1)),
          ),
          const SizedBox(height: 2),
          Text(
            displayValue,
            style: const TextStyle(fontSize: 11, color: Color(0xFF334155)),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}