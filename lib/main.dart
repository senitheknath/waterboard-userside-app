import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'firebase_options.dart';

// =============================================================
// PERSISTENT LOCAL STORAGE SERVICE (STANDALONE OFFLINE SUPPORT)
// =============================================================
class AppPreferences {
  static const String _keyThemeMode = 'theme_mode';
  static const String _keyUserName = 'user_name';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserPhone = 'user_phone';
  static const String _keyIsBillPaid = 'is_bill_paid';
  static const String _keyPaymentHistory = 'payment_history';
  static const String _keyComplaints = 'complaints';
  static const String _keyIndoorLeakageEnabled = 'indoor_leakage_enabled';
  static const String _keyLeakageLimitLiters = 'leakage_limit_liters';
  static const String _keyMonthlyUsageLimit = 'monthly_usage_limit';
  static const String _keyMeterReading = 'meter_reading';
  static const String _keyPrevMonthReading = 'prev_month_reading';
  static const String _keyWaterUsage = 'water_usage';
  static const String _keyUsageCharge = 'usage_charge';
  static const String _keyServiceCharge = 'service_charge';
  static const String _keySubtotal = 'subtotal';
  static const String _keyVatAmount = 'vat_amount';
  static const String _keyTotalBill = 'total_bill';
  static const String _keySlabText = 'slab_text';
  static const String _keyLeakageFromHour = 'leakage_from_hour';
  static const String _keyLeakageFromMinute = 'leakage_from_minute';
  static const String _keyLeakageToHour = 'leakage_to_hour';
  static const String _keyLeakageToMinute = 'leakage_to_minute';
  static const String _keyValveStatus = 'valve_status';
  static const String _keySuspendedByAdmin = 'suspended_by_admin';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      debugPrint('SharedPreferences init error: $e');
    }
  }

  static ThemeMode getThemeMode() {
    final val = _prefs?.getString(_keyThemeMode);
    if (val == 'dark') return ThemeMode.dark;
    if (val == 'light') return ThemeMode.light;
    return ThemeMode.system;
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    String val = 'system';
    if (mode == ThemeMode.dark) val = 'dark';
    if (mode == ThemeMode.light) val = 'light';
    await _prefs?.setString(_keyThemeMode, val);
  }

  static String getUserName() => _prefs?.getString(_keyUserName) ?? 'Ravi Amarasinghe';
  static Future<void> setUserName(String val) async => await _prefs?.setString(_keyUserName, val);

  static String getUserEmail() => _prefs?.getString(_keyUserEmail) ?? 'ravi.a@example.com';
  static Future<void> setUserEmail(String val) async => await _prefs?.setString(_keyUserEmail, val);

  static String getUserPhone() => _prefs?.getString(_keyUserPhone) ?? '+94 77 123 4567';
  static Future<void> setUserPhone(String val) async => await _prefs?.setString(_keyUserPhone, val);

  static bool getIsBillPaid() => _prefs?.getBool(_keyIsBillPaid) ?? false;
  static Future<void> setIsBillPaid(bool val) async => await _prefs?.setBool(_keyIsBillPaid, val);

  static bool getValveStatus() => _prefs?.getBool(_keyValveStatus) ?? true;
  static Future<void> setValveStatus(bool val) async => await _prefs?.setBool(_keyValveStatus, val);

  static bool getSuspendedByAdmin() => _prefs?.getBool(_keySuspendedByAdmin) ?? false;
  static Future<void> setSuspendedByAdmin(bool val) async => await _prefs?.setBool(_keySuspendedByAdmin, val);

  static bool getIndoorLeakageEnabled() => _prefs?.getBool(_keyIndoorLeakageEnabled) ?? true;
  static Future<void> setIndoorLeakageEnabled(bool val) async => await _prefs?.setBool(_keyIndoorLeakageEnabled, val);

  static double getLeakageLimitLiters() => _prefs?.getDouble(_keyLeakageLimitLiters) ?? 250.0;
  static Future<void> setLeakageLimitLiters(double val) async => await _prefs?.setDouble(_keyLeakageLimitLiters, val);

  static double getMonthlyUsageLimit() => _prefs?.getDouble(_keyMonthlyUsageLimit) ?? 1000.0;
  static Future<void> setMonthlyUsageLimit(double val) async => await _prefs?.setDouble(_keyMonthlyUsageLimit, val);

  static double getMeterReading() => _prefs?.getDouble(_keyMeterReading) ?? 1500.0;
  static Future<void> setMeterReading(double val) async => await _prefs?.setDouble(_keyMeterReading, val);

  static double getPrevMonthReading() => _prefs?.getDouble(_keyPrevMonthReading) ?? 1460.0;
  static Future<void> setPrevMonthReading(double val) async => await _prefs?.setDouble(_keyPrevMonthReading, val);

  static double getWaterUsage() => _prefs?.getDouble(_keyWaterUsage) ?? 40.0;
  static Future<void> setWaterUsage(double val) async => await _prefs?.setDouble(_keyWaterUsage, val);

  static double? getUsageCharge() => _prefs?.getDouble(_keyUsageCharge);
  static Future<void> setUsageCharge(double val) async => await _prefs?.setDouble(_keyUsageCharge, val);

  static double? getServiceCharge() => _prefs?.getDouble(_keyServiceCharge);
  static Future<void> setServiceCharge(double val) async => await _prefs?.setDouble(_keyServiceCharge, val);

  static double? getSubtotal() => _prefs?.getDouble(_keySubtotal);
  static Future<void> setSubtotal(double val) async => await _prefs?.setDouble(_keySubtotal, val);

  static double? getVatAmount() => _prefs?.getDouble(_keyVatAmount);
  static Future<void> setVatAmount(double val) async => await _prefs?.setDouble(_keyVatAmount, val);

  static double? getTotalBill() => _prefs?.getDouble(_keyTotalBill);
  static Future<void> setTotalBill(double val) async => await _prefs?.setDouble(_keyTotalBill, val);

  static String? getSlabText() => _prefs?.getString(_keySlabText);
  static Future<void> setSlabText(String val) async => await _prefs?.setString(_keySlabText, val);

  static TimeOfDay getLeakageFromTime() {
    final h = _prefs?.getInt(_keyLeakageFromHour) ?? 22;
    final m = _prefs?.getInt(_keyLeakageFromMinute) ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  static Future<void> setLeakageFromTime(TimeOfDay t) async {
    await _prefs?.setInt(_keyLeakageFromHour, t.hour);
    await _prefs?.setInt(_keyLeakageFromMinute, t.minute);
  }

  static TimeOfDay getLeakageToTime() {
    final h = _prefs?.getInt(_keyLeakageToHour) ?? 5;
    final m = _prefs?.getInt(_keyLeakageToMinute) ?? 0;
    return TimeOfDay(hour: h, minute: m);
  }

  static Future<void> setLeakageToTime(TimeOfDay t) async {
    await _prefs?.setInt(_keyLeakageToHour, t.hour);
    await _prefs?.setInt(_keyLeakageToMinute, t.minute);
  }

  static List<Map<String, dynamic>>? getPaymentHistory() {
    final raw = _prefs?.getString(_keyPaymentHistory);
    if (raw != null) {
      try {
        final List list = jsonDecode(raw);
        return list.map((e) => Map<String, dynamic>.from(e)).toList();
      } catch (_) {}
    }
    return null;
  }

  static Future<void> setPaymentHistory(List<Map<String, dynamic>> history) async {
    try {
      await _prefs?.setString(_keyPaymentHistory, jsonEncode(history));
    } catch (_) {}
  }

  static List<Map<String, dynamic>>? getComplaints() {
    final raw = _prefs?.getString(_keyComplaints);
    if (raw != null) {
      try {
        final List list = jsonDecode(raw);
        return list.map((e) {
          final m = Map<String, dynamic>.from(e);
          final s = m['status']?.toString().toLowerCase() ?? '';
          if (s.contains('resolved')) {
            m['statusColor'] = const Color(0xFF16A34A);
            m['statusBg'] = const Color(0xFFDCFCE7);
          } else {
            m['statusColor'] = const Color(0xFFD97706);
            m['statusBg'] = const Color(0xFFFEF3C7);
          }
          return m;
        }).toList();
      } catch (_) {}
    }
    return null;
  }

  static Future<void> setComplaints(List<Map<String, dynamic>> complaints) async {
    try {
      final serializable = complaints.map((c) {
        final copy = Map<String, dynamic>.from(c);
        copy.remove('statusColor');
        copy.remove('statusBg');
        return copy;
      }).toList();
      await _prefs?.setString(_keyComplaints, jsonEncode(serializable));
    } catch (_) {}
  }
}

// Global Theme Mode Notifier
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

// Apple iOS Liquid Glass Theme Configuration & Semantic Tokens
class AppTheme {
  // Apple Vibrant Liquid Palette
  static const Color primary = Color(0xFF0A84FF); // Liquid Electric Blue
  static const Color primaryDark = Color(0xFF38BDF8); // Sky Refraction
  static const Color success = Color(0xFF30D158); // Liquid Emerald
  static const Color warning = Color(0xFFFF9F0A); // Liquid Amber
  static const Color danger = Color(0xFFFF453A); // Liquid Crimson
  static const Color accentIndigo = Color(0xFF5E5CE6); // Liquid Indigo
  static const Color accentPurple = Color(0xFFBF5AF2); // Liquid Violet

  static bool isDark(BuildContext context) => Theme.of(context).brightness == Brightness.dark;

  static Color background(BuildContext context) =>
      isDark(context) ? const Color(0xFF060913) : const Color(0xFFF2F5F9);

  static Color card(BuildContext context) =>
      isDark(context) ? const Color(0xFF101624).withValues(alpha: 0.70) : Colors.white.withValues(alpha: 0.76);

  static Color surfaceAlt(BuildContext context) =>
      isDark(context) ? const Color(0xFF161F33).withValues(alpha: 0.55) : const Color(0xFFE8EDF5).withValues(alpha: 0.65);

  static Color textPrimary(BuildContext context) =>
      isDark(context) ? const Color(0xFFF8FAFC) : const Color(0xFF0B1220);

  static Color textSecondary(BuildContext context) =>
      isDark(context) ? const Color(0xFF94A3B8) : const Color(0xFF5B6B82);

  static Color textMuted(BuildContext context) =>
      isDark(context) ? const Color(0xFF64748B) : const Color(0xFF8E9BAE);

  static Color border(BuildContext context) =>
      isDark(context) ? Colors.white.withValues(alpha: 0.13) : Colors.white.withValues(alpha: 0.70);

  static Color divider(BuildContext context) =>
      isDark(context) ? Colors.white.withValues(alpha: 0.08) : Colors.black.withValues(alpha: 0.06);

  static Color iconBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF192236).withValues(alpha: 0.8) : const Color(0xFFE6ECF5).withValues(alpha: 0.9);

  static Color primaryChipBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF0A84FF).withValues(alpha: 0.22) : const Color(0xFF0A84FF).withValues(alpha: 0.12);

  static Color shadow(BuildContext context) =>
      isDark(context) ? Colors.black.withValues(alpha: 0.35) : Colors.black.withValues(alpha: 0.05);

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF2F5F9),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.light,
        primary: primary,
        surface: Colors.white,
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
      cardColor: Colors.white,
      dividerColor: const Color(0xFFE2E8F0),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF060913),
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        brightness: Brightness.dark,
        primary: primaryDark,
        surface: const Color(0xFF101624),
      ),
      fontFamily: 'Roboto',
      useMaterial3: true,
      cardColor: const Color(0xFF101624),
      dividerColor: const Color(0xFF1E293B),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
      ),
    );
  }
}

// =============================================================
// APPLE LIQUID GLASS: REUSABLE AMBIENT MESH & CARD COMPONENTS
// =============================================================

/// Ambient animated/static liquid aurora mesh that gives glass sub-surface color depth
class LiquidMeshBackground extends StatelessWidget {
  final Widget child;
  const LiquidMeshBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return Stack(
      children: [
        // Solid Canvas Foundation & Ambient Mesh (Isolated in RepaintBoundary for optimal FPS)
        Positioned.fill(
          child: RepaintBoundary(
            child: Stack(
              children: [
                Positioned.fill(
                  child: Container(
                    color: isDark ? const Color(0xFF060913) : const Color(0xFFF2F5F9),
                  ),
                ),

                // Ambient Top-Right Radial Glow (Liquid Electric Cyan)
                Positioned(
                  top: -60,
                  right: -60,
                  width: 320,
                  height: 320,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            isDark
                                ? const Color(0xFF0A84FF).withValues(alpha: 0.22)
                                : const Color(0xFF38BDF8).withValues(alpha: 0.30),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Ambient Mid-Left Radial Glow (Liquid Indigo / Violet)
                Positioned(
                  top: 240,
                  left: -80,
                  width: 340,
                  height: 340,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            isDark
                                ? const Color(0xFF5E5CE6).withValues(alpha: 0.16)
                                : const Color(0xFF818CF8).withValues(alpha: 0.20),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Ambient Bottom-Right Radial Glow (Liquid Aquamarine)
                Positioned(
                  bottom: 40,
                  right: -70,
                  width: 300,
                  height: 300,
                  child: IgnorePointer(
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            isDark
                                ? const Color(0xFF30D158).withValues(alpha: 0.12)
                                : const Color(0xFF34D399).withValues(alpha: 0.18),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                // Gaussian Diffusion Blur Layer for Mesh
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 45, sigmaY: 45),
                    child: const SizedBox.expand(),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Main App Foreground
        child,
      ],
    );
  }
}

/// Reusable Apple Liquid Glass Card Container with frosted blur & specular border
class LiquidGlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Color? tintColor;
  final double? blurSigma;
  final VoidCallback? onTap;
  final bool hasGlow;
  final Color? glowColor;

  const LiquidGlassCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 24.0,
    this.tintColor,
    this.blurSigma,
    this.onTap,
    this.hasGlow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final sigma = blurSigma ?? 24.0;
    final defaultTint = isDark
        ? const Color(0xFF101624).withValues(alpha: 0.70)
        : Colors.white.withValues(alpha: 0.76);

    Widget cardContent = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding ?? const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: tintColor ?? defaultTint,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isDark ? Colors.white.withValues(alpha: 0.14) : Colors.white.withValues(alpha: 0.75),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: (glowColor ?? Colors.black).withValues(alpha: isDark ? (hasGlow ? 0.35 : 0.22) : 0.05),
                blurRadius: hasGlow ? 24 : 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardContent,
        ),
      );
    }

    if (margin != null) {
      return Padding(padding: margin!, child: cardContent);
    }
    return cardContent;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppPreferences.init();
  themeModeNotifier.value = AppPreferences.getThemeMode();

  themeModeNotifier.addListener(() {
    AppPreferences.setThemeMode(themeModeNotifier.value);
  });

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseDatabase.instance.setPersistenceEnabled(true);
    FirebaseDatabase.instance.setPersistenceCacheSizeBytes(10000000); // 10MB local cache
  } catch (e) {
    debugPrint('Firebase initialization notice: $e');
  }

  runApp(const WaterUtilityApp());
}

class WaterUtilityApp extends StatelessWidget {
  const WaterUtilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'AquaFlow Water',
          debugShowCheckedModeBanner: false,
          themeMode: currentMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: const MainNavigationScreen(),
        );
      },
    );
  }
}

// =============================================================
// NWSDB SRI LANKA WATER BILL & 18% VAT TARIFF CALCULATOR
// =============================================================
class WaterBillBreakdown {
  final int units;
  final double usageCharge;
  final double serviceCharge;
  final double subtotal;
  final double vatAmount;
  final double totalBill;
  final String slabText;

  const WaterBillBreakdown({
    required this.units,
    required this.usageCharge,
    required this.serviceCharge,
    required this.subtotal,
    required this.vatAmount,
    required this.totalBill,
    required this.slabText,
  });

  static WaterBillBreakdown calculate(num unitsNum) {
    final int units = unitsNum.round() > 0 ? unitsNum.round() : 0;

    double usageCharge = 0.0;
    const capacities = <int>[5, 5, 5, 5, 5, 5, 10, 10, 25, 25];
    const rates = <double>[50, 70, 90, 100, 120, 150, 170, 195, 225, 250];
    int remaining = units;
    for (var i = 0; i < capacities.length && remaining > 0; i++) {
      final consumed = remaining < capacities[i] ? remaining : capacities[i];
      usageCharge += consumed * rates[i];
      remaining -= consumed;
    }
    if (remaining > 0) usageCharge += remaining * 280.0;

    late final double serviceCharge;
    late final String slabText;
    if (units <= 5) {
      serviceCharge = 300.0;
      slabText = '00 – 05 units';
    } else if (units <= 10) {
      serviceCharge = 300.0;
      slabText = '06 – 10 units';
    } else if (units <= 15) {
      serviceCharge = 300.0;
      slabText = '11 – 15 units';
    } else if (units <= 20) {
      serviceCharge = 400.0;
      slabText = '16 – 20 units';
    } else if (units <= 25) {
      serviceCharge = 500.0;
      slabText = '21 – 25 units';
    } else if (units <= 30) {
      serviceCharge = 600.0;
      slabText = '26 – 30 units';
    } else if (units <= 40) {
      serviceCharge = 1500.0;
      slabText = '31 – 40 units';
    } else if (units <= 50) {
      serviceCharge = 3000.0;
      slabText = '41 – 50 units';
    } else if (units <= 75) {
      serviceCharge = 3500.0;
      slabText = '51 – 75 units';
    } else if (units <= 100) {
      serviceCharge = 4000.0;
      slabText = '76 – 100 units';
    } else {
      serviceCharge = 4500.0;
      slabText = 'Over 100 units';
    }

    final double subtotal = usageCharge + serviceCharge;
    final double vatAmount = (subtotal * 0.18 * 100).round() / 100.0;
    final double totalBill = ((subtotal + vatAmount) * 100).round() / 100.0;

    return WaterBillBreakdown(
      units: units,
      usageCharge: usageCharge,
      serviceCharge: serviceCharge,
      subtotal: subtotal,
      vatAmount: vatAmount,
      totalBill: totalBill,
      slabText: slabText,
    );
  }
}

// =============================================================
// MAIN NAVIGATION WITH ANIMATED SCREEN TRANSITIONS & BOTTOM NAV
// =============================================================
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;
  DateTime? _lastBackPressTime;

  // Shared App State
  bool _isBillPaid = false;
  final String _selectedSector = 'Sector 14 – Block A';
  String _userName = 'Ravi Amarasinghe';
  String _userEmail = 'ravi.a@example.com';
  String _userPhone = '+94 77 123 4567';

  // Live Firebase Water Meter State
  double _meterReading = 1500.0;
  double _previousMonthReading = 1460.0;
  double _calculatedWaterUsage = 40.0;
  bool _isValveOpen = true; // Boolean only: true (OPEN), false (CLOSED)
  bool _isSuspendedByAdmin = false; // Priority: Admin override lock
  String _pressureStatus = 'Normal';
  double _pressureBar = 0.0;
  double _flowRate = 14.2;
  double _totalLiters = 0.0;
  String _monthName = 'September';
  bool _isFirebaseConnected = false;
  bool _isUsageLoading = false;
  bool _isCalculatingBill = false;

  // Indoor Leakage Detector & Monthly Usage Limit State
  bool _indoorLeakageEnabled = true;
  double _leakageLimitLiters = 250.0;
  double _monthlyUsageLimit = 1000.0;
  TimeOfDay _leakageFromTime = const TimeOfDay(hour: 22, minute: 0); // 10:00 PM
  TimeOfDay _leakageToTime = const TimeOfDay(hour: 5, minute: 0);   // 05:00 AM

  // Local Auth — single instance for the lifetime of this State
  final LocalAuthentication _localAuth = LocalAuthentication();

  // Live Firebase Bill Breakdown Data (Directly from Firebase)
  double? _firebaseUsageCharge;
  double? _firebaseServiceCharge;
  double? _firebaseSubtotal;
  double? _firebaseVatAmount;
  double? _firebaseTotalBill;
  String? _firebaseSlabText;

  WaterBillBreakdown get _activeBillBreakdown {
    if (_firebaseUsageCharge != null &&
        _firebaseServiceCharge != null &&
        _firebaseTotalBill != null) {
      final sub = _firebaseSubtotal ?? (_firebaseUsageCharge! + _firebaseServiceCharge!);
      final vat = _firebaseVatAmount ?? (_firebaseTotalBill! - sub);
      return WaterBillBreakdown(
        units: _calculatedWaterUsage.round(),
        usageCharge: _firebaseUsageCharge!,
        serviceCharge: _firebaseServiceCharge!,
        subtotal: sub,
        vatAmount: vat,
        totalBill: _firebaseTotalBill!,
        slabText: _firebaseSlabText ?? '31 – 40 units',
      );
    }
    return WaterBillBreakdown.calculate(_calculatedWaterUsage);
  }

  double get _billAmount => _activeBillBreakdown.totalBill;

  Future<void> _toggleValveStatus() async {
    // Priority Check: If WaterBoard Admin has suspended the valve, user cannot turn it back on!
    if (_isSuspendedByAdmin) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(CupertinoIcons.lock_fill, color: Colors.white, size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Water Supply Suspended by Water Board Admin. Only Administrator can reactivate this line.',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 4),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      return;
    }

    final nextState = !_isValveOpen;

    // Security Gate: Authenticate via phone lock (Pattern, PIN, Password, Fingerprint, Face ID)
    final authenticated = await _authenticateWithDeviceLock(nextState: nextState);
    if (!authenticated) {
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Row(
              children: [
                Icon(CupertinoIcons.lock_shield_fill, color: Colors.white, size: 19),
                SizedBox(width: 10),
                Expanded(
                  child: Text('Device authentication required to switch valve.', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            backgroundColor: const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
      return;
    }

    setState(() => _isValveOpen = nextState);
    try {
      final updateData = {
        'valveStatus': nextState, // STRICTLY BOOLEAN ONLY
        'closedByUser': !nextState,
        'suspendedByAdmin': false,
        'valveUpdatedBy': 'user',
      };

      // 1. Synchronize with Firebase Realtime Database SDK
      try {
        await FirebaseDatabase.instance.ref('users/user_0001/watermeter').update(updateData);
        await FirebaseDatabase.instance.ref('users/WB-0041/watermeter').update(updateData);
      } catch (sdkErr) {
        debugPrint('Firebase SDK update notice: $sdkErr');
      }

      // 2. Direct REST API sync guarantee (ensures update reaches Firebase immediately)
      const dbUrl = 'https://waterapp2026-default-rtdb.firebaseio.com';
      const fsUrl = 'https://firestore.googleapis.com/v1/projects/waterapp2026/databases/(default)/documents';
      for (final id in ['user_0001', 'WB-0041']) {
        try {
          http.patch(
            Uri.parse('$dbUrl/users/$id/watermeter.json'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(updateData),
          );
        } catch (restErr) {
          debugPrint('REST patch notice for $id: $restErr');
        }

        try {
          http.patch(
            Uri.parse('$fsUrl/users/$id?updateMask.fieldPaths=watermeter.valveStatus&updateMask.fieldPaths=watermeter.closedByUser&updateMask.fieldPaths=watermeter.suspendedByAdmin'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'fields': {
                'watermeter': {
                  'mapValue': {
                    'fields': {
                      'valveStatus': {'booleanValue': nextState},
                      'closedByUser': {'booleanValue': !nextState},
                      'suspendedByAdmin': {'booleanValue': false},
                    },
                  },
                },
              },
            }),
          );
        } catch (_) {}
      }

      AppPreferences.setValveStatus(nextState);
      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                Icon(
                  nextState ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.slash_circle_fill,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    nextState ? 'Valve OPENED · Water Flow Active' : 'Valve CLOSED · Water Supply Shut Off by User',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            backgroundColor: nextState ? const Color(0xFF10B981) : const Color(0xFFDC2626),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error toggling valve: $e');
    }
  }

  Future<void> _onCalculateBill() async {
    if (_isCalculatingBill) return;
    setState(() => _isCalculatingBill = true);

    try {
      // 1. Signal Firebase RTDB to trigger ESP32-S3 camera capture
      FirebaseDatabase.instance.ref('users/user_0001/watermeter').update({
        'triggerCapture': true,
      });
      FirebaseDatabase.instance.ref('users/WB-0041/watermeter').update({
        'triggerCapture': true,
      });

      // 2. Call OCR Backend server to capture frame from ESP32, replace latest.jpg, and calculate bill
      try {
        final uri = Uri.parse('http://127.0.0.1:5000/calculate_bill');
        final res = await http.get(uri).timeout(const Duration(seconds: 14));
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          if (data['success'] == true) {
            final reading = data['reading'];
            if (mounted) {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: const Color(0xFF0F172A),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  content: Row(
                    children: [
                      const Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF10B981), size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Meter image captured & saved! Reading: $reading units. Bill updated.',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                  duration: const Duration(seconds: 4),
                ),
              );
            }
            return;
          }
        }
      } catch (httpErr) {
        debugPrint('OCR backend HTTP call notice: $httpErr. Telemetry will sync via Firebase.');
      }

      if (mounted) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: const Color(0xFF0F172A),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            content: const Row(
              children: [
                Icon(CupertinoIcons.camera_fill, color: Color(0xFF38BDF8), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Capture signal sent to ESP32-S3! Image is saving to OCR backend & Firebase is updating.',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 13),
                  ),
                ),
              ],
            ),
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      debugPrint('Calculate bill error: $e');
    } finally {
      if (mounted) {
        setState(() => _isCalculatingBill = false);
      }
    }
  }

  Future<bool> _authenticateWithDeviceLock({required bool nextState}) async {
    try {
      final bool canCheckBiometrics = await _localAuth.canCheckBiometrics;
      final bool isDeviceSupported = await _localAuth.isDeviceSupported();

      if (!canCheckBiometrics && !isDeviceSupported) {
        // Device has no lock screen configured — allow safely
        return true;
      }

      final actionLabel = nextState ? 'Open Water Supply Valve' : 'Shut Off Water Supply Valve';
      final bool didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Confirm phone screen lock (Pattern, PIN, Password or Biometrics) to $actionLabel.',
        biometricOnly: false,
        persistAcrossBackgrounding: true,
      );

      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Device authentication platform error: $e');
      // If the device does not have lock screen configured or not available, allow safely
      if (e.code == 'NotAvailable' || e.code == 'PasscodeNotSet' || e.code == 'NotEnrolled') {
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Device authentication error: $e');
      return true; // allow fallback on device error
    }
  }

  void _triggerLeakageAlertFlow(double percentage) {
    final limit = _leakageLimitLiters;
    final current = limit * percentage;

    if (percentage < 1.0) {
      String title = '';
      String message = '';
      Color fg = const Color(0xFFD97706);
      Color bg = const Color(0xFFFEF3C7);
      IconData icon = CupertinoIcons.exclamationmark_triangle_fill;

      if (percentage == 0.75) {
        title = 'Unusual Water Usage (75%)';
        message = 'Nighttime usage reached ${current.toInt()} L of ${limit.toInt()} L limit (${_formatTime12Hour(_leakageFromTime)} – ${_formatTime12Hour(_leakageToTime)}).';
        fg = const Color(0xFFD97706);
        bg = const Color(0xFFFEF3C7);
        icon = CupertinoIcons.exclamationmark_triangle_fill;
      } else if (percentage == 0.90) {
        title = 'High Flow Warning (90%)';
        message = 'Potential leak detected: ${current.toInt()} L consumed. Nearing auto-shutoff threshold.';
        fg = const Color(0xFFEA580C);
        bg = const Color(0xFFFFEDD5);
        icon = CupertinoIcons.exclamationmark_circle_fill;
      } else if (percentage == 0.95) {
        title = 'Critical Leakage Risk (95%)';
        message = 'Immediate attention: ${current.toInt()} L / ${limit.toInt()} L. Shutoff imminent.';
        fg = const Color(0xFFDC2626);
        bg = const Color(0xFFFEE2E2);
        icon = CupertinoIcons.bell_fill;
      }

      _showHeadsUpNotification(
        title: title,
        message: message,
        fgColor: fg,
        bgColor: bg,
        icon: icon,
      );
    } else {
      // 100% Emergency Leakage Alert with countdown and automatic valve shutoff
      _showLockscreenEmergencyCountdown(limitLiters: limit);
    }
  }

  void _triggerMonthlyAlert(double percentage) {
    final limit = _monthlyUsageLimit;
    final current = limit * percentage;
    String title = '';
    String message = '';
    Color fg = const Color(0xFF1877F2);
    Color bg = const Color(0xFFEBF3FF);

    if (percentage == 0.80) {
      title = 'Monthly Budget Advisory (80%)';
      message = 'You have consumed 80% (${current.toInt()} L) of your ${limit.toInt()} L monthly quota.';
      fg = const Color(0xFF1877F2);
      bg = const Color(0xFFEBF3FF);
    } else if (percentage == 0.90) {
      title = 'Monthly Usage Warning (90%)';
      message = '90% of your allocated monthly budget (${current.toInt()} L) has been reached.';
      fg = const Color(0xFFD97706);
      bg = const Color(0xFFFEF3C7);
    } else {
      title = 'Monthly Budget Ceiling (100%)';
      message = '100% monthly limit (${limit.toInt()} L) reached. Surcharge tariffs may apply.';
      fg = const Color(0xFFDC2626);
      bg = const Color(0xFFFEE2E2);
    }

    _showHeadsUpNotification(
      title: title,
      message: message,
      fgColor: fg,
      bgColor: bg,
      icon: CupertinoIcons.drop_fill,
    );
  }

  void _showHeadsUpNotification({
    required String title,
    required String message,
    required Color fgColor,
    required Color bgColor,
    required IconData icon,
  }) {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: fgColor.withValues(alpha: 0.2), shape: BoxShape.circle),
              child: Icon(icon, color: fgColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(color: fgColor, fontWeight: FontWeight.w800, fontSize: 13.5)),
                  const SizedBox(height: 3),
                  Text(message, style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.card(context),
        duration: const Duration(seconds: 5),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: fgColor.withValues(alpha: 0.5), width: 1.2),
        ),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: fgColor,
          onPressed: () {},
        ),
      ),
    );
  }

  bool _isEmergencySheetOpen = false;

  void _showLockscreenEmergencyCountdown({required double limitLiters, double currentLiters = 1500.0}) {
    if (_isEmergencySheetOpen) return;
    _isEmergencySheetOpen = true;
    HapticFeedback.heavyImpact();

    // Get current monitored flow from Sunday daily record
    double flowVal = currentLiters;
    if (_dailyChartData.isNotEmpty) {
      final sundayItem = _dailyChartData.firstWhere(
        (item) => item['day'] == 'Sun' || item['fullName'] == 'Sunday',
        orElse: () => _dailyChartData.last,
      );
      flowVal = (sundayItem['liters'] as num?)?.toDouble() ?? currentLiters;
    }

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'LeakageAlert',
      barrierColor: Colors.black.withValues(alpha: 0.35),
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (ctx, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        final curvedAnim = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(curvedAnim),
          child: FadeTransition(
            opacity: curvedAnim,
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.94, end: 1.0).animate(curvedAnim),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  child: Material(
                    color: Colors.transparent,
                    child: _AppleEmergencyLeakageBottomSheet(
                      limitLiters: limitLiters,
                      currentLiters: flowVal,
                      fromTimeStr: _formatTime12Hour(_leakageFromTime),
                      toTimeStr: _formatTime12Hour(_leakageToTime),
                      onAutoCloseValve: () {
                        setState(() => _isValveOpen = false);
                        try {
                          FirebaseDatabase.instance.ref('users/user_0001/watermeter').update({
                            'valveStatus': false, // STRICTLY BOOLEAN
                          });
                          AppPreferences.setValveStatus(false);
                        } catch (e) {
                          debugPrint('Error closing valve on timeout: $e');
                        }
                      },
                      onReopenValve: () {
                        setState(() => _isValveOpen = true);
                        try {
                          FirebaseDatabase.instance.ref('users/user_0001/watermeter').update({
                            'valveStatus': true, // STRICTLY BOOLEAN
                          });
                          AppPreferences.setValveStatus(true);
                        } catch (e) {
                          debugPrint('Error reopening valve: $e');
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    ).then((_) {
      _isEmergencySheetOpen = false;
    });
  }

  late final DatabaseReference _userRootRef;
  late final DatabaseReference _waterMeterRef;
  late final DatabaseReference _monthlyUsageRef;
  late final DatabaseReference _dailyUsageRef;
  late final DatabaseReference _complaintsRef;
  late final DatabaseReference _connectedRef;
  StreamSubscription<DatabaseEvent>? _userRootSubscription;
  StreamSubscription<DatabaseEvent>? _waterMeterSubscription;
  StreamSubscription<DatabaseEvent>? _dailyUsageSubscription;
  StreamSubscription<DatabaseEvent>? _monthlyUsageSubscription;
  StreamSubscription<DatabaseEvent>? _complaintsSubscription;
  StreamSubscription<DatabaseEvent>? _connectedSubscription;

  // Complaints Data
  late List<Map<String, dynamic>> _complaints;

  // Payment History Data
  late List<Map<String, dynamic>> _paymentHistory;

  // Monthly Chart Data (Synced from Firebase Realtime Database)
  List<Map<String, dynamic>> _monthlyChartData = [
    {'label': 'Jan', 'val': 28.0, 'cost': 'LKR 1,644.92', 'fullName': 'January'},
    {'label': 'Feb', 'val': 30.0, 'cost': 'LKR 1,758.20', 'fullName': 'February'},
    {'label': 'Mar', 'val': 26.0, 'cost': 'LKR 1,531.64', 'fullName': 'March'},
    {'label': 'Apr', 'val': 32.0, 'cost': 'LKR 2,100.40', 'fullName': 'April'},
    {'label': 'May', 'val': 35.0, 'cost': 'LKR 2,472.10', 'fullName': 'May'},
    {'label': 'Jun', 'val': 38.0, 'cost': 'LKR 2,843.80', 'fullName': 'June'},
    {'label': 'Jul', 'val': 34.0, 'cost': 'LKR 2,348.20', 'fullName': 'July'},
    {'label': 'Aug', 'val': 36.0, 'cost': 'LKR 2,596.00', 'fullName': 'August'},
    {'label': 'Sep', 'val': 37.0, 'cost': 'LKR 2,719.90', 'fullName': 'September'},
  ];

  // Daily Chart Data (Synced from Firebase Realtime Database - Monday to Sunday in Liters)
  List<Map<String, dynamic>> _dailyChartData = [
    {'day': 'Mon', 'fullName': 'Monday', 'usage': 1.2, 'liters': 1200, 'cost': 'LKR 62.40', 'status': 'Optimal'},
    {'day': 'Tue', 'fullName': 'Tuesday', 'usage': 1.5, 'liters': 1500, 'cost': 'LKR 78.00', 'status': 'Normal'},
    {'day': 'Wed', 'fullName': 'Wednesday', 'usage': 1.8, 'liters': 1800, 'cost': 'LKR 93.60', 'status': 'High Normal'},
    {'day': 'Thu', 'fullName': 'Thursday', 'usage': 1.4, 'liters': 1400, 'cost': 'LKR 72.80', 'status': 'Optimal'},
    {'day': 'Fri', 'fullName': 'Friday', 'usage': 1.9, 'liters': 1900, 'cost': 'LKR 98.80', 'status': 'Peak Day'},
    {'day': 'Sat', 'fullName': 'Saturday', 'usage': 2.3, 'liters': 2300, 'cost': 'LKR 119.60', 'status': 'Weekend Peak'},
    {'day': 'Sun', 'fullName': 'Sunday', 'usage': 1.5, 'liters': 1500, 'cost': 'LKR 78.00', 'status': 'Optimal'},
  ];

  // Unread Notifications Count
  int _unreadNotifications = 3;

  Timer? _restSyncTimer;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _fetchFromFirebaseRest();
    // Realtime background sync polling every 2s
    _restSyncTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _fetchFromFirebaseRest();
    });
    _setupFirebaseRealtimeListeners();
  }

  Future<void> _fetchFromFirebaseRest() async {
    final client = HttpClient();
    client.connectionTimeout = const Duration(seconds: 4);
    try {
      final request = await client.getUrl(Uri.parse('https://waterapp2026-default-rtdb.firebaseio.com/users/user_0001.json'));
      final response = await request.close();
      if (response.statusCode == 200) {
        final responseBody = await response.transform(utf8.decoder).join();
        final data = jsonDecode(responseBody);
        if (data is Map && mounted) {
          setState(() => _isFirebaseConnected = true);
          _handleDataSnapshot(data);
          if (data.containsKey('monthly_usage') && data['monthly_usage'] is Map) {
            _updatePaymentHistoryFromFirebase(data['monthly_usage'] as Map);
          }
          if (data.containsKey('daily_usage') && data['daily_usage'] is Map) {
            _updateDailyChartDataFromFirebase(data['daily_usage'] as Map);
          }
          if (data.containsKey('complaints') && data['complaints'] is Map) {
            final complaintsMap = data['complaints'] as Map;
            final List<Map<String, dynamic>> list = [];
            for (final val in complaintsMap.values) {
              if (val is Map) {
                list.add(Map<String, dynamic>.from(val));
              }
            }
            if (list.isNotEmpty && mounted) {
              setState(() {
                _complaints = list;
                AppPreferences.setComplaints(list);
              });
            }
          }
        }
      }
    } catch (e) {
      debugPrint('REST auto-fetch notice: $e');
    } finally {
      client.close();
    }
  }

  String _formatTime12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:$minute $period';
  }

  void _setupFirebaseRealtimeListeners() {
    try {
      _connectedRef = FirebaseDatabase.instance.ref('.info/connected');
      _connectedSubscription = _connectedRef.onValue.listen((event) {
        final connected = event.snapshot.value == true;
        if (mounted) {
          setState(() => _isFirebaseConnected = connected);
        }
      });

      // 0. Direct User Root Listener (Profile & Watermeter Realtime Updates)
      _userRootRef = FirebaseDatabase.instance.ref('users/user_0001');
      try {
        _userRootRef.keepSynced(true);
      } catch (_) {}
      _userRootSubscription = _userRootRef.onValue.listen(
        (DatabaseEvent event) {
          if (mounted) setState(() => _isFirebaseConnected = true);
          if (event.snapshot.value != null) {
            _handleDataSnapshot(event.snapshot.value);
          }
        },
        onError: (err) => debugPrint('Firebase user root listener error: $err'),
      );

      // 1. Direct Watermeter Listener
      _waterMeterRef = FirebaseDatabase.instance.ref('users/user_0001/watermeter');
      try {
        _waterMeterRef.keepSynced(true);
      } catch (_) {}
      _waterMeterSubscription = _waterMeterRef.onValue.listen(
        (DatabaseEvent event) {
          if (mounted) setState(() => _isFirebaseConnected = true);
          _handleDataSnapshot(event.snapshot.value);
        },
        onError: (err) => debugPrint('Firebase watermeter listener error: $err'),
      );

      // 2. Direct Monthly Usage Listener for Payment History
      _monthlyUsageRef = FirebaseDatabase.instance.ref('users/user_0001/monthly_usage');
      try {
        _monthlyUsageRef.keepSynced(true);
      } catch (_) {}
      _monthlyUsageSubscription = _monthlyUsageRef.onValue.listen(
        (DatabaseEvent event) {
          if (mounted) setState(() => _isFirebaseConnected = true);
          if (event.snapshot.value is Map) {
            _updatePaymentHistoryFromFirebase(event.snapshot.value as Map);
          }
        },
        onError: (err) => debugPrint('Firebase monthly_usage listener error: $err'),
      );

      // 3. Direct Daily Usage Listener (Monday to Sunday in Litres)
      _dailyUsageRef = FirebaseDatabase.instance.ref('users/user_0001/daily_usage');
      try {
        _dailyUsageRef.keepSynced(true);
      } catch (_) {}
      _dailyUsageSubscription = _dailyUsageRef.onValue.listen(
        (DatabaseEvent event) {
          if (mounted) setState(() => _isFirebaseConnected = true);
          if (event.snapshot.value is Map) {
            _updateDailyChartDataFromFirebase(event.snapshot.value as Map);
          }
        },
        onError: (err) => debugPrint('Firebase daily_usage listener error: $err'),
      );

      // 4. Direct Complaints Listener
      _complaintsRef = FirebaseDatabase.instance.ref('users/user_0001/complaints');
      _complaintsSubscription = _complaintsRef.onValue.listen(
        (DatabaseEvent event) {
          if (event.snapshot.value is Map && mounted) {
            final complaintsMap = event.snapshot.value as Map;
            final List<Map<String, dynamic>> list = [];
            for (final val in complaintsMap.values) {
              if (val is Map) {
                list.add(Map<String, dynamic>.from(val));
              }
            }
            if (list.isNotEmpty) {
              setState(() {
                _complaints = list;
                AppPreferences.setComplaints(list);
              });
            }
          }
        },
        onError: (err) => debugPrint('Firebase complaints listener error: $err'),
      );
    } catch (e) {
      debugPrint('Firebase Realtime Database setup error: $e');
    }
  }

  void _updatePaymentHistoryFromFirebase(Map monthlyUsageMap) {
    try {
      final List<Map<String, dynamic>> items = [];
      final sortedKeys = monthlyUsageMap.keys.map((k) => k.toString()).toList()..sort();
      
      // Reverse so latest month comes first
      for (final key in sortedKeys.reversed) {
        final val = monthlyUsageMap[key];
        if (val is Map) {
          final monthName = val['month']?.toString() ?? 'Month';
          final usage = (val['usage'] as num?)?.toDouble() ?? 0.0;
          final usageCharge = (val['usageCharge'] as num?)?.toDouble() ?? 0.0;
          final serviceCharge = (val['serviceCharge'] as num?)?.toDouble() ?? 0.0;
          final vatAmount = (val['vatAmount'] as num?)?.toDouble() ?? 0.0;
          final totalBill = (val['totalBill'] as num?)?.toDouble() ?? 0.0;
          final status = val['status']?.toString() ?? 'Paid';

          final breakdownStr = usageCharge > 0
              ? 'Usage: LKR ${usageCharge.toStringAsFixed(2)} · Service: LKR ${serviceCharge.toStringAsFixed(2)} · VAT (18%): LKR ${vatAmount.toStringAsFixed(2)}'
              : '${usage.toInt()} units · 18% VAT included';

          final dateStr = '22 ${monthName.length >= 3 ? monthName.substring(0, 3) : monthName} 2026';

          items.add({
            'month': '$monthName 2026',
            'date': dateStr,
            'method': 'Online Banking / Visa',
            'amount': 'LKR ${totalBill.toStringAsFixed(2)}',
            'txnId': 'TXN-${key.replaceAll('_', '').toUpperCase()}-2026',
            'status': status,
            'breakdown': breakdownStr,
          });
        }
      }

      // Populate monthly chart data in chronological order (only valid records with usage > 0)
      final List<Map<String, dynamic>> chartList = [];
      for (final key in sortedKeys) {
        final val = monthlyUsageMap[key];
        if (val is Map && val.containsKey('usage')) {
          final usage = (val['usage'] as num?)?.toDouble() ?? 0.0;
          if (usage <= 0) continue;
          final monthName = val['month']?.toString() ?? key;
          final shortLabel = monthName.length >= 3 ? monthName.substring(0, 3) : monthName;
          final totalBill = (val['totalBill'] as num?)?.toDouble() ?? 0.0;
          chartList.add({
            'label': shortLabel,
            'val': usage,
            'cost': 'LKR ${totalBill.toStringAsFixed(2)}',
            'fullName': monthName,
          });
        }
      }

      if (items.isNotEmpty && mounted) {
        setState(() {
          _paymentHistory = items;
          if (chartList.isNotEmpty) {
            _monthlyChartData = chartList;
          }
        });
        AppPreferences.setPaymentHistory(items);
      }
    } catch (e) {
      debugPrint('Error updating payment history from Firebase: $e');
    }
  }

  void _updateDailyChartDataFromFirebase(Map dailyUsageMap) {
    try {
      final List<Map<String, dynamic>> list = [];
      final sortedKeys = dailyUsageMap.keys.map((k) => k.toString()).toList()..sort();
      for (final key in sortedKeys) {
        final val = dailyUsageMap[key];
        if (val is Map) {
          final day = val['day']?.toString() ?? 'Day';
          final dayShort = val['dayShort']?.toString() ?? (day.length >= 3 ? day.substring(0, 3) : day);
          final liters = (val['liters'] as num?)?.toInt() ??
              (val['usage_liters'] as num?)?.toInt() ??
              (((val['usage_m3'] as num?)?.toDouble() ?? (val['usage'] as num?)?.toDouble() ?? 1.2) * 1000).round();
          final usage = (val['usage_m3'] as num?)?.toDouble() ??
              (val['usage'] as num?)?.toDouble() ??
              (liters / 1000.0);
          final cost = val['cost']?.toString() ??
              'LKR ${(val['cost_lkr'] as num?)?.toStringAsFixed(2) ?? (usage * 52.0).toStringAsFixed(2)}';
          final status = val['status']?.toString() ?? 'Optimal';
          list.add({
            'day': dayShort,
            'fullName': day,
            'usage': usage,
            'liters': liters,
            'cost': cost,
            'status': status,
          });
        }
      }
      if (list.isNotEmpty && mounted) {
        final sundayData = dailyUsageMap['07_sunday'];
        final sundayLiters = sundayData is Map
            ? (sundayData['liters'] as num?)?.toDouble()
            : null;
        setState(() {
          _dailyChartData = list;
          if (sundayLiters != null) _totalLiters = sundayLiters;
        });
      }
    } catch (e) {
      debugPrint('Error updating daily chart data from Firebase: $e');
    }
  }

  void _loadPreferences() {
    _userName = AppPreferences.getUserName();
    _userEmail = AppPreferences.getUserEmail();
    _userPhone = AppPreferences.getUserPhone();
    _isBillPaid = AppPreferences.getIsBillPaid();
    _isValveOpen = AppPreferences.getValveStatus();
    _isSuspendedByAdmin = AppPreferences.getSuspendedByAdmin();
    _indoorLeakageEnabled = AppPreferences.getIndoorLeakageEnabled();
    _leakageLimitLiters = AppPreferences.getLeakageLimitLiters();
    _monthlyUsageLimit = AppPreferences.getMonthlyUsageLimit();
    _leakageFromTime = AppPreferences.getLeakageFromTime();
    _leakageToTime = AppPreferences.getLeakageToTime();
    _meterReading = AppPreferences.getMeterReading();
    _previousMonthReading = AppPreferences.getPrevMonthReading();
    _calculatedWaterUsage = AppPreferences.getWaterUsage();
    _firebaseUsageCharge = AppPreferences.getUsageCharge();
    _firebaseServiceCharge = AppPreferences.getServiceCharge();
    _firebaseSubtotal = AppPreferences.getSubtotal();
    _firebaseVatAmount = AppPreferences.getVatAmount();
    _firebaseTotalBill = AppPreferences.getTotalBill();
    _firebaseSlabText = AppPreferences.getSlabText();

    _complaints = AppPreferences.getComplaints() ?? [
      {
        'id': 'CMP-8821',
        'type': 'Pressure',
        'title': 'Low Water Pressure in Kitchen',
        'status': 'In Progress',
        'date': '18 Aug 2026',
        'time': '10:45 AM',
        'description': 'Water pressure dropped significantly since Tuesday morning. 2nd floor taps barely running.',
        'updateText': 'Technician assigned. Site visit scheduled for today between 2 PM - 4 PM.',
        'technician': 'K. Perera (ID: TECH-402)',
        'timeline': [
          {'title': 'Complaint Registered', 'time': '18 Aug, 10:45 AM', 'done': true},
          {'title': 'Review & Triage', 'time': '18 Aug, 11:30 AM', 'done': true},
          {'title': 'Technician Assigned', 'time': '18 Aug, 01:15 PM', 'done': true},
          {'title': 'Resolution in Progress', 'time': 'Pending', 'done': false},
        ],
      },
      {
        'id': 'CMP-8794',
        'type': 'Billing',
        'title': 'Meter Reading Discrepancy',
        'status': 'Resolved',
        'date': '28 Jul 2026',
        'time': '11:00 AM',
        'description': 'July reading was estimated higher than physical meter value.',
        'updateText': 'Bill corrected. LKR 240 credit applied to your account.',
        'technician': 'Billing Desk',
        'timeline': [
          {'title': 'Complaint Registered', 'time': '28 Jul, 11:00 AM', 'done': true},
          {'title': 'Meter Reading Audit', 'time': '29 Jul, 04:00 PM', 'done': true},
          {'title': 'Adjustment Approved', 'time': '31 Jul, 09:30 AM', 'done': true},
          {'title': 'Resolved with Credit Note', 'time': '01 Aug, 10:00 AM', 'done': true},
        ],
      },
    ];

    _paymentHistory = AppPreferences.getPaymentHistory() ?? [
      {
        'month': 'Sep 2026',
        'date': '22 Sep 2026',
        'method': 'Online Banking',
        'amount': 'LKR 3,091.60',
        'txnId': 'TXN-09SEPTEMBER-2026',
        'status': 'Paid',
        'breakdown': 'Usage: LKR 2,220.00 · Service: LKR 400.00 · VAT (18%): LKR 471.60',
      },
      {
        'month': 'Aug 2026',
        'date': '22 Aug 2026',
        'method': 'Visa Card (•• 4242)',
        'amount': 'LKR 2,100.40',
        'txnId': 'TXN-08AUGUST-2026',
        'status': 'Paid',
        'breakdown': 'Usage: LKR 1,570.00 · Service: LKR 200.00 · VAT (18%): LKR 330.40',
      },
      {
        'month': 'Jul 2026',
        'date': '22 Jul 2026',
        'method': 'MasterCard (•• 8819)',
        'amount': 'LKR 2,348.20',
        'txnId': 'TXN-07JULY-2026',
        'status': 'Paid',
        'breakdown': 'Usage: LKR 1,780.00 · Service: LKR 200.00 · VAT (18%): LKR 368.20',
      },
      {
        'month': 'Jun 2026',
        'date': '22 Jun 2026',
        'method': 'Online Banking',
        'amount': 'LKR 2,843.80',
        'txnId': 'TXN-06JUNE-2026',
        'status': 'Paid',
        'breakdown': 'Usage: LKR 2,010.00 · Service: LKR 400.00 · VAT (18%): LKR 433.80',
      },
    ];
  }

  bool? _parseValveBoolean(dynamic raw) {
    if (raw == null) return null;
    if (raw is bool) return raw;
    final str = raw.toString().trim().toLowerCase();
    if (str == 'true' || str == 'open' || str == '1') return true;
    if (str == 'false' || str == 'closed' || str == 'close' || str == '0') return false;
    return null;
  }

  void _handleDataSnapshot(dynamic rawData) {
    if (rawData == null || rawData is! Map) return;

    try {
      final wm = rawData.containsKey('watermeter') && rawData['watermeter'] is Map
          ? rawData['watermeter'] as Map
          : rawData;

      // Extract current meter reading, previous reading, and usage directly from watermeter first
      final cur = _findDouble(wm, [
            'currentReading',
            'current_reading',
            'ocrReading',
            'ocr_reading',
            'meterReading',
            'meter_reading',
            'reading',
          ], shallow: true) ??
          _findDouble(rawData, [
            'currentReading',
            'current_reading',
            'ocrReading',
            'ocr_reading',
            'meterReading',
            'meter_reading',
            'reading',
          ]);

      final prev = _findDouble(wm, [
            'previousReading',
            'previous_reading',
            'previousMonthReading',
            'previous_month_reading',
            'previousMonth',
            'previous_month',
            'prevReading',
            'prev_reading',
            'lastMonth',
            'last_month',
          ], shallow: true) ??
          _findDouble(rawData, [
            'previousReading',
            'previous_reading',
            'previousMonthReading',
            'previous_month_reading',
            'previousMonth',
            'previous_month',
            'prevReading',
            'prev_reading',
            'lastMonth',
            'last_month',
          ]);

      final usage = _findDouble(wm, [
            'usage',
            'water_usage',
            'waterUsage',
            'calculated_usage',
            'currentUsage',
            'current_usage',
          ], shallow: true) ??
          _findDouble(rawData, [
            'usage',
            'water_usage',
            'waterUsage',
            'calculated_usage',
            'currentUsage',
            'current_usage',
          ]);

      // Direct Firebase Bill Breakdown fields
      final usageCharge = _findDouble(wm, ['usageCharge', 'usage_charge'], shallow: true) ??
          _findDouble(rawData, ['usageCharge', 'usage_charge']);
      final serviceCharge = _findDouble(wm, ['serviceCharge', 'service_charge'], shallow: true) ??
          _findDouble(rawData, ['serviceCharge', 'service_charge']);
      final subtotal = _findDouble(wm, ['subtotal', 'sub_total'], shallow: true) ??
          _findDouble(rawData, ['subtotal', 'sub_total']);
      final vatAmount = _findDouble(wm, ['vatAmount', 'vat_amount', 'vat'], shallow: true) ??
          _findDouble(rawData, ['vatAmount', 'vat_amount', 'vat']);
      final totalBill = _findDouble(wm, ['totalBill', 'total_bill', 'billAmount', 'bill_amount'], shallow: true) ??
          _findDouble(rawData, ['totalBill', 'total_bill', 'billAmount', 'bill_amount']);
      final slabText = _findString(wm, ['slabText', 'slab_text'], shallow: true) ??
          _findString(rawData, ['slabText', 'slab_text']);

      final profile = rawData['profile'] is Map ? rawData['profile'] as Map : null;
      final profileStatus = profile?['status']?.toString() ?? rawData['status']?.toString();

      final valveVal = _parseValveBoolean(wm['valveStatus'] ?? wm['valve_status'] ?? wm['valveOpen'] ?? rawData['valveStatus']);
      final pressure = wm['pressureStatus']?.toString() ?? wm['pressure_status']?.toString() ?? rawData['pressureStatus']?.toString();
      final pressureBar = _findDouble(wm, ['pressure', 'pressureBar', 'pressure_bar'], shallow: true) ??
          _findDouble(rawData, ['pressure', 'pressureBar', 'pressure_bar']);
      final flow = _findDouble(wm, ['flowRate', 'flow_rate', 'flowSensor', 'flow_sensor', 'flow'], shallow: true) ??
          _findDouble(rawData, ['flowRate', 'flow_rate', 'flow']);
      final month = wm['month']?.toString() ?? wm['latestMonth']?.toString() ?? rawData['month']?.toString();
      final wmAdminSuspended = wm['suspendedByAdmin'] as bool? ?? rawData['suspendedByAdmin'] as bool?;
      final closedByUser = wm['closedByUser'] as bool? ?? rawData['closedByUser'] as bool? ?? false;

      bool isSusp = false;
      if (valveVal == true || (profileStatus != null && profileStatus.toLowerCase() == 'active' && wmAdminSuspended != true)) {
        isSusp = false;
      } else if (wmAdminSuspended == true || (profileStatus != null && profileStatus.toLowerCase() == 'suspended')) {
        isSusp = !closedByUser;
      } else if (valveVal == false) {
        isSusp = !closedByUser;
      }

      if (rawData.containsKey('monthly_usage') && rawData['monthly_usage'] is Map) {
        _updatePaymentHistoryFromFirebase(rawData['monthly_usage'] as Map);
      }

      if (mounted) {
        setState(() {
          _isSuspendedByAdmin = isSusp;
          AppPreferences.setSuspendedByAdmin(isSusp);

          if (valveVal != null) {
            _isValveOpen = valveVal;
            AppPreferences.setValveStatus(valveVal);
          }
          if (pressure != null) _pressureStatus = pressure;
          if (pressureBar != null) _pressureBar = pressureBar;
          if (flow != null) _flowRate = flow;
          if (month != null) _monthName = month;

          if (cur != null) {
            _meterReading = cur;
            AppPreferences.setMeterReading(cur);
          }
          if (prev != null) {
            _previousMonthReading = prev;
            AppPreferences.setPrevMonthReading(prev);
          }
          if (usage != null) {
            _calculatedWaterUsage = usage;
            AppPreferences.setWaterUsage(usage);
          } else if (cur != null && prev != null) {
            _calculatedWaterUsage = cur - prev;
            AppPreferences.setWaterUsage(_calculatedWaterUsage);
          }

          // Direct Firebase Breakdown Data
          if (usageCharge != null) {
            _firebaseUsageCharge = usageCharge;
            AppPreferences.setUsageCharge(usageCharge);
          }
          if (serviceCharge != null) {
            _firebaseServiceCharge = serviceCharge;
            AppPreferences.setServiceCharge(serviceCharge);
          }
          if (subtotal != null) {
            _firebaseSubtotal = subtotal;
            AppPreferences.setSubtotal(subtotal);
          }
          if (vatAmount != null) {
            _firebaseVatAmount = vatAmount;
            AppPreferences.setVatAmount(vatAmount);
          }
          if (totalBill != null) {
            _firebaseTotalBill = totalBill;
            AppPreferences.setTotalBill(totalBill);
          }
          if (slabText != null && slabText.isNotEmpty) {
            _firebaseSlabText = slabText;
            AppPreferences.setSlabText(slabText);
          }
          _isUsageLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Error parsing Firebase data: $e');
    }
  }

  String? _findString(Map data, List<String> keys, {bool shallow = false}) {
    for (final k in keys) {
      if (data.containsKey(k)) {
        final v = data[k];
        if (v != null) return v.toString();
      }
    }
    if (shallow) return null;
    for (final v in data.values) {
      if (v is Map) {
        final res = _findString(v, keys);
        if (res != null) return res;
      }
    }
    return null;
  }

  double? _findDouble(Map data, List<String> keys, {bool shallow = false}) {
    for (final k in keys) {
      if (data.containsKey(k)) {
        final v = data[k];
        if (v is num) return v.toDouble();
        if (v is String) {
          final cleaned = v.replaceAll(RegExp(r'[^0-9.]'), '');
          return double.tryParse(cleaned);
        }
      }
    }
    if (shallow) return null;
    for (final v in data.values) {
      if (v is Map) {
        final res = _findDouble(v, keys);
        if (res != null) return res;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _restSyncTimer?.cancel();
    _connectedSubscription?.cancel();
    _userRootSubscription?.cancel();
    _waterMeterSubscription?.cancel();
    _monthlyUsageSubscription?.cancel();
    _dailyUsageSubscription?.cancel();
    _complaintsSubscription?.cancel();
    super.dispose();
  }

  String _getActiveMonthKey() {
    final months = [
      'january', 'february', 'march', 'april', 'may', 'june',
      'july', 'august', 'september', 'october', 'november', 'december'
    ];
    final name = _monthName.trim().toLowerCase();
    final idx = months.indexOf(name);
    if (idx != -1) {
      return '${(idx + 1).toString().padLeft(2, '0')}_$name';
    }
    return '09_september';
  }

  void _onPayBillSuccess() {
    final breakdown = _activeBillBreakdown;
    final now = DateTime.now();
    final monthKey = _getActiveMonthKey();
    final timeStr = '${now.day} ${_monthName.substring(0, 3)} ${now.year}, '
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';

    setState(() {
      _isBillPaid = true;
      _paymentHistory.insert(0, {
        'month': '$_monthName ${now.year}',
        'date': timeStr,
        'method': 'Visa Card (•• 4242)',
        'amount': 'LKR ${breakdown.totalBill.toStringAsFixed(2)}',
        'txnId': 'TXN-${now.millisecondsSinceEpoch.toString().substring(5)}',
        'status': 'Paid',
        'breakdown': 'Usage: LKR ${breakdown.usageCharge.toStringAsFixed(2)} · Service: LKR ${breakdown.serviceCharge.toStringAsFixed(2)} · VAT (18%): LKR ${breakdown.vatAmount.toStringAsFixed(2)}',
      });
      AppPreferences.setIsBillPaid(true);
      AppPreferences.setPaymentHistory(_paymentHistory);
    });

    try {
      final targetIds = ['user_0001', 'WB-0041'];
      for (final id in targetIds) {
        FirebaseDatabase.instance.ref('users/$id/monthly_usage/$monthKey').update({
          'status': 'Paid',
        });
        FirebaseDatabase.instance.ref('users/$id/watermeter').update({
          'isPaid': true,
        });
      }
    } catch (_) {}
  }

  void _onUndoPayment() {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text('Undo Payment?'),
        content: const Text(
          'Do you want to cancel this bill payment transaction? Your previous balance and outstanding due will be restored.',
        ),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text('Cancel'),
            onPressed: () => Navigator.pop(ctx),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: const Text('Undo Payment'),
            onPressed: () {
              Navigator.pop(ctx);
              _performUndoPayment();
            },
          ),
        ],
      ),
    );
  }

  void _performUndoPayment() {
    final monthKey = _getActiveMonthKey();

    setState(() {
      _isBillPaid = false;
      AppPreferences.setIsBillPaid(false);
      // Remove the latest paid transaction if present
      if (_paymentHistory.isNotEmpty && _paymentHistory.first['status'] == 'Paid') {
        _paymentHistory.removeAt(0);
        AppPreferences.setPaymentHistory(_paymentHistory);
      }
    });

    try {
      final targetIds = ['user_0001', 'WB-0041'];
      for (final id in targetIds) {
        FirebaseDatabase.instance.ref('users/$id/watermeter').update({
          'isPaid': false,
        });
        FirebaseDatabase.instance.ref('users/$id/monthly_usage/$monthKey').update({
          'status': 'Unpaid',
        });
      }
    } catch (_) {}

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0A84FF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(CupertinoIcons.arrow_counterclockwise_circle_fill, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Text(
              'Payment undone · Due restored (LKR ${_activeBillBreakdown.totalBill.toStringAsFixed(2)})',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _onAddNewComplaint(Map<String, dynamic> newComplaint) {
    setState(() {
      _complaints.insert(0, newComplaint);
      AppPreferences.setComplaints(_complaints);
    });

    try {
      final key = newComplaint['id']?.toString() ?? 'CMP-${DateTime.now().millisecondsSinceEpoch}';
      FirebaseDatabase.instance.ref('users/user_0001/complaints/$key').set(newComplaint);
    } catch (e) {
      debugPrint('Error writing complaint to Firebase: $e');
    }
  }

  void _showNotificationCenter() {
    setState(() => _unreadNotifications = 0);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _NotificationCenterSheet(
        onViewBill: () {
          Navigator.pop(ctx);
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    );
  }

  Widget _buildAdminSuspendedOverlay() {
    return Positioned.fill(
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: Container(
            color: Colors.transparent, // Pure blur without dark dimming
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 340),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 26),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08), // Transparent frosted glass
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Lock Icon in Frosted Grey/Translucent Circle (No emojis)
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.10),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.25),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.lock_fill,
                          size: 26,
                          color: Color(0xFFE2E8F0), // Clean grey/silver shade
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Account Suspended',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Outstanding Due Pill (No dollar coin icon, transparent grey styling)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.07),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
                      ),
                      child: Text(
                        'Outstanding Due: LKR ${_billAmount.toStringAsFixed(2)}',
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Action Buttons in Transparent Grey Shades
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFE2E8F0),
                              backgroundColor: Colors.white.withValues(alpha: 0.04),
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.20)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onPressed: () {
                              setState(() => _currentIndex = 0);
                            },
                            child: const Text('View Bill', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.5)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white.withValues(alpha: 0.16),
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white.withValues(alpha: 0.30)),
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            onPressed: () {
                              _showPaymentSheet();
                            },
                            child: const Text('Pay Due Bill', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _wrapWithSuspensionGuard(Widget screen) {
    if (!_isSuspendedByAdmin) return screen;

    return Stack(
      children: [
        // Desaturate colors
        ColorFiltered(
          colorFilter: const ColorFilter.matrix(<double>[
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0.2126, 0.7152, 0.0722, 0, 0,
            0,      0,      0,      1, 0,
          ]),
          child: screen,
        ),
        // Frosted 60% Transparent Lock Overlay
        _buildAdminSuspendedOverlay(),
      ],
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return BillScreen(
          isPaid: _isBillPaid,
          amount: _billAmount,
          waterUsage: _calculatedWaterUsage,
          monthName: _monthName,
          breakdown: _activeBillBreakdown,
          paymentHistory: _paymentHistory,
          isValveOpen: _isValveOpen,
          isSuspendedByAdmin: _isSuspendedByAdmin,
          onToggleValve: _toggleValveStatus,
          onPayPressed: () => _showPaymentSheet(),
          onUndoPayment: _onUndoPayment,
          onNotificationTap: _showNotificationCenter,
          unreadCount: _unreadNotifications,
          onCalculateBill: _onCalculateBill,
          isCalculatingBill: _isCalculatingBill,
        );
      case 1:
        return _wrapWithSuspensionGuard(
          UsageAlertsScreen(
            meterReading: _meterReading,
            previousMonthReading: _previousMonthReading,
            calculatedWaterUsage: _calculatedWaterUsage,
            monthlyChartData: _monthlyChartData,
            dailyChartData: _dailyChartData,
            isFirebaseConnected: _isFirebaseConnected,
            isUsageLoading: _isUsageLoading,
            isValveOpen: _isValveOpen,
            onToggleValve: _toggleValveStatus,
            indoorLeakageEnabled: _indoorLeakageEnabled,
            leakageLimitLiters: _leakageLimitLiters,
            monthlyUsageLimit: _monthlyUsageLimit,
            leakageFromTime: _leakageFromTime,
            leakageToTime: _leakageToTime,
            onUpdateLeakageSettings: (enabled, limit, from, to) {
              setState(() {
                _indoorLeakageEnabled = enabled;
                _leakageLimitLiters = limit;
                _leakageFromTime = from;
                _leakageToTime = to;
              });
              AppPreferences.setIndoorLeakageEnabled(enabled);
              AppPreferences.setLeakageLimitLiters(limit);
              AppPreferences.setLeakageFromTime(from);
              AppPreferences.setLeakageToTime(to);
            },
            onUpdateMonthlyLimit: (limit) {
              setState(() => _monthlyUsageLimit = limit);
              AppPreferences.setMonthlyUsageLimit(limit);
            },
            onTriggerLeakageAlert: _triggerLeakageAlertFlow,
            onTriggerMonthlyAlert: _triggerMonthlyAlert,
            onNotificationTap: _showNotificationCenter,
            unreadCount: _unreadNotifications,
          ),
        );
      case 2:
        return _wrapWithSuspensionGuard(
          GrievancesScreen(
            complaints: _complaints,
            onFileComplaint: _showFileComplaintSheet,
            onNotificationTap: _showNotificationCenter,
            unreadCount: _unreadNotifications,
          ),
        );
      case 3:
      default:
        return _wrapWithSuspensionGuard(
          ProfileScreen(
            userName: _userName,
            userEmail: _userEmail,
            userPhone: _userPhone,
            selectedSector: _selectedSector,
            meterReading: _meterReading,
            previousMonthReading: _previousMonthReading,
            waterUsage: _calculatedWaterUsage,
            isValveOpen: _isValveOpen,
            pressureStatus: _pressureStatus,
            pressureBar: _pressureBar,
            flowRate: _flowRate,
            totalLiters: _totalLiters,
            monthName: _monthName,
            isFirebaseConnected: _isFirebaseConnected,
            onToggleValve: _toggleValveStatus,
            onProfileUpdated: (name, email, phone) {
              setState(() {
                _userName = name;
                _userEmail = email;
                _userPhone = phone;
              });
              AppPreferences.setUserName(name);
              AppPreferences.setUserEmail(email);
              AppPreferences.setUserPhone(phone);
            },
            onNotificationTap: _showNotificationCenter,
            unreadCount: _unreadNotifications,
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
        } else {
          final now = DateTime.now();
          if (_lastBackPressTime == null || now.difference(_lastBackPressTime!) > const Duration(seconds: 2)) {
            _lastBackPressTime = now;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Press back again to exit AquaFlow'),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: LiquidMeshBackground(
        child: Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,
          body: SafeArea(
            bottom: false,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: const Cubic(0.25, 0.1, 0.25, 1.0),
              switchOutCurve: const Cubic(0.25, 0.1, 0.25, 1.0),
              transitionBuilder: (Widget child, Animation<double> animation) {
                final isEntering = child.key == ValueKey<int>(_currentIndex);

                final scaleBegin = isEntering ? 0.982 : 1.0;
                final scaleEnd = isEntering ? 1.0 : 0.988;

                return ScaleTransition(
                  scale: Tween<double>(begin: scaleBegin, end: scaleEnd).animate(
                    CurvedAnimation(
                      parent: animation,
                      curve: const Cubic(0.25, 0.1, 0.25, 1.0),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: FadeTransition(
                    opacity: CurvedAnimation(
                      parent: animation,
                      curve: isEntering ? Curves.easeOutCubic : Curves.easeInCubic,
                    ),
                    child: child,
                  ),
                );
              },
              child: KeyedSubtree(
                key: ValueKey<int>(_currentIndex),
                child: _buildCurrentScreen(),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: Container(
              margin: const EdgeInsets.fromLTRB(18, 0, 18, 14),
              child: RepaintBoundary(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(34),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 7),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: isDark
                              ? [
                                  Colors.white.withValues(alpha: 0.05),
                                  Colors.white.withValues(alpha: 0.01),
                                ]
                              : [
                                  Colors.white.withValues(alpha: 0.12),
                                  Colors.white.withValues(alpha: 0.04),
                                ],
                        ),
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: isDark ? 0.18 : 0.32),
                          width: 0.8,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: isDark ? 0.14 : 0.04),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem(0, CupertinoIcons.doc_text, CupertinoIcons.doc_text_fill, 'Bill', isDark),
                          _buildNavItem(1, CupertinoIcons.drop, CupertinoIcons.drop_fill, 'Usage', isDark),
                          _buildNavItem(2, CupertinoIcons.bubble_left_bubble_right, CupertinoIcons.bubble_left_bubble_right_fill, 'Help', isDark),
                          _buildNavItem(3, CupertinoIcons.person_crop_circle, CupertinoIcons.person_crop_circle_fill, 'Profile', isDark),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label, bool isDark) {
    final isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        if (_currentIndex != index) {
          HapticFeedback.selectionClick();
          setState(() {
            _currentIndex = index;
          });
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutCubic,
        padding: EdgeInsets.symmetric(horizontal: isSelected ? 16 : 12, vertical: 6.5),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF0A84FF).withValues(alpha: 0.22) : const Color(0xFF0A84FF).withValues(alpha: 0.14))
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          border: isSelected
              ? Border.all(
                  color: isDark ? const Color(0xFF0A84FF).withValues(alpha: 0.45) : const Color(0xFF0A84FF).withValues(alpha: 0.30),
                  width: 0.9,
                )
              : Border.all(color: Colors.transparent, width: 0.9),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF0A84FF).withValues(alpha: isDark ? 0.30 : 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: AnimatedScale(
          duration: const Duration(milliseconds: 200),
          scale: isSelected ? 1.03 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? filledIcon : outlineIcon,
                size: 21,
                color: isSelected
                    ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0A84FF))
                    : (isDark ? Colors.white.withValues(alpha: 0.70) : const Color(0xFF475569)),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? Colors.white : const Color(0xFF0A84FF))
                      : (isDark ? Colors.white.withValues(alpha: 0.70) : const Color(0xFF475569)),
                  letterSpacing: -0.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPaymentSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _PaymentModalSheet(
        amount: _billAmount,
        onPaymentSuccessful: () {
          _onPayBillSuccess();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF10B981),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              content: const Row(
                children: [
                  Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white, size: 20),
                  SizedBox(width: 10),
                  Text('Payment completed successfully!', style: TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showFileComplaintSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _FileComplaintSheet(
        onSubmit: (complaint) {
          _onAddNewComplaint(complaint);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF1877F2),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              content: Row(
                children: [
                  const Icon(CupertinoIcons.paperplane_fill, color: Colors.white, size: 18),
                  const SizedBox(width: 10),
                  Text('Ticket ${complaint['id']} registered!'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

}

// =============================================================
// 1. BILL SCREEN (Interactive, Animated & Robust UI Boxes)
// =============================================================
class BillScreen extends StatelessWidget {
  final bool isPaid;
  final double amount;
  final double waterUsage;
  final String monthName;
  final WaterBillBreakdown? breakdown;
  final List<Map<String, dynamic>> paymentHistory;
  final bool isValveOpen;
  final bool isSuspendedByAdmin;
  final VoidCallback onToggleValve;
  final VoidCallback onPayPressed;
  final VoidCallback? onUndoPayment;
  final VoidCallback onNotificationTap;
  final int unreadCount;
  final VoidCallback? onCalculateBill;
  final bool isCalculatingBill;

  const BillScreen({
    super.key,
    required this.isPaid,
    required this.amount,
    this.waterUsage = 40.0,
    this.monthName = 'September',
    this.breakdown,
    required this.paymentHistory,
    required this.isValveOpen,
    this.isSuspendedByAdmin = false,
    required this.onToggleValve,
    required this.onPayPressed,
    this.onUndoPayment,
    required this.onNotificationTap,
    required this.unreadCount,
    this.onCalculateBill,
    this.isCalculatingBill = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final activeBreakdown = breakdown ?? WaterBillBreakdown.calculate(waterUsage);

    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 95),
      children: [
        _buildAnimatedEntrance(
          index: 0,
          child: _buildHeader(
            context,
            title: 'Water Bill',
            onNotificationTap: onNotificationTap,
            unreadCount: unreadCount,
          ),
        ),
        if (isSuspendedByAdmin) ...[
          const SizedBox(height: 12),
          _buildAnimatedEntrance(
            index: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.20), width: 1.0),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(7),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.10),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.lock_fill, color: Color(0xFFE2E8F0), size: 18),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Account Suspended',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Water supply locked by administration. Please settle outstanding bill.',
                          style: TextStyle(
                            color: Color(0xFFCBD5E1),
                            fontSize: 11.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 18),

        // Main Hero Liquid Glass Gradient Card
        _buildAnimatedEntrance(
          index: 1,
          child: _InteractiveBillCard(
            isPaid: isPaid,
            amount: activeBreakdown.totalBill,
            waterUsage: waterUsage,
            monthName: monthName,
            isValveOpen: isValveOpen,
            onToggleValve: onToggleValve,
            onUndoPayment: onUndoPayment,
          ),
        ),

        const SizedBox(height: 16),

        // Calculate Bill & Photo OCR Trigger Button
        _buildAnimatedEntrance(
          index: 2,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: isCalculatingBill ? null : onCalculateBill,
                icon: isCalculatingBill
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2.2, color: Colors.white),
                      )
                    : const Icon(CupertinoIcons.camera_viewfinder, color: Colors.white, size: 21),
                label: Text(
                  isCalculatingBill ? 'Capturing & Calculating Bill...' : 'Calculate Bill',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.2,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
          ),
        ),

        // Pay Button / Paid Status Banner (Clean Glass Capsule with Undo tap)
        _buildAnimatedEntrance(
          index: 2,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: isPaid
                ? InkWell(
                    key: const ValueKey('paid_banner'),
                    onTap: onUndoPayment,
                    borderRadius: BorderRadius.circular(20),
                    child: LiquidGlassCard(
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      borderRadius: 20,
                      tintColor: isDark
                          ? const Color(0xFF064E3B).withValues(alpha: 0.55)
                          : const Color(0xFFD1FAE5).withValues(alpha: 0.8),
                      hasGlow: true,
                      glowColor: const Color(0xFF10B981),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(CupertinoIcons.checkmark_seal_fill, color: Color(0xFF30D158), size: 22),
                          SizedBox(width: 8),
                          Text(
                            'Bill Paid in Full · Tap to Undo',
                            style: TextStyle(
                              color: Color(0xFF30D158),
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: -0.2,
                            ),
                          ),
                          SizedBox(width: 6),
                          Icon(CupertinoIcons.arrow_counterclockwise, color: Color(0xFF30D158), size: 16),
                        ],
                      ),
                    ),
                  )
                : SizedBox(
                    key: const ValueKey('pay_button_box'),
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton.icon(
                      onPressed: onPayPressed,
                      icon: const Icon(CupertinoIcons.creditcard_fill, color: Colors.white, size: 20),
                      label: Text(
                        'Pay LKR ${activeBreakdown.totalBill.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.white, fontSize: 15.5, fontWeight: FontWeight.w700),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0A84FF),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 22),
        _buildAnimatedEntrance(
          index: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('BILL BREAKDOWN'),
              InkWell(
                onTap: () => _showTariffInfoDialog(context),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A84FF).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF0A84FF).withValues(alpha: 0.25)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(CupertinoIcons.chart_bar_alt_fill, size: 14, color: Color(0xFF0A84FF)),
                      SizedBox(width: 5),
                      Text('Tariff Rate Chart', style: TextStyle(color: Color(0xFF0A84FF), fontSize: 11.5, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Breakdown Card with Interactive Liquid Glass Rows
        _buildAnimatedEntrance(
          index: 4,
          child: LiquidGlassCard(
            padding: const EdgeInsets.all(18),
            borderRadius: 22,
            child: Column(
              children: [
                _buildClickableBreakdownRow(
                  context,
                  'Usage Charge (Tiered)',
                  'LKR ${activeBreakdown.usageCharge.toStringAsFixed(2)}',
                  info: 'Tiered consumption charge for ${activeBreakdown.units} units (${activeBreakdown.slabText}).',
                  isBoldVal: true,
                ),
                Divider(height: 20, color: AppTheme.divider(context)),
                _buildClickableBreakdownRow(
                  context,
                  'Monthly Service Charge',
                  'LKR ${activeBreakdown.serviceCharge.toStringAsFixed(2)}',
                  info: 'Fixed NWSDB monthly service charge for ${activeBreakdown.slabText} slab.',
                ),
                Divider(height: 20, color: AppTheme.divider(context)),
                _buildClickableBreakdownRow(
                  context,
                  'Total Tax / VAT (18%)',
                  'LKR ${activeBreakdown.vatAmount.toStringAsFixed(2)}',
                  info: '18% Value Added Tax (VAT) applied on taxable charges.',
                  isBoldVal: true,
                ),
                Divider(height: 20, color: AppTheme.divider(context)),
                _buildClickableBreakdownRow(
                  context,
                  'Previous Balance',
                  'LKR 0.00',
                  info: 'All prior statements have been cleared without late fees.',
                ),
                Divider(height: 20, color: AppTheme.divider(context)),
                _buildClickableBreakdownRow(
                  context,
                  'Total Due',
                  isPaid ? 'LKR 0.00 (PAID)' : 'LKR ${activeBreakdown.totalBill.toStringAsFixed(2)}',
                  info: 'Total payable for the cycle: Subtotal + VAT (18%).',
                  isPrimaryTotal: true,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 22),
        _buildAnimatedEntrance(
          index: 5,
          child: _buildSectionHeader('PAYMENT HISTORY (${paymentHistory.length})'),
        ),
        const SizedBox(height: 8),

        // Payment History Items with tap to view e-receipt
        ...paymentHistory.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return _buildAnimatedEntrance(
            index: 6 + idx,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildPaymentHistoryItem(context, item),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildClickableBreakdownRow(
    BuildContext context,
    String label,
    String value, {
    required String info,
    bool isBoldVal = false,
    bool isPrimaryTotal = false,
  }) {
    final isDark = AppTheme.isDark(context);

    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(info),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: isPrimaryTotal ? 14 : 13,
                  fontWeight: isPrimaryTotal ? FontWeight.w700 : FontWeight.w500,
                  color: isPrimaryTotal ? AppTheme.textPrimary(context) : AppTheme.textSecondary(context),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: isPrimaryTotal ? 14 : 13,
                fontWeight: (isBoldVal || isPrimaryTotal) ? FontWeight.w700 : FontWeight.w600,
                color: isPrimaryTotal ? (isDark ? const Color(0xFF38BDF8) : const Color(0xFF0A84FF)) : AppTheme.textPrimary(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentHistoryItem(BuildContext context, Map<String, dynamic> item) {
    final isDark = AppTheme.isDark(context);

    return LiquidGlassCard(
      onTap: () => _showReceiptModal(context, item),
      padding: const EdgeInsets.all(14),
      borderRadius: 20,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.primaryChipBg(context),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(CupertinoIcons.building_2_fill, color: isDark ? const Color(0xFF38BDF8) : const Color(0xFF0A84FF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['month'] ?? 'September 2026',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppTheme.textPrimary(context),
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${item['date']} · ${item['method']}',
                  style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11.5),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                item['amount'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 13.5,
                  color: AppTheme.textPrimary(context),
                ),
              ),
              const SizedBox(height: 3),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF30D158).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'PAID',
                  style: TextStyle(color: Color(0xFF30D158), fontSize: 9.5, fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showTariffInfoDialog(BuildContext context) {
    final isDark = AppTheme.isDark(context);
    final currentUnits = waterUsage.round();

    final List<Map<String, dynamic>> tariffData = [
      {'range': '00 – 05', 'rate': '12.00', 'service': '50.00', 'min': 0, 'max': 5},
      {'range': '06 – 10', 'rate': '16.00', 'service': '65.00', 'min': 6, 'max': 10},
      {'range': '11 – 15', 'rate': '20.00', 'service': '70.00', 'min': 11, 'max': 15},
      {'range': '16 – 20', 'rate': '40.00', 'service': '80.00', 'min': 16, 'max': 20},
      {'range': '21 – 25', 'rate': '58.00', 'service': '100.00', 'min': 21, 'max': 25},
      {'range': '26 – 30', 'rate': '88.00', 'service': '200.00', 'min': 26, 'max': 30},
      {'range': '31 – 40', 'rate': '105.00', 'service': '400.00', 'min': 31, 'max': 40},
      {'range': '41 – 50', 'rate': '120.00', 'service': '650.00', 'min': 41, 'max': 50},
      {'range': '51 – 75', 'rate': '130.00', 'service': '1,000.00', 'min': 51, 'max': 75},
      {'range': 'Over 75', 'rate': '140.00', 'service': '1,600.00', 'min': 76, 'max': 999999},
    ];

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: AppTheme.card(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1877F2).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(CupertinoIcons.table_fill, color: Color(0xFF1877F2), size: 20),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Domestic Water Tariff Chart',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                              color: AppTheme.textPrimary(ctx),
                            ),
                          ),
                          Text(
                            'Official NWSDB Gazette Rate Schedule',
                            style: TextStyle(
                              fontSize: 11.5,
                              color: AppTheme.textSecondary(ctx),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(CupertinoIcons.xmark, size: 18),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Tariff Table matching screenshot layout
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1), width: 1.2),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  children: [
                    // Table Header Row (Blue background matching screenshot)
                    Container(
                      color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFF93C5FD),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'No. of units',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Container(width: 1, height: 24, color: isDark ? Colors.white24 : const Color(0xFF64748B)),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Usage Charge\n(Rs./ Unit)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                          Container(width: 1, height: 24, color: isDark ? Colors.white24 : const Color(0xFF64748B)),
                          Expanded(
                            flex: 4,
                            child: Text(
                              'Monthly Service\nCharge (Rs.)',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5,
                                color: isDark ? Colors.white : const Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Table Data Rows
                    ...tariffData.asMap().entries.map((entry) {
                      final idx = entry.key;
                      final row = entry.value;
                      final isCurrent = currentUnits >= (row['min'] as int) && currentUnits <= (row['max'] as int);
                      final isEven = idx % 2 == 0;

                      Color rowBg = isEven
                          ? (isDark ? const Color(0xFF0F172A) : Colors.white)
                          : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC));

                      if (isCurrent) {
                        rowBg = isDark ? const Color(0xFF1E40AF).withValues(alpha: 0.4) : const Color(0xFFDBEAFE);
                      }

                      return Container(
                        color: rowBg,
                        padding: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 8),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    row['range'] as String,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w600,
                                      color: isCurrent
                                          ? const Color(0xFF2563EB)
                                          : AppTheme.textPrimary(ctx),
                                    ),
                                  ),
                                  if (isCurrent) ...[
                                    const SizedBox(width: 3),
                                    const Icon(CupertinoIcons.star_fill, size: 12, color: Color(0xFF2563EB)),
                                  ],
                                ],
                              ),
                            ),
                            Container(width: 1, height: 18, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            Expanded(
                              flex: 4,
                              child: Text(
                                row['rate'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                                  color: AppTheme.textPrimary(ctx),
                                ),
                              ),
                            ),
                            Container(width: 1, height: 18, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                            Expanded(
                              flex: 4,
                              child: Text(
                                row['service'] as String,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w500,
                                  color: AppTheme.textPrimary(ctx),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // VAT Formula Explanation Note
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.info_circle_fill, size: 14, color: Color(0xFF1877F2)),
                        const SizedBox(width: 6),
                        Text(
                          'Tariff & VAT Rules:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.textPrimary(ctx),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '• Usage charges are calculated incrementally across slabs.\n'
                      '• Subtotal = Usage Charge + Monthly Service Charge.\n'
                      '• Value Added Tax (VAT): 18% applied on the Subtotal.\n'
                      '• Total Bill = Subtotal + VAT (18%).',
                      style: TextStyle(
                        fontSize: 11.5,
                        height: 1.4,
                        color: AppTheme.textSecondary(ctx),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Close Tariff Chart', style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReceiptModal(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ReceiptModalSheet(item: item),
    );
  }
}

class _InteractiveBillCard extends StatefulWidget {
  final bool isPaid;
  final double amount;
  final double waterUsage;
  final String monthName;
  final bool isValveOpen;
  final VoidCallback onToggleValve;
  final VoidCallback? onUndoPayment;

  const _InteractiveBillCard({
    required this.isPaid,
    required this.amount,
    this.waterUsage = 37.0,
    this.monthName = 'September',
    required this.isValveOpen,
    required this.onToggleValve,
    this.onUndoPayment,
  });

  @override
  State<_InteractiveBillCard> createState() => _InteractiveBillCardState();
}

class _InteractiveBillCardState extends State<_InteractiveBillCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final isClosed = !widget.isValveOpen;

    return GestureDetector(
      onTap: isClosed ? null : () => setState(() => _isExpanded = !_isExpanded),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isClosed
                ? const [Color(0xFFE11D48), Color(0xFF9F1239)]
                : const [Color(0xFF0A84FF), Color(0xFF0058D0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(26),
          boxShadow: [
            BoxShadow(
              color: (isClosed ? const Color(0xFFFF453A) : const Color(0xFF0A84FF)).withValues(alpha: 0.38),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(26),
          child: Stack(
            children: [
              // Underlying Card Data (Blurred when valve is closed)
              ImageFiltered(
                imageFilter: ImageFilter.blur(
                  sigmaX: isClosed ? 5.5 : 0.0,
                  sigmaY: isClosed ? 5.5 : 0.0,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.monthName} 2026',
                            style: const TextStyle(color: Colors.white70, fontSize: 13.5, fontWeight: FontWeight.w500),
                          ),
                          GestureDetector(
                            onTap: widget.isPaid ? widget.onUndoPayment : null,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4.5),
                              decoration: BoxDecoration(
                                color: widget.isPaid ? const Color(0xFF30D158) : Colors.white.withValues(alpha: 0.22),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.35),
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (widget.isPaid) const Icon(CupertinoIcons.checkmark_alt_circle_fill, color: Colors.white, size: 13),
                                  if (widget.isPaid) const SizedBox(width: 4),
                                  Text(
                                    widget.isPaid ? 'Paid' : 'Unpaid',
                                    style: const TextStyle(color: Colors.white, fontSize: 11.5, fontWeight: FontWeight.w700),
                                  ),
                                  if (widget.isPaid) ...[
                                    const SizedBox(width: 3),
                                    const Icon(CupertinoIcons.arrow_counterclockwise, color: Colors.white70, size: 10),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      AnimatedCrossFade(
                        duration: const Duration(milliseconds: 250),
                        crossFadeState: widget.isPaid ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        firstChild: Text(
                          'LKR ${widget.amount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                        ),
                        secondChild: const Text(
                          'LKR 0.00',
                          style: TextStyle(color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800, letterSpacing: -0.5),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        widget.isPaid ? 'Cleared on 22 Sep 2026' : 'Due 25 Sep 2026 (3 days remaining)',
                        style: TextStyle(
                          color: widget.isPaid ? Colors.white.withValues(alpha: 0.9) : Colors.white70,
                          fontSize: 12.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 18),

                      // 3 Glass Stats Pills with Tap Feedback
                      Row(
                        children: [
                          Expanded(
                            child: _buildGlassStat(
                              context,
                              CupertinoIcons.drop_fill,
                              'Usage',
                              '${widget.waterUsage.round()} units',
                              'Active meter consumption for current billing cycle: ${widget.waterUsage.round()} units.',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGlassStat(
                              context,
                              CupertinoIcons.speedometer,
                              'Meter ID',
                              'WB-04812',
                              'Smart ultrasonic digital meter linked to account.',
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildGlassStat(
                              context,
                              CupertinoIcons.chart_bar_fill,
                              'Avg/Day',
                              '${(widget.waterUsage / 30.0).toStringAsFixed(1)} units',
                              'Daily average consumption is ${(widget.waterUsage / 30.0).toStringAsFixed(2)} units/day.',
                            ),
                          ),
                        ],
                      ),

                      if (_isExpanded) ...[
                        const SizedBox(height: 14),
                        const Divider(color: Colors.white24),
                        const SizedBox(height: 6),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Billing Cycle: 01 Aug – 31 Aug', style: TextStyle(color: Colors.white70, fontSize: 11)),
                            Text('Tariff: Domestic Standard', style: TextStyle(color: Colors.white70, fontSize: 11)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              // Foreground Overlay when Valve is Closed
              if (isClosed)
                Positioned.fill(
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 18),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.50),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.1),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'VALVE CLOSED',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 15,
                                  letterSpacing: 0.5,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Water supply is shut off (Protection Active)',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70, fontSize: 11.5, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: widget.onToggleValve,
                                icon: const Icon(CupertinoIcons.drop_fill, size: 15, color: Color(0xFFFF453A)),
                                label: const Text(
                                  'Open Valve',
                                  style: TextStyle(color: Color(0xFFFF453A), fontWeight: FontWeight.w800, fontSize: 12.5),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFFFF453A),
                                  elevation: 0,
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassStat(BuildContext context, IconData icon, String label, String value, String description) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$label ($value): $description'),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      },
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w500)),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================
// EMERGENCY LEAKAGE APPLE BOTTOM SHEET NOTIFICATION WINDOW
// =============================================================
class _AppleEmergencyLeakageBottomSheet extends StatefulWidget {
  final double limitLiters;
  final double currentLiters;
  final String fromTimeStr;
  final String toTimeStr;
  final VoidCallback onAutoCloseValve;
  final VoidCallback onReopenValve;

  const _AppleEmergencyLeakageBottomSheet({
    required this.limitLiters,
    this.currentLiters = 1500.0,
    required this.fromTimeStr,
    required this.toTimeStr,
    required this.onAutoCloseValve,
    required this.onReopenValve,
  });

  @override
  State<_AppleEmergencyLeakageBottomSheet> createState() => _AppleEmergencyLeakageBottomSheetState();
}

class _AppleEmergencyLeakageBottomSheetState extends State<_AppleEmergencyLeakageBottomSheet>
    with SingleTickerProviderStateMixin {
  int _secondsRemaining = 15;
  Timer? _countdownTimer;
  bool _isAutoClosed = false;
  StreamSubscription<DatabaseEvent>? _valveListener;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _startCountdown();
    _listenValveStatus();
  }

  void _listenValveStatus() {
    try {
      _valveListener = FirebaseDatabase.instance.ref('users/user_0001/watermeter/valveStatus').onValue.listen((event) {
        final val = event.snapshot.value;
        final bool isOpen = val == true || val?.toString().toLowerCase() == 'true' || val?.toString().toLowerCase() == 'open';
        // If valve has been reopened while this sheet was in closed state, auto-close the popup!
        if (isOpen && _isAutoClosed && mounted) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Valve reopened · Supply active'),
                behavior: SnackBarBehavior.floating,
                backgroundColor: const Color(0xFF007AFF),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          }
        }
      });
    } catch (_) {}
  }

  void _startCountdown() {
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }
      if (_secondsRemaining > 1) {
        setState(() => _secondsRemaining--);
      } else {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _isAutoClosed = true;
        });
        widget.onAutoCloseValve();

        // Smoothly and automatically close the popup window after the countdown completes
        Timer(const Duration(milliseconds: 900), () {
          if (mounted && Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _countdownTimer?.cancel();
    _valveListener?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppTheme.isDark(context);

    return PopScope(
      canPop: false,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
          child: Container(
            padding: const EdgeInsets.fromLTRB(18, 10, 18, 18),
            decoration: BoxDecoration(
              color: isDark
                  ? const Color(0xFF141416).withValues(alpha: 0.72)
                  : Colors.white.withValues(alpha: 0.76),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(
                color: isDark
                    ? Colors.white.withValues(alpha: 0.16)
                    : Colors.white.withValues(alpha: 0.65),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.45 : 0.14),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // iOS Drag Handle Pill
                  Center(
                    child: Container(
                      width: 32,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white.withValues(alpha: 0.25) : Colors.black.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.08),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: !_isAutoClosed
                        ? Column(
                            key: const ValueKey('alert_active'),
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // Minimal Alert Row
                              Row(
                                children: [
                                  ScaleTransition(
                                    scale: _pulseAnimation,
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        SizedBox(
                                          width: 42,
                                          height: 42,
                                          child: CircularProgressIndicator(
                                            value: _secondsRemaining / 15.0,
                                            strokeWidth: 3.2,
                                            backgroundColor: isDark ? const Color(0xFF2C2C2E) : const Color(0xFFF2F2F7),
                                            valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF3B30)),
                                          ),
                                        ),
                                        AnimatedSwitcher(
                                          duration: const Duration(milliseconds: 180),
                                          transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
                                          child: Text(
                                            '${_secondsRemaining}s',
                                            key: ValueKey(_secondsRemaining),
                                            style: TextStyle(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w800,
                                              color: isDark ? Colors.white : const Color(0xFF1C1C1E),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'High Flow Alert',
                                          style: TextStyle(
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w700,
                                            color: AppTheme.textPrimary(context),
                                            letterSpacing: -0.2,
                                          ),
                                        ),
                                        const SizedBox(height: 1),
                                        Text(
                                          '${widget.currentLiters.toInt()} L · Limit ${widget.limitLiters.toInt()} L',
                                          style: const TextStyle(
                                            color: Color(0xFFFF3B30),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              // Compact Action Row
                              Row(
                                children: [
                                  Expanded(
                                    child: SizedBox(
                                      height: 40,
                                      child: OutlinedButton(
                                        onPressed: () {
                                          _countdownTimer?.cancel();
                                          widget.onAutoCloseValve();
                                          setState(() => _isAutoClosed = true);
                                        },
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: const Color(0xFFFF3B30).withValues(alpha: 0.4),
                                            width: 1.1,
                                          ),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: const Text(
                                          'Shut Off',
                                          style: TextStyle(
                                            color: Color(0xFFFF3B30),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    flex: 2,
                                    child: SizedBox(
                                      height: 40,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _countdownTimer?.cancel();
                                          Navigator.pop(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF34C759),
                                          foregroundColor: Colors.white,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child: const Text(
                                          'Dismiss',
                                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Row(
                            key: const ValueKey('alert_closed'),
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ScaleTransition(
                                    scale: _pulseAnimation,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF3B30).withValues(alpha: 0.15),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(CupertinoIcons.drop, color: Color(0xFFFF3B30), size: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Valve Closed',
                                        style: TextStyle(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w700,
                                          color: AppTheme.textPrimary(context),
                                          letterSpacing: -0.2,
                                        ),
                                      ),
                                      Text(
                                        'Auto-shutoff active',
                                        style: TextStyle(
                                          fontSize: 11.5,
                                          color: AppTheme.textMuted(context),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 38,
                                child: ElevatedButton(
                                  onPressed: () {
                                    widget.onReopenValve();
                                    if (mounted && Navigator.canPop(context)) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF007AFF),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  ),
                                  child: const Text('Reopen', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// =============================================================
// 2. USAGE & ALERTS SCREEN (With Indoor Leakage & Monthly Limit)
// =============================================================
class UsageAlertsScreen extends StatefulWidget {
  final VoidCallback onNotificationTap;
  final int unreadCount;
  final double meterReading;
  final double previousMonthReading;
  final double calculatedWaterUsage;
  final List<Map<String, dynamic>> monthlyChartData;
  final List<Map<String, dynamic>> dailyChartData;
  final bool isFirebaseConnected;
  final bool isUsageLoading;
  final bool isValveOpen;
  final VoidCallback onToggleValve;
  final bool indoorLeakageEnabled;
  final double leakageLimitLiters;
  final double monthlyUsageLimit;
  final TimeOfDay leakageFromTime;
  final TimeOfDay leakageToTime;
  final Function(bool enabled, double limit, TimeOfDay from, TimeOfDay to) onUpdateLeakageSettings;
  final Function(double limit) onUpdateMonthlyLimit;
  final Function(double percentage) onTriggerLeakageAlert;
  final Function(double percentage) onTriggerMonthlyAlert;

  const UsageAlertsScreen({
    super.key,
    required this.onNotificationTap,
    required this.unreadCount,
    this.meterReading = 1497.0,
    this.previousMonthReading = 1460.0,
    this.calculatedWaterUsage = 37.0,
    this.monthlyChartData = const [],
    this.dailyChartData = const [],
    this.isFirebaseConnected = false,
    this.isUsageLoading = false,
    required this.isValveOpen,
    required this.onToggleValve,
    required this.indoorLeakageEnabled,
    required this.leakageLimitLiters,
    required this.monthlyUsageLimit,
    required this.leakageFromTime,
    required this.leakageToTime,
    required this.onUpdateLeakageSettings,
    required this.onUpdateMonthlyLimit,
    required this.onTriggerLeakageAlert,
    required this.onTriggerMonthlyAlert,
  });

  @override
  State<UsageAlertsScreen> createState() => _UsageAlertsScreenState();
}

class _UsageAlertsScreenState extends State<UsageAlertsScreen> {
  int _selectedTab = 0; // 0: Monthly, 1: Daily
  int? _selectedBarIndex;

  late bool _leakageEnabled;
  late double _leakageLimit;
  late double _monthlyLimit;
  late TimeOfDay _fromTime;
  late TimeOfDay _toTime;

  @override
  void initState() {
    super.initState();
    _leakageEnabled = widget.indoorLeakageEnabled;
    _leakageLimit = widget.leakageLimitLiters;
    _monthlyLimit = widget.monthlyUsageLimit;
    _fromTime = widget.leakageFromTime;
    _toTime = widget.leakageToTime;
  }

  @override
  void didUpdateWidget(covariant UsageAlertsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.indoorLeakageEnabled != widget.indoorLeakageEnabled) {
      _leakageEnabled = widget.indoorLeakageEnabled;
    }
    if (oldWidget.leakageLimitLiters != widget.leakageLimitLiters) {
      _leakageLimit = widget.leakageLimitLiters;
    }
    if (oldWidget.monthlyUsageLimit != widget.monthlyUsageLimit) {
      _monthlyLimit = widget.monthlyUsageLimit;
    }
    if (oldWidget.leakageFromTime != widget.leakageFromTime) {
      _fromTime = widget.leakageFromTime;
    }
    if (oldWidget.leakageToTime != widget.leakageToTime) {
      _toTime = widget.leakageToTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMonthly = _selectedTab == 0;

    // Dynamic monthly average in units
    final double monthlyAvg = widget.monthlyChartData.isNotEmpty
        ? (widget.monthlyChartData.map((e) => (e['val'] as num?)?.toDouble() ?? 0.0).reduce((a, b) => a + b) /
            widget.monthlyChartData.length)
        : 33.3;

    // Dynamic daily average in Liters
    final double dailyAvgLiters = widget.dailyChartData.isNotEmpty
        ? (widget.dailyChartData.map((e) => (e['liters'] as num?)?.toDouble() ?? (((e['usage'] as num?)?.toDouble() ?? 0.0) * 1000.0)).reduce((a, b) => a + b) /
            widget.dailyChartData.length)
        : 1642.8;

    final double latestDailyLiters = widget.dailyChartData.isNotEmpty
        ? ((widget.dailyChartData.last['liters'] as num?)?.toDouble() ?? 1400.0)
        : 1400.0;
    final String latestDailyDay = widget.dailyChartData.isNotEmpty
        ? (widget.dailyChartData.last['day']?.toString() ?? 'Today')
        : 'Today';

    final bool hasSelection = _selectedBarIndex != null &&
        _selectedBarIndex! >= 0 &&
        _selectedBarIndex! < widget.dailyChartData.length;

    final double activeDailyLiters = hasSelection
        ? ((widget.dailyChartData[_selectedBarIndex!]['liters'] as num?)?.toDouble() ?? latestDailyLiters)
        : latestDailyLiters;
    final String activeDailyDay = hasSelection
        ? (widget.dailyChartData[_selectedBarIndex!]['day']?.toString() ?? 'Selected')
        : latestDailyDay;

    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 95),
      children: [
        _buildAnimatedEntrance(
          index: 0,
          child: _buildHeader(
            context,
            title: 'Usage & Alerts',
            onNotificationTap: widget.onNotificationTap,
            unreadCount: widget.unreadCount,
          ),
        ),
        const SizedBox(height: 14),

        // 1. Animated Segmented Glass Control
        _buildAnimatedEntrance(
          index: 1,
          child: LiquidGlassCard(
            padding: const EdgeInsets.all(4),
            borderRadius: 18,
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedTab = 0;
                      _selectedBarIndex = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0
                            ? (AppTheme.isDark(context) ? const Color(0xFF0A84FF).withValues(alpha: 0.28) : const Color(0xFF0A84FF).withValues(alpha: 0.15))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: _selectedTab == 0
                            ? Border.all(color: const Color(0xFF0A84FF).withValues(alpha: 0.4), width: 1.0)
                            : Border.all(color: Colors.transparent, width: 1.0),
                      ),
                      child: Center(
                        child: Text(
                          'Monthly',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: _selectedTab == 0
                                ? (AppTheme.isDark(context) ? Colors.white : const Color(0xFF0A84FF))
                                : AppTheme.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _selectedTab = 1;
                      _selectedBarIndex = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.symmetric(vertical: 9),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1
                            ? (AppTheme.isDark(context) ? const Color(0xFF0A84FF).withValues(alpha: 0.28) : const Color(0xFF0A84FF).withValues(alpha: 0.15))
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        border: _selectedTab == 1
                            ? Border.all(color: const Color(0xFF0A84FF).withValues(alpha: 0.4), width: 1.0)
                            : Border.all(color: Colors.transparent, width: 1.0),
                      ),
                      child: Center(
                        child: Text(
                          'Daily',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: _selectedTab == 1
                                ? (AppTheme.isDark(context) ? Colors.white : const Color(0xFF0A84FF))
                                : AppTheme.textSecondary(context),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 2. Interactive Liquid Glass Chart Card
        _buildAnimatedEntrance(
          index: 2,
          child: LiquidGlassCard(
            padding: const EdgeInsets.all(18),
            borderRadius: 24,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      isMonthly ? 'Monthly Consumption' : 'Daily Consumption Trend',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15.5, color: AppTheme.textPrimary(context)),
                    ),
                    Row(
                      children: [
                        const Icon(CupertinoIcons.waveform_path_ecg, size: 15, color: Color(0xFF0A84FF)),
                        const SizedBox(width: 4),
                        Text(
                          isMonthly ? 'Avg ${monthlyAvg.toStringAsFixed(1)} units' : 'Avg ${dailyAvgLiters.round()} L',
                          style: const TextStyle(color: Color(0xFF0A84FF), fontSize: 12.5, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  isMonthly
                      ? 'Live monthly records from Firebase · Tap bar for details'
                      : 'Live volume in Liters · Tap points to inspect volume',
                  style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                ),
                const SizedBox(height: 14),

                // Dynamic Chart Rendering
                SizedBox(
                  height: 180,
                  child: isMonthly
                      ? InteractiveMonthlyBarChart(
                          data: widget.monthlyChartData,
                          threshold: _monthlyLimit / 25.0,
                          selectedIndex: _selectedBarIndex,
                          onBarSelected: (idx) => setState(() => _selectedBarIndex = idx),
                        )
                      : ModernDailySplineAreaChart(
                          threshold: _leakageLimit / 50.0,
                          selectedIndex: _selectedBarIndex,
                          dailyData: widget.dailyChartData,
                          onPointSelected: (idx) => setState(() => _selectedBarIndex = idx),
                        ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // 3. Modern Apple-Style Meter Reading Box (Under the Graph)
        _buildAnimatedEntrance(
          index: 3,
          child: _buildModernAppleMeterBox(),
        ),

        const SizedBox(height: 14),

        // 4. 3 Summary Cards with Animated values
        _buildAnimatedEntrance(
          index: 4,
          child: Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  icon: CupertinoIcons.chart_bar_alt_fill,
                  iconColor: const Color(0xFF0A84FF),
                  bgColor: AppTheme.primaryChipBg(context),
                  value: widget.isUsageLoading
                      ? '…'
                      : isMonthly
                          ? '${widget.calculatedWaterUsage.round()} units'
                          : '${activeDailyLiters.toInt()} L',
                  valueColor: const Color(0xFF0A84FF),
                  label: isMonthly ? 'This Month' : activeDailyDay,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  icon: CupertinoIcons.speedometer,
                  iconColor: const Color(0xFF64748B),
                  bgColor: AppTheme.surfaceAlt(context),
                  value: '${widget.meterReading.round()} units',
                  valueColor: const Color(0xFF64748B),
                  label: 'Current Meter',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricCard(
                  icon: CupertinoIcons.drop_fill,
                  iconColor: const Color(0xFF30D158),
                  bgColor: const Color(0xFF30D158).withValues(alpha: 0.14),
                  value: isMonthly
                      ? '${(widget.calculatedWaterUsage / 30.0).toStringAsFixed(1)} units'
                      : '${dailyAvgLiters.round()} L',
                  valueColor: const Color(0xFF30D158),
                  label: isMonthly ? 'Avg / Day' : 'Daily Avg',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        _buildAnimatedEntrance(
          index: 5,
          child: _buildSectionHeader('INDOOR LEAKAGE DETECTOR'),
        ),
        const SizedBox(height: 8),

        // 5. REDESIGNED INDOOR LEAKAGE DETECTOR CARD (COMPACT LIQUID GLASS)
        _buildAnimatedEntrance(
          index: 6,
          child: _buildIndoorLeakageDetectorCard(),
        ),

        const SizedBox(height: 16),
        _buildAnimatedEntrance(
          index: 7,
          child: _buildSectionHeader('MONTHLY USAGE LIMIT'),
        ),
        const SizedBox(height: 8),

        // 6. MONTHLY USAGE LIMIT SLIDER CARD (COMPACT LIQUID GLASS)
        _buildAnimatedEntrance(
          index: 8,
          child: _buildMonthlyUsageLimitCard(),
        ),
      ],
    );
  }

  String _formatTime12Hour(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    final hourStr = hour.toString().padLeft(2, '0');
    return '$hourStr:$minute $period';
  }

  /// Computes the monitored flow volume (in Liters) for the user's selected time window
  /// synced with current real-time and Sunday / active day's Firebase data.
  ({double monitoredLiters, bool isWindowActive, String statusLabel, double totalDayLiters, String dayName}) _calculateMonitoredFlow() {
    // 1. Get Sunday data from Firebase dailyChartData (or fallback)
    double dayLiters = 1500.0;
    String dayName = 'Sunday';

    if (widget.dailyChartData.isNotEmpty) {
      final sundayItem = widget.dailyChartData.firstWhere(
        (item) => item['day'] == 'Sun' || item['fullName'] == 'Sunday',
        orElse: () => widget.dailyChartData.last,
      );
      dayLiters = (sundayItem['liters'] as num?)?.toDouble() ?? 1500.0;
      dayName = sundayItem['fullName']?.toString() ?? 'Sunday';
    }

    // 2. Current Device Time
    final now = TimeOfDay.now();
    final nowMin = now.hour * 60 + now.minute;
    final fromMin = _fromTime.hour * 60 + _fromTime.minute;
    final toMin = _toTime.hour * 60 + _toTime.minute;

    bool isWindowActive = false;
    double monitoredLiters = 0.0;
    String statusLabel = '';

    if (fromMin == toMin) {
      isWindowActive = true;
      monitoredLiters = dayLiters;
      statusLabel = '24/7 Active · $dayName';
    } else if (fromMin < toMin) {
      // Same-day window (e.g. 7:00 AM – 9:00 AM or 6:00 PM – 10:00 PM)
      if (nowMin < fromMin) {
        isWindowActive = false;
        monitoredLiters = 0.0;
        statusLabel = 'Starts at ${_formatTime12Hour(_fromTime)} (Outside Window)';
      } else if (nowMin >= fromMin && nowMin <= toMin) {
        isWindowActive = true;
        monitoredLiters = dayLiters;
        statusLabel = 'Active Window (${_formatTime12Hour(_fromTime)} – ${_formatTime12Hour(_toTime)})';
      } else {
        isWindowActive = false;
        monitoredLiters = dayLiters;
        statusLabel = 'Completed (${_formatTime12Hour(_fromTime)} – ${_formatTime12Hour(_toTime)})';
      }
    } else {
      // Overnight window (e.g., 10:00 PM – 5:00 AM)
      if (nowMin >= fromMin || nowMin <= toMin) {
        isWindowActive = true;
        monitoredLiters = dayLiters;
        statusLabel = 'Active Night Window (${_formatTime12Hour(_fromTime)} – ${_formatTime12Hour(_toTime)})';
      } else {
        isWindowActive = false;
        monitoredLiters = 0.0;
        statusLabel = 'Starts at ${_formatTime12Hour(_fromTime)} (Tonight)';
      }
    }

    return (
      monitoredLiters: monitoredLiters,
      isWindowActive: isWindowActive,
      statusLabel: statusLabel,
      totalDayLiters: dayLiters,
      dayName: dayName,
    );
  }

  Widget _buildIndoorLeakageDetectorCard() {
    final isDark = AppTheme.isDark(context);
    final flowCalc = _calculateMonitoredFlow();
    final double monitoredLiters = flowCalc.monitoredLiters;
    final bool isWindowActive = flowCalc.isWindowActive;
    final bool isExceeded = _leakageEnabled && isWindowActive && monitoredLiters > _leakageLimit && _leakageLimit > 0;

    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Switch Row
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: _leakageEnabled
                      ? (isExceeded ? const Color(0xFFFF3B30).withValues(alpha: 0.14) : const Color(0xFF0A84FF).withValues(alpha: 0.14))
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  isExceeded ? CupertinoIcons.exclamationmark_triangle_fill : CupertinoIcons.shield_fill,
                  color: _leakageEnabled
                      ? (isExceeded ? const Color(0xFFFF3B30) : const Color(0xFF0A84FF))
                      : const Color(0xFF94A3B8),
                  size: 17,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Night Leak Protection',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.5,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: 0.88,
                child: Switch(
                  value: _leakageEnabled,
                  activeTrackColor: isExceeded
                      ? const Color(0xFFFF3B30).withValues(alpha: 0.4)
                      : const Color(0xFF0A84FF).withValues(alpha: 0.4),
                  activeThumbColor: isExceeded ? const Color(0xFFFF3B30) : const Color(0xFF0A84FF),
                  onChanged: (val) {
                    setState(() => _leakageEnabled = val);
                    widget.onUpdateLeakageSettings(_leakageEnabled, _leakageLimit, _fromTime, _toTime);
                  },
                ),
              ),
            ],
          ),

          if (_leakageEnabled) ...[
            Divider(height: 12, color: AppTheme.divider(context)),

            // Active Hours Row
            InkWell(
              onTap: () async {
                final from = await showTimePicker(
                  context: context,
                  initialTime: _fromTime,
                  helpText: 'Select Start Time',
                );
                if (from != null && mounted) {
                  final to = await showTimePicker(
                    context: context,
                    initialTime: _toTime,
                    helpText: 'Select End Time',
                  );
                  if (to != null && mounted) {
                    setState(() {
                      _fromTime = from;
                      _toTime = to;
                    });
                    widget.onUpdateLeakageSettings(_leakageEnabled, _leakageLimit, from, to);
                  } else {
                    setState(() => _fromTime = from);
                    widget.onUpdateLeakageSettings(_leakageEnabled, _leakageLimit, from, _toTime);
                  }
                }
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Active Hours',
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: AppTheme.textPrimary(context),
                      ),
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_formatTime12Hour(_fromTime)} – ${_formatTime12Hour(_toTime)}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0A84FF),
                            ),
                          ),
                        ),
                        const SizedBox(width: 2),
                        Icon(CupertinoIcons.chevron_forward, size: 14, color: AppTheme.textMuted(context)),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            Divider(height: 12, color: AppTheme.divider(context)),

            // Real-Time Monitored Flow Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isExceeded
                        ? const Color(0xFFFF3B30).withValues(alpha: 0.14)
                        : (isWindowActive
                            ? const Color(0xFF0A84FF).withValues(alpha: 0.12)
                            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),

            Divider(height: 12, color: AppTheme.divider(context)),

            // Flow Limit Row & Clean Slider
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shut-off Limit',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.textPrimary(context),
                  ),
                ),
                Text(
                  '${_leakageLimit.toInt()} L',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isExceeded ? const Color(0xFFFF3B30) : const Color(0xFF0A84FF),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),

            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: isExceeded ? const Color(0xFFFF3B30) : const Color(0xFF0A84FF),
                inactiveTrackColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                thumbColor: Colors.white,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.5, elevation: 2),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                trackHeight: 3.5,
              ),
              child: Slider(
                value: _leakageLimit.clamp(0.0, 2000.0),
                min: 0,
                max: 2000,
                divisions: 40,
                onChanged: (val) {
                  setState(() => _leakageLimit = val);
                  widget.onUpdateLeakageSettings(_leakageEnabled, val, _fromTime, _toTime);
                },
                onChangeEnd: (val) {
                  final flowCalc = _calculateMonitoredFlow();
                  if (_leakageEnabled && flowCalc.isWindowActive && flowCalc.monitoredLiters > val && val > 0) {
                    widget.onTriggerLeakageAlert(1.0);
                  }
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMonthlyUsageLimitCard() {
    final isDark = AppTheme.isDark(context);
    final currentUsageLiters = widget.calculatedWaterUsage * 1000.0;
    final ratio = (currentUsageLiters / (_monthlyLimit > 0 ? _monthlyLimit : 1.0)).clamp(0.0, 1.0);

    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row with Target & Consumed Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF30D158).withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      CupertinoIcons.flag_fill,
                      color: Color(0xFF30D158),
                      size: 17,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Monthly Water Target',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.5,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      Text(
                        '${(ratio * 100).toInt()}% consumed · ${currentUsageLiters.toInt()} of ${_monthlyLimit.toInt()} L',
                        style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11.5),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF30D158).withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${_monthlyLimit.toInt()} L',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF30D158),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Minimalist Slider
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF30D158),
              inactiveTrackColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              thumbColor: Colors.white,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.5, elevation: 2),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
              trackHeight: 3.5,
            ),
            child: Slider(
              value: _monthlyLimit,
              min: 0,
              max: 2000,
              divisions: 20,
              onChanged: (val) {
                setState(() => _monthlyLimit = val);
                widget.onUpdateMonthlyLimit(val);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required Color valueColor,
    required String label,
  }) {
    return LiquidGlassCard(
      padding: const EdgeInsets.all(12),
      borderRadius: 18,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: iconColor, size: 16),
          ),
          const SizedBox(height: 6),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              value,
              key: ValueKey(value),
              style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14, color: valueColor),
            ),
          ),
          const SizedBox(height: 1),
          Text(label, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 10.5, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  List<String> _getMeterDigits() {
    final int intVal = widget.meterReading.toInt();
    final String str = intVal.toString().padLeft(4, '0');
    return str.split('');
  }

  Widget _buildModernAppleMeterBox() {
    final digits = _getMeterDigits();

    return LiquidGlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      borderRadius: 22,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: AppTheme.primaryChipBg(context),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  CupertinoIcons.speedometer,
                  color: Color(0xFF0A84FF),
                  size: 19,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Meter Reading',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary(context),
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Row(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Text(
                  digits.join(''),
                  key: ValueKey(digits.join('')),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.textPrimary(context),
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primaryChipBg(context),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'm³ / unit',
                  style: TextStyle(
                    color: Color(0xFF0A84FF),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
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

// -------------------------------------------------------------
// 1. INTERACTIVE MONTHLY BAR CHART (SYNCED WITH FIREBASE)
// -------------------------------------------------------------
class InteractiveMonthlyBarChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  final double threshold;
  final int? selectedIndex;
  final ValueChanged<int> onBarSelected;

  const InteractiveMonthlyBarChart({
    super.key,
    required this.data,
    this.threshold = 20.0,
    required this.selectedIndex,
    required this.onBarSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return Center(
        child: Text(
          'No monthly records available',
          style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13),
        ),
      );
    }

    final double maxUsage = data.map((e) => ((e['val'] as num?)?.toDouble() ?? 0.0)).reduce(math.max);
    // Dynamic maxVal: 25% headroom so bars never hit the ceiling, rounded to clean multiple of 5
    final double maxVal = math.max(20.0, (((maxUsage * 1.25) / 5).ceil() * 5).toDouble());

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalWidth = constraints.maxWidth;
        final totalHeight = constraints.maxHeight;
        const leftPadding = 38.0;
        const rightPadding = 8.0;
        const bottomLabelHeight = 22.0;
        final plotWidth = totalWidth - leftPadding - rightPadding;
        final plotHeight = totalHeight - bottomLabelHeight;

        final int? selIdx = (selectedIndex != null && selectedIndex! >= 0 && selectedIndex! < data.length)
            ? selectedIndex
            : null;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Y-Axis Grid Lines & Labels
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGridLine(context, '${maxVal.toInt()}'),
                  _buildGridLine(context, '${(maxVal * 0.75).toInt()}'),
                  _buildGridLine(context, '${(maxVal * 0.50).toInt()}'),
                  _buildGridLine(context, '${(maxVal * 0.25).toInt()}'),
                  _buildGridLine(context, '0'),
                  const SizedBox(height: 18),
                ],
              ),
            ),

            // 2. Fixed Bottom-Aligned Monthly Bars (Zero Vertical Shifting)
            Positioned(
              left: leftPadding,
              right: rightPadding,
              top: 0,
              bottom: 0,
              child: RepaintBoundary(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: data.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final item = entry.value;
                  final double val = (item['val'] as num?)?.toDouble() ?? 0.0;
                  final double barHeight = ((val / maxVal) * (plotHeight - 14)).clamp(6.0, plotHeight - 14);
                  final bool isSelected = selIdx == index;
                  final bool isCurrent = index == data.length - 1;

                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (selectedIndex == index) {
                          onBarSelected(-1); // Toggle off if already selected
                        } else {
                          onBarSelected(index);
                        }
                      },
                      behavior: HitTestBehavior.opaque,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutCubic,
                            width: isSelected ? 20 : 15,
                            height: barHeight,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isSelected
                                    ? [const Color(0xFF00E5FF), const Color(0xFF0072FF)]
                                    : isCurrent
                                        ? [const Color(0xFF1C7EFF), const Color(0xFF0060E6)]
                                        : [const Color(0xFF93C5FD), const Color(0xFF3B82F6)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(5),
                                topRight: Radius.circular(5),
                              ),
                              boxShadow: isSelected
                                  ? [
                                      BoxShadow(
                                        color: const Color(0xFF1877F2).withValues(alpha: 0.55),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 6),
                          SizedBox(
                            height: 16,
                            child: Text(
                              item['label'],
                              style: TextStyle(
                                color: isSelected ? const Color(0xFF1877F2) : AppTheme.textSecondary(context),
                                fontSize: 10,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

            // 3. Floating Tooltip Badge Overlay (Independent of Flex layout)
            if (selIdx != null)
              () {
                final item = data[selIdx];
                final double val = (item['val'] as num?)?.toDouble() ?? 0.0;
                final double barHeight = ((val / maxVal) * (plotHeight - 14)).clamp(6.0, plotHeight - 14);
                final double stepWidth = plotWidth / data.length;
                final double barCenterX = leftPadding + (selIdx + 0.5) * stepWidth;
                final double barTopY = totalHeight - bottomLabelHeight - barHeight;

                const double tooltipWidth = 66.0;
                final double tooltipLeft = (barCenterX - tooltipWidth / 2)
                    .clamp(leftPadding, totalWidth - rightPadding - tooltipWidth);
                final double tooltipTop = (barTopY - 28).clamp(0.0, totalHeight - 34);

                return Positioned(
                  left: tooltipLeft,
                  top: tooltipTop,
                  child: IgnorePointer(
                    child: Container(
                      width: tooltipWidth,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.6), width: 0.8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        '${val.round()} units',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Color(0xFF38BDF8),
                          fontSize: 9.5,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.2,
                        ),
                      ),
                    ),
                  ),
                );
              }(),
          ],
        );
      },
    );
  }

  Widget _buildGridLine(BuildContext context, String label) {
    return Row(
      children: [
        SizedBox(
          width: 32,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(color: AppTheme.textMuted(context), fontSize: 9.5, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(child: Container(height: 0.8, color: AppTheme.divider(context))),
      ],
    );
  }
}

// -------------------------------------------------------------
// 2. BEAUTIFUL MODERN DAILY SPLINE AREA GRAPH WITH GRADIENT & TOUCH
// -------------------------------------------------------------
class ModernDailySplineAreaChart extends StatefulWidget {
  final double threshold;
  final int? selectedIndex;
  final ValueChanged<int> onPointSelected;
  final List<Map<String, dynamic>>? dailyData;

  const ModernDailySplineAreaChart({
    super.key,
    required this.threshold,
    required this.selectedIndex,
    required this.onPointSelected,
    this.dailyData,
  });

  @override
  State<ModernDailySplineAreaChart> createState() => _ModernDailySplineAreaChartState();
}

class _ModernDailySplineAreaChartState extends State<ModernDailySplineAreaChart> with SingleTickerProviderStateMixin {
  List<Map<String, dynamic>> get _dailyPoints => (widget.dailyData != null && widget.dailyData!.isNotEmpty)
      ? widget.dailyData!
      : const [
          {'day': 'Mon', 'fullName': 'Monday', 'usage': 1.2, 'liters': 1200, 'cost': 'LKR 62.40', 'status': 'Optimal'},
          {'day': 'Tue', 'fullName': 'Tuesday', 'usage': 1.5, 'liters': 1500, 'cost': 'LKR 78.00', 'status': 'Normal'},
          {'day': 'Wed', 'fullName': 'Wednesday', 'usage': 1.8, 'liters': 1800, 'cost': 'LKR 93.60', 'status': 'High Normal'},
          {'day': 'Thu', 'fullName': 'Thursday', 'usage': 1.4, 'liters': 1400, 'cost': 'LKR 72.80', 'status': 'Optimal'},
          {'day': 'Fri', 'fullName': 'Friday', 'usage': 1.9, 'liters': 1900, 'cost': 'LKR 98.80', 'status': 'Peak Day'},
          {'day': 'Sat', 'fullName': 'Saturday', 'usage': 2.3, 'liters': 2300, 'cost': 'LKR 119.60', 'status': 'Weekend Peak'},
          {'day': 'Sun', 'fullName': 'Sunday', 'usage': 1.5, 'liters': 1500, 'cost': 'LKR 78.00', 'status': 'Optimal'},
        ];

  late AnimationController _animController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _progressAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic maxLiters based on real data with 25% top breathing room
    double maxDataLiters = 0.0;
    for (final p in _dailyPoints) {
      final double lit = (p['liters'] as num?)?.toDouble() ??
          (((p['usage'] as num?)?.toDouble() ?? 0.0) * 1000.0);
      if (lit > maxDataLiters) maxDataLiters = lit;
    }
    if (maxDataLiters <= 0) maxDataLiters = 2300.0;
    final double step = maxDataLiters > 2500 ? 500.0 : 200.0;
    final double maxLiters = math.max(1000.0, (((maxDataLiters * 1.25) / step).ceil() * step).toDouble());

    final int activeIdx = (widget.selectedIndex != null && widget.selectedIndex! >= 0 && widget.selectedIndex! < _dailyPoints.length)
        ? widget.selectedIndex!
        : _dailyPoints.length - 1; // Default highlight latest day
    final activeItem = _dailyPoints[activeIdx];

    return LayoutBuilder(
      builder: (context, constraints) {
        final chartWidth = constraints.maxWidth;
        final chartHeight = constraints.maxHeight - 28;
        const leftPadding = 48.0;
        final plotWidth = chartWidth - leftPadding - 12.0;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // 1. Y-Axis Grid Lines & Labels in Liters
            Positioned.fill(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildGridLine(context, '${maxLiters.toInt()} L'),
                  _buildGridLine(context, '${(maxLiters * 0.75).toInt()} L'),
                  _buildGridLine(context, '${(maxLiters * 0.50).toInt()} L'),
                  _buildGridLine(context, '${(maxLiters * 0.25).toInt()} L'),
                  _buildGridLine(context, '0 L'),
                  const SizedBox(height: 18),
                ],
              ),
            ),

            // 2. Smooth Spline Curved Area & Line Painter
            Positioned(
              left: leftPadding,
              top: 0,
              width: plotWidth,
              height: chartHeight,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, _) {
                  return RepaintBoundary(
                    child: CustomPaint(
                      painter: _SplineAreaPainter(
                        data: _dailyPoints,
                        maxLiters: maxLiters,
                        progress: _progressAnimation.value,
                        selectedIndex: activeIdx,
                        isDark: AppTheme.isDark(context),
                      ),
                    ),
                  );
                },
              ),
            ),

            // 3. Interactive Touch Overlay & Floating Active Info Tooltip
            Positioned(
              left: leftPadding,
              top: 0,
              width: plotWidth,
              height: chartHeight,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) => _handleTouch(details.localPosition.dx, plotWidth),
                onPanUpdate: (details) => _handleTouch(details.localPosition.dx, plotWidth),
                child: LayoutBuilder(
                  builder: (ctx, plotConstraints) {
                    final stepX = plotWidth / (_dailyPoints.length - 1);
                    final double pointX = activeIdx * stepX;
                    final double litVal = (activeItem['liters'] as num?)?.toDouble() ??
                        (((activeItem['usage'] as num?)?.toDouble() ?? 1.4) * 1000.0);
                    final double pointY = chartHeight * (1.0 - (litVal / maxLiters).clamp(0.0, 1.0));

                    return Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Vertical Indicator Line
                        Positioned(
                          left: pointX,
                          top: pointY,
                          bottom: 0,
                          child: CustomPaint(
                            size: Size(1, math.max(1.0, chartHeight - pointY)),
                            painter: const VerticalDashedLinePainter(),
                          ),
                        ),

                        // Glowing Pulsating Active Data Point
                        Positioned(
                          left: pointX - 8,
                          top: pointY - 8,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF1877F2),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF38BDF8).withValues(alpha: 0.7),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        // Floating Glass Tooltip Card Above Active Point
                        Positioned(
                          left: (pointX - 60).clamp(0.0, plotWidth - 120),
                          top: (pointY - 38).clamp(0.0, chartHeight - 36),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                              border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.6), width: 1),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(CupertinoIcons.drop_fill, color: Color(0xFF38BDF8), size: 12),
                                const SizedBox(width: 4),
                                Text(
                                  '${litVal.toInt()} L · ${activeItem['day']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),

            // 4. X-Axis Day Pills with Active Indicator
            Positioned(
              left: leftPadding,
              right: 12.0,
              bottom: 0,
              height: 22,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _dailyPoints.asMap().entries.map((entry) {
                  final int index = entry.key;
                  final item = entry.value;
                  final bool isSelected = activeIdx == index;

                  return GestureDetector(
                    onTap: () => widget.onPointSelected(index),
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color(0xFF1877F2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['day'] ?? 'Day',
                        style: TextStyle(
                          color: isSelected ? Colors.white : AppTheme.textMuted(context),
                          fontSize: 10.5,
                          fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleTouch(double localX, double plotWidth) {
    final stepX = plotWidth / (_dailyPoints.length - 1);
    final rawIndex = (localX / stepX).round();
    final clampedIdx = rawIndex.clamp(0, _dailyPoints.length - 1);
    widget.onPointSelected(clampedIdx);
  }

  Widget _buildGridLine(BuildContext context, String label) {
    return Row(
      children: [
        SizedBox(
          width: 42,
          child: Text(
            label,
            textAlign: TextAlign.right,
            style: TextStyle(color: AppTheme.textMuted(context), fontSize: 9.0, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(child: Container(height: 0.8, color: AppTheme.divider(context))),
      ],
    );
  }
}

// -------------------------------------------------------------
// 3. SMOOTH CUBIC SPLINE AREA & GRADIENT PAINTER
// -------------------------------------------------------------
class _SplineAreaPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  final double maxLiters;
  final double progress;
  final int selectedIndex;
  final bool isDark;

  _SplineAreaPainter({
    required this.data,
    required this.maxLiters,
    required this.progress,
    required this.selectedIndex,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final double stepX = size.width / (data.length - 1);
    final List<Offset> points = [];

    for (int i = 0; i < data.length; i++) {
      final double x = i * stepX;
      final double lit = (data[i]['liters'] as num?)?.toDouble() ??
          (((data[i]['usage'] as num?)?.toDouble() ?? 1.2) * 1000.0);
      final double targetY = size.height * (1.0 - (lit / maxLiters).clamp(0.0, 1.0));
      final double y = size.height - (size.height - targetY) * progress;
      points.add(Offset(x, y));
    }

    // Build Smooth Cubic Spline Path
    final Path linePath = Path();
    linePath.moveTo(points[0].dx, points[0].dy);

    for (int i = 0; i < points.length - 1; i++) {
      final p0 = points[i];
      final p1 = points[i + 1];
      final controlPoint1 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p0.dy);
      final controlPoint2 = Offset(p0.dx + (p1.dx - p0.dx) / 2, p1.dy);
      linePath.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p1.dx, p1.dy);
    }

    // Area Fill Path
    final Path areaPath = Path.from(linePath);
    areaPath.lineTo(points.last.dx, size.height);
    areaPath.lineTo(points.first.dx, size.height);
    areaPath.close();

    // 1. Draw Glowing Gradient Area Fill
    final Paint fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF1877F2).withValues(alpha: isDark ? 0.45 : 0.28),
          const Color(0xFF38BDF8).withValues(alpha: isDark ? 0.15 : 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    canvas.drawPath(areaPath, fillPaint);

    // 2. Draw Smooth Spline Stroke Line
    final Paint linePaint = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFF38BDF8), Color(0xFF1877F2), Color(0xFF6366F1)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;

    canvas.drawPath(linePath, linePaint);

    // 3. Draw All Point Dots
    final Paint pointOutlinePaint = Paint()
      ..color = isDark ? const Color(0xFF0F172A) : Colors.white
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final Paint pointFillPaint = Paint()
      ..color = const Color(0xFF38BDF8)
      ..style = PaintingStyle.fill;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      canvas.drawCircle(p, 4.0, pointFillPaint);
      canvas.drawCircle(p, 4.0, pointOutlinePaint);
    }
  }

  @override
  bool shouldRepaint(covariant _SplineAreaPainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.selectedIndex != selectedIndex ||
      oldDelegate.isDark != isDark ||
      oldDelegate.maxLiters != maxLiters ||
      oldDelegate.data != data;
}

class VerticalDashedLinePainter extends CustomPainter {
  final Color color;
  const VerticalDashedLinePainter({this.color = const Color(0xFF38BDF8)});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.75)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    const dashHeight = 4.0;
    const dashSpace = 3.0;
    double startY = 0;

    while (startY < size.height) {
      final double endY = math.min(startY + dashHeight, size.height);
      canvas.drawLine(Offset(0, startY), Offset(0, endY), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// =============================================================
// 3. GRIEVANCES / HELP SCREEN (Interactive Tickets & Timeline)
// =============================================================
// =============================================================
// 4. GRIEVANCES / HELP SCREEN (Interactive Tickets & Timeline)
// =============================================================
class GrievancesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> complaints;
  final VoidCallback onFileComplaint;
  final VoidCallback onNotificationTap;
  final int unreadCount;

  const GrievancesScreen({
    super.key,
    required this.complaints,
    required this.onFileComplaint,
    required this.onNotificationTap,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 95),
      children: [
        _buildAnimatedEntrance(
          index: 0,
          child: _buildHeader(
            context,
            title: 'Grievances & Help',
            onNotificationTap: onNotificationTap,
            unreadCount: unreadCount,
          ),
        ),
        const SizedBox(height: 16),

        // File a Complaint Button
        _buildAnimatedEntrance(
          index: 1,
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onFileComplaint,
              icon: const Icon(CupertinoIcons.plus_bubble_fill, color: Colors.white, size: 19),
              label: const Text(
                'File a New Complaint / Request',
                style: TextStyle(color: Colors.white, fontSize: 14.5, fontWeight: FontWeight.w700),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0A84FF),
                elevation: 0,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              ),
            ),
          ),
        ),

        const SizedBox(height: 22),
        _buildAnimatedEntrance(
          index: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionHeader('MY ACTIVE TICKETS (${complaints.length})'),
              const Text('Tap to inspect timeline', style: TextStyle(color: Color(0xFF8E9BAE), fontSize: 11)),
            ],
          ),
        ),
        const SizedBox(height: 8),

        // Complaint Cards with Clickable Timeline Inspection
        ...complaints.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return _buildAnimatedEntrance(
            index: 3 + idx,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: _buildInteractiveComplaintCard(context, item),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildInteractiveComplaintCard(BuildContext context, Map<String, dynamic> item) {
    return LiquidGlassCard(
      onTap: () => _showComplaintTimelineModal(context, item),
      padding: const EdgeInsets.all(16),
      borderRadius: 22,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  item['title'] ?? 'Water Supply Grievance',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: AppTheme.textPrimary(context), height: 1.3),
                ),
              ),
              const SizedBox(width: 8),
              () {
                final statusStr = item['status']?.toString() ?? 'In Review';
                final isResolved = statusStr.toLowerCase().contains('resolved') || statusStr.toLowerCase().contains('cleared') || statusStr.toLowerCase().contains('completed');
                final Color statusFg = item['statusColor'] is Color ? item['statusColor'] as Color : (isResolved ? const Color(0xFF30D158) : const Color(0xFFFF9F0A));
                final Color statusBg = isResolved ? const Color(0xFF30D158).withValues(alpha: 0.15) : const Color(0xFFFF9F0A).withValues(alpha: 0.15);

                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: statusBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(statusStr, style: TextStyle(color: statusFg, fontSize: 10.5, fontWeight: FontWeight.w700)),
                );
              }(),
            ],
          ),
          const SizedBox(height: 4),
          Text('${item['id']} · ${item['date']}', style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11.5)),
          const SizedBox(height: 12),

          // Latest Update Box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surfaceAlt(context),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Latest Field Update', style: TextStyle(color: Color(0xFF0A84FF), fontSize: 11.5, fontWeight: FontWeight.w700)),
                    Icon(CupertinoIcons.time, size: 13, color: Color(0xFF0A84FF)),
                  ],
                ),
                const SizedBox(height: 3),
                Text(item['updateText'], style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 11.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showComplaintTimelineModal(BuildContext context, Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _ComplaintTrackerSheet(item: item),
    );
  }
}

// =============================================================
// 4. PROFILE & TELEMETRY SCREEN (Apple Grouped Settings Style)
// =============================================================
class ProfileScreen extends StatelessWidget {
  final String userName;
  final String userEmail;
  final String userPhone;
  final String selectedSector;
  final double meterReading;
  final double previousMonthReading;
  final double waterUsage;
  final bool isValveOpen;
  final String pressureStatus;
  final double pressureBar;
  final double flowRate;
  final double totalLiters;
  final String monthName;
  final bool isFirebaseConnected;
  final VoidCallback onToggleValve;
  final void Function(String name, String email, String phone) onProfileUpdated;
  final VoidCallback onNotificationTap;
  final int unreadCount;

  const ProfileScreen({
    super.key,
    required this.userName,
    required this.userEmail,
    required this.userPhone,
    this.selectedSector = 'Sector 14 - Colombo Central',
    required this.meterReading,
    required this.previousMonthReading,
    required this.waterUsage,
    this.isValveOpen = true,
    this.pressureStatus = 'Normal',
    this.pressureBar = 0.0,
    this.flowRate = 14.2,
    this.totalLiters = 0.0,
    this.monthName = 'September',
    this.isFirebaseConnected = true,
    required this.onToggleValve,
    required this.onProfileUpdated,
    required this.onNotificationTap,
    this.unreadCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    final initials = userName.trim().split(' ').map((e) => e.isNotEmpty ? e[0] : '').take(2).join('').toUpperCase();

    return ListView(
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 95),
      children: [
        _buildAnimatedEntrance(
          index: 0,
          child: _buildHeader(
            context,
            title: 'Account Profile',
            onNotificationTap: onNotificationTap,
            unreadCount: unreadCount,
          ),
        ),
        const SizedBox(height: 16),

        // Profile Avatar Card
        _buildAnimatedEntrance(
          index: 1,
          child: Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () => _showEditProfileModal(context),
                  child: Stack(
                    children: [
                      Container(
                        width: 76,
                        height: 76,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0A84FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0A84FF).withValues(alpha: 0.35),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text(initials, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Color(0xFF060913),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.pencil, size: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Text(userName, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17.5, color: AppTheme.textPrimary(context), letterSpacing: -0.2)),
                const SizedBox(height: 3),
                Text('$userEmail · $userPhone', style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11.5)),
              ],
            ),
          ),
        ),

        const SizedBox(height: 18),

        // Live Water Utility Device Telemetry Card
        _buildAnimatedEntrance(
          index: 2,
          child: LiquidGlassCard(
            padding: const EdgeInsets.all(16),
            borderRadius: 22,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(CupertinoIcons.drop_triangle_fill, color: Color(0xFF0A84FF), size: 20),
                        const SizedBox(width: 8),
                        Text(
                          'Registered Water Meter',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14.5,
                            color: AppTheme.textPrimary(context),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: isFirebaseConnected
                            ? const Color(0xFF30D158).withValues(alpha: 0.14)
                            : const Color(0xFFFF9F0A).withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        isFirebaseConnected ? 'Firebase Live' : 'Offline',
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: isFirebaseConnected ? const Color(0xFF30D158) : const Color(0xFFFF9F0A),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _deviceInfoRow(context, 'User ID / Account', 'user_0001 (ACC-0001-LK)'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Meter Serial Number', 'WB-04812 (Ultrasonic Smart)'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Current Meter Reading', '${meterReading.toInt()} units'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Previous Meter Reading', '${previousMonthReading.toInt()} units'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Active Cycle Usage', '${waterUsage.toInt()} units ($monthName 2026)'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Live Flow Rate', '${flowRate.toStringAsFixed(2)} L/min'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Live Pressure', '${pressureBar.toStringAsFixed(2)} bar · $pressureStatus'),
                Divider(height: 14, color: AppTheme.divider(context)),
                _deviceInfoRow(context, 'Sunday Water Volume', '${totalLiters.toStringAsFixed(0)} liters'),
                Divider(height: 14, color: AppTheme.divider(context)),

                // Interactive Actuator Valve Status Row (Apple Settings Style)
                InkWell(
                  onTap: onToggleValve,
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: isValveOpen
                                    ? const Color(0xFF30D158).withValues(alpha: 0.14)
                                    : const Color(0xFFFF453A).withValues(alpha: 0.14),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                isValveOpen ? CupertinoIcons.drop_fill : CupertinoIcons.drop,
                                color: isValveOpen ? const Color(0xFF30D158) : const Color(0xFFFF453A),
                                size: 18,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Main Water Valve',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.5,
                                    color: AppTheme.textPrimary(context),
                                  ),
                                ),
                                Text(
                                  isValveOpen ? 'Supply active · Open' : 'Supply shut off · Closed',
                                  style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Transform.scale(
                          scale: 0.88,
                          child: Switch(
                            value: isValveOpen,
                            activeThumbColor: const Color(0xFF30D158),
                            activeTrackColor: const Color(0xFF30D158).withValues(alpha: 0.35),
                            inactiveThumbColor: const Color(0xFFFF453A),
                            inactiveTrackColor: const Color(0xFFFF453A).withValues(alpha: 0.3),
                            onChanged: (_) => onToggleValve(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Profile Menu Items (Apple Inset Grouped Liquid Glass)
        _buildAnimatedEntrance(
          index: 3,
          child: LiquidGlassCard(
            padding: const EdgeInsets.all(14),
            borderRadius: 22,
            child: Column(
              children: [
                _buildProfileOption(
                  context,
                  CupertinoIcons.person_fill,
                  'Personal Details',
                  subtitle: 'Name, address, registered meter ID',
                  onTap: () => _showEditProfileModal(context),
                ),
                Divider(height: 16, color: AppTheme.divider(context)),
                ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeModeNotifier,
                  builder: (ctx, currentMode, _) {
                    final isDark = currentMode == ThemeMode.dark ||
                        (currentMode == ThemeMode.system &&
                            MediaQuery.of(ctx).platformBrightness == Brightness.dark);
                    final modeSubtitle = currentMode == ThemeMode.system
                        ? 'System Default (${isDark ? 'Dark' : 'Light'})'
                        : (isDark ? 'Dark mode enabled' : 'Light mode enabled');

                    return _buildProfileOption(
                      context,
                      isDark ? CupertinoIcons.moon_stars_fill : CupertinoIcons.sun_max_fill,
                      'Dark Mode',
                      subtitle: modeSubtitle,
                      trailing: Transform.scale(
                        scale: 0.88,
                        child: Switch(
                          value: isDark,
                          activeThumbColor: const Color(0xFF0A84FF),
                          onChanged: (val) {
                            themeModeNotifier.value = val ? ThemeMode.dark : ThemeMode.light;
                          },
                        ),
                      ),
                      onTap: () => _showAppearanceModal(context),
                    );
                  },
                ),
                Divider(height: 16, color: AppTheme.divider(context)),
                _buildProfileOption(
                  context,
                  CupertinoIcons.bell_fill,
                  'Notification Preferences',
                  subtitle: 'SMS outage alerts, bill reminders',
                  onTap: () => _showNotificationPreferencesModal(context),
                ),
                Divider(height: 16, color: AppTheme.divider(context)),
                _buildProfileOption(
                  context,
                  CupertinoIcons.creditcard_fill,
                  'Payment Methods',
                  subtitle: 'Saved credit cards, direct debit bank',
                  onTap: () => _showPaymentMethodsModal(context),
                ),
                Divider(height: 16, color: AppTheme.divider(context)),
                _buildProfileOption(
                  context,
                  CupertinoIcons.lock_shield_fill,
                  'Privacy & Security',
                  subtitle: 'Biometric face unlock, PIN passcode',
                  onTap: () => _showPrivacySecurityModal(context),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Quick Actions Group
        _buildAnimatedEntrance(
          index: 3,
          child: LiquidGlassCard(
            padding: const EdgeInsets.all(14),
            borderRadius: 22,
            child: Column(
              children: [
                _buildProfileOption(
                  context,
                  CupertinoIcons.arrow_down_doc_fill,
                  'Download Annual Statement',
                  subtitle: 'PDF report for tax filings',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: const Color(0xFF30D158),
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        content: const Text('Statement 2025-2026 downloaded to device!'),
                      ),
                    );
                  },
                ),
                Divider(height: 16, color: AppTheme.divider(context)),
                _buildProfileOption(
                  context,
                  CupertinoIcons.arrow_right_square_fill,
                  'Log Out Account',
                  subtitle: 'Switch water utility customer profile',
                  isDestructive: true,
                  onTap: () => _showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String title, {
    required String subtitle,
    required VoidCallback onTap,
    Widget? trailing,
    bool isDestructive = false,
  }) {
    final isDark = AppTheme.isDark(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDestructive
                    ? (isDark ? const Color(0xFF451A1A) : const Color(0xFFFEE2E2))
                    : AppTheme.iconBg(context),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: isDestructive
                    ? const Color(0xFFDC2626)
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                size: 18,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDestructive ? const Color(0xFFDC2626) : AppTheme.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(subtitle, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
                ],
              ),
            ),
            trailing ?? Icon(CupertinoIcons.chevron_forward, size: 14, color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1)),
          ],
        ),
      ),
    );
  }

  Widget _deviceInfoRow(BuildContext context, String title, String val, {bool isBadge = false, Color badgeColor = const Color(0xFF10B981)}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: AppTheme.textSecondary(context),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        if (isBadge)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              val,
              style: TextStyle(
                color: badgeColor,
                fontWeight: FontWeight.w700,
                fontSize: 11,
              ),
            ),
          )
        else
          Text(
            val,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary(context),
              fontSize: 12,
            ),
          ),
      ],
    );
  }

  void _showAppearanceModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AppearanceSheet(),
    );
  }

  void _showEditProfileModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _EditProfileSheet(
        initialName: userName,
        initialEmail: userEmail,
        initialPhone: userPhone,
        onProfileUpdated: onProfileUpdated,
      ),
    );
  }


  void _showNotificationPreferencesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _NotificationPreferencesSheet(),
    );
  }

  void _showPaymentMethodsModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _PaymentMethodsSheet(),
    );
  }

  void _showPrivacySecurityModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _PrivacySecuritySheet(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.card(ctx),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Confirm Log Out', style: TextStyle(fontWeight: FontWeight.w700, color: AppTheme.textPrimary(ctx))),
        content: Text('Are you sure you want to log out of your water utility account?', style: TextStyle(color: AppTheme.textSecondary(ctx))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppTheme.textSecondary(ctx))),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  content: const Text('Session ended safely.'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFDC2626),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}

// =============================================================
// MODAL SHEETS & INTERACTIVE POPUPS
// =============================================================

// 0. APPEARANCE & THEME SHEET (Light, Dark, System Selection)
class _AppearanceSheet extends StatelessWidget {
  const _AppearanceSheet();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, _) {
        final isDark = AppTheme.isDark(context);

        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
            decoration: BoxDecoration(
              color: AppTheme.card(context),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppTheme.border(context),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Appearance & Theme',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary(context),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryChipBg(context),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          currentMode == ThemeMode.system
                              ? 'System'
                              : (currentMode == ThemeMode.dark ? 'Dark' : 'Light'),
                          style: TextStyle(
                            color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF1877F2),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Select your preferred display theme for the Water Utility application.',
                    style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 12),
                  ),
                  const SizedBox(height: 18),
                  _themeOptionTile(
                    context,
                    title: 'Light Theme',
                    subtitle: 'Bright and clean interface designed for daylight',
                    icon: CupertinoIcons.sun_max_fill,
                    mode: ThemeMode.light,
                    isSelected: currentMode == ThemeMode.light,
                  ),
                  const SizedBox(height: 10),
                  _themeOptionTile(
                    context,
                    title: 'Dark Theme',
                    subtitle: 'Deep slate theme that reduces eye strain in low light',
                    icon: CupertinoIcons.moon_stars_fill,
                    mode: ThemeMode.dark,
                    isSelected: currentMode == ThemeMode.dark,
                  ),
                  const SizedBox(height: 10),
                  _themeOptionTile(
                    context,
                    title: 'System Default',
                    subtitle: 'Automatically matches your device system appearance',
                    icon: CupertinoIcons.device_phone_portrait,
                    mode: ThemeMode.system,
                    isSelected: currentMode == ThemeMode.system,
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _themeOptionTile(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required ThemeMode mode,
    required bool isSelected,
  }) {
    final isDark = AppTheme.isDark(context);
    final activeColor = isDark ? const Color(0xFF60A5FA) : const Color(0xFF1877F2);

    return InkWell(
      onTap: () {
        themeModeNotifier.value = mode;
      },
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark
                  ? const Color(0xFF1E3A8A).withValues(alpha: 0.35)
                  : const Color(0xFFEBF3FF))
              : AppTheme.surfaceAlt(context),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? activeColor : AppTheme.border(context),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFDBEAFE))
                    : AppTheme.iconBg(context),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? activeColor : AppTheme.textSecondary(context),
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: isSelected ? activeColor : AppTheme.textPrimary(context),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.circle,
              color: isSelected ? activeColor : AppTheme.textMuted(context),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

// 0B. EDIT PROFILE MODAL SHEET WITH DEDICATED CONTROLLER LIFECYCLE
class _EditProfileSheet extends StatefulWidget {
  final String initialName;
  final String initialEmail;
  final String initialPhone;
  final void Function(String name, String email, String phone) onProfileUpdated;

  const _EditProfileSheet({
    required this.initialName,
    required this.initialEmail,
    required this.initialPhone,
    required this.onProfileUpdated,
  });

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _emailCtrl = TextEditingController(text: widget.initialEmail);
    _phoneCtrl = TextEditingController(text: widget.initialPhone);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
              ),
            ),
            const SizedBox(height: 20),
            Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
            const SizedBox(height: 16),
            _buildInput('Full Name', _nameCtrl, CupertinoIcons.person_fill),
            const SizedBox(height: 12),
            _buildInput('Email Address', _emailCtrl, CupertinoIcons.mail_solid),
            const SizedBox(height: 12),
            _buildInput('Mobile Number', _phoneCtrl, CupertinoIcons.phone_fill),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  widget.onProfileUpdated(_nameCtrl.text.trim(), _emailCtrl.text.trim(), _phoneCtrl.text.trim());
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: const Color(0xFF10B981),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      content: const Text('Profile details saved!'),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1877F2),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary(context))),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 14),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppTheme.textMuted(context), size: 18),
            filled: true,
            fillColor: AppTheme.surfaceAlt(context),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF1877F2), width: 1.5)),
          ),
        ),
      ],
    );
  }
}

// 1. PAYMENT MODAL SHEET (With ScrollView & Keyboard Padding to prevent UI Box Overflow)
class _PaymentModalSheet extends StatefulWidget {
  final double amount;
  final VoidCallback onPaymentSuccessful;

  const _PaymentModalSheet({required this.amount, required this.onPaymentSuccessful});

  @override
  State<_PaymentModalSheet> createState() => _PaymentModalSheetState();
}

class _PaymentModalSheetState extends State<_PaymentModalSheet> {
  int _selectedMethod = 0; // 0: Visa, 1: Master, 2: Bank Direct
  bool _isProcessing = false;
  final TextEditingController _promoCtrl = TextEditingController();
  double _discount = 0.0;

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  void _applyPromo() {
    if (_promoCtrl.text.trim().toUpperCase() == 'WATER2026') {
      setState(() => _discount = 500.0);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFF10B981),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Text('Promo code WATER2026 applied (-LKR 500.00)!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: const Text('Invalid code. Try "WATER2026"'),
        ),
      );
    }
  }

  void _processPayment() async {
    setState(() => _isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;
    setState(() => _isProcessing = false);
    Navigator.pop(context);
    widget.onPaymentSuccessful();
  }

  @override
  Widget build(BuildContext context) {
    final finalAmount = (widget.amount - _discount).clamp(0.0, 999999.0);

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 30),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Complete Payment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
                  const Row(
                    children: [
                      Icon(CupertinoIcons.lock_shield_fill, size: 14, color: Color(0xFF10B981)),
                      SizedBox(width: 4),
                      Text('256-bit SSL', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w700)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Amount Summary Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceAlt(context),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.border(context)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Payable Amount', style: TextStyle(color: AppTheme.textSecondary(context), fontWeight: FontWeight.w600)),
                    Text(
                      'LKR ${finalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Color(0xFF1877F2), fontWeight: FontWeight.w800, fontSize: 18),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),
              Text('Select Payment Method', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
              const SizedBox(height: 10),

              _paymentMethodTile(context, 0, CupertinoIcons.creditcard_fill, 'Visa Card', '•••• 4242 (Default)'),
              _paymentMethodTile(context, 1, CupertinoIcons.creditcard_fill, 'MasterCard', '•••• 8819'),
              _paymentMethodTile(context, 2, CupertinoIcons.building_2_fill, 'Direct Bank Transfer', 'Commercial Bank Account'),

              const SizedBox(height: 12),
              // Promo Code Row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _promoCtrl,
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Enter Promo (Try WATER2026)',
                        hintStyle: TextStyle(fontSize: 12, color: AppTheme.textMuted(context)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        filled: true,
                        fillColor: AppTheme.surfaceAlt(context),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _applyPromo,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0F172A),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Apply', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Confirm & Pay Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isProcessing
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5),
                        )
                      : Text(
                          'Confirm & Pay LKR ${finalAmount.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _paymentMethodTile(BuildContext context, int index, IconData icon, String title, String subtitle) {
    final isSelected = _selectedMethod == index;
    final isDark = AppTheme.isDark(context);

    return InkWell(
      onTap: () => setState(() => _selectedMethod = index),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? const Color(0xFF1E3A8A).withValues(alpha: 0.35) : const Color(0xFFEBF3FF))
              : AppTheme.surfaceAlt(context),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isSelected ? const Color(0xFF1877F2) : AppTheme.border(context)),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFF1877F2) : AppTheme.textSecondary(context), size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isSelected ? const Color(0xFF1877F2) : AppTheme.textPrimary(context))),
                  Text(subtitle, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
                ],
              ),
            ),
            Icon(isSelected ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.circle, color: isSelected ? const Color(0xFF1877F2) : AppTheme.textMuted(context), size: 18),
          ],
        ),
      ),
    );
  }
}

// 2. RECEIPT MODAL SHEET
class _ReceiptModalSheet extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ReceiptModalSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Electronic Tax Invoice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: const Color(0xFFDCFCE7), borderRadius: BorderRadius.circular(12)),
                    child: const Text('Paid & Cleared', style: TextStyle(color: Color(0xFF16A34A), fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _receiptRow(context, 'Transaction ID', item['txnId']),
              _receiptRow(context, 'Billing Period', item['month']),
              _receiptRow(context, 'Payment Date', item['date']),
              _receiptRow(context, 'Payment Method', item['method']),
              _receiptRow(context, 'Amount Paid', item['amount'], isBold: true),
              Divider(height: 24, color: AppTheme.divider(context)),
              Text(item['breakdown'], style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 12)),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: const Text('Receipt share link copied to clipboard!'),
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.share, size: 18),
                      label: const Text('Share Link'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF10B981),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: const Text('PDF Receipt downloaded successfully!'),
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.arrow_down_doc_fill, color: Colors.white, size: 18),
                      label: const Text('Download PDF', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _receiptRow(BuildContext context, String title, String val, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 13)),
          Text(val, style: TextStyle(fontWeight: isBold ? FontWeight.w800 : FontWeight.w600, color: AppTheme.textPrimary(context), fontSize: 13)),
        ],
      ),
    );
  }
}


// 4. FILE COMPLAINT MODAL SHEET
class _FileComplaintSheet extends StatefulWidget {
  final ValueChanged<Map<String, dynamic>> onSubmit;

  const _FileComplaintSheet({required this.onSubmit});

  @override
  State<_FileComplaintSheet> createState() => _FileComplaintSheetState();
}

class _FileComplaintSheetState extends State<_FileComplaintSheet> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _descCtrl = TextEditingController();
  String _category = 'Low Pressure';
  String _priority = 'Normal';
  bool _attachedPhoto = false;

  final List<String> _categories = [
    'Low Pressure',
    'Billing Discrepancy',
    'Water Quality / Odor',
    'Pipe Burst / Leak',
    'Meter Malfunction',
    'Other Enquiry'
  ];

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 18),
              Text('File a New Grievance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
              const SizedBox(height: 4),
              Text('A technical officer will be assigned within 24 business hours.', style: TextStyle(color: AppTheme.textMuted(context), fontSize: 12)),
              const SizedBox(height: 16),

              // Category Selector
              Text('Category', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary(context))),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceAlt(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border(context)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    dropdownColor: AppTheme.card(context),
                    value: _category,
                    items: _categories.map((c) => DropdownMenuItem(value: c, child: Text(c, style: TextStyle(fontSize: 13, color: AppTheme.textPrimary(context))))).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _category = val);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 12),
              Text('Subject Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary(context))),
              const SizedBox(height: 6),
              TextField(
                controller: _titleCtrl,
                style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'e.g. Unusually low pressure during 6-8 AM',
                  hintStyle: TextStyle(fontSize: 13, color: AppTheme.textMuted(context)),
                  filled: true,
                  fillColor: AppTheme.surfaceAlt(context),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
                ),
              ),

              const SizedBox(height: 12),
              Text('Detailed Description', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textSecondary(context))),
              const SizedBox(height: 6),
              TextField(
                controller: _descCtrl,
                maxLines: 3,
                style: TextStyle(color: AppTheme.textPrimary(context), fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Provide specific location landmarks or observations...',
                  hintStyle: TextStyle(fontSize: 13, color: AppTheme.textMuted(context)),
                  filled: true,
                  fillColor: AppTheme.surfaceAlt(context),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: AppTheme.border(context))),
                ),
              ),

              const SizedBox(height: 12),
              // Urgency & Photo
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        setState(() => _attachedPhoto = !_attachedPhoto);
                      },
                      icon: Icon(_attachedPhoto ? CupertinoIcons.checkmark_alt_circle_fill : CupertinoIcons.camera_fill, size: 16, color: _attachedPhoto ? const Color(0xFF10B981) : AppTheme.textSecondary(context)),
                      label: Text(_attachedPhoto ? 'Photo Added' : 'Attach Photo', style: TextStyle(fontSize: 12, color: _attachedPhoto ? const Color(0xFF10B981) : AppTheme.textSecondary(context))),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: AppTheme.surfaceAlt(context),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppTheme.border(context)),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _priority,
                          dropdownColor: AppTheme.card(context),
                          isExpanded: true,
                          items: ['Normal', 'High Priority', 'Emergency'].map((p) => DropdownMenuItem(value: p, child: Text(p, style: TextStyle(fontSize: 12, color: AppTheme.textPrimary(context))))).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _priority = val);
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final title = _titleCtrl.text.trim().isEmpty ? 'Grievance: $_category' : _titleCtrl.text.trim();
                    final randomId = 'CMP-2026-${(1000 + DateTime.now().millisecond).toString()}';
                    widget.onSubmit({
                      'id': randomId,
                      'title': title,
                      'category': _category,
                      'date': 'Today, 21:25',
                      'status': 'In Review',
                      'statusColor': const Color(0xFFD97706),
                      'statusBg': const Color(0xFFFEF3C7),
                      'updateText': 'Ticket registered. Dispatching to field officer.',
                      'technician': 'Queued for Assignment',
                      'timeline': [
                        {'title': 'Complaint Registered', 'time': 'Today, Just now', 'done': true},
                        {'title': 'Review by Duty Engineer', 'time': 'Pending (Est. 2h)', 'done': false},
                        {'title': 'Field Team Assigned', 'time': 'Pending', 'done': false},
                        {'title': 'Resolution Confirmation', 'time': 'Pending', 'done': false},
                      ],
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1877F2),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('Submit Grievance Ticket', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// 6. COMPLAINT TRACKER & TIMELINE MODAL SHEET
class _ComplaintTrackerSheet extends StatelessWidget {
  final Map<String, dynamic> item;

  const _ComplaintTrackerSheet({required this.item});

  @override
  Widget build(BuildContext context) {
    final List timeline = item['timeline'] ?? [];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(item['title'] ?? 'Water Supply Grievance', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
                  ),
                  () {
                    final statusStr = item['status']?.toString() ?? 'In Review';
                    final isResolved = statusStr.toLowerCase().contains('resolved') || statusStr.toLowerCase().contains('cleared') || statusStr.toLowerCase().contains('completed');
                    final Color statusFg = item['statusColor'] is Color ? item['statusColor'] as Color : (isResolved ? const Color(0xFF16A34A) : const Color(0xFFD97706));
                    final Color statusBg = item['statusBg'] is Color ? item['statusBg'] as Color : (isResolved ? const Color(0xFFDCFCE7) : const Color(0xFFFEF3C7));

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: statusBg, borderRadius: BorderRadius.circular(14)),
                      child: Text(statusStr, style: TextStyle(color: statusFg, fontSize: 11, fontWeight: FontWeight.w700)),
                    );
                  }(),
                ],
              ),
              const SizedBox(height: 4),
              Text('${item['id']} · Assigned Officer: ${item['technician'] ?? 'Central Desk'}', style: TextStyle(color: AppTheme.textMuted(context), fontSize: 12)),
              const SizedBox(height: 20),

              // Timeline Steps
              ...timeline.asMap().entries.map((entry) {
                final idx = entry.key;
                final step = entry.value;
                final isDone = step['done'] == true;
                final isLast = idx == timeline.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            color: isDone ? const Color(0xFF1877F2) : AppTheme.border(context),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isDone ? CupertinoIcons.checkmark_alt : CupertinoIcons.circle_fill,
                            size: 14,
                            color: isDone ? Colors.white : AppTheme.textMuted(context),
                          ),
                        ),
                        if (!isLast)
                          Container(
                            width: 2,
                            height: 32,
                            color: isDone ? const Color(0xFF1877F2) : AppTheme.border(context),
                          ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(step['title'], style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: isDone ? AppTheme.textPrimary(context) : AppTheme.textMuted(context))),
                            Text(step['time'], style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
                            const SizedBox(height: 14),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),

              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: const Text('Priority callback requested! Desk will contact you.'),
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.phone_fill, size: 16),
                      label: const Text('Request Call', style: TextStyle(fontWeight: FontWeight.w600)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: const Color(0xFF1877F2),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            content: const Text('Note added to ticket timeline.'),
                          ),
                        );
                      },
                      icon: const Icon(CupertinoIcons.plus_bubble_fill, color: Colors.white, size: 16),
                      label: const Text('Add Note', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1877F2),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 7. NOTIFICATION CENTER SHEET
class _NotificationCenterSheet extends StatelessWidget {
  final VoidCallback onViewBill;

  const _NotificationCenterSheet({required this.onViewBill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifications & Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
                  const Text('All caught up', style: TextStyle(color: Color(0xFF10B981), fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              const SizedBox(height: 16),
              _notifItem(
                context,
                CupertinoIcons.exclamationmark_triangle_fill,
                const Color(0xFFD97706),
                const Color(0xFFFEF3C7),
                'Scheduled Maintenance Tomorrow',
                'Sector 14 supply will be interrupted between 09:00 - 14:00.',
                '10m ago',
                onTap: () => Navigator.pop(context),
              ),
              _notifItem(
                context,
                CupertinoIcons.doc_text_fill,
                const Color(0xFF1877F2),
                AppTheme.primaryChipBg(context),
                'August Water Bill Generated',
                'Monthly statement for LKR 2,719.90 is now available.',
                '2h ago',
                onTap: onViewBill,
              ),
              _notifItem(
                context,
                CupertinoIcons.checkmark_alt_circle_fill,
                const Color(0xFF10B981),
                const Color(0xFFDCFCE7),
                'Leak Check Completed',
                'Automated AI meter scan verified normal flow rate.',
                '1d ago',
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notifItem(
    BuildContext context,
    IconData icon,
    Color color,
    Color bg,
    String title,
    String body,
    String time, {
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.surfaceAlt(context),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.border(context)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary(context))),
                      Text(time, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(body, style: TextStyle(color: AppTheme.textSecondary(context), fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 8. NOTIFICATION PREFERENCES SHEET
class _NotificationPreferencesSheet extends StatefulWidget {
  const _NotificationPreferencesSheet();

  @override
  State<_NotificationPreferencesSheet> createState() => _NotificationPreferencesSheetState();
}

class _NotificationPreferencesSheetState extends State<_NotificationPreferencesSheet> {
  bool _push = true;
  bool _sms = true;
  bool _billAlert = true;
  bool _outageAlert = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Notification Preferences', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
              const SizedBox(height: 16),
              _switchTile(context, 'Push Notifications', 'Real-time updates on status changes', _push, (v) => setState(() => _push = v)),
              _switchTile(context, 'Emergency SMS Outages', 'Immediate text alerts for burst pipes', _sms, (v) => setState(() => _sms = v)),
              _switchTile(context, 'Billing & Due Date Reminders', 'Notices 3 days prior to due date', _billAlert, (v) => setState(() => _billAlert = v)),
              _switchTile(context, 'Scheduled Works Bulletins', 'Early notices for sector water maintenance', _outageAlert, (v) => setState(() => _outageAlert = v)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _switchTile(BuildContext context, String title, String subtitle, bool val, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary(context))),
                Text(subtitle, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
              ],
            ),
          ),
          Switch(value: val, activeThumbColor: const Color(0xFF1877F2), onChanged: onChanged),
        ],
      ),
    );
  }
}

// 9. PAYMENT METHODS SHEET
class _PaymentMethodsSheet extends StatelessWidget {
  const _PaymentMethodsSheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Payment Methods', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
              const SizedBox(height: 16),
              _cardItem(context, CupertinoIcons.creditcard_fill, 'Visa Ending in 4242', 'Expires 09/28 · Primary Auto-Pay', true),
              _cardItem(context, CupertinoIcons.creditcard_fill, 'MasterCard Ending in 8819', 'Expires 11/27', false),
              _cardItem(context, CupertinoIcons.building_2_fill, 'Commercial Bank Direct Debit', 'Account No: ••••••4920', false),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        content: const Text('Add new payment card gateway opened.'),
                      ),
                    );
                  },
                  icon: const Icon(CupertinoIcons.add, size: 18),
                  label: const Text('Add New Card or Bank Account'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardItem(BuildContext context, IconData icon, String title, String subtitle, bool isDefault) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.surfaceAlt(context),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDefault ? const Color(0xFF1877F2) : AppTheme.border(context)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1877F2)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.textPrimary(context))),
                Text(subtitle, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
              ],
            ),
          ),
          if (isDefault)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(color: AppTheme.primaryChipBg(context), borderRadius: BorderRadius.circular(8)),
              child: const Text('Default', style: TextStyle(color: Color(0xFF1877F2), fontSize: 10, fontWeight: FontWeight.w700)),
            ),
        ],
      ),
    );
  }
}

// 10. PRIVACY & SECURITY SHEET
class _PrivacySecuritySheet extends StatefulWidget {
  const _PrivacySecuritySheet();

  @override
  State<_PrivacySecuritySheet> createState() => _PrivacySecuritySheetState();
}

class _PrivacySecuritySheetState extends State<_PrivacySecuritySheet> {
  bool _biometrics = true;
  bool _twoFactor = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppTheme.card(context),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(color: AppTheme.border(context), borderRadius: BorderRadius.circular(2)),
                ),
              ),
              const SizedBox(height: 20),
              Text('Privacy & Security', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.textPrimary(context))),
              const SizedBox(height: 16),
              _securitySwitch(context, 'Biometric Face / Fingerprint Unlock', 'Prompt before accessing payment screens', _biometrics, (v) => setState(() => _biometrics = v)),
              _securitySwitch(context, 'Two-Factor Authentication (2FA)', 'SMS OTP for bill payments above LKR 10,000', _twoFactor, (v) => setState(() => _twoFactor = v)),
              const SizedBox(height: 10),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text('Change App Passcode PIN', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary(context))),
                trailing: Icon(CupertinoIcons.chevron_forward, size: 14, color: AppTheme.textMuted(context)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      content: const Text('Passcode reset PIN link sent to registered email.'),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _securitySwitch(BuildContext context, String title, String subtitle, bool val, ValueChanged<bool> onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textPrimary(context))),
                Text(subtitle, style: TextStyle(color: AppTheme.textMuted(context), fontSize: 11)),
              ],
            ),
          ),
          Switch(value: val, activeThumbColor: const Color(0xFF1877F2), onChanged: onChanged),
        ],
      ),
    );
  }
}

// =============================================================
// ANIMATION HELPERS & SHARED WIDGETS
// =============================================================

Widget _buildAnimatedEntrance({required int index, required Widget child, Key? key}) {
  return TweenAnimationBuilder<double>(
    key: key ?? ValueKey('anim_entrance_$index'),
    tween: Tween<double>(begin: 0.0, end: 1.0),
    duration: Duration(milliseconds: 280 + (index * 40)),
    curve: Curves.easeOutCubic,
    builder: (context, value, animChild) {
      return Opacity(
        opacity: value,
        child: Transform.translate(
          offset: Offset(0, 14 * (1 - value)),
          child: animChild,
        ),
      );
    },
    child: child,
  );
}

Widget _buildHeader(
  BuildContext context, {
  required String title,
  required VoidCallback onNotificationTap,
  required int unreadCount,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: AppTheme.textPrimary(context),
          letterSpacing: -0.5,
        ),
      ),
      Row(
        children: [
          GestureDetector(
            onTap: onNotificationTap,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppTheme.card(context),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.shadow(context),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(CupertinoIcons.bell_fill, color: AppTheme.textPrimary(context), size: 19),
                ),
                if (unreadCount > 0)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '$unreadCount',
                        style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w800),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFF1877F2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: const Text(
              'RA',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    ],
  );
}

Widget _buildSectionHeader(String title) {
  return Text(
    title,
    style: const TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      color: Color(0xFF94A3B8),
      letterSpacing: 0.8,
    ),
  );
}
