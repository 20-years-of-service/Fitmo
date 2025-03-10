import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const String _themeKey = 'theme_preference';
  bool _isDarkMode = false;
  late SharedPreferences _prefs;
  bool _isInitialized = false;

  // Cores principais do aplicativo
  static const Color primaryPurple = Color(0xFF6677CC);
  static const Color darkPurple = Color(0xFF4455BB);
  static const Color lightPurple = Color(0xFF8899FF);
  static const Color accentPurple = Color(0xFFAA77BB);
  static const Color darkAccentPurple = Color(0xFF9955BB);
  static const Color secondaryPink = Color(0xFFFF6699);
  static const Color lightPink = Color(0xFFFF99AA);

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  bool get isDarkMode => _isDarkMode;
  bool get isInitialized => _isInitialized;

  // Inicializa o provider carregando a preferência do usuário
  Future<void> _loadThemeFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
    _isInitialized = true;
    notifyListeners();
  }

  // Alterna entre tema claro e escuro e salva a preferência
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  // Define o tema diretamente para um valor específico e salva a preferência
  Future<void> setTheme(bool isDark) async {
    if (_isDarkMode == isDark) return;
    _isDarkMode = isDark;
    await _prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  // Retorna o tema atual baseado na preferência do usuário
  ThemeData get currentTheme {
    return _isDarkMode ? _darkTheme : _lightTheme;
  }

  // Tema claro
  final ThemeData _lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: primaryPurple,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryPurple,
      brightness: Brightness.light,
      primary: primaryPurple,
      secondary: accentPurple,
      tertiary: secondaryPink,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      iconTheme: IconThemeData(color: Color(0xFF212121)),
      titleTextStyle: TextStyle(
        color: Color(0xFF212121),
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Color(0xFF212121)),
      headlineMedium: TextStyle(color: Color(0xFF212121)),
      headlineSmall: TextStyle(color: Color(0xFF212121)),
      bodyLarge: TextStyle(color: Color(0xFF212121)),
      bodyMedium: TextStyle(color: Color(0xFF212121)),
      bodySmall: TextStyle(color: Colors.grey),
    ),
    iconTheme: const IconThemeData(
      color: primaryPurple,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryPurple;
        }
        return Colors.white;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryPurple.withOpacity(0.5);
        }
        return Colors.grey[300];
      }),
    ),
  );

  // Tema escuro melhorado
  final ThemeData _darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: lightPurple,
    scaffoldBackgroundColor: const Color(0xFF121212),
    colorScheme: ColorScheme.fromSeed(
      seedColor: lightPurple,
      brightness: Brightness.dark,
      primary: lightPurple,
      secondary: accentPurple,
      tertiary: secondaryPink,
      surface: const Color(0xFF1E1E1E),
      background: const Color(0xFF121212),
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      elevation: 0,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    cardTheme: CardTheme(
      color: const Color(0xFF1E1E1E),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),
    textTheme: const TextTheme(
      headlineLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      headlineSmall: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
      bodySmall: TextStyle(color: Colors.grey),
      titleMedium: TextStyle(color: Colors.white),
      titleSmall: TextStyle(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: lightPurple,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return lightPurple;
        }
        return Colors.grey[400];
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return lightPurple.withOpacity(0.5);
        }
        return Colors.grey[700];
      }),
    ),
    // Adicionando estilos de botões
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: lightPurple,
      ),
    ),
    // Tema para os componentes do material
    dialogTheme: const DialogTheme(
      backgroundColor: Color(0xFF1E1E1E),
      titleTextStyle: TextStyle(
          color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
      contentTextStyle: TextStyle(color: Colors.white),
    ),
    dividerTheme: const DividerThemeData(
      color: Color(0xFF2C2C2C),
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return lightPurple;
        }
        return Colors.grey[800];
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
    ),
    // Cores para o fundo de inputs
    inputDecorationTheme: InputDecorationTheme(
      fillColor: const Color(0xFF2C2C2C),
      filled: true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(color: Colors.grey[500]),
      labelStyle: const TextStyle(color: Colors.white70),
    ),
  );
}
