import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const RooSuperApp());
}

// ---------------------------------------------------------------------------
// Design tokens
// ---------------------------------------------------------------------------

abstract final class RooColors {
  static const Color primary = Color(0xFF0038A8);
  static const Color primaryDark = Color(0xFF1A237E);
  static const Color royalBlue = Color(0xFF2962FF);
  static const Color trackingBlue = Color(0xFF1A56BE);
  static const Color teal = Color(0xFF004D40);
  static const Color scaffoldBg = Color(0xFFF8F9FE);
  static const Color inputFill = Color(0xFFF1F3F9);
  static const Color contactCardBg = Color(0xFFF0F2FF);
  static const Color labelGrey = Color(0xFF757575);
  static const Color textDark = Color(0xFF1E293B);
  static const Color divider = Color(0xFFE8ECF4);
  static const Color navInactive = Color(0xFF94A3B8);
  static const Color navPill = Color(0xFFE8F0FE);
  static const Color logoutRed = Color(0xFFDC2626);
}

abstract final class RooSpacing {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
}

/// Static corp list for fleet selection.
abstract final class RooCorps {
  static const List<String> names = [
    'AECS',
    'AXON',
    'TBSW',
    'TSAC',
    'TSAB',
    'TSB',
  ];

  static const String validationMessage = 'Please select corp';
}

/// Static trip list for fleet selection.
abstract final class RooTrips {
  static const List<String> names = [
    'Pickup-8:30AM',
    'Drop-12:30PM',
    'Drop-4:30PM',
  ];

  static const String validationMessage = 'Please select trip';
}

// ---------------------------------------------------------------------------
// App
// ---------------------------------------------------------------------------

class RooSuperApp extends StatelessWidget {
  const RooSuperApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: RooColors.primary,
        primary: RooColors.primary,
        surface: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: RooColors.scaffoldBg,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: RooColors.inputFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: RooColors.primary, width: 1.5),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: RooSpacing.md,
          vertical: RooSpacing.md,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: RooColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: RooColors.primary,
          side: const BorderSide(color: Color(0xFFD1D9E6)),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.inter(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
      ),
    );

    return MaterialApp(
      title: 'RooSuper',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.interTextTheme(base.textTheme),
      ),
      home: const LoginScreen(),
    );
  }
}

// ---------------------------------------------------------------------------
// Reusable widgets
// ---------------------------------------------------------------------------

class RooLogo extends StatelessWidget {
  const RooLogo({super.key, this.size = 72, this.borderWidth = 3});

  final double size;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: RooColors.primary, width: borderWidth),
        color: Colors.white,
      ),
      child: ClipOval(
        child: Image.asset(
          'assets/roosuper_logo.png',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return CustomPaint(painter: _RooLogoPainter());
          },
        ),
      ),
    );
  }
}

class _RooLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final blue = Paint()
      ..color = RooColors.primary
      ..style = PaintingStyle.fill;
    final lightBlue = Paint()..color = const Color(0xFF5B9BD5);

    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.22;

    // Stylized R stem
    final stem = RRect.fromRectAndRadius(
      Rect.fromLTWH(cx - r * 0.35, cy - r * 1.1, r * 0.55, r * 1.6),
      Radius.circular(r * 0.15),
    );
    canvas.drawRRect(stem, blue);

    // R bowl
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx + r * 0.05, cy - r * 0.15), radius: r * 0.85),
      -math.pi * 0.15,
      math.pi * 1.35,
      false,
      Paint()
        ..color = RooColors.primary
        ..style = PaintingStyle.stroke
        ..strokeWidth = r * 0.42
        ..strokeCap = StrokeCap.round,
    );

    // Pin dot accent
    canvas.drawCircle(Offset(cx + r * 0.75, cy + r * 0.55), r * 0.22, lightBlue);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class RooLabeledField extends StatelessWidget {
  const RooLabeledField({
    super.key,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.obscureText = false,
    this.suffixIcon,
    this.controller,
  });

  final String label;
  final String hint;
  final IconData prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: RooColors.textDark,
          ),
        ),
        const SizedBox(height: RooSpacing.xs),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: GoogleFonts.inter(fontSize: 15, color: RooColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.inter(
              color: const Color(0xFF9CA3AF),
              fontSize: 14,
            ),
            prefixIcon: Icon(prefixIcon, color: RooColors.labelGrey, size: 22),
            suffixIcon: suffixIcon,
          ),
        ),
      ],
    );
  }
}

class RooCard extends StatelessWidget {
  const RooCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(RooSpacing.lg),
    this.radius = 18,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class RooBottomNavBar extends StatelessWidget {
  const RooBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    (Icons.grid_view_rounded, 'Dashboard'),
    (Icons.explore_outlined, 'Tracking'),
    (Icons.person_outline, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: RooSpacing.md,
            vertical: RooSpacing.xs,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_items.length, (i) {
              final (icon, label) = _items[i];
              final selected = i == currentIndex;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: selected ? RooColors.navPill : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          icon,
                          size: 24,
                          color: selected ? RooColors.primary : RooColors.navInactive,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          color: selected ? RooColors.primary : RooColors.navInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class RooAppHeader extends StatelessWidget {
  const RooAppHeader({
    super.key,
    this.showTruckTitle = false,
    this.showSearch = false,
    this.notificationDot = false,
    this.centerSelectors = false,
    this.selectedCorp,
    this.onCorpChanged,
    this.selectedTrip,
    this.onTripChanged,
    this.selectorAutovalidateMode = AutovalidateMode.disabled,
  });

  final bool showTruckTitle;
  final bool showSearch;
  final bool notificationDot;
  final bool centerSelectors;
  final String? selectedCorp;
  final ValueChanged<String?>? onCorpChanged;
  final String? selectedTrip;
  final ValueChanged<String?>? onTripChanged;
  final AutovalidateMode selectorAutovalidateMode;

  @override
  Widget build(BuildContext context) {
    if (centerSelectors) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          RooSpacing.md,
          RooSpacing.sm,
          RooSpacing.md,
          RooSpacing.xs,
        ),
        child: Row(
          children: [
            const RooLogo(size: 40, borderWidth: 2),
            const SizedBox(width: RooSpacing.sm),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: _CorpSelectorField(
                      value: selectedCorp,
                      onChanged: onCorpChanged,
                      autovalidateMode: selectorAutovalidateMode,
                    ),
                  ),
                  const SizedBox(width: RooSpacing.xs),
                  Expanded(
                    child: _TripSelectorField(
                      value: selectedTrip,
                      onChanged: onTripChanged,
                      autovalidateMode: selectorAutovalidateMode,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_outlined, color: RooColors.primaryDark),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: RooSpacing.md,
        vertical: RooSpacing.sm,
      ),
      child: Row(
        children: [
          if (showTruckTitle) ...[
            const Icon(Icons.local_shipping_outlined, color: RooColors.primary, size: 26),
            const SizedBox(width: RooSpacing.xs),
            Text(
              'RooSuper',
              style: GoogleFonts.inter(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: RooColors.primary,
              ),
            ),
          ] else
            const RooLogo(size: 40, borderWidth: 2),
          const Spacer(),
          if (showSearch)
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.search, color: RooColors.labelGrey),
            ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.notifications_outlined,
                  color: showTruckTitle ? RooColors.labelGrey : RooColors.primaryDark,
                ),
              ),
              if (notificationDot)
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Corp dropdown chip (uses [DropdownButtonFormField]).
class _CorpSelectorField extends StatelessWidget {
  const _CorpSelectorField({
    required this.value,
    required this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final String? value;
  final ValueChanged<String?>? onChanged;
  final AutovalidateMode autovalidateMode;

  static final _valueStyle = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: RooColors.primaryDark,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'CORP SELECTION',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: RooColors.labelGrey,
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: value,
            autovalidateMode: autovalidateMode,
            isExpanded: true,
            isDense: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: RooColors.primaryDark,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              errorStyle: TextStyle(fontSize: 9, height: 1.2),
            ),
            hint: Text('Select', style: _valueStyle.copyWith(color: RooColors.labelGrey)),
            style: _valueStyle,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            validator: (corp) =>
                corp == null || corp.isEmpty ? RooCorps.validationMessage : null,
            items: RooCorps.names
                .map(
                  (corp) => DropdownMenuItem<String>(
                    value: corp,
                    child: Text(corp, style: _valueStyle),
                  ),
                )
                .toList(),
            selectedItemBuilder: (context) => RooCorps.names
                .map((corp) => Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        corp,
                        style: _valueStyle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ))
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

/// Trip dropdown chip (uses [DropdownButtonFormField]).
class _TripSelectorField extends StatelessWidget {
  const _TripSelectorField({
    required this.value,
    required this.onChanged,
    this.autovalidateMode = AutovalidateMode.disabled,
  });

  final String? value;
  final ValueChanged<String?>? onChanged;
  final AutovalidateMode autovalidateMode;

  static final _valueStyle = GoogleFonts.inter(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: RooColors.primaryDark,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'TRIP SELECTION',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: RooColors.labelGrey,
            ),
          ),
          DropdownButtonFormField<String>(
            initialValue: value,
            autovalidateMode: autovalidateMode,
            isExpanded: true,
            isDense: true,
            icon: const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
              color: RooColors.primaryDark,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedErrorBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
              errorStyle: TextStyle(fontSize: 9, height: 1.2),
            ),
            hint: Text('Select', style: _valueStyle.copyWith(color: RooColors.labelGrey)),
            style: _valueStyle,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.circular(12),
            validator: (trip) =>
                trip == null || trip.isEmpty ? RooTrips.validationMessage : null,
            items: RooTrips.names
                .map(
                  (trip) => DropdownMenuItem<String>(
                    value: trip,
                    child: Text(trip, style: _valueStyle),
                  ),
                )
                .toList(),
            selectedItemBuilder: (context) => RooTrips.names
                .map(
                  (trip) => Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      trip,
                      style: _valueStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                )
                .toList(),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class RooSettingsTile extends StatelessWidget {
  const RooSettingsTile({
    super.key,
    required this.icon,
    required this.label,
    this.trailing,
    this.iconColor,
    this.labelColor,
    this.iconBg,
    this.showDivider = true,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final Color? iconColor;
  final Color? labelColor;
  final Color? iconBg;
  final bool showDivider;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: RooSpacing.md,
              vertical: 14,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: iconBg ?? const Color(0xFFEEF2FF),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: iconColor ?? RooColors.primary, size: 20),
                ),
                const SizedBox(width: RooSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: labelColor ?? RooColors.textDark,
                    ),
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
        ),
        if (showDivider)
          const Divider(height: 1, thickness: 1, color: RooColors.divider, indent: 68),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Login screen
// ---------------------------------------------------------------------------

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscurePassword = true;
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController(text: '••••••••');

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const MainShell()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width;
    final horizontalPad = maxWidth > 600 ? (maxWidth - 420) / 2 : RooSpacing.xl;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F0FE),
              Colors.white,
              Color(0xFFF0F4FA),
            ],
            stops: [0.0, 0.45, 1.0],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: horizontalPad),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 600),
              child: Column(
                children: [
                  const SizedBox(height: RooSpacing.xxl),
                  const RooLogo(),
                  const SizedBox(height: RooSpacing.lg),
                  Text(
                    'Welcome to RooSuper',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: RooColors.primary,
                    ),
                  ),
                  const SizedBox(height: RooSpacing.xs),
                  Text(
                    'Logistics Management System',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: RooColors.labelGrey,
                    ),
                  ),
                  const SizedBox(height: RooSpacing.xl),
                  RooCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        RooLabeledField(
                          label: 'Username',
                          hint: 'Enter your username',
                          prefixIcon: Icons.person_outline,
                          controller: _usernameController,
                        ),
                        const SizedBox(height: RooSpacing.lg),
                        RooLabeledField(
                          label: 'Password',
                          hint: '••••••••',
                          prefixIcon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          controller: _passwordController,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: RooColors.labelGrey,
                              size: 22,
                            ),
                            onPressed: () =>
                                setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: RooSpacing.sm),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              foregroundColor: RooColors.primary,
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              'Forgot Password?',
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: RooSpacing.md),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _goToHome,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text('Login'),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward, size: 20),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: RooSpacing.lg),
                        Row(
                          children: [
                            const Expanded(child: Divider(color: RooColors.divider)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                'OR',
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: RooColors.labelGrey,
                                ),
                              ),
                            ),
                            const Expanded(child: Divider(color: RooColors.divider)),
                          ],
                        ),
                        const SizedBox(height: RooSpacing.lg),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.smartphone_outlined, size: 20),
                            label: const Text('Login with OTP'),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RooSpacing.xxl),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: GoogleFonts.inter(fontSize: 13, color: RooColors.labelGrey),
                      children: [
                        const TextSpan(text: 'Need help? Contact '),
                        TextSpan(
                          text: 'Support Center',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w700,
                            color: RooColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: RooSpacing.xl),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Main shell (bottom navigation)
// ---------------------------------------------------------------------------

class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  String? _selectedCorp = RooCorps.names.first;
  String? _selectedTrip = RooTrips.names.first;
  bool _selectorValidateOnNav = false;
  final _dashboardFormKey = GlobalKey<FormState>();

  String _selectionValidationMessage() {
    if (_selectedCorp == null || _selectedCorp!.isEmpty) {
      return RooCorps.validationMessage;
    }
    if (_selectedTrip == null || _selectedTrip!.isEmpty) {
      return RooTrips.validationMessage;
    }
    return RooTrips.validationMessage;
  }

  void _onBottomNavTap(int index) {
    if (index == _index) return;

    if (index != 0) {
      setState(() => _selectorValidateOnNav = true);
      final formValid = _dashboardFormKey.currentState?.validate() ?? false;
      if (!formValid ||
          _selectedCorp == null ||
          _selectedCorp!.isEmpty ||
          _selectedTrip == null ||
          _selectedTrip!.isEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(
              content: Text(
                _selectionValidationMessage(),
                style: GoogleFonts.inter(fontWeight: FontWeight.w500),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        return;
      }
    }

    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final autovalidateMode = _selectorValidateOnNav
        ? AutovalidateMode.onUserInteraction
        : AutovalidateMode.disabled;

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          DashboardScreen(
            dashboardFormKey: _dashboardFormKey,
            selectedCorp: _selectedCorp,
            onCorpChanged: (corp) => setState(() => _selectedCorp = corp),
            selectedTrip: _selectedTrip,
            onTripChanged: (trip) => setState(() => _selectedTrip = trip),
            selectorAutovalidateMode: autovalidateMode,
          ),
          TrackingScreen(
            selectedCorp: _selectedCorp,
            selectedTrip: _selectedTrip,
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: RooBottomNavBar(
        currentIndex: _index,
        onTap: _onBottomNavTap,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dashboard screen
// ---------------------------------------------------------------------------

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({
    super.key,
    required this.dashboardFormKey,
    required this.selectedCorp,
    required this.onCorpChanged,
    required this.selectedTrip,
    required this.onTripChanged,
    this.selectorAutovalidateMode = AutovalidateMode.disabled,
  });

  final GlobalKey<FormState> dashboardFormKey;
  final String? selectedCorp;
  final ValueChanged<String?> onCorpChanged;
  final String? selectedTrip;
  final ValueChanged<String?> onTripChanged;
  final AutovalidateMode selectorAutovalidateMode;

  @override
  Widget build(BuildContext context) {
    final serif = GoogleFonts.playfairDisplay;
    final pad = MediaQuery.paddingOf(context);

    return ColoredBox(
      color: RooColors.scaffoldBg,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: pad.top),
              child: Form(
                key: dashboardFormKey,
                autovalidateMode: selectorAutovalidateMode,
                child: RooAppHeader(
                  centerSelectors: true,
                  selectedCorp: selectedCorp,
                  onCorpChanged: onCorpChanged,
                  selectedTrip: selectedTrip,
                  onTripChanged: onTripChanged,
                  selectorAutovalidateMode: selectorAutovalidateMode,
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              RooSpacing.md,
              RooSpacing.sm,
              RooSpacing.md,
              RooSpacing.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'FLEET OVERVIEW',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: RooColors.primaryDark,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Oct 24, 2023',
                            style: serif(
                              fontSize: 28,
                              fontWeight: FontWeight.w700,
                              color: RooColors.primaryDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: const Color(0xFFF0F2F5),
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () {},
                        borderRadius: BorderRadius.circular(12),
                        child: const SizedBox(
                          width: 44,
                          height: 44,
                          child: Icon(Icons.refresh, color: RooColors.textDark, size: 22),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: RooSpacing.lg),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth > 500 ? 4 : 2;
                    return GridView.count(
                      crossAxisCount: crossAxisCount,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: RooSpacing.md,
                      crossAxisSpacing: RooSpacing.md,
                      childAspectRatio: 1.05,
                      children: const [
                        _StatCard(
                          label: 'Trips',
                          value: '24',
                          icon: Icons.local_shipping_outlined,
                          iconBg: Color(0xFFE3F2FD),
                          iconColor: RooColors.primaryDark,
                          valueColor: RooColors.primaryDark,
                          badge: '+12%',
                          badgeColor: RooColors.royalBlue,
                        ),
                        _StatCard(
                          label: 'Not Started',
                          value: '5',
                          icon: Icons.access_time,
                          iconBg: Color(0xFFF3F4F6),
                          iconColor: RooColors.labelGrey,
                          valueColor: Colors.black,
                        ),
                        _StatCard(
                          label: 'InProgress',
                          value: '12',
                          icon: Icons.directions_run,
                          iconBg: Color(0xFFE3F2FD),
                          iconColor: RooColors.royalBlue,
                          valueColor: RooColors.royalBlue,
                          showDot: true,
                        ),
                        _StatCard(
                          label: 'Completed',
                          value: '7',
                          icon: Icons.check_circle_outline,
                          iconBg: Color(0xFFE0F2F1),
                          iconColor: RooColors.teal,
                          valueColor: RooColors.teal,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: RooSpacing.lg),
                _StatusDistributionCard(serif: serif),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.valueColor,
    this.badge,
    this.badgeColor,
    this.showDot = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color valueColor;
  final String? badge;
  final Color? badgeColor;
  final bool showDot;

  @override
  Widget build(BuildContext context) {
    final serif = GoogleFonts.playfairDisplay;

    return RooCard(
      padding: const EdgeInsets.all(RooSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              if (badge != null)
                Text(
                  badge!,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: badgeColor,
                  ),
                )
              else if (showDot)
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: RooColors.royalBlue,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
          const Spacer(),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 13, color: RooColors.labelGrey),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: serif(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: valueColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusDistributionCard extends StatelessWidget {
  const _StatusDistributionCard({required this.serif});

  final TextStyle Function({
    Color? color,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
  }) serif;

  @override
  Widget build(BuildContext context) {
    return RooCard(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: Stack(
              alignment: Alignment.center,
              children: [
                PieChart(
                  PieChartData(
                    sectionsSpace: 2,
                    centerSpaceRadius: 58,
                    sections: [
                      PieChartSectionData(
                        value: 50,
                        color: RooColors.royalBlue,
                        radius: 28,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 29,
                        color: RooColors.teal,
                        radius: 28,
                        showTitle: false,
                      ),
                      PieChartSectionData(
                        value: 21,
                        color: const Color(0xFFB0BEC5),
                        radius: 28,
                        showTitle: false,
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '24',
                      style: serif(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: RooColors.primaryDark,
                      ),
                    ),
                    Text(
                      'TOTAL',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1,
                        color: RooColors.labelGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Status Distribution',
            style: serif(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: RooColors.primaryDark,
            ),
          ),
          const SizedBox(height: RooSpacing.lg),
          const _LegendRow(
            color: RooColors.royalBlue,
            label: 'InProgress',
            percent: '50%',
          ),
          const SizedBox(height: RooSpacing.sm),
          const _LegendRow(
            color: RooColors.teal,
            label: 'Completed',
            percent: '29%',
          ),
          const SizedBox(height: RooSpacing.sm),
          const _LegendRow(
            color: Color(0xFFB0BEC5),
            label: 'Not Started',
            percent: '21%',
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.color,
    required this.label,
    required this.percent,
  });

  final Color color;
  final String label;
  final String percent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: RooSpacing.sm),
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.inter(fontSize: 14, color: RooColors.textDark),
          ),
        ),
        Text(
          percent,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Tracking screen
// ---------------------------------------------------------------------------

class TrackingScreen extends StatelessWidget {
  const TrackingScreen({super.key, this.selectedCorp, this.selectedTrip});

  final String? selectedCorp;
  final String? selectedTrip;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8EEF5),
      body: Stack(
        children: [
          const Positioned.fill(child: _MockMap()),
          Column(
            children: [
              ColoredBox(
                color: Colors.white,
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const RooAppHeader(showSearch: true, notificationDot: true),
                      if (selectedCorp != null)
                        _SelectionBanner(
                          label: 'Selected Corp',
                          value: selectedCorp!,
                          icon: Icons.business_outlined,
                        ),
                      if (selectedTrip != null)
                        _SelectionBanner(
                          label: 'Selected Trip',
                          value: selectedTrip!,
                          icon: Icons.route_outlined,
                        ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              const _VehicleSelectionSheet(),
            ],
          ),
        ],
      ),
    );
  }
}

class _SelectionBanner extends StatelessWidget {
  const _SelectionBanner({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        RooSpacing.md,
        0,
        RooSpacing.md,
        RooSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(horizontal: RooSpacing.md, vertical: 10),
      decoration: BoxDecoration(
        color: RooColors.contactCardBg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: RooColors.primary),
          const SizedBox(width: RooSpacing.sm),
          Text(
            label,
            style: GoogleFonts.inter(fontSize: 12, color: RooColors.labelGrey),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: RooColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockMap extends StatelessWidget {
  const _MockMap();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _MapPainter(),
      child: Stack(
        children: [
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.35,
            top: MediaQuery.sizeOf(context).height * 0.28,
            child: _MapLabel(text: 'MAIN STREET'),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.08,
            top: MediaQuery.sizeOf(context).height * 0.42,
            child: Transform.rotate(
              angle: -0.4,
              child: _MapLabel(text: 'INDUSTRIAL AVENUE'),
            ),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.55,
            top: MediaQuery.sizeOf(context).height * 0.22,
            child: _VehicleMarker(label: 'TR-2904', active: true),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.42,
            top: MediaQuery.sizeOf(context).height * 0.38,
            child: _VehicleMarker(label: 'TR-2881', active: true, small: true),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.2,
            top: MediaQuery.sizeOf(context).height * 0.32,
            child: const Icon(Icons.hotel, color: Color(0xFFE91E63), size: 28),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.68,
            top: MediaQuery.sizeOf(context).height * 0.35,
            child: const Icon(Icons.restaurant, color: Color(0xFFFF8C00), size: 24),
          ),
          Positioned(
            left: MediaQuery.sizeOf(context).width * 0.72,
            top: MediaQuery.sizeOf(context).height * 0.48,
            child: Column(
              children: [
                const Icon(Icons.restaurant, color: Color(0xFFFF8C00), size: 22),
                Text(
                  "McDonald's",
                  style: GoogleFonts.inter(fontSize: 9, color: RooColors.labelGrey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFEEF2F7);
    canvas.drawRect(Offset.zero & size, bg);

    final road = Paint()
      ..color = const Color(0xFFB8D4F0)
      ..strokeWidth = 22
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(
      Offset(size.width * 0.1, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.32),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.25, size.height * 0.15),
      Offset(size.width * 0.35, size.height * 0.85),
      road,
    );
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.7, size.height * 0.75),
      Paint()
        ..color = const Color(0xFFC5DBF0)
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round,
    );

    final block = Paint()..color = Colors.white.withValues(alpha: 0.85);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.55, size.height * 0.5, size.width * 0.3, size.height * 0.15),
        const Radius.circular(8),
      ),
      block,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _MapLabel extends StatelessWidget {
  const _MapLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.8,
        color: const Color(0xFF64748B),
      ),
    );
  }
}

class _VehicleMarker extends StatelessWidget {
  const _VehicleMarker({
    required this.label,
    this.active = false,
    this.small = false,
  });

  final String label;
  final bool active;
  final bool small;

  @override
  Widget build(BuildContext context) {
    final size = small ? 44.0 : 52.0;
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: RooColors.trackingBlue, width: 1.5),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: RooColors.textDark,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: size + 16,
          height: size + 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: RooColors.trackingBlue.withValues(alpha: 0.15),
          ),
          child: Center(
            child: Container(
              width: size,
              height: size,
              decoration: const BoxDecoration(
                color: RooColors.trackingBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_shipping, color: Colors.white, size: 24),
            ),
          ),
        ),
      ],
    );
  }
}

class _VehicleSelectionSheet extends StatelessWidget {
  const _VehicleSelectionSheet();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(RooSpacing.md, 0, RooSpacing.md, 0),
      padding: const EdgeInsets.fromLTRB(RooSpacing.lg, RooSpacing.lg, RooSpacing.lg, RooSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vehicle Selection',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: RooColors.textDark,
                ),
              ),
              Text(
                '3 Selected',
                style: GoogleFonts.inter(fontSize: 13, color: RooColors.labelGrey),
              ),
            ],
          ),
          const SizedBox(height: RooSpacing.md),
          const _VehicleRow(
            id: 'TR-2904',
            status: 'Active • 45 km/h',
            active: true,
            selected: true,
          ),
          const SizedBox(height: RooSpacing.sm),
          const _VehicleRow(
            id: 'TR-2881',
            status: 'Active • 32 km/h',
            active: true,
            selected: true,
          ),
          const SizedBox(height: RooSpacing.sm),
          const _VehicleRow(
            id: 'TR-1042',
            status: 'Stationary • Idle 12m',
            active: false,
            selected: true,
          ),
        ],
      ),
    );
  }
}

class _VehicleRow extends StatelessWidget {
  const _VehicleRow({
    required this.id,
    required this.status,
    required this.active,
    required this.selected,
  });

  final String id;
  final String status;
  final bool active;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(RooSpacing.md),
      decoration: BoxDecoration(
        color: RooColors.inputFill,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: active ? const Color(0xFFE8F0FE) : const Color(0xFFF3F4F6),
              shape: BoxShape.circle,
            ),
            child: Icon(
              active ? Icons.local_shipping : Icons.pause_circle_outline,
              color: active ? RooColors.trackingBlue : RooColors.labelGrey,
              size: 22,
            ),
          ),
          const SizedBox(width: RooSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  id,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: RooColors.textDark,
                  ),
                ),
                Text(
                  status,
                  style: GoogleFonts.inter(fontSize: 12, color: RooColors.labelGrey),
                ),
              ],
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: selected ? RooColors.trackingBlue : Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                color: selected ? RooColors.trackingBlue : RooColors.divider,
                width: 2,
              ),
            ),
            child: selected
                ? const Icon(Icons.check, color: Colors.white, size: 16)
                : null,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Profile screen
// ---------------------------------------------------------------------------

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _pushNotifications = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: RooColors.scaffoldBg,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SafeArea(
              bottom: false,
              child: const RooAppHeader(),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              RooSpacing.md,
              0,
              RooSpacing.md,
              RooSpacing.xl,
            ),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _ProfileHeaderCard(),
                const SizedBox(height: RooSpacing.xl),
                Text(
                  'Account Settings',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: RooColors.textDark,
                  ),
                ),
                const SizedBox(height: RooSpacing.md),
                RooCard(
                  padding: EdgeInsets.zero,
                  child: Column(
                    children: [
                      RooSettingsTile(
                        icon: Icons.lock_clock_outlined,
                        label: 'Change Password',
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: RooColors.navInactive,
                        ),
                        onTap: () {},
                      ),
                      RooSettingsTile(
                        icon: Icons.notifications_outlined,
                        label: 'Push Notifications',
                        trailing: Switch(
                          value: _pushNotifications,
                          onChanged: (v) => setState(() => _pushNotifications = v),
                        ),
                        onTap: () =>
                            setState(() => _pushNotifications = !_pushNotifications),
                      ),
                      RooSettingsTile(
                        icon: Icons.dark_mode_outlined,
                        label: 'Dark Mode',
                        trailing: Switch(
                          value: _darkMode,
                          onChanged: (v) => setState(() => _darkMode = v),
                        ),
                        onTap: () => setState(() => _darkMode = !_darkMode),
                      ),
                      RooSettingsTile(
                        icon: Icons.shield_outlined,
                        label: 'Privacy & Security',
                        trailing: const Icon(
                          Icons.chevron_right,
                          color: RooColors.navInactive,
                        ),
                        onTap: () {},
                      ),
                      RooSettingsTile(
                        icon: Icons.language,
                        label: 'Language',
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'English',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                color: RooColors.labelGrey,
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: RooColors.navInactive,
                            ),
                          ],
                        ),
                        onTap: () {},
                      ),
                      RooSettingsTile(
                        icon: Icons.logout,
                        label: 'Logout',
                        iconColor: RooColors.logoutRed,
                        labelColor: RooColors.logoutRed,
                        iconBg: const Color(0xFFFEE2E2),
                        showDivider: false,
                        onTap: () {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute<void>(builder: (_) => const LoginScreen()),
                            (_) => false,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: RooSpacing.xl),
                Center(
                  child: Column(
                    children: [
                      Text(
                        'RooSuper Enterprise v2.4.1 (Stable)',
                        style: GoogleFonts.inter(fontSize: 12, color: RooColors.labelGrey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Managed by Fleet Command Hub',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFFCBD5E1),
                        ),
                      ),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHeaderCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RooCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 100,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                  gradient: LinearGradient(
                    colors: [RooColors.royalBlue, RooColors.primaryDark],
                  ),
                ),
              ),
              Positioned(
                top: 50,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: CircleAvatar(
                        radius: 48,
                        backgroundColor: const Color(0xFFCBD5E1),
                        child: Icon(Icons.person, size: 48, color: Colors.grey.shade600),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: RooColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.edit, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 58),
          Text(
            'John Doe',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: RooColors.textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Senior Logistics Supervisor',
            style: GoogleFonts.inter(fontSize: 14, color: RooColors.labelGrey),
          ),
          const SizedBox(height: RooSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: RooSpacing.md),
            child: Column(
              children: [
                _ContactInfoTile(
                  icon: Icons.mail_outline,
                  label: 'EMAIL ADDRESS',
                  value: 'john.doe@roosuper.logistics',
                ),
                const SizedBox(height: RooSpacing.sm),
                _ContactInfoTile(
                  icon: Icons.phone_outlined,
                  label: 'MOBILE NUMBER',
                  value: '+1 (555) 012-3456',
                ),
              ],
            ),
          ),
          const SizedBox(height: RooSpacing.lg),
        ],
      ),
    );
  }
}

class _ContactInfoTile extends StatelessWidget {
  const _ContactInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(RooSpacing.md),
      decoration: BoxDecoration(
        color: RooColors.contactCardBg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: RooColors.primary, size: 22),
          const SizedBox(width: RooSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.6,
                    color: RooColors.labelGrey,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: RooColors.textDark,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
