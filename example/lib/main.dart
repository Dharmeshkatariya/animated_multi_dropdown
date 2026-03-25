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
      title: 'Premium Dropdown Showcase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF6366F1),
          secondary: Color(0xFF8B5CF6),
          tertiary: Color(0xFFA78BFA),
          surface: Color(0xFFFAFAFA),
          onSurface: Color(0xFF1F2937),
          error: Color(0xFFEF4444),
        ),
        fontFamily: 'Poppins',
        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1F2937),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
            letterSpacing: -0.3,
          ),
        ),
        cardTheme: CardThemeData(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(color: Colors.grey.shade100, width: 1),
          ),
        ),
      ),
      home: const PremiumHomePage(),
    );
  }
}

class PremiumHomePage extends StatefulWidget {
  const PremiumHomePage({super.key});

  @override
  State<PremiumHomePage> createState() => _PremiumHomePageState();
}

class _PremiumHomePageState extends State<PremiumHomePage>
    with SingleTickerProviderStateMixin {
  // ==================== INDICATOR SELECTIONS ====================
  // Radio selections
  String? selectedClassicRadio;
  String? selectedCheckmarkRadio;
  String? selectedDotRadio;
  String? selectedSquareRadio;

  // Toggle & Switch
  String? selectedToggle;
  String? selectedSwitch;

  // Checkbox selections
  List<String> selectedClassicCheckbox = [];
  List<String> selectedModernCheckbox = [];
  List<String> selectedDotCheckbox = [];
  List<String> selectedSquareCheckbox = [];

  // Gradient & Neumorphic
  String? selectedGradientRadio;
  List<String> selectedGradientCheckbox = [];
  String? selectedNeumorphicRadio;
  List<String> selectedNeumorphicCheckbox = [];

  // Custom indicators
  String? selectedStar;
  List<String> selectedHeart = [];

  // ==================== ANIMATION STRATEGY SELECTIONS ====================
  final Map<DropdownAnimationType, String?> singleStrategySelections = {};
  final Map<DropdownAnimationType, List<String>> multiStrategySelections = {};

  // ==================== SAMPLE DATA WITH PREMIUM COLORS ====================
  final List<PremiumItem> fruits = [
    PremiumItem('🍎 Apple', Color(0xFFEF4444)),
    PremiumItem('🍌 Banana', Color(0xFFEAB308)),
    PremiumItem('🍊 Orange', Color(0xFFF97316)),
    PremiumItem('🥭 Mango', Color(0xFFEAB308)),
    PremiumItem('🍇 Grapes', Color(0xFF8B5CF6)),
    PremiumItem('🍓 Strawberry', Color(0xFFEF4444)),
  ];

  final List<PremiumItem> technologies = [
    PremiumItem('⚡ Flutter', Color(0xFF00B4B4)),
    PremiumItem('⚛️ React', Color(0xFF61DAFB)),
    PremiumItem('🅰️ Angular', Color(0xFFDD0031)),
    PremiumItem('💚 Vue.js', Color(0xFF42B883)),
    PremiumItem('🚀 Svelte', Color(0xFFFF3E00)),
    PremiumItem('🔷 Next.js', Color(0xFF000000)),
  ];

  final List<PremiumItem> languages = [
    PremiumItem('🐍 Python', Color(0xFF3776AB)),
    PremiumItem('🎯 Dart', Color(0xFF00B4B4)),
    PremiumItem('📜 JavaScript', Color(0xFFF7DF1E)),
    PremiumItem('☕ Java', Color(0xFFF89820)),
    PremiumItem('🦀 Rust', Color(0xFFDEA584)),
    PremiumItem('⚡ Go', Color(0xFF00ADD8)),
  ];

  final List<PremiumItem> colors = [
    PremiumItem('🔴 Ruby Red', Color(0xFFEF4444)),
    PremiumItem('🔵 Sapphire Blue', Color(0xFF3B82F6)),
    PremiumItem('🟢 Emerald Green', Color(0xFF10B981)),
    PremiumItem('🟡 Golden Yellow', Color(0xFFF59E0B)),
    PremiumItem('🟣 Amethyst Purple', Color(0xFF8B5CF6)),
    PremiumItem('🟠 Coral Orange', Color(0xFFF97316)),
  ];

  final List<PremiumItem> desserts = [
    PremiumItem('🍰 Chocolate Cake', Color(0xFF78350F)),
    PremiumItem('🍪 Cookie', Color(0xFFB45309)),
    PremiumItem('🍩 Donut', Color(0xFFF59E0B)),
    PremiumItem('🍦 Ice Cream', Color(0xFFFCD34D)),
    PremiumItem('🍫 Chocolate', Color(0xFF78350F)),
    PremiumItem('🍬 Candy', Color(0xFFEC4899)),
  ];

  @override
  void initState() {
    super.initState();
    // Initialize strategy selections
    for (var type in DropdownAnimationType.values) {
      singleStrategySelections[type] = null;
      multiStrategySelections[type] = [];
    }
  }

  void _resetAll() {
    setState(() {
      // Reset indicators
      selectedClassicRadio = null;
      selectedCheckmarkRadio = null;
      selectedDotRadio = null;
      selectedSquareRadio = null;
      selectedToggle = null;
      selectedSwitch = null;
      selectedGradientRadio = null;
      selectedNeumorphicRadio = null;
      selectedStar = null;

      selectedClassicCheckbox = [];
      selectedModernCheckbox = [];
      selectedDotCheckbox = [];
      selectedSquareCheckbox = [];
      selectedGradientCheckbox = [];
      selectedNeumorphicCheckbox = [];
      selectedHeart = [];

      // Reset strategies
      for (var type in DropdownAnimationType.values) {
        singleStrategySelections[type] = null;
        multiStrategySelections[type] = [];
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✨ All selections reset'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: EdgeInsets.all(16),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Premium Dropdown Showcase'),
        centerTitle: false,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            child: Row(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'v2.0',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: _resetAll,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.refresh,
                        size: 20, color: Color(0xFF64748B)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroHeader(),
            const SizedBox(height: 32),

            // ==================== INDICATOR TYPES SECTION ====================
            _buildSectionHeader('Indicator Types', Icons.tune,
                '16+ Beautiful Indicator Styles'),
            const SizedBox(height: 24),
            _buildIndicatorGrid(),
            const SizedBox(height: 48),

            // ==================== ANIMATION STRATEGIES SECTION ====================
            _buildSectionHeader('Animation Strategies', Icons.animation,
                '25+ Stunning Animation Effects'),
            const SizedBox(height: 24),
            _buildAnimationStrategiesGrid(),
            const SizedBox(height: 48),

            // ==================== SELECTION SUMMARY ====================
            _buildSelectionSummary(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6), Color(0xFFA78BFA)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF6366F1).withValuesOpacity(0.3),
            blurRadius: 20,
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
                  color: Colors.white.withValuesOpacity(0.2),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.auto_awesome,
                    color: Colors.white, size: 28),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'PREMIUM DROPDOWN',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.white70,
                        letterSpacing: 1,
                      ),
                    ),
                    const Text(
                      'Indicator Types + Animation Strategies',
                      style: TextStyle(
                        fontSize: 24,
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
          const SizedBox(height: 20),
          Text(
            'Experience the most comprehensive dropdown collection with 16+ indicator styles and 25+ stunning animation strategies. Perfect for premium applications.',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValuesOpacity(0.9),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _buildFeatureChip(Icons.radio_button_checked, '4 Radio Styles',
                  Color(0xFFFCD34D)),
              _buildFeatureChip(
                  Icons.check_box, '4 Checkbox Styles', Color(0xFFA7F3D0)),
              _buildFeatureChip(
                  Icons.toggle_on, 'Toggle/Switch', Color(0xFFFED7AA)),
              _buildFeatureChip(
                  Icons.gradient, 'Gradient Styles', Color(0xFFDDD6FE)),
              _buildFeatureChip(
                  Icons.animation, '25+ Animations', Color(0xFFFBCFE8)),
              _buildFeatureChip(Icons.brush, 'Custom Icons', Color(0xFFCFFAFE)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureChip(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor.withValuesOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValuesOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: Colors.white, size: 22),
            ),
            const SizedBox(width: 14),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                    letterSpacing: -0.3,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 3,
          width: 60,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildIndicatorGrid() {
    return Column(
      children: [
        // Radio Indicators Row
        _buildIndicatorRow(
          title: 'Radio Indicators',
          icon: Icons.radio_button_checked,
          children: [
            _buildPremiumCard(
              title: 'Classic Radio',
              gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              child: SimpleDropdownFactory.radio(
                items: fruits.map((e) => e.name).toList(),
                value: selectedClassicRadio,
                onChanged: (value) =>
                    setState(() => selectedClassicRadio = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select a fruit',
                activeColor: Color(0xFF6366F1),
              ),
            ),
            _buildPremiumCard(
              title: 'Radio + Checkmark',
              gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
              child: SimpleDropdownFactory.single(
                items: technologies.map((e) => e.name).toList(),
                value: selectedCheckmarkRadio,
                onChanged: (value) =>
                    setState(() => selectedCheckmarkRadio = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select tech',
                highlightColor: Color(0xFF10B981),
                indicatorType: IndicatorType.radioCheckmark,
              ),
            ),
            _buildPremiumCard(
              title: 'Radio + Dot',
              gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              child: SimpleDropdownFactory.single(
                items: languages.map((e) => e.name).toList(),
                value: selectedDotRadio,
                onChanged: (value) => setState(() => selectedDotRadio = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select language',
                highlightColor: Color(0xFFF59E0B),
                indicatorType: IndicatorType.radioDot,
              ),
            ),
            _buildPremiumCard(
              title: 'Square Radio',
              gradientColors: [Color(0xFFEF4444), Color(0xFFF87171)],
              child: SimpleDropdownFactory.single(
                items: colors.map((e) => e.name).toList(),
                value: selectedSquareRadio,
                onChanged: (value) =>
                    setState(() => selectedSquareRadio = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select color',
                highlightColor: Color(0xFFEF4444),
                indicatorType: IndicatorType.radioSquare,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Toggle & Switch Row
        _buildIndicatorRow(
          title: 'Toggle & Switch',
          icon: Icons.toggle_on,
          children: [
            _buildPremiumCard(
              title: 'Toggle Style',
              gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              child: SimpleDropdownFactory.toggle(
                items: fruits.map((e) => e.name).toList(),
                value: selectedToggle,
                onChanged: (value) => setState(() => selectedToggle = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Toggle to select',
                activeColor: Color(0xFF6366F1),
              ),
            ),
            _buildPremiumCard(
              title: 'Switch Style',
              gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
              child: SimpleDropdownFactory.switchStyle(
                items: technologies.map((e) => e.name).toList(),
                value: selectedSwitch,
                onChanged: (value) => setState(() => selectedSwitch = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Switch to select',
                activeColor: Color(0xFF10B981),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Checkbox Indicators Row
        _buildIndicatorRow(
          title: 'Checkbox Indicators',
          icon: Icons.check_box,
          children: [
            _buildPremiumCard(
              title: 'Classic Checkbox',
              gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              child: SimpleDropdownFactory.multiple(
                items: fruits.map((e) => e.name).toList(),
                value: selectedClassicCheckbox,
                onChanged: (values) => setState(
                    () => selectedClassicCheckbox = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select fruits',
                highlightColor: Color(0xFF6366F1),
                indicatorType: IndicatorType.classic,
              ),
            ),
            _buildPremiumCard(
              title: 'Modern Checkbox',
              gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
              child: SimpleDropdownFactory.multiple(
                items: technologies.map((e) => e.name).toList(),
                value: selectedModernCheckbox,
                onChanged: (values) => setState(
                    () => selectedModernCheckbox = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select tech',
                highlightColor: Color(0xFF10B981),
                indicatorType: IndicatorType.checkmark,
              ),
            ),
            _buildPremiumCard(
              title: 'Dot Checkbox',
              gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              child: SimpleDropdownFactory.dotCheckbox(
                items: languages.map((e) => e.name).toList(),
                value: selectedDotCheckbox,
                onChanged: (values) => setState(
                    () => selectedDotCheckbox = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select languages',
                activeColor: Color(0xFFF59E0B),
              ),
            ),
            _buildPremiumCard(
              title: 'Square Checkbox',
              gradientColors: [Color(0xFFEF4444), Color(0xFFF87171)],
              child: SimpleDropdownFactory.multiple(
                items: colors.map((e) => e.name).toList(),
                value: selectedSquareCheckbox,
                onChanged: (values) => setState(
                    () => selectedSquareCheckbox = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select colors',
                highlightColor: Color(0xFFEF4444),
                indicatorType: IndicatorType.square,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Gradient & Neumorphic Row
        _buildIndicatorRow(
          title: 'Gradient & Neumorphic',
          icon: Icons.gradient,
          children: [
            _buildPremiumCard(
              title: 'Gradient Radio',
              gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
              child: SimpleDropdownFactory.gradientRadio(
                items: fruits.map((e) => e.name).toList(),
                value: selectedGradientRadio,
                onChanged: (value) =>
                    setState(() => selectedGradientRadio = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                gradientColors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                hintText: 'Select fruit',
              ),
            ),
            _buildPremiumCard(
              title: 'Gradient Checkbox',
              gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
              child: SimpleDropdownFactory.gradientCheckbox(
                items: technologies.map((e) => e.name).toList(),
                value: selectedGradientCheckbox,
                onChanged: (values) => setState(
                    () => selectedGradientCheckbox = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                gradientColors: [Color(0xFF10B981), Color(0xFF34D399)],
                hintText: 'Select tech',
              ),
            ),
            _buildPremiumCard(
              title: 'Neumorphic Radio',
              gradientColors: [Color(0xFFEC4899), Color(0xFFF472B6)],
              child: SimpleDropdownFactory.single(
                items: languages.map((e) => e.name).toList(),
                value: selectedNeumorphicRadio,
                onChanged: (value) =>
                    setState(() => selectedNeumorphicRadio = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select language',
                highlightColor: Color(0xFFEC4899),
                indicatorType: IndicatorType.neumorphic,
              ),
            ),
            _buildPremiumCard(
              title: 'Neumorphic Checkbox',
              gradientColors: [Color(0xFF06B6D4), Color(0xFF22D3EE)],
              child: SimpleDropdownFactory.multiple(
                items: colors.map((e) => e.name).toList(),
                value: selectedNeumorphicCheckbox,
                onChanged: (values) => setState(() =>
                    selectedNeumorphicCheckbox = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select colors',
                highlightColor: Color(0xFF06B6D4),
                indicatorType: IndicatorType.neumorphic,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Custom Indicators Row
        _buildIndicatorRow(
          title: 'Custom Indicators',
          icon: Icons.brush,
          children: [
            _buildPremiumCard(
              title: 'Star Icon',
              gradientColors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
              child: SimpleDropdownFactory.customStarSingle(
                items: desserts.map((e) => e.name).toList(),
                value: selectedStar,
                onChanged: (value) => setState(() => selectedStar = value),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select dessert',
                activeColor: Color(0xFFF59E0B),
              ),
            ),
            _buildPremiumCard(
              title: 'Heart Icon',
              gradientColors: [Color(0xFFEF4444), Color(0xFFF87171)],
              child: SimpleDropdownFactory.customHeartMultiple(
                items: technologies.map((e) => e.name).toList(),
                value: selectedHeart,
                onChanged: (values) =>
                    setState(() => selectedHeart = List<String>.from(values)),
                itemBuilder: (item) =>
                    Text(item, style: const TextStyle(fontSize: 14)),
                hintText: 'Select favorites',
                activeColor: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildIndicatorRow({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Color(0xFF6366F1)),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 800 ? 4 : 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: children,
        ),
      ],
    );
  }

  Widget _buildPremiumCard({
    required String title,
    required List<Color> gradientColors,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            gradientColors[0].withValuesOpacity(0.05),
            gradientColors[1].withValuesOpacity(0.02)
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: gradientColors[0].withValuesOpacity(0.2), width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: gradientColors),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: gradientColors[0],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }

  Widget _buildAnimationStrategiesGrid() {
    final glassStrategies = [
      DropdownAnimationType.glass,
      DropdownAnimationType.glassMorphism,
      DropdownAnimationType.floatingGlass,
      DropdownAnimationType.floatingCard,
      DropdownAnimationType.morphingGlass,
      DropdownAnimationType.morphing,
    ];

    final liquidStrategies = [
      DropdownAnimationType.liquid,
      DropdownAnimationType.liquidSmooth,
      DropdownAnimationType.fluidWave,
      DropdownAnimationType.liquidMetal,
      DropdownAnimationType.liquidSwipe,
      DropdownAnimationType.gradientWave,
    ];

    final neonStrategies = [
      DropdownAnimationType.neon,
      DropdownAnimationType.neonPulse,
      DropdownAnimationType.cyberpunk,
      DropdownAnimationType.cyberNeon,
    ];

    final bounceStrategies = [
      DropdownAnimationType.bouncy3d,
      DropdownAnimationType.gravityWell,
      DropdownAnimationType.foldable,
      DropdownAnimationType.cosmicRipple,
    ];

    final staggerStrategies = [
      DropdownAnimationType.staggered,
      DropdownAnimationType.staggeredVerticalDropItem,
      DropdownAnimationType.hologram,
      DropdownAnimationType.holographicFan,
      DropdownAnimationType.molecular,
    ];

    return Column(
      children: [
        _buildStrategyCategory(
          title: 'Glass & Morphing',
          icon: Icons.animation,
          color: Color(0xFF6366F1),
          strategies: glassStrategies,
        ),
        const SizedBox(height: 24),
        _buildStrategyCategory(
          title: 'Liquid & Fluid',
          icon: Icons.waves,
          color: Color(0xFF10B981),
          strategies: liquidStrategies,
        ),
        const SizedBox(height: 24),
        _buildStrategyCategory(
          title: 'Neon & Cyber',
          icon: Icons.flash_on,
          color: Color(0xFFF59E0B),
          strategies: neonStrategies,
        ),
        const SizedBox(height: 24),
        _buildStrategyCategory(
          title: '3D & Bounce',
          icon: Icons.theater_comedy,
          color: Color(0xFFEF4444),
          strategies: bounceStrategies,
        ),
        const SizedBox(height: 24),
        _buildStrategyCategory(
          title: 'Staggered & Holographic',
          icon: Icons.view_agenda,
          color: Color(0xFF8B5CF6),
          strategies: staggerStrategies,
        ),
      ],
    );
  }

  Widget _buildStrategyCategory({
    required String title,
    required IconData icon,
    required Color color,
    required List<DropdownAnimationType> strategies,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValuesOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: MediaQuery.of(context).size.width > 1200
              ? 4
              : MediaQuery.of(context).size.width > 800
                  ? 3
                  : 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: strategies
              .map((strategy) => _buildStrategyCard(
                    title: _getAnimationDisplayName(strategy),
                    strategy: strategy,
                    color: color,
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildStrategyCard({
    required String title,
    required DropdownAnimationType strategy,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValuesOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValuesOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SimpleDropdownFactory.single(
              items: fruits.map((e) => e.name).toList(),
              value: singleStrategySelections[strategy],
              onChanged: (value) =>
                  setState(() => singleStrategySelections[strategy] = value),
              itemBuilder: (item) =>
                  Text(item, style: const TextStyle(fontSize: 13)),
              hintText: 'Select',
              highlightColor: color,
              animationType: strategy,
              height: 42,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
      ),
    );
  }

  String _getAnimationDisplayName(DropdownAnimationType type) {
    switch (type) {
      case DropdownAnimationType.glass:
        return 'Glass';
      case DropdownAnimationType.glassMorphism:
        return 'Glass Morphism';
      case DropdownAnimationType.floatingGlass:
        return 'Floating Glass';
      case DropdownAnimationType.floatingCard:
        return 'Floating Card';
      case DropdownAnimationType.morphingGlass:
        return 'Morphing Glass';
      case DropdownAnimationType.morphing:
        return 'Morphing';
      case DropdownAnimationType.liquid:
        return 'Liquid';
      case DropdownAnimationType.liquidSmooth:
        return 'Liquid Smooth';
      case DropdownAnimationType.fluidWave:
        return 'Fluid Wave';
      case DropdownAnimationType.liquidMetal:
        return 'Liquid Metal';
      case DropdownAnimationType.liquidSwipe:
        return 'Liquid Swipe';
      case DropdownAnimationType.gradientWave:
        return 'Gradient Wave';
      case DropdownAnimationType.neon:
        return 'Neon';
      case DropdownAnimationType.neonPulse:
        return 'Neon Pulse';
      case DropdownAnimationType.cyberpunk:
        return 'Cyberpunk';
      case DropdownAnimationType.cyberNeon:
        return 'Cyber Neon';
      case DropdownAnimationType.bouncy3d:
        return 'Bouncy 3D';
      case DropdownAnimationType.gravityWell:
        return 'Gravity Well';
      case DropdownAnimationType.foldable:
        return 'Foldable';
      case DropdownAnimationType.cosmicRipple:
        return 'Cosmic Ripple';
      case DropdownAnimationType.staggered:
        return 'Staggered';
      case DropdownAnimationType.staggeredVerticalDropItem:
        return 'Staggered Vertical';
      case DropdownAnimationType.hologram:
        return 'Hologram';
      case DropdownAnimationType.holographicFan:
        return 'Holographic Fan';
      case DropdownAnimationType.molecular:
        return 'Molecular';
    }
  }

  Widget _buildSelectionSummary() {
    int totalSelections = 0;
    List<Map<String, dynamic>> selections = [];

    // Count indicator selections
    if (selectedClassicRadio != null) {
      totalSelections++;
      selections
          .add({'label': 'Classic Radio', 'value': selectedClassicRadio!});
    }
    if (selectedCheckmarkRadio != null) {
      totalSelections++;
      selections
          .add({'label': 'Checkmark Radio', 'value': selectedCheckmarkRadio!});
    }
    if (selectedDotRadio != null) {
      totalSelections++;
      selections.add({'label': 'Dot Radio', 'value': selectedDotRadio!});
    }
    if (selectedSquareRadio != null) {
      totalSelections++;
      selections.add({'label': 'Square Radio', 'value': selectedSquareRadio!});
    }
    if (selectedToggle != null) {
      totalSelections++;
      selections.add({'label': 'Toggle', 'value': selectedToggle!});
    }
    if (selectedSwitch != null) {
      totalSelections++;
      selections.add({'label': 'Switch', 'value': selectedSwitch!});
    }
    if (selectedGradientRadio != null) {
      totalSelections++;
      selections
          .add({'label': 'Gradient Radio', 'value': selectedGradientRadio!});
    }
    if (selectedNeumorphicRadio != null) {
      totalSelections++;
      selections.add(
          {'label': 'Neumorphic Radio', 'value': selectedNeumorphicRadio!});
    }
    if (selectedStar != null) {
      totalSelections++;
      selections.add({'label': 'Star', 'value': selectedStar!});
    }

    totalSelections += selectedClassicCheckbox.length;
    totalSelections += selectedModernCheckbox.length;
    totalSelections += selectedDotCheckbox.length;
    totalSelections += selectedSquareCheckbox.length;
    totalSelections += selectedGradientCheckbox.length;
    totalSelections += selectedNeumorphicCheckbox.length;
    totalSelections += selectedHeart.length;

    if (selectedClassicCheckbox.isNotEmpty) {
      selections.add({
        'label': 'Classic Box',
        'value': '${selectedClassicCheckbox.length} selected'
      });
    }
    if (selectedModernCheckbox.isNotEmpty) {
      selections.add({
        'label': 'Modern Box',
        'value': '${selectedModernCheckbox.length} selected'
      });
    }
    if (selectedDotCheckbox.isNotEmpty) {
      selections.add({
        'label': 'Dot Box',
        'value': '${selectedDotCheckbox.length} selected'
      });
    }
    if (selectedSquareCheckbox.isNotEmpty) {
      selections.add({
        'label': 'Square Box',
        'value': '${selectedSquareCheckbox.length} selected'
      });
    }
    if (selectedGradientCheckbox.isNotEmpty) {
      selections.add({
        'label': 'Gradient Box',
        'value': '${selectedGradientCheckbox.length} selected'
      });
    }
    if (selectedNeumorphicCheckbox.isNotEmpty) {
      selections.add({
        'label': 'Neumorphic Box',
        'value': '${selectedNeumorphicCheckbox.length} selected'
      });
    }
    if (selectedHeart.isNotEmpty) {
      selections
          .add({'label': 'Heart', 'value': '${selectedHeart.length} selected'});
    }

    // Count strategy selections
    for (var entry in singleStrategySelections.entries) {
      if (entry.value != null) {
        totalSelections++;
        selections.add({
          'label': _getAnimationDisplayName(entry.key),
          'value': entry.value!
        });
      }
    }

    for (var entry in multiStrategySelections.entries) {
      if (entry.value.isNotEmpty) {
        totalSelections += entry.value.length;
        selections.add({
          'label': _getAnimationDisplayName(entry.key),
          'value': '${entry.value.length} selected'
        });
      }
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF8FAFC), Colors.white],
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
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(Icons.summarize,
                        color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Selection Summary',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  '$totalSelections items',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (selections.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  children: [
                    Icon(Icons.touch_app, size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'No selections yet',
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    Text(
                      'Try selecting from any dropdown above',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              ),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: selections.map((selection) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6366F1).withValuesOpacity(0.1),
                        Color(0xFF8B5CF6).withValuesOpacity(0.05)
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                        color: Color(0xFF6366F1).withValuesOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${selection['label']}: ',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6366F1),
                        ),
                      ),
                      Text(
                        selection['value'],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
        ],
      ),
    );
  }
}

class PremiumItem {
  final String name;
  final Color color;

  const PremiumItem(this.name, this.color);
}
