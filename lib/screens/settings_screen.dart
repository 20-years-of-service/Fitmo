import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io' show Platform;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _forceFullScreenMode();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _forceFullScreenMode();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _forceFullScreenMode() {
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.edgeToEdge,
        overlays: [SystemUiOverlay.top],
      );

      final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
      final isDarkMode = themeProvider.isDarkMode;

      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarDividerColor: Colors.transparent,
        ),
      );
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );

      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _forceFullScreenMode();
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF121212) : const Color(0xFFF5F5F5),
      body: SafeArea(
        child: LayoutBuilder(builder: (context, constraints) {
          final double availableWidth = constraints.maxWidth;
          final double contentPadding = availableWidth * 0.06;

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: contentPadding),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Cabeçalho "Ajustes"
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Text(
                        'Ajustes',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.grey[400] : Colors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Título "Configurações"
                    Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 16),
                      child: Text(
                        'Configurações',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDarkMode
                              ? Colors.white
                              : const Color(0xFF212121),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    _buildSectionTitle('Aparência', isDarkMode),
                    const SizedBox(height: 8),
                    _buildSettingCard(
                      'Tema',
                      'Escolha entre modo claro ou escuro',
                      _buildThemeToggle(isDarkMode),
                      isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Conta', isDarkMode),
                    const SizedBox(height: 8),
                    _buildSettingItem(
                      'Notificações',
                      'Gerenciar suas preferências de notificação',
                      Icons.notifications_none,
                      () {
                        // Navegação para tela de notificações
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      'Privacidade',
                      'Gerenciar configurações de privacidade',
                      Icons.security,
                      () {
                        // Navegação para tela de privacidade
                      },
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Informações', isDarkMode),
                    const SizedBox(height: 8),
                    _buildSettingItem(
                      'Termos de Uso',
                      'Leia nossos termos e condições',
                      Icons.description_outlined,
                      () {
                        // Navegação para termos de uso
                      },
                      isDarkMode: isDarkMode,
                    ),
                    _buildSettingItem(
                      'Sobre o Fitmo',
                      'Versão do aplicativo e informações',
                      Icons.info_outline,
                      () {
                        // Navegação para tela sobre
                      },
                      isDarkMode: isDarkMode,
                    ),
                    const SizedBox(height: 24),
                    _buildSectionTitle('Avançado', isDarkMode),
                    const SizedBox(height: 8),
                    _buildSettingItem(
                      'Limpar dados',
                      'Remover todos os seus dados do aplicativo',
                      Icons.delete_outline,
                      () {
                        // Diálogo de confirmação para limpar dados
                      },
                      isDarkMode: isDarkMode,
                      isDestructive: true,
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Versão 1.0.0',
                        style: TextStyle(
                          fontSize: 14,
                          color:
                              isDarkMode ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                    ),
                    // Espaço adicional para evitar que o conteúdo fique atrás da barra de navegação
                    const SizedBox(height: 80),
                  ]),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSectionTitle(String title, bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDarkMode ? Colors.grey[300] : const Color(0xFF333333),
        ),
      ),
    );
  }

  Widget _buildSettingCard(
      String title, String subtitle, Widget trailing, bool isDarkMode) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color:
                          isDarkMode ? Colors.white : const Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggle(bool isDarkMode) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.light_mode,
              color: isDarkMode ? Colors.grey[400] : const Color(0xFFFF9800),
              size: 20,
            ),
            const SizedBox(width: 8),
            Switch(
              value: isDarkMode,
              onChanged: (value) {
                themeProvider.setTheme(value);
              },
              activeColor: const Color(0xFF6677CC),
              activeTrackColor: const Color(0xFF6677CC).withOpacity(0.5),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.dark_mode,
              color: isDarkMode ? const Color(0xFF8899FF) : Colors.grey[400],
              size: 20,
            ),
          ],
        );
      },
    );
  }

  Widget _buildSettingItem(
    String title,
    String subtitle,
    IconData icon,
    VoidCallback onTap, {
    bool isDestructive = false,
    required bool isDarkMode,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDarkMode ? 0.2 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withOpacity(isDarkMode ? 0.2 : 0.1)
                      : isDarkMode
                          ? const Color(0xFF6677CC).withOpacity(0.2)
                          : const Color(0xFF6677CC).withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: isDestructive
                      ? Colors.red
                      : isDarkMode
                          ? const Color(0xFF8899FF)
                          : const Color(0xFF6677CC),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDestructive
                            ? Colors.red
                            : isDarkMode
                                ? Colors.white
                                : const Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
